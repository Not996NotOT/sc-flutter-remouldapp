import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:notarization_station_app/base_framework/view_model/single_view_state_model.dart';
import 'package:notarization_station_app/page/login/vm/user_view_model.dart';
import 'package:notarization_station_app/socket/mqtt_client.dart';
import 'package:notarization_station_app/utils/GenerateTestUserSig.dart';
import 'package:tencent_trtc_cloud/trtc_cloud.dart';
import 'package:tencent_trtc_cloud/trtc_cloud_def.dart';
import 'package:tencent_trtc_cloud/trtc_cloud_listener.dart';
import 'package:tencent_trtc_cloud/trtc_cloud_video_view.dart';
import 'package:tencent_trtc_cloud/tx_device_manager.dart';

import '../../../config.dart';

class LiveRoomAndIntroduceViewModel extends SingleViewStateModel
    with ClientCallback {
  UserViewModel userViewModel;

  String roomId;

  LiveRoomAndIntroduceViewModel({this.userViewModel, this.roomId});

  // 添加云端的用户
  List userList = [];

  // 当前获取的数据
  List dataList = [];

  // 标记切换的tab位置
  int tabIndex = 0;

  PageController pageController = new PageController();

  TRTCCloud trtcCloud;

  TXDeviceManager txDeviceManager;

  @override
  void clientDataHandler(onData, topic) {
    if (topic == "live_room_user_list") {
      Map data = json.decode(onData);
      if (data["roomId"] == roomId) {}
    }
  }

  @override
  Future loadData() {
    // iniRoom();
    return null;
  }

  @override
  onCompleted(data) {
    throw UnimplementedError();
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
    String userSig = await GenerateTestUserSig.genTestSig(userViewModel.idCard);
    trtcCloud.enterRoom(
        TRTCParams(
            sdkAppId: Config.sdkAppId, //应用Id
            userId: userViewModel.idCard, // 用户Id
            userSig: userSig, // 用户签名
            roomId: int.parse(roomId)), //房间Id
        TRTCCloudDef.TRTC_APP_SCENE_VIDEOCALL);
    print(
        ".......................................1${userList.length}----${userViewModel.idCard}-----$roomId");
    // userList.add({
    //   'userId': userViewModel.idCard,
    //   "widget": addRoom(true, true, userViewModel.idCard)
    // });
    // notifyListeners();
  }

  addRoom(bool video, bool isMe, String userId) {
    return Container(
      height: 230,
      child: video
          ? TRTCCloudVideoView(
              key: ValueKey(userId),
              onViewCreated: (viewId) {
                isMe
                    ? trtcCloud.startLocalPreview(true, viewId)
                    : trtcCloud.startRemoteView(userId,
                        TRTCCloudDef.TRTC_VIDEO_STREAM_TYPE_SMALL, viewId);
              })
          : SizedBox(
              height: 230,
            ),
    );
  }

  /// 事件回调
  onRtcListener(type, param) {
    print("......huidiao加入$type");
    if (type == TRTCCloudListener.onError) {
      log("错误回调------错误信息${param['errMsg']}");
    }
    if (type == TRTCCloudListener.onEnterRoom) {
      if (param > 0) {
        print('进房成功-----$param');
        // _startShareFunction();
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
      notifyListeners();
    }

    //截图回调
    if (type == TRTCCloudListener.onSnapshotComplete) {
      print("++++++++++截图回调++++$param+");
      if (param['errCode'] == 0) {
        // if (imgName == 1) {
        //   faceComparison(param['path'], "verfied", false);
        // } else {
        //   faceComparison(param['path'], "realSignCB", true);
        // }
      }
    }
    if (type == TRTCCloudListener.onScreenCaptureStarted) {
      print("++++++++++屏幕分享++++$param+");
    }
  }

  // 销毁房间的一些信息
  destoryRoom() {
    try {
      trtcCloud?.stopScreenCapture();
      trtcCloud?.muteAllRemoteAudio(true);
      trtcCloud?.stopScreenCapture();
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
  }
}
