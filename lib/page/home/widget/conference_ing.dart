import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:notarization_station_app/appTheme.dart';
import 'package:notarization_station_app/base_framework/widget_state/base_state.dart';
import 'package:notarization_station_app/config.dart';
import 'package:notarization_station_app/iconfont/Icon.dart';
import 'package:notarization_station_app/page/home/entity/data.dart';
import 'package:notarization_station_app/page/home/entity/vote_entity.dart';
import 'package:notarization_station_app/page/home/widget/noScrollBehavior.dart';
import 'package:notarization_station_app/page/login/vm/user_view_model.dart';
import 'package:notarization_station_app/socket/mqtt_client.dart';
import 'package:notarization_station_app/utils/GenerateTestUserSig.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tencent_trtc_cloud/trtc_cloud.dart';
import 'package:tencent_trtc_cloud/trtc_cloud_def.dart';
import 'package:tencent_trtc_cloud/trtc_cloud_listener.dart';
import 'package:tencent_trtc_cloud/trtc_cloud_video_view.dart';
import 'package:tencent_trtc_cloud/tx_device_manager.dart';

class DomeIngPage extends StatefulWidget {
  @override
  _ConferenceINGPageState createState() => _ConferenceINGPageState();
}

class _ConferenceINGPageState extends BaseState<DomeIngPage> {
  List chatList = [];
  ScrollController msgController = ScrollController();
  TextEditingController textEditingController = TextEditingController();

  //RTC相关
  TRTCCloud trtcCloud;
  TXDeviceManager txDeviceManager;
  List userList = []; //远端所有的视频用户
  Map otherUser = {}; //主持人的视频
  Map notaryInfo = {}; //公证员的视频
  List allowList = []; //允许在麦上的用户

  List<VoteEntity> voteList = [];
  VoteEntity presentVote = VoteEntity();
  bool isShow = true;
  String pdfUrl = "";

  bool isBanned = false;
  int isShowVote = 1;
  SharedPreferences prefs;
  bool isSignature = false;
  // List<String> prefsList = [];

  @override
  void initState() {
    super.initState();
    isBanned = VideoConferenceData.mute == 1 ? false : true;
    iniRoom();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    destoryRoom();
    MqttClientMsg.instance
        ?.unsubscribe("/topic/conference/${VideoConferenceData.roomId}");
  }

  // 弹出对话框
  Future<bool> showDeleteConfirmDialog1() {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("提示"),
          content: Text("是否确认退出?"),
          actions: <Widget>[
            ElevatedButton(
              child: Text("取消"),
              onPressed: () => Navigator.of(context).pop(), // 关闭对话框
            ),
            ElevatedButton(
              child: Text("确认"),
              onPressed: () {
                //关闭对话框并返回true
                Navigator.of(context).pop(true);
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppTheme.themeBlue,
          centerTitle: true,
          title: Text(
            "11111",
            style: TextStyle(fontSize: 16),
          ),
          leading: InkWell(
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: 22,
            ),
            onTap: () {
              showDeleteConfirmDialog1();
            },
          ),
          actions: <Widget>[
            TextButton(
                onPressed: () {},
                child: Text(
                  "历史表决",
                  style: TextStyle(color: Colors.white),
                ))
          ],
        ),
        floatingActionButtonLocation: CustomFloatingActionButtonLocation(
            FloatingActionButtonLocation.endFloat, 0, -50),
        floatingActionButton: Container(
          width: getWidthPx(70),
          height: getWidthPx(70),
          child: FloatingActionButton(
            child: handIco(color: Colors.white, size: 20),
            onPressed: () {
              //trtcCloud.startScreenCapture(TRTCVideoEncParam());
            },
          ),
        ),
        body: WillPopScope(
          onWillPop: () {
            showDeleteConfirmDialog1();
            return Future.value(false);
          },
          child: Consumer<UserViewModel>(builder: (ctx, userModel, child) {
            return Container(
              color: AppTheme.bg_c,
              child: Container(
                height: getHeightPx(1334),
                width: getWidthPx(750),
                child: peopleNum(),
              ),
            );
          }),
        ));
  }

  Widget peopleNum() {
    print("..............房间数${userList.length}");
    return Column(
      children: [
        Container(
          height: getWidthPx(300),
          width: getWidthPx(300),
          child: TRTCCloudVideoView(
              key: ValueKey("666666"),
              onViewCreated: (viewId) {
                trtcCloud.startRemoteView(
                    "666666", TRTCCloudDef.TRTC_VIDEO_STREAM_TYPE_SUB, viewId);
              }),
        ),
        Expanded(
          child: ScrollConfiguration(
            behavior: EUMNoScrollBehavior(),
            child: userList.length == 0
                ? SizedBox()
                : GridView.builder(
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, //每行三列
                      childAspectRatio: 1.0, //显示区域宽高相等
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                    ),
                    itemCount: userList.length,
                    itemBuilder: (context, index) {
                      return userList[index]['widget'] != null
                          ? userList[index]['widget']
                          : SizedBox();
                    }),
          ),
        ),
      ],
    );
  }

  iniRoom() async {
    // 创建 TRTCCloud 单例
    trtcCloud = await TRTCCloud.sharedInstance();
    // 获取设备管理模块
    txDeviceManager = trtcCloud.getDeviceManager();
    trtcCloud.setVideoEncoderParam(TRTCVideoEncParam());
    // 注册事件回调
    trtcCloud.registerListener(onRtcListener);
    // 进房
    enterRoom();
    await trtcCloud.startLocalAudio(TRTCCloudDef.TRTC_AUDIO_QUALITY_SPEECH);
  }

  // 进入房间
  enterRoom() async {
    String userSig = await GenerateTestUserSig.genTestSig("777777");
    trtcCloud.enterRoom(
        TRTCParams(
            sdkAppId: Config.sdkAppId, //应用Id
            userId: "777777", // 用户Id
            userSig: userSig, // 用户签名
            strRoomId: "10086aa"), //房间Id
        TRTCCloudDef.TRTC_APP_SCENE_VIDEOCALL);
    userList
        .add({'userId': "777777", "widget": addRoom(false, true, "777777")});
    trtcCloud?.stopLocalAudio();
    setState(() {});
  }

  // 销毁房间的一些信息
  destoryRoom() {
    trtcCloud?.muteAllRemoteAudio(true);
    trtcCloud?.stopLocalPreview();
    trtcCloud?.stopAllRemoteView();
    trtcCloud?.stopLocalAudio();
    trtcCloud?.exitRoom();
    trtcCloud?.unRegisterListener(onRtcListener);
    TRTCCloud?.destroySharedInstance();
  }

  addRoom(bool video, bool isMe, String userId) {
    return Container(
      child: video
          ? TRTCCloudVideoView(
              key: ValueKey(userId),
              onViewCreated: (viewId) {
                isMe
                    ? trtcCloud.startLocalPreview(true, viewId)
                    : trtcCloud.startRemoteView(userId,
                        TRTCCloudDef.TRTC_VIDEO_STREAM_TYPE_SMALL, viewId);
              })
          : SizedBox(),
    );
  }

  /// 事件回调
  onRtcListener(type, param) {
    if (type == TRTCCloudListener.onError) {
      log("错误回调------错误信息${param['errMsg']}");
    }
    if (type == TRTCCloudListener.onEnterRoom) {
      if (param > 0) {
      } else {
        log("进房失败------进房失败的错误码$param");
      }
    }
    if (type == TRTCCloudListener.onExitRoom) {
      //离开房间原因，0：主动调用 exitRoom 退房；1：被服务器踢出当前房间；2：当前房间整个被解散。
      if (param > 0) {
        log("退房成功------");
      }
    }
    // 远端用户进房
    if (type == TRTCCloudListener.onRemoteUserEnterRoom) {
      print("......远方加入$param");
      userList.add({'userId': param, "widget": addRoom(true, false, param)});
    }
    // 远端用户离开房间
    if (type == TRTCCloudListener.onRemoteUserLeaveRoom) {
      String userId = param['userId'];
      for (var i = 0; i < userList.length; i++) {
        if (userList[i]['userId'] == userId) {
          userList.removeAt(i);
        }
      }
    }
    //远端用户是否存在可播放的主路画面（一般用于摄像头）
    // print("++++++++是否1111++++$type----------$param");
    if (type == TRTCCloudListener.onUserVideoAvailable) {
      String userId = param['userId'];
      print("++++++++是否存在可播放++++$userId----------${param['available']}");

      // 根据状态对视频进行开启和关闭
      if (param['available']) {
        for (var i = 0; i < userList.length; i++) {
          if (userList[i]['userId'] == userId) {
            userList[i]['widget'] = addRoom(true, false, userId);
          }
        }
      } else {
        for (var i = 0; i < userList.length; i++) {
          if (userList[i]['userId'] == userId) {
            trtcCloud.stopRemoteView(
                userId, TRTCCloudDef.TRTC_VIDEO_STREAM_TYPE_SMALL);
            userList[i]['widget'] = addRoom(false, false, userId);
          }
        }
      }
      setState(() {});
    }

    //截图回调
    if (type == TRTCCloudListener.onSnapshotComplete) {
      print("++++++++++截图回调++++$param+");
    }
  }
}

class CustomFloatingActionButtonLocation extends FloatingActionButtonLocation {
  FloatingActionButtonLocation location;
  double offsetX; // X方向的偏移量
  double offsetY; // Y方向的偏移量
  CustomFloatingActionButtonLocation(this.location, this.offsetX, this.offsetY);

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    Offset offset = location.getOffset(scaffoldGeometry);
    return Offset(offset.dx + offsetX, offset.dy + offsetY);
  }
}
