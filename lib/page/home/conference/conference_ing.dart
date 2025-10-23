import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:http_parser/http_parser.dart';
import 'package:notarization_station_app/appTheme.dart';
import 'package:notarization_station_app/base_framework/utils/toast_util.dart';
import 'package:notarization_station_app/base_framework/widget_state/base_state.dart';
import 'package:notarization_station_app/config.dart';
import 'package:notarization_station_app/iconfont/Icon.dart';
import 'package:notarization_station_app/page/home/entity/data.dart';
import 'package:notarization_station_app/page/home/entity/vote_entity.dart';
import 'package:notarization_station_app/page/home/vm/dialog/conference_dialog_vm.dart';
import 'package:notarization_station_app/page/home/widget/noScrollBehavior.dart';
import 'package:notarization_station_app/page/infomation/widget/comment.dart';
import 'package:notarization_station_app/page/login/vm/user_view_model.dart';
import 'package:notarization_station_app/routes/router.dart';
import 'package:notarization_station_app/service_api/home_api.dart';
import 'package:notarization_station_app/socket/mqtt_client.dart';
import 'package:notarization_station_app/utils/GenerateTestUserSig.dart';
import 'package:notarization_station_app/utils/common_tools.dart';
import 'package:notarization_station_app/utils/global.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:provider/provider.dart';
import 'package:tencent_trtc_cloud/trtc_cloud.dart';
import 'package:tencent_trtc_cloud/trtc_cloud_def.dart';
import 'package:tencent_trtc_cloud/trtc_cloud_listener.dart';
import 'package:tencent_trtc_cloud/trtc_cloud_video_view.dart';
import 'package:tencent_trtc_cloud/tx_device_manager.dart';

class ConferenceIngPage extends StatefulWidget {
  @override
  _ConferenceINGPageState createState() => _ConferenceINGPageState();
}

class _ConferenceINGPageState extends BaseState<ConferenceIngPage>
    with ClientCallback {
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
  // SharedPreferences prefs;
  bool isSignature = false;
  // List<String> prefsList = [];
  UserViewModel user;

  @override
  void initState() {
    super.initState();

    isBanned = VideoConferenceData.mute == 1 ? false : true;
    iniRoom();
    MqttClientMsg.instance.setCallback(this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    if (user.idCard == null) {
      MqttClientMsg.instance?.disconnect();
    }
    wjPrint("当前节点是否被销毁了");
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
            FlatButton(
              child: Text("取消"),
              onPressed: () => Navigator.of(context).pop(), // 关闭对话框
            ),
            FlatButton(
              child: Text("确认"),
              onPressed: () {
                destoryRoom();
                MqttClientMsg.instance?.unsubscribe(
                    "/topic/conference/${VideoConferenceData.roomId}");
                //关闭对话框并返回true
                Navigator.of(context).pop(true);
                G.getCurrentState().pushReplacementNamed(RoutePaths.HomeIndex);
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
            VideoConferenceData.meetTitle,
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
                onPressed: () {
                  showHistoryVote();
                },
                child: const Text(
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
              print('#####################MqttClientMsg: ');
              print(MqttClientMsg.instance.toString());
              MqttClientMsg.instance?.postMessage(
                  json.encode({
                    "code": "quizVote",
                    "info": VideoConferenceData.id,
                    "userName": VideoConferenceData.userName
                  }),
                  "/topic/conference/collect/${VideoConferenceData.roomId}");
            },
          ),
        ),
        body: WillPopScope(
          onWillPop: () {
            showDeleteConfirmDialog1();
            return Future.value(false);
          },
          child: Consumer<UserViewModel>(builder: (ctx, userModel, child) {
            user = userModel;
            return Container(
              color: AppTheme.bg_c,
              child: Container(
                height: getHeightPx(1334),
                width: getWidthPx(750),
                child: Stack(
                  children: [
                    peopleNum(),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            //列表内容少的时候靠上
                            color: Colors.transparent,
                            height: getHeightPx(400),
                            width: getWidthPx(500),
                            alignment: Alignment.topLeft,
                            child: ScrollConfiguration(
                              behavior: EUMNoScrollBehavior(),
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  var item = chatList[index];
                                  return Align(
                                    alignment: Alignment.centerLeft,
                                    child: Container(
                                      padding:
                                          EdgeInsets.fromLTRB(15, 5, 15, 5),
                                      margin:
                                          EdgeInsets.fromLTRB(10, 10, 0, 10),
                                      decoration: new BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15)),
                                        color: Color(0x33000000),
                                      ),
                                      child: RichText(
                                        text: TextSpan(
                                          children: <TextSpan>[
                                            TextSpan(
                                              text: "${item['name']}  ",
                                              style: TextStyle(
                                                color: item['me'] == 1
                                                    ? Colors.amber
                                                    : AppTheme.themeBlue,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            TextSpan(
                                              text: "${item['info']}",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                itemCount: chatList.length,
                                physics: const AlwaysScrollableScrollPhysics(),
                                controller: msgController,
                              ),
                            ),
                          ),
                          Container(
                            width: getWidthPx(750),
                            decoration: new BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              color: Colors.transparent,
                            ),
                            margin: EdgeInsets.only(top: 1),
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              children: [
                                // InkWell(
                                //   onTap:(){
                                //     // vm.requestCameraPermission();
                                //   },
                                //   child: Icon(
                                //     Icons.photo,
                                //     color: Colors.black26,
                                //     size: 30,
                                //   ),
                                // ),
                                PopupMenuButton(
                                  padding: EdgeInsets.all(0),
                                  offset: Offset(100, -120),
                                  onSelected: (value) {
                                    if (isBanned) {
                                      sendMessage(value);
                                    }
                                  },
                                  child: Icon(
                                    Icons.title,
                                    color: Colors.black26,
                                    size: 30,
                                  ),
                                  itemBuilder:
                                      (BuildContext context) => //菜单项构造器
                                          <PopupMenuEntry>[
                                    PopupMenuItem(
                                      value: '本人已连接，做好开会准备了。',
                                      child: Text("本人已连接，做好开会准备了。"),
                                    ),
                                    PopupMenuItem(
                                      value: '针对这个问题，我有一些看法！',
                                      child: Text("针对这个问题，我有一些看法！"),
                                    ),
                                    PopupMenuItem(
                                      value: '是否可以重复一下刚刚的观点！',
                                      child: Text("是否可以重复一下刚刚的观点！"),
                                    ),
                                  ],
                                ),
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      if (isBanned) {
                                        showDialog<String>(
                                            context: context, //BuildContext对象
                                            builder: (BuildContext context) {
                                              return GestureDetector(
                                                onTap: () {
                                                  G.pop(); //点击背景透明层，退出弹出框
                                                },
                                                child: CommentDialog(
                                                    params: "",
                                                    callback: (o) {
                                                      G.pop();
                                                      sendMessage(o);
                                                    }),
                                              );
                                            });
                                      }
                                    },
                                    child: Container(
                                      margin: EdgeInsets.fromLTRB(6, 6, 10, 6),
                                      padding: EdgeInsets.fromLTRB(5, 3, 0, 0),
                                      decoration: BoxDecoration(
                                          color: Color(0x33000000),
                                          borderRadius:
                                              BorderRadius.circular(6)),
                                      constraints: BoxConstraints(
                                          minHeight: 30.0, maxHeight: 100.0),
                                      child: Text(
                                        isBanned ? "请输入聊天内容" : "全体禁言中",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 14),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ));
  }

  Widget peopleNum() {
    return Column(
      children: [
        Container(
          height: getWidthPx(500),
          child: notaryInfo['widget'] == null
              ? Stack(
                  children: [
                    otherUser['widget'] != null
                        ? otherUser['widget']
                        : SizedBox(),
                    Positioned(
                      top: 4,
                      left: 10,
                      child: Row(
                        children: [
                          Text(
                              "主持人 ${otherUser['name'] == null ? "" : otherUser['name']}",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 14)),
                          SizedBox(
                            width: 6,
                          ),
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                                shape: BoxShape
                                    .circle, //可以设置角度，BoxShape.circle直接圆形
                                color: Colors.green),
                          )
                        ],
                      ),
                    ),
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                      child: Container(
                        child: Stack(
                          children: [
                            otherUser['widget'] != null
                                ? otherUser['widget']
                                : SizedBox(),
                            Positioned(
                              top: 4,
                              left: 10,
                              child: Row(
                                children: [
                                  Text(
                                      "主持人 ${otherUser['name'] == null ? "" : otherUser['name']}",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 14)),
                                  SizedBox(
                                    width: 6,
                                  ),
                                  Container(
                                    width: 10,
                                    height: 10,
                                    decoration: BoxDecoration(
                                        shape: BoxShape
                                            .circle, //可以设置角度，BoxShape.circle直接圆形
                                        color: Colors.green),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: Stack(
                          children: [
                            notaryInfo['widget'] != null
                                ? notaryInfo['widget']
                                : SizedBox(),
                            Positioned(
                              top: 4,
                              left: 10,
                              child: Row(
                                children: [
                                  Text(
                                      "公证员 ${notaryInfo['name'] == null ? "" : notaryInfo['name']}",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 14)),
                                  SizedBox(
                                    width: 6,
                                  ),
                                  Container(
                                    width: 10,
                                    height: 10,
                                    decoration: BoxDecoration(
                                        shape: BoxShape
                                            .circle, //可以设置角度，BoxShape.circle直接圆形
                                        color: Colors.green),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
        ),
        Expanded(
          child: Center(
            child: ScrollConfiguration(
              behavior: EUMNoScrollBehavior(),
              child: allowList.length == 0
                  ? SizedBox()
                  : GridView.builder(
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: allowList.length < 3
                            ? allowList.length
                            : allowList.length < 7
                                ? 2
                                : 3, //每行三列
                        childAspectRatio: 1.0, //显示区域宽高相等
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                      ),
                      itemCount: allowList.length,
                      itemBuilder: (context, index) {
                        return Stack(
                          children: [
                            allowList[index]['widget'] != null
                                ? allowList[index]['widget']
                                : SizedBox(),
                            Positioned(
                              top: 4,
                              left: 10,
                              child: Row(
                                children: [
                                  Text(
                                      allowList[index]['userId'] ==
                                              VideoConferenceData.id
                                          ? "我"
                                          : "主讲人 ${allowList[index]['name'] == null ? "" : allowList[index]['name']}",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 14)),
                                  SizedBox(
                                    width: 6,
                                  ),
                                  Container(
                                    width: 10,
                                    height: 10,
                                    decoration: BoxDecoration(
                                        shape: BoxShape
                                            .circle, //可以设置角度，BoxShape.circle直接圆形
                                        color: Colors.green),
                                  )
                                ],
                              ),
                            ),
                          ],
                        );
                      }),
            ),
          ),
        ),
      ],
    );
  }

  iniRoom() async {
    // prefs = await SharedPreferences.getInstance();
    // isSignature = prefs.getBool("isSignature");
    // if (isSignature == null) {
    //   prefs.setBool("isSignature", false);
    // }
    // if (prefs.getString("startVote") != null) {
    //   List item = json.decode(prefs.getString("startVote"));
    //   item.forEach((e) {
    //     voteList.add(JsonConvert.fromJsonAsT(e));
    //   });
    // }
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
    String userSig =
        await GenerateTestUserSig.genTestSig(VideoConferenceData.id);
    trtcCloud.enterRoom(
        TRTCParams(
            sdkAppId: Config.sdkAppId, //应用Id
            userId: VideoConferenceData.id, // 用户Id
            userSig: userSig, // 用户签名
            strRoomId: VideoConferenceData.roomId), //房间Id
        TRTCCloudDef.TRTC_APP_SCENE_VIDEOCALL);
    // userList.add({'userId':VideoConferenceData.id,"widget":addRoom(true,true,VideoConferenceData.id),"name":VideoConferenceData.userName,"type":VideoConferenceData.userType,"idCard":VideoConferenceData.userIdCard});
    allowList.add({
      'userId': VideoConferenceData.id,
      "widget": addRoom(true, true, VideoConferenceData.id),
      "name": VideoConferenceData.userName,
      "type": VideoConferenceData.userType,
      "idCard": VideoConferenceData.userIdCard
    });
    trtcCloud?.stopLocalAudio();
    setState(() {});
  }

  // 销毁房间的一些信息
  destoryRoom() {
    try {
      trtcCloud?.muteAllRemoteAudio(true);
      trtcCloud?.stopLocalPreview();
    } catch (e) {
      print("....$e");
    }
    try {
      trtcCloud?.stopAllRemoteView();
      trtcCloud?.stopLocalAudio();
    } catch (e) {
      print("....$e");
    }
    try {
      trtcCloud?.exitRoom();
      trtcCloud?.unRegisterListener(onRtcListener);
    } catch (e) {
      print("....$e");
    }
    try {
      TRTCCloud?.destroySharedInstance();
    } catch (e) {
      print("....$e");
    }
    print('是否销毁了！');
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
        MqttClientMsg.instance
            .subscribe("/topic/conference/${VideoConferenceData.roomId}");
        // isSignature = prefs.getBool("isSignature") ?? false;
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
      List info = param.toString().split("-");
      if (param.toString().split("-")[0] == "notary") {
        notaryInfo = {
          'userId': param,
          "widget": addRoom(false, false, param),
          "name": info[1],
          "type": info[0],
          "idCard": info[2]
        };
      } else if (param.toString().split("-")[0] == "host") {
        otherUser = {
          'userId': param,
          "widget": addRoom(false, false, param),
          "name": info[1],
          "type": info[0],
          "idCard": info[2]
        };
      } else {
        userList.add({
          'userId': param,
          "widget": addRoom(false, false, param),
          "name": info[1],
          "type": info[0],
          "idCard": info[2]
        });
      }
    }
    // 远端用户离开房间
    if (type == TRTCCloudListener.onRemoteUserLeaveRoom) {
      String userId = param['userId'];
      if (userId == notaryInfo['userId']) {
        notaryInfo.clear();
      } else if (userId == otherUser['userId']) {
        otherUser.clear();
      } else {
        for (var i = 0; i < userList.length; i++) {
          if (userList[i]['userId'] == userId) {
            userList.removeAt(i);
          }
        }
        for (var i = 0; i < allowList.length; i++) {
          if (allowList[i]['userId'] == userId) {
            allowList.removeAt(i);
          }
        }
      }
    }
    //远端用户是否存在可播放的主路画面（一般用于摄像头）
    if (type == TRTCCloudListener.onUserVideoAvailable) {
      String userId = param['userId'];
      print("++++++++是否存在可播放++++$userId----------${param['available']}");

      // 根据状态对视频进行开启和关闭
      if (param['available']) {
        if (userId == notaryInfo['userId']) {
          notaryInfo['widget'] = addRoom(true, false, userId);
        } else if (userId == otherUser['userId']) {
          otherUser['widget'] = addRoom(true, false, userId);
        } else {
          for (var i = 0; i < userList.length; i++) {
            if (userList[i]['userId'] == userId) {
              userList[i]['widget'] = addRoom(true, false, userId);
            }
          }
          // for (var i = 0; i < prefsList.length; i++) {
          //   if (prefsList[i] == userId) {
          //     allowList[i]['widget'] = addRoom(true,false,userId);
          //   }
          // }
        }
      } else {
        if (userId == notaryInfo['userId']) {
          trtcCloud.stopRemoteView(
              userId, TRTCCloudDef.TRTC_VIDEO_STREAM_TYPE_SMALL);
          notaryInfo['widget'] = addRoom(false, false, userId);
        } else if (userId == otherUser['userId']) {
          trtcCloud.stopRemoteView(
              userId, TRTCCloudDef.TRTC_VIDEO_STREAM_TYPE_SMALL);
          otherUser['widget'] = addRoom(false, false, userId);
        } else {
          for (var i = 0; i < userList.length; i++) {
            if (userList[i]['userId'] == userId) {
              trtcCloud.stopRemoteView(
                  userId, TRTCCloudDef.TRTC_VIDEO_STREAM_TYPE_SMALL);
              userList[i]['widget'] = addRoom(false, false, userId);
            }
          }
          // for (var i = 0; i < allowList.length; i++) {
          //   if (allowList[i]['userId'] == userId) {
          //     allowList[i]['widget'] = addRoom(false,false,userId);
          //   }
          // }
        }
      }
      // if(prefs.getStringList("speak")!=null&&prefs.getStringList("speak").length!=0){
      //   log("进房成功------1${prefs.getStringList("speak")}");
      //   List allowPrefs = prefs.getStringList("speak");
      //   allowPrefs.forEach((el) {
      //     if(el!=VideoConferenceData.id){
      //       log("进房成功------3${userList.length}");
      //       userList.forEach((e) {
      //         if(e['userId']==el){
      //           if(!allowList.any((e) => e['userId'] == el)){
      //             allowList.add(e);
      //           }
      //         }
      //       });
      //       log("进房成功------3${allowList.length}");
      //     }else{
      //       ToastUtil.showOtherToast("你当前在麦上，可以讲话");
      //       trtcCloud?.startLocalAudio(70);
      //     }
      //   });
      // }

      setState(() {});
    }

    //截图回调
    if (type == TRTCCloudListener.onSnapshotComplete) {
      print("++++++++++截图回调++++$param+");
      if (param['errCode'] == 0) {
        faceComparison(param['path']);
      }
    }
  }

  //签字
  showSignature(String name, String idCard, String tyKeyword, String offSet,
      String code) {
    String url =
        "${Config.caUrl}?name=$name&idCard=${idCard == "" ? "未填写身份证号" : idCard}&tyKeyword=$tyKeyword&offSet=$offSet&terminalType=flutter";
    if (Platform.isIOS) {
      url = Uri.encodeFull(url);
    }
    showDialog(
        context: G.getCurrentState().overlay.context,
        builder: (ctx) {
          print('roomId: ${VideoConferenceData.roomId}');
          print('userName: ${VideoConferenceData.userName}');
          print('userId: ${VideoConferenceData.userId}');
          return DemoPage(
            label: url,
            code: code,
            roomId: VideoConferenceData.roomId,
            userName: VideoConferenceData.userName,
            userId: VideoConferenceData.userId,
            pdfUrl: pdfUrl,
          );

          // return WillPopScope(
          //   onWillPop:(){
          //     return Future.value(false);
          //   },
          //   child: WebViewPlus(
          //     javascriptMode: JavascriptMode.unrestricted,
          //     onWebViewCreated: (controller) {
          //       controller.loadUrl(url,headers: {});
          //     },
          //     javascriptChannels: <JavascriptChannel>[
          //       JavascriptChannel(
          //           name: "share",
          //           onMessageReceived: (JavascriptMessage message) {
          //             if(message.message!=null){
          //               Map msg =  json.decode(message.message);
          //               G.pop();
          //               Map<String, dynamic> data = {
          //                 "userId":VideoConferenceData.userId,
          //                 "pdfPath":pdfUrl,
          //                 "sign":json.decode(msg['encDataFilePath']),
          //                 "userToken":VideoConferenceData.userId
          //               };
          //               HomeApi.getSingleton().postSignature(data).then((res){
          //                 print("...33333....$res");
          //                 if(res['code']==200){
          //                   prefs.setBool("isSignature", true);
          //               print('=================================================');
          //                   MqttClientMsg.instance?.postMessage(json.encode({"code":code,"info": "已签字","userName":VideoConferenceData.userName}),"/topic/conference/collect/${VideoConferenceData.roomId}");
          //                 }
          //               });
          //             }
          //           }
          //       ),
          //     ].toSet(),
          //     onPageFinished: (url) {
          //       print('....$url');
          //     },
          //   ),
          // );
        });
  }

  @override
  void clientDataHandler(onData, topic) {
    print('MQTT的消息...$onData....$topic');
    if (topic == "conference") {
      var orderData = json.decode(onData);
      print('MQTT的消息11...$orderData');
      socketInfo(orderData);
    }
  }

  socketInfo(info) {
    if (info['code'] == "startVote") {
      bool isVote = true;
      voteList.forEach((element) {
        if (element.voteName == info['name']) {
          isVote = false;
        }
      });
      if (isVote) {
        isShow = true;
        VoteEntity data = new VoteEntity();
        data.voteData = <VoteVoteData>[];
        VoteVoteData option1 = new VoteVoteData();
        option1.optionName = "同意";
        VoteVoteData option2 = new VoteVoteData();
        option2.optionName = "反对";
        VoteVoteData option3 = new VoteVoteData();
        option3.optionName = "弃权";
        data.voteData.add(option1);
        data.voteData.add(option2);
        data.voteData.add(option3);
        data.voteImg = json.decode(info['imagePath'] ?? '[]');
        data.voteName = info['name'];
        presentVote = data;
        voteList.add(data);
        // prefs.remove("startVote");
        // prefs.setString("startVote", json.encode(voteList));
        // print("----------------------1${prefs.getString("startVote")}");
        showVote(data);
      }
    } else if (info['code'] == "VoteSign") {
      // isSignature = prefs.getBool("isSignature");
      // print('判断是否重复签字isSignature：  ${isSignature}');
      if (!isSignature) {
        isSignature = true;
        postVote();
      }
    } else if (info['code'] == "stopVote") {
      G.pop();
    } else if (info['code'] == "canSpeak") {
      if (info['info'] != VideoConferenceData.id) {
        userList.forEach((e) {
          if (e['userId'] == info['info']) {
            allowList.add(e);
          }
        });
      } else {
        ToastUtil.showOtherToast("你当前在麦上，可以讲话");
        trtcCloud?.startLocalAudio(70);
      }
      // try{
      //   prefsList.add(info['info']);
      //   prefs.remove("speak");
      //   prefs.setStringList("speak", prefsList);
      // }catch(e){
      //   log("进房成功------1$e");
      // }
    } else if (info['code'] == "nocanSpeak") {
      if (info['info'] != VideoConferenceData.id) {
        for (var i = 0; i < allowList.length; i++) {
          if (allowList[i]['userId'] == info['info']) {
            allowList.removeAt(i);
          }
        }
      } else {
        ToastUtil.showOtherToast("你当前被下麦，不可讲话");
        trtcCloud?.stopLocalAudio();
      }

      // try{
      //   for (var i = 0; i < prefsList.length; i++) {
      //     if (prefsList[i] == info['info']) {
      //       prefsList.removeAt(i);
      //     }
      //   }
      //   prefs.remove("speak");
      //   prefs.setStringList("speak", prefsList);
      // }catch(e){
      //   log("进房成功------1$e");
      // }

    } else if (info['code'] == "quitMeeting") {
      ToastUtil.showOtherToast("退出了视频会议了");
      destoryRoom();
      MqttClientMsg.instance
          ?.unsubscribe("/topic/conference/${VideoConferenceData.roomId}");
      G.getCurrentState().pushReplacementNamed(RoutePaths.HomeIndex);
      // prefs.remove("isSignature");
      // G.pop();
    } else if (info['code'] == "checkFace") {
      if (info['userId'] == "" ||
          info['userId'] == VideoConferenceData.userIdCard) {
        captureImg();
      }
    } else if (info['code'] == "chatMessage") {
      if (info['senderId'] != VideoConferenceData.userIdCard) {
        addChatList(info['sender'], info['msg'], 0, info['img']);
      }
    } else if (info['code'] == "nomute") {
      isBanned = true;
    } else if (info['code'] == "mute") {
      isBanned = false;
    }
    setState(() {});
  }

  captureImg() async {
    final directory = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    String _downloadPath =
        '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.png';
    print("++++++++++++++++++++++++++++++$_downloadPath");
    trtcCloud.snapshotVideo(
        "", TRTCCloudDef.TRTC_VIDEO_STREAM_TYPE_BIG, 0, _downloadPath);
  }

  postVote() {
    Map<String, dynamic> data = {
      "name": VideoConferenceData.userName,
      "voteList": voteList
    };
    // print("++++++++++++++++++++++++++++++$_downloadPath");

    HomeApi.getSingleton().postVote(data).then((res) {
      print("...2222....$res");
      if (res['code'] == 200) {
        pdfUrl = res['item']['pdf'];
        showImg(res['item']['image']);
      } else {
        isSignature = false;
      }
    });
  }

  showImg(List info) {
    showDialog(
        barrierDismissible: false,
        context: G.getCurrentState().overlay.context,
        builder: (ctx) {
          return WillPopScope(
            onWillPop: () {
              return Future.value(false);
            },
            child: Dialog(
              child: Container(
                width: getWidthPx(750),
                height: getWidthPx(750),
                child: Column(
                  children: [
                    Expanded(
                        child: PhotoViewGallery.builder(
                      backgroundDecoration: BoxDecoration(
                        color: Colors.transparent,
                      ),
                      scrollPhysics: const BouncingScrollPhysics(),
                      builder: (BuildContext context, int index) {
                        return PhotoViewGalleryPageOptions(
                          imageProvider: NetworkImage(info[index]),
                        );
                      },
                      itemCount: info.length,
                      enableRotation: true,
                    )),
                    // ignore: deprecated_member_use
                    MaterialButton(
                      color: AppTheme.themeBlue,
                      child: Text(
                        "已查阅",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        G.pop();
                        showSignature(
                            VideoConferenceData.userName,
                            VideoConferenceData.userIdCard,
                            "shiping,决议人签名",
                            "0",
                            "signature");
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  showHistoryVote() {
    print("----------------------------${voteList.length}");
    showModalBottomSheet(
        backgroundColor: Colors.white,
        context: G.getCurrentState().overlay.context,
        enableDrag: false,
        builder: (ctx) {
          return WillPopScope(
            onWillPop: () {
              return Future.value(false);
            },
            child: StatefulBuilder(
              builder: (ctx, setBottomSheet) {
                return Container(
                  width: getWidthPx(750),
                  child: Column(
                    children: [
                      Container(
                        width: getWidthPx(750),
                        padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                        decoration: new BoxDecoration(
                          color: AppTheme.themeBlue,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                                child: Text(
                              "会议历史表决(左右滑动切换,上下滚动查看表决文书)",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12),
                            )),
                            IconButton(
                              icon: Icon(
                                Icons.clear,
                                color: Colors.white,
                                size: 16,
                              ),
                              tooltip: "关闭",
                              onPressed: () {
                                G.pop();
                              },
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Swiper(
                          itemBuilder: (BuildContext context, int index) {
                            VoteEntity item = voteList[index];
                            return Column(
                              children: [
                                Container(
                                  width: getWidthPx(750),
                                  padding: EdgeInsets.all(8),
                                  decoration: new BoxDecoration(),
                                  child: Text(
                                    "  ${index + 1}. ${item.voteName}",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                item.voteImg == null
                                    ? SizedBox()
                                    : Expanded(
                                        child: PhotoViewGallery.builder(
                                          scrollPhysics:
                                              const BouncingScrollPhysics(),
                                          builder: (BuildContext context,
                                              int index) {
                                            return PhotoViewGalleryPageOptions(
                                              imageProvider: NetworkImage(
                                                  item.voteImg[index]),
                                              initialScale:
                                                  PhotoViewComputedScale
                                                          .contained *
                                                      0.8,
                                              heroAttributes:
                                                  PhotoViewHeroAttributes(
                                                      tag: index + 1),
                                            );
                                          },
                                          scrollDirection: Axis.vertical,
                                          itemCount: item.voteImg.length,
                                          loadingBuilder: (context, event) =>
                                              Center(
                                            child: Container(
                                              width: 20.0,
                                              height: 20.0,
                                              child: CircularProgressIndicator(
                                                value: event == null
                                                    ? 0
                                                    : event.cumulativeBytesLoaded /
                                                        event
                                                            .expectedTotalBytes,
                                              ),
                                            ),
                                          ),
                                          backgroundDecoration: BoxDecoration(
                                            color: AppTheme.bg_c,
                                          ),
                                        ),
                                      ),
                                voteOption(item.voteData, setBottomSheet,
                                    item.voteName)
                              ],
                            );
                          },
                          loop: false,
                          itemCount: voteList.length,
                          // pagination: SwiperPagination(),
                          // control: SwiperControl(),
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          );
        });
  }

  Widget voteOption(List<VoteVoteData> info, setBottomSheet, String voteName) {
    bool isList = true;
    String data = "";
    info.forEach((e) {
      print("122222${e.optionData}");
      if (e.optionData != null && e.optionData.isNotEmpty) {
        isList = false;
        data = e.optionData;
      }
    });
    if (isList) {
      return Container(
        width: getWidthPx(750),
        height: getWidthPx(100),
        margin: EdgeInsets.fromLTRB(10, 6, 10, 6),
        decoration: new BoxDecoration(
          color: Color.fromRGBO(33, 33, 33, 0.7),
          borderRadius: BorderRadius.all(Radius.circular(4.0)),
        ),
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: info == null ? 0 : info.length,
            itemBuilder: (ctx, a) {
              VoteVoteData el = info[a];
              return Container(
                width: getWidthPx(750) / info.length,
                child: TextButton(
                    onPressed: () {
                      el.optionData = el.optionName;
                      // prefs.remove("startVote");
                      // prefs.setString("startVote", json.encode(voteList));
                      MqttClientMsg.instance?.postMessage(
                          json.encode({
                            "code": "voteResult",
                            "info": el.optionName,
                            "voteName": voteName,
                            "userName": VideoConferenceData.userName
                          }),
                          "/topic/conference/collect/${VideoConferenceData.roomId}");
                      isShow = false;
                      setBottomSheet(() {});
                    },
                    child: Text(
                      " ${el.optionName}",
                      style: TextStyle(
                          color: el.optionName == "同意"
                              ? Colors.green
                              : el.optionName == "反对"
                                  ? Colors.red
                                  : Colors.amber,
                          fontSize: 14),
                    )),
              );
            }),
      );
    } else {
      return Container(
        width: getWidthPx(750),
        height: getWidthPx(100),
        margin: EdgeInsets.fromLTRB(10, 6, 10, 6),
        decoration: new BoxDecoration(
          color: Color.fromRGBO(33, 33, 33, 0.7),
          borderRadius: BorderRadius.all(Radius.circular(4.0)),
        ),
        child: Center(
            child: Text(
          "你选择是：$data",
          style: TextStyle(color: Colors.green, fontSize: 14),
        )),
      );
    }
  }

  showVote(VoteEntity data) {
    if (isShowVote == 1) {
      isShowVote = 2;
    } else {
      // G.pop();
    }
    showModalBottomSheet(
        backgroundColor: Colors.white,
        context: G.getCurrentState().overlay.context,
        builder: (ctx) {
          return WillPopScope(
            onWillPop: () {
              return Future.value(false);
            },
            child: StatefulBuilder(
              builder: (ctx, setBottomSheet) {
                return Container(
                  width: getWidthPx(750),
                  height: getHeightPx(1000),
                  child: Column(
                    children: [
                      Container(
                        width: getWidthPx(750),
                        padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                        decoration: new BoxDecoration(
                          color: AppTheme.themeBlue,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                                child: Text(
                              "会议表决",
                              style: TextStyle(color: Colors.white),
                            )),
                            IconButton(
                              icon: Icon(
                                Icons.clear,
                                color: Colors.white,
                              ),
                              tooltip: "关闭",
                              onPressed: () {
                                G.pop();
                              },
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: getWidthPx(750),
                        padding: EdgeInsets.all(8),
                        decoration: new BoxDecoration(),
                        child: Text(
                          "  ${data.voteName}",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      data.voteImg == null
                          ? SizedBox()
                          : Expanded(
                              child: PhotoViewGallery.builder(
                              scrollPhysics: const BouncingScrollPhysics(),
                              builder: (BuildContext context, int index) {
                                return PhotoViewGalleryPageOptions(
                                  imageProvider:
                                      NetworkImage(data.voteImg[index]),
                                  initialScale:
                                      PhotoViewComputedScale.contained * 0.8,
                                  heroAttributes:
                                      PhotoViewHeroAttributes(tag: index + 1),
                                );
                              },
                              scrollDirection: Axis.vertical,
                              itemCount: data.voteImg.length,
                              loadingBuilder: (context, event) => Center(
                                child: Container(
                                  width: 20.0,
                                  height: 20.0,
                                  child: CircularProgressIndicator(
                                    value: event == null
                                        ? 0
                                        : event.cumulativeBytesLoaded /
                                            event.expectedTotalBytes,
                                  ),
                                ),
                              ),
                              backgroundDecoration: BoxDecoration(
                                color: AppTheme.bg_c,
                              ),
                            )),
                      isShow
                          ? Container(
                              width: getWidthPx(750),
                              height: getWidthPx(100),
                              margin: EdgeInsets.fromLTRB(10, 6, 10, 6),
                              decoration: new BoxDecoration(
                                color: Color.fromRGBO(33, 33, 33, 0.7),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4.0)),
                              ),
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: data.voteData == null
                                      ? 0
                                      : data.voteData.length,
                                  itemBuilder: (ctx, a) {
                                    VoteVoteData item = data.voteData[a];
                                    return Container(
                                      width: getWidthPx(750) /
                                          data.voteData.length,
                                      child: TextButton(
                                          onPressed: () {
                                            item.optionData = item.optionName;
                                            voteList.forEach((el) {
                                              if (el.voteName ==
                                                  data.voteName) {
                                                el.voteData[a].optionData =
                                                    item.optionName;
                                              }
                                            });
                                            // prefs.remove("startVote");
                                            // prefs.setString("startVote",
                                            //     json.encode(voteList));
                                            MqttClientMsg.instance?.postMessage(
                                                json.encode({
                                                  "code": "voteResult",
                                                  "info": item.optionName,
                                                  "voteName":
                                                      data.voteName,
                                                  "userName":
                                                      VideoConferenceData
                                                          .userName
                                                }),
                                                "/topic/conference/collect/${VideoConferenceData.roomId}");
                                            isShow = false;
                                            setBottomSheet(() {});
                                          },
                                          child: Text(
                                            " ${item.optionName}",
                                            style: TextStyle(
                                                color: item.optionName == "同意"
                                                    ? Colors.green
                                                    : item.optionName == "反对"
                                                        ? Colors.red
                                                        : Colors.amber,
                                                fontSize: 14),
                                          )),
                                    );
                                  }),
                            )
                          : SizedBox()
                    ],
                  ),
                );
              },
            ),
          );
        });
  }

  faceComparison(String path) async {
    final result = await FlutterImageCompress.compressWithFile(
      path,
      minWidth: 2300, //压缩后的最小宽度
      minHeight: 1500, //压缩后的最小高度
      quality: 20, //压缩质量
      rotate: 0, //旋转角度
    );
    String name = path.substring(path.lastIndexOf("/") + 1, path.length);
    MultipartFile multipartFile = MultipartFile.fromBytes(
      result,
      filename: name,
      contentType: MediaType("image", "jpg"),
    );
    HomeApi.getSingleton().uploadPictures(multipartFile).then((res) {
      print('-------------------------$res');
      if (res['code'] == 200) {
        Map<String, dynamic> data = {
          "name": VideoConferenceData.userName,
          "idCard": VideoConferenceData.userIdCard,
          "image": Config.splicingImageUrl(res['item']['filePath']),
          "image_type": 'url'
        };
        HomeApi.getSingleton().faceComparison(data).then((element) {
          MqttClientMsg.instance?.postMessage(
              json.encode({
                "code": "huiYicheckFaceBack",
                "id": VideoConferenceData.id,
                "info": element['code'] == 200 ? "1" : "2",
                "userName": VideoConferenceData.userName
              }),
              "/topic/conference/collect/${VideoConferenceData.roomId}");
        });
      }
    });
  }

  // 滚动消息至聊天底部
  scrollMsgBottom() {
    Timer(Duration(milliseconds: 100),
        () => msgController.jumpTo(msgController.position.maxScrollExtent));
  }

  //发送消息
  sendMessage(String msg) {
    MqttClientMsg.instance?.postMessage(
        json.encode({
          "code": "chatMessage",
          "msg": msg,
          "sender": VideoConferenceData.userName,
          "img": 0
        }),
        "/topic/conference/collect/${VideoConferenceData.roomId}");
    MqttClientMsg.instance?.postMessage(
        json.encode({
          "code": "chatMessage",
          "msg": msg,
          "sender": VideoConferenceData.userName,
          "senderId": VideoConferenceData.userIdCard,
          "img": 0
        }),
        "/topic/conference/${VideoConferenceData.roomId}");
    addChatList(VideoConferenceData.userName, msg, 1, 0);
  }

  addChatList(String name, text, int num, int imgNum) {
    var info = {
      "name": name,
      "time":
          "${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}:${DateTime.now().second.toString().padLeft(2, '0')}",
      "info": text,
      "me": num,
      "isImg": imgNum,
    };
    chatList.add(info);
    scrollMsgBottom();
    setState(() {});
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
