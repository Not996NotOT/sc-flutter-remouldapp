import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:amap_location_fluttify/amap_location_fluttify.dart';
import 'package:camera/camera.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http_parser/http_parser.dart';
import 'package:notarization_station_app/base_framework/utils/toast_util.dart';
import 'package:notarization_station_app/base_framework/view_model/single_view_state_model.dart';
import 'package:notarization_station_app/base_framework/widget/photo_view/photo_view_gallery.dart';
import 'package:notarization_station_app/page/home/vm/bottomsheet/protocol_bottomsheet_vm.dart';
import 'package:notarization_station_app/page/login/vm/user_view_model.dart';
import 'package:notarization_station_app/routes/router.dart';
import 'package:notarization_station_app/service_api/home_api.dart';
import 'package:notarization_station_app/socket/mqtt_client.dart';
import 'package:notarization_station_app/utils/global.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tencent_trtc_cloud/trtc_cloud.dart';
import 'package:tencent_trtc_cloud/trtc_cloud_def.dart';
import 'package:tencent_trtc_cloud/trtc_cloud_listener.dart';
import 'package:tencent_trtc_cloud/trtc_cloud_video_view.dart';
import 'package:tencent_trtc_cloud/tx_device_manager.dart';

import '../../../config.dart';
import '../../../utils/GenerateTestUserSig.dart';
// import 'package:geocode/geocode.dart';

class ProtocolIngViewModel extends SingleViewStateModel with ClientCallback {
  UserViewModel userViewModel;
  String roomId;
  String unitGuid;
  double videoHeight;
  int showOneImg = 1;
  StreamSubscription<ConnectivityResult> subscription;
  Timer timer;
  CameraController cameraController;
  List<CameraDescription> cameras = [];
  int camerasNum = 1;

  String captureCode = "";
  bool isBase64 = false;

  //RTC相关
  RtcEngine engine;
  List userList = [];
  // int notaryInfo = 0;
  List protocolInfoList = [];

  //
  // Map<String, Object> _locationResult;
  //
  // StreamSubscription<Map<String, Object>> _locationListener;
  //
  // AMapFlutterLocation _locationPlugin = new AMapFlutterLocation();

// 腾讯
  // final String roomId;

  ProtocolIngViewModel(this.userViewModel, this.roomId, this.unitGuid);

  setCameras(List<CameraDescription> info) {
    cameras = info;
  }

  @override
  onCompleted(data) {}

  @override
  Future loadData() {
    MqttClientMsg.instance.setCallback(this);
    // 声网
    // initPlatformState();
    // 腾讯
    iniRoom();
    getNetwork();
    getProtocolInfo();
    return null;
  }

  getProtocolInfo() {
    Map<String, String> map = {
      "projectId": unitGuid,
      "idCard": userViewModel.idCard
    };
    print(map);
    HomeApi.getSingleton().getProtocolInfo(map).then((res) {
      print('+++++++++++++$res');
      if (res['code'] == 200) {
        protocolInfoList = res['item'];
        notifyListeners();
      }
    });
  }

  socketInfo(info) {
    if (info['code'] == 2100) {
      showImg(info, false);
    } else if (info['code'] == 2102) {
      getLocation(info['orderId']);
      // getAmapLocation();
    } else if (info['code'] == 2101) {
      showSignature(info['name'], info['idCard'], info['keyword'],
          "${info['offSet']}", "2101", info['orderId'], info['companyId'],
          annexId: info['annexId'], path: info['path']);
    } else if (info['code'] == "2103") {
      // capturePng("2103",info['orderId']);
      print('截图captureImg');
      captureImg();
    } else if (info['code'] == "400") {
      // closeRoom();
      closeSocket();
      if (showOneImg != 1) {
        G.pop();
      }
      G.getCurrentState().popUntil(ModalRoute.withName(RoutePaths.HomeIndex));
    }
    notifyListeners();
  }

  //
  // ///开始定位
  // getAmapLocation(){
  //   if (Platform.isIOS) {
  //     requestAccuracyAuthorization();
  //   }
  //   ///注册定位结果监听
  //   _locationListener = _locationPlugin
  //       .onLocationChanged()
  //       .listen((Map<String, Object> result) {
  //         print("getAmapLocation-----$result");
  //   });
  //
  //   if (null != _locationPlugin) {
  //     ///开始定位之前设置定位参数
  //     _setLocationOption();
  //     _locationPlugin.startLocation();
  //   }
  // }
  // ///停止定位
  // void _stopLocation() {
  //   if (null != _locationPlugin) {
  //     _locationPlugin.stopLocation();
  //   }
  // }
  //
  // ///获取iOS native的accuracyAuthorization类型
  // void requestAccuracyAuthorization() async {
  //   AMapAccuracyAuthorization currentAccuracyAuthorization =
  //   await _locationPlugin.getSystemAccuracyAuthorization();
  //   if (currentAccuracyAuthorization ==
  //       AMapAccuracyAuthorization.AMapAccuracyAuthorizationFullAccuracy) {
  //     print("精确定位类型");
  //   } else if (currentAccuracyAuthorization ==
  //       AMapAccuracyAuthorization.AMapAccuracyAuthorizationReducedAccuracy) {
  //     print("模糊定位类型");
  //   } else {
  //     print("未知定位类型");
  //   }
  // }
  //
  // ///设置定位参数
  // void _setLocationOption() {
  //   if (null != _locationPlugin) {
  //     AMapLocationOption locationOption = new AMapLocationOption();
  //
  //     ///是否单次定位
  //     locationOption.onceLocation = false;
  //
  //     ///是否需要返回逆地理信息
  //     locationOption.needAddress = true;
  //
  //     ///逆地理信息的语言类型
  //     locationOption.geoLanguage = GeoLanguage.DEFAULT;
  //
  //     locationOption.desiredLocationAccuracyAuthorizationMode =
  //         AMapLocationAccuracyAuthorizationMode.ReduceAccuracy;
  //
  //     locationOption.fullAccuracyPurposeKey = "AMapLocationScene";
  //
  //     ///设置Android端连续定位的定位间隔
  //     locationOption.locationInterval = 2000;
  //
  //     ///设置Android端的定位模式<br>
  //     ///可选值：<br>
  //     ///<li>[AMapLocationMode.Battery_Saving]</li>
  //     ///<li>[AMapLocationMode.Device_Sensors]</li>
  //     ///<li>[AMapLocationMode.Hight_Accuracy]</li>
  //     locationOption.locationMode = AMapLocationMode.Hight_Accuracy;
  //
  //     ///设置iOS端的定位最小更新距离<br>
  //     locationOption.distanceFilter = -1;
  //
  //     ///设置iOS端期望的定位精度
  //     /// 可选值：<br>
  //     /// <li>[DesiredAccuracy.Best] 最高精度</li>
  //     /// <li>[DesiredAccuracy.BestForNavigation] 适用于导航场景的高精度 </li>
  //     /// <li>[DesiredAccuracy.NearestTenMeters] 10米 </li>
  //     /// <li>[DesiredAccuracy.Kilometer] 1000米</li>
  //     /// <li>[DesiredAccuracy.ThreeKilometers] 3000米</li>
  //     locationOption.desiredAccuracy = DesiredAccuracy.Best;
  //
  //     ///设置iOS端是否允许系统暂停定位
  //     locationOption.pausesLocationUpdatesAutomatically = false;
  //
  //     ///将定位参数设置给定位插件
  //     _locationPlugin.setLocationOption(locationOption);
  //   }
  // }

  getLocation(String data) async {
    print("位置信息：-----");
    if(!await Permission.location.status.isGranted){
      G.showCustomToast(
        context: G.getCurrentState().overlay.context,
        titleText: "定位权限使用说明：",
        subTitleText: "用于获取当前位置信息",
        time: 2,);
    }
    if (await Permission.location.request().isGranted) {
      // myLocation.Location mylocation = myLocation.Location();
      // bool _serviceEnabled;
      // PermissionStatus _permissionGranted;
      // _serviceEnabled = await mylocation.serviceEnabled();
      // if (!_serviceEnabled) {
      //   _serviceEnabled = await mylocation.requestService();
      //   if (!_serviceEnabled) {
      //     return;
      //   }
      // }
      //
      // _permissionGranted = (await mylocation.hasPermission()) as PermissionStatus;
      // if (_permissionGranted == PermissionStatus.denied) {
      //   _permissionGranted = (await mylocation.requestPermission()) as PermissionStatus;
      //   if (_permissionGranted != PermissionStatus.granted) {
      //     return;
      //   }
      // }
      // myLocation.LocationData _locationData = await mylocation.getLocation();
      // final location1 = await GeoCode().reverseGeocoding(latitude: _locationData.latitude,longitude: _locationData.longitude);
      Location location = await AmapLocation.instance
          .fetchLocation(mode: LocationAccuracy.High, needAddress: true);
      print("打印获取的定位信息------$location");
      // if(location.country.isEmpty){
      //   ToastUtil.showErrorToast("请打开手机定位服务");
      // }
      MqttClientMsg.instance.postMessage(
          json.encode({
            "code": "2102",
            "orderId": data,
            "address": location.address,
            "latLng": location.latLng,
            "idCard": userViewModel.idCard,
            "userId": roomId
          }),
          "/topic/protocol/collect/$roomId");
    } else {
      G.showPermissionDialog(str: "访问定位权限");
    }
  }

  closeSocket() {
    MqttClientMsg.instance.unsubscribe("/topic/protocol/$roomId");
  }

  closeRoom() async {
    log("------------退出房间的$roomId");
    destoryRoom();
    subscription?.cancel();
    cameraController?.dispose();
    timer?.cancel();
  }

  showImg(info, isBase64) {
    if (showOneImg == 1) {
      showOneImg = 2;
    } else {
      G.pop();
    }
    showDialog(
        context: G.getCurrentState().overlay.context,
        builder: (ctx) {
          return PhotoViewGalleryScreen(
              height: videoHeight,
              isBase64: isBase64,
              onWillPop: () {
                showOneImg = 1;
                return Future.value(true);
              },
              onTop: () {
                MqttClientMsg.instance.postMessage(
                    json.encode({
                      "code": "2100",
                      "orderId": info['orderId'],
                      "signFileChecked": info['signFileChecked'],
                      "bookFileChecked": info['bookFileChecked'],
                      "userId": roomId,
                      "idCard": userViewModel.idCard
                    }),
                    "/topic/protocol/collect/$roomId");
                showOneImg = 1;
                G.pop();
              },
              images: info['images'], //传入图片list
              index: 0, //传入当前点击的图片的index
              heroTag: "1");
        });
  }

  // capturePng(String code,String data) async {
  //   engine.enableLocalVideo(false);
  //   sleep(Duration(milliseconds:300));
  //   try {
  //     cameras = await availableCameras();
  //     cameraController = CameraController(cameras[camerasNum], ResolutionPreset.medium);
  //     await cameraController.initialize();
  //     sleep(Duration(milliseconds: 500));
  //     XFile info = await cameraController.takePicture();
  //     sleep(Duration(milliseconds: 100));
  //     cameraController.dispose();
  //     engine.enableLocalVideo(true);
  //     final result = await FlutterImageCompress.compressWithFile(
  //       info.path,
  //       minWidth: 2300, //压缩后的最小宽度
  //       minHeight: 1500, //压缩后的最小高度
  //       quality: 20, //压缩质量
  //       rotate: 0, //旋转角度
  //     );
  //     MultipartFile multipartFile = MultipartFile.fromBytes(
  //       result,
  //       filename: '${DateTime.now().millisecondsSinceEpoch}.jpg',
  //       contentType: MediaType("image", "jpg"),
  //     );
  //     HomeApi.getSingleton().uploadPictures(multipartFile).then((res) {
  //       if (res != null) {
  //           if (res['code'] == 200) {
  //             print('-------------------------$res');
  //             MqttClientMsg.instance.postMessage(json.encode({
  //                 "code": code,
  //                 "userId": roomId,
  //                 "info": res['item']['filePath'],
  //                 "orderId": data,
  //                 "idCard": userViewModel.idCard
  //             }), "/topic/protocol/collect/$roomId");
  //           }
  //         }
  //     });
  //   } catch (e) {
  //     print("$e，GG报错");
  //     engine.enableLocalVideo(true);
  //   }
  // }

  showSignature(String name, String idCard, String tyKeyword, String offSet,
      String code, String orderId, String companyId,
      {String annexId = "", String path = ""}) {
    print('-------521,$tyKeyword,$offSet,$code');
    String url =
        "${Config.caUrl}?name=$name&idCard=$idCard&tyKeyword=$tyKeyword&offSet=$offSet&terminalType=flutter";
    print('-------521$url');
    if (Platform.isIOS) {
      url = Uri.encodeFull(url);
    }

    showModalBottomSheet<int>(
      enableDrag: false,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: G.getCurrentState().overlay.context,
      builder: (BuildContext context) {
        return SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: qmDemoPage1(
            unitGuid: code,
            name: name,
            orderId: orderId,
            notarizationMatters: roomId.toString(),
            annexId: annexId,
            companyId: companyId,
            idCard: userViewModel.idCard,
          ),
        );
      },
    );
    // showDialog(
    //     context:G.getCurrentState().overlay.context,
    //     builder: (context) {
    //       return DemoPage(
    //           label: url,
    //           code: code,
    //           name: name,
    //           orderId: orderId,
    //           roomId:roomId.toString(),
    //           annexId:annexId,
    //           path:path,
    //           companyId:companyId,
    //           idCard:idCard,
    //       );
    //     }

    //     // builder: (ctx){
    //     //   return WebViewPlus(
    //     //     javascriptMode: JavascriptMode.unrestricted,
    //     //     onWebViewCreated: (controller) {
    //     //       controller.loadUrl(url,headers: {});
    //     //     },
    //     //     javascriptChannels: <JavascriptChannel>[
    //     //       JavascriptChannel(
    //     //           name: "share",
    //     //           onMessageReceived: (JavascriptMessage message) {
    //     //             if(message.message!=null){
    //     //               G.pop();
    //     //               Map msg =  json.decode(message.message);
    //     //               List arr = [];
    //     //               arr.add(msg['base64']);
    //     //               Map<String,Object> map1 = {"files": arr,"idCard":'111'};
    //     //               HomeApi.getSingleton().uploadImg(map1).then((res){
    //     //                 if(res!=null){
    //     //                   if(res['code']==200){
    //     //                     MqttClientMsg.instance.postMessage(
    //     //                         json.encode(
    //     //                             {
    //     //                               "code":code,
    //     //                               "encDataFilePath": msg['encDataFilePath'],
    //     //                               "annexId": annexId,
    //     //                               "path": path,
    //     //                               "idCard":userViewModel.idCard,
    //     //                               "orderId":orderId,
    //     //                               "companyId":companyId,
    //     //                               "userId": roomId,
    //     //                               "info": res['item'][0]['filePath']
    //     //                             }),
    //     //                         "/topic/protocol/collect/$roomId");
    //     //                   }
    //     //                 }
    //     //               });
    //     //             }
    //     //           }
    //     //       ),
    //     //     ].toSet(),
    //     //     onPageFinished: (url) {
    //     //       print('....$url');
    //     //     },
    //     //   );
    //     // }
    // );
  }

  getNetwork() {
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      // Got a new connectivity status!
      print("--------------网络出现了波动-----$result");
      if (result == ConnectivityResult.mobile) {
        // 当前处于移动网络
        timer?.cancel();
        ToastUtil.showNormalToast("当前处于移动网络，注意流量！");
      } else if (result == ConnectivityResult.wifi) {
        // 当前处于wifi.
        timer?.cancel();
      } else {
        print(
            "------------------------------------------------------------断了一下");
        timer = Timer(Duration(seconds: 5), () {
          ToastUtil.showErrorToast("你的网络断开了，请检查网络状态！");
        });
      }
    });
  }

  // 初始化应用
  // Future<void> initPlatformState() async {
  //   print("111111111111--------${Config.aPPId}+++++++++++${Config.token}++++++++$roomId");
  //   try{
  //     /// 创建 RTC 客户端实例
  //     engine = await RtcEngine.create(Config.aPPId);
  //     /// 定义事件处理逻辑
  //     engine.setEventHandler(RtcEngineEventHandler(
  //       ///回调事件处理
  //       joinChannelSuccess: (String channel, int uid, int elapsed) {
  //         print('加入频道回调 $channel $uid');
  //         userList.add({"name":"自己","uid":uid});
  //         notifyListeners();
  //       },
  //       userJoined: (int uid, int elapsed) {
  //         //远方视频加入
  //         print('远方视频加入 $uid');

  //       },
  //       userOffline: (int uid, UserOfflineReason reason) {
  //         //远方视频离开
  //         print('远方视频离开 $uid');
  //         for (var i = 0; i < userList.length; i++) {
  //           if (userList[i]['uid'] == uid) {
  //             userList.removeAt(i);
  //           }
  //         }
  //         notifyListeners();
  //       },
  //       remoteVideoStateChanged:(int uid, VideoRemoteState state, VideoRemoteStateReason reason, int elapsed){
  //         print('远方视频状态 $uid----$state-------------$reason-------------$elapsed');
  //         if(state == VideoRemoteState.Decoding){
  //           if(uid == 951){
  //             notaryInfo = uid;
  //           }else if(!userList.any((item) => item['name']==uid)){
  //             userList.add({"name":uid,"uid":uid});
  //           }
  //         }
  //         notifyListeners();
  //       },

  //     ));
  //     /// 开启视频
  //     await engine.enableVideo();
  //     /// 加入频道
  //     await engine.joinChannel(Config.token, "$roomId", null, 0);
  //   }catch(e){
  //     print("到底出现到什么错误$e");
  //   }
  //   notifyListeners();
  // }

  // destoryRoom(){
  //   engine?.leaveChannel();
  //   engine?.disableVideo();
  //   engine?.disableAudio();
  //   engine?.destroy();//销毁 RtcEngine 实例
  // }

  @override
  void clientDataHandler(onData, topic) {
    print('MQTT的消息...$onData....$topic');
    var orderData = json.decode(onData);
    if (topic == "protocol" && orderData['idCard'] == userViewModel.idCard) {
      socketInfo(orderData);
    }
  }

  //腾讯音视频
  //RTC相关
  TRTCCloud trtcCloud;
  TXDeviceManager txDeviceManager;
  // List userList = []; //远端所有的视频用户
  Map otherUser = {}; //主持人的视频
  Map notaryInfo = {}; //公证员的视频
  List allowList = []; //允许在麦上的用户

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
    print("..................腾讯进入房间.....................");
    print(
        "..................腾讯进入房间idCard.....................${userViewModel.idCard}");
    String userSig = await GenerateTestUserSig.genTestSig(userViewModel.idCard);
    print(
        "..................腾讯进入房间Config.sdkAppId.....................${Config.sdkAppId}");
    print("..................腾讯进入房间userSig.....................${userSig}");
    print("腾讯orderInfo.roomId........................${roomId}");

    trtcCloud.enterRoom(
        TRTCParams(
            sdkAppId: Config.sdkAppId, //应用Id
            userId: userViewModel.idCard, // 用户Id
            userSig: userSig, // 用户签名
            strRoomId: roomId), //房间Id
        TRTCCloudDef.TRTC_APP_SCENE_VIDEOCALL);
    print(
        ".......................................1${userList.length}----${userViewModel.idCard}-----$roomId");
    userList.add({
      'userId': userViewModel.idCard,
      "widget": addRoom(true, true, userViewModel.idCard)
    });
    // trtcCloud.startScreenCapture(TRTCCloudDef.TRTC_VIDEO_STREAM_TYPE_SUB,TRTCVideoEncParam(videoBitrate: 1600,videoResolution: 720*1280,videoResolutionMode: 10,  videoFps:10));
    notifyListeners();
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
    print("......huidiao加入$type");
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
      notifyListeners();
    }

    //截图回调
    if (type == TRTCCloudListener.onSnapshotComplete) {
      print("++++++++++截图回调++++$param+");
      if (param['errCode'] == 0) {
        faceComparison(param['path'], "2103");
      }
    }
    if (type == TRTCCloudListener.onScreenCaptureStarted) {
      print("++++++++++屏幕分享++++$param+");
    }
  }

  captureImg() async {
    print("++++++++++截图+++++");
    final directory = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    String _downloadPath =
        '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.png';
    print("+++++++++++++截图+++++++++++++++++$_downloadPath");
    trtcCloud.snapshotVideo(
        "", TRTCCloudDef.TRTC_VIDEO_STREAM_TYPE_BIG, 0, _downloadPath);
  }

  faceComparison(String path, String code) async {
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
      if (res != null) {
        if (res['code'] == 200) {
          MqttClientMsg.instance.postMessage(
              json.encode({
                "code": code,
                "userId": roomId,
                "info": res['item']['filePath'],
                "orderId": data,
                "idCard": userViewModel.idCard
              }),
              "/topic/protocol/collect/$roomId");
        }
      }
    });
  }

  // 销毁房间的一些信息
  destoryRoom() {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
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
  }
}
