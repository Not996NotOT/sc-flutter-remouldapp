import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:camera/camera.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http_parser/http_parser.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:notarization_station_app/base_framework/utils/toast_util.dart';
import 'package:notarization_station_app/base_framework/view_model/single_view_state_model.dart';
import 'package:notarization_station_app/base_framework/widget/photo_view/photo_view_gallery.dart';
import 'package:notarization_station_app/config.dart';
import 'package:notarization_station_app/page/home/entity/small_list_entity.dart';
import 'package:notarization_station_app/page/home/entity/small_material_entity.dart';
import 'package:notarization_station_app/page/home/vm/dialog/start_dialog_vm.dart';
import 'package:notarization_station_app/page/login/vm/user_view_model.dart';
import 'package:notarization_station_app/routes/router.dart';
import 'package:notarization_station_app/service_api/home_api.dart';
import 'package:notarization_station_app/socket/mqtt_client.dart';
import 'package:notarization_station_app/utils/global.dart';
import 'package:permission_handler/permission_handler.dart';

class SmallVideoModel extends SingleViewStateModel with ClientCallback {
  UserViewModel userViewModel;
  String roomId;
  double videoHeight;
  int offSet = 1;
  int showOneImg = 1;
  String titleString = "";
  StreamSubscription<ConnectivityResult> subscription;
  Timer timer;
  TabController tabController;
  Map<int, List<SmallListItemsUserList>> hasMapList;

  //截图相关
  CameraController cameraController;
  Future<void> initializeControllerFuture;
  List<CameraDescription> cameras;

  //是否前置
  bool frontCamera = true;
  //RTC相关
  RtcEngine engine;
  List userList = [];

  bool isCapture = true;

  SmallListItems route;
  //材料
  List<SmallMaterialEntity> materialList = [];

  SmallVideoModel(this.userViewModel, this.roomId, this.tabController,
      this.hasMapList, this.route);

  setCameras(List<CameraDescription> cameras) {
    this.cameras = cameras;
  }

  setImgNewList(List<SmallMaterialEntity> info) {
    materialList = info;
    notifyListeners();
  }

  @override
  onCompleted(data) {}

  @override
  Future loadData() {
    MqttClientMsg.instance.setCallback(this);
    initPlatformState();
    getNetwork();
    return null;
  }

  socketInfo(info) {
    if (info['code'] == 'bank001') {
      showImg(info['bankImglist']);
    } else if (info['code'] == 'bank002') {
      titleString = info['importantMsg'];
    } else if (info['code'] == 'bank003') {
      showImg(info['bankImglist']);
    } else if (info['code'] == 'bankSign') {
      //签名
      showSignature(info['name'], info['idCard'], "bank,手印", offSet, "020");
    } else if (info['code'] == 'verfi') {
      if (isCapture) {
        screenshot();
      }
    } else if (info['code'] == '400') {
      closeSocket();
      G.getCurrentState().popUntil(ModalRoute.withName(RoutePaths.HomeIndex));
    } else if (info['code'] == 'bankOver') {
      showImg(info['bankImglist']);
    } else if (info['code'] == 'tabChange') {
      print("--------------${info['info'] != ""}");
      if (info['info'] != "") {
        tabController.index =
            hasMapList.keys.toList().indexOf(int.parse(info['info']));
      }
    } else if (info['code'] == 'bankHTSign') {
      //签名
      showSignature(
          info['name'], info['idCard'], info['keyWord'], offSet, "020");
    }
    notifyListeners();
  }

  showImg(info) {
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
              isBase64: false,
              onWillPop: () {
                showOneImg = 1;
                return Future.value(true);
              },
              onTop: () {
                MqttClientMsg.instance?.postMessage(
                    json.encode({
                      "code": "888",
                      "info": '',
                      "userId": roomId,
                    }),
                    "/topic/bank/collect/${route.loanOfficerIdCard}");
                showOneImg = 1;
                G.pop();
              },
              images: info,
              //传入图片list
              index: 0,
              //传入当前点击的图片的index
              heroTag: "1");
        });
  }

  showSignature(
      String name, String idCard, String tyKeyword, int offSet, String code) {
    String url =
        '${Config.caUrl}?name=$name&idCard=$idCard&tyKeyword=$tyKeyword&offSet=$offSet&terminalType=flutter';
    if (Platform.isIOS) {
      url = Uri.encodeFull(url);
    }
    showDialog(
        context: G.getCurrentState().overlay.context,
        builder: (ctx) {
          return DemoPage(
            label: url,
            code: code,
            roomId: roomId,
            idCard: userViewModel.idCard,
            route: route.loanOfficerIdCard,
          );

          // return WebViewPlus(
          //   javascriptMode: JavascriptMode.unrestricted,
          //   onWebViewCreated: (controller) {
          //     controller.loadUrl(url);
          //   },
          //   javascriptChannels: <JavascriptChannel>[
          //     JavascriptChannel(
          //         name: "share",
          //         onMessageReceived: (JavascriptMessage message) {
          //           if (message.message != null) {
          //             Map msg = json.decode(message.message);
          //             List arr = [];
          //             arr.add(msg['base64']);
          //             Map<String, Object> map1 = {"files": arr, "idCard": '111'};
          //             HomeApi.getSingleton().uploadImg(map1).then((res) {
          //               if (res != null) {
          //                 if (res['code'] == 200) {
          //                   MqttClientMsg.instance?.postMessage(json.encode({
          //                     "code": code,
          //                     "encDataFilePath": msg['encDataFilePath'],
          //                     "userId": roomId,
          //                     "idCard": idCard,
          //                     "info": res['item'][0]['filePath']
          //                   }),"/topic/bank/collect/${route.loanOfficerIdCard}");
          //                 }
          //               }
          //               G.pop();
          //             });
          //           }
          //         }),
          //   ].toSet(),
          //   onPageFinished: (url) {
          //     print('....$url');
          //   },
          // );
        });
  }

  //截图
  screenshot() async {
    isCapture = false;
    engine.enableLocalVideo(false);
    sleep(Duration(milliseconds: 300));
    try {
      cameras = await availableCameras();
      cameraController = CameraController(
          cameras[frontCamera ? 1 : 0], ResolutionPreset.medium);
      await cameraController.initialize();
      if (cameraController.value.isInitialized) {
        sleep(Duration(milliseconds: 500));
        XFile info = await cameraController.takePicture();
        sleep(Duration(milliseconds: 100));
        cameraController.dispose();
        engine.enableLocalVideo(true);
        final result = await FlutterImageCompress.compressWithFile(
          info.path,
          minWidth: 2300, //压缩后的最小宽度
          minHeight: 1500, //压缩后的最小高度
          quality: 20, //压缩质量
          rotate: 0, //旋转角度
        );
        MultipartFile multipartFile = MultipartFile.fromBytes(
          result,
          filename: '${DateTime.now().millisecondsSinceEpoch}.jpg',
          contentType: MediaType("image", "jpg"),
        );
        HomeApi.getSingleton().uploadPictures(multipartFile).then((res) {
          if (res != null && res['code'] == 200) {
            MqttClientMsg.instance?.postMessage(
                json.encode({
                  "code": "verfied",
                  "userId": roomId,
                  "info": res['item']['filePath']
                }),
                "/topic/bank/collect/${route.loanOfficerIdCard}");
          }
        });
        isCapture = true;
      }
    } catch (e) {
      engine.enableLocalVideo(true);
    }
  }

  getNetwork() {
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
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

  closeSocket() {
    MqttClientMsg.instance?.unsubscribe("/topic/bank/${userViewModel.idCard}");
  }

  closeRoom() {
    destoryRoom();
    cameraController?.dispose();
    subscription?.cancel();
    timer?.cancel();
  }

  // 初始化应用
  Future<void> initPlatformState() async {
    print(
        "111111111111111*--------${Config.aPPId}+++++++++++${Config.token}++++++++$roomId");
    try {
      /// 创建 RTC 客户端实例
      engine = await RtcEngine.create(Config.aPPId);

      /// 定义事件处理逻辑
      engine.setEventHandler(RtcEngineEventHandler(
        ///回调事件处理
        joinChannelSuccess: (String channel, int uid, int elapsed) {
          print('加入频道回调 $channel $uid');
          userList.add({"name": "自己", "uid": uid});
          notifyListeners();
        },
        userJoined: (int uid, int elapsed) {
          //远方视频加入
          print('远方视频加入 $uid');
          // userList.add({"name":uid,"uid":uid});
          // notifyListeners();
        },
        userOffline: (int uid, UserOfflineReason reason) {
          //远方视频离开
          print('远方视频离开 $uid');
          for (var i = 0; i < userList.length; i++) {
            if (userList[i]['uid'] == uid) {
              userList.removeAt(i);
            }
          }
          notifyListeners();
        },
        remoteVideoStateChanged: (int uid, VideoRemoteState state,
            VideoRemoteStateReason reason, int elapsed) {
          print(
              '远方视频状态 $uid----$state-------------$reason-------------$elapsed');
          if (state == VideoRemoteState.Decoding) {
            if (!userList.any((item) => item['name'] == uid)) {
              userList.add({"name": uid, "uid": uid});
            }
          }
          notifyListeners();
        },
      ));

      /// 开启视频
      await engine.enableVideo();

      /// 加入频道
      await engine.joinChannel(Config.token, "$roomId", null, 0);
    } catch (e) {
      print("到底出现到什么错误$e");
    }
    notifyListeners();
  }

  destoryRoom() {
    engine?.leaveChannel();
    engine?.disableVideo();
    engine?.disableAudio();
    engine?.destroy(); //销毁 RtcEngine 实例
  }

  Future<void> requestCameraPermission(
      String name, StateSetter setBottomSheet) async {
    if(Platform.isAndroid){
      if(!await Permission.storage.status.isGranted || !await Permission.camera.status.isGranted){
        G.showCustomToast(
            context: G.getCurrentContext(),
            titleText: "相机、存储权限使用说明：",
            subTitleText: "用于拍摄、录制视频、文件存储等场景",
            time: 2
        );
      }
      if (await Permission.storage.request().isGranted &&
          await Permission.camera.request().isGranted){
        selectAssets(name, setBottomSheet);
      } else {
        G.showPermissionDialog(str: "访问内部相机、相册及文件权限");
      }
    }
    if(Platform.isIOS){
      if(await Permission.photos.request().isGranted && await Permission.camera.request().isGranted){
        selectAssets(name, setBottomSheet);
      }else{
        G.showPermissionDialog(str: "访问相机、相册权限");
      }
    }

  }

  //选照片
  Future<void> selectAssets(String name, StateSetter setBottomSheet) async {
    try {
      List<Asset> resultList = await MultiImagePicker.pickImages(
        // 选择图片的最大数量
        maxImages: 5,
        // 是否支持拍照
        enableCamera: true,
        materialOptions: MaterialOptions(
          actionBarTitle: "相册图片",
          allViewTitle: "所有图片",
          actionBarColor: "#1E90FF",
          actionBarTitleColor: "#FFFFFF",
          statusBarColor: '#1E90FF',
          startInAllView: true,
          useDetailsView: true,
          selectCircleStrokeColor: "#FFFFFF",
          selectionLimitReachedText: "您最多只能选择这些",
          textOnNothingSelected: "没有选择照片",
        ),
      );
      List tempResultList = [];
      tempResultList.addAll(resultList);
      if (tempResultList != null && tempResultList.length != 0) {
        EasyLoading.show(status: "上传图片中");
        for (int i = 0; i < tempResultList.length; i++) {
          Asset asset = tempResultList[i];
          if (asset.originalHeight <= 0 || asset.originalWidth <= 0) {
            EasyLoading.dismiss();
            resultList.remove(asset);
            ToastUtil.showErrorToast("文件已破损，请重新选择");
          }
        }
        for (var i = 0; i < resultList.length; i++) {
          Asset asset = resultList[i];
          ByteData oldBd = await asset.getByteData(quality: 30);
            List<int> imageData = oldBd.buffer.asUint8List();
            final dateTime = DateTime.now().millisecondsSinceEpoch;
            List<int> result = await FlutterImageCompress.compressWithList(
              imageData,
              minWidth: 2300, //压缩后的最小宽度
              minHeight: 1500, //压缩后的最小高度
              quality: 20, //压缩质量
              rotate: 0, //旋转角度
            );
            MultipartFile multipartFile = MultipartFile.fromBytes(
              result,
              filename: '$dateTime.png',
              contentType: MediaType("image", "jpg"),
            );
            HomeApi.getSingleton().uploadPictures(multipartFile).then((res) {
              if (res != null && res['code'] == 200) {
                List list = [];
                SmallMaterialData data = SmallMaterialData();
                data.imgPath = res['item']['unitGuid'];
                data.materialName = "$name附件${i + 1}";
                list.add(data);
                Map<String, dynamic> info = {
                  "image": json.encode(list),
                  "bankOrderId": route.bankOrderId,
                };
                HomeApi.getSingleton().updateSmall(info).then((data) {
                  if (data['code'] == 200) {
                    SmallMaterialData listInfo = SmallMaterialData();
                    listInfo.annexId =
                        Config.splicingImageUrl(res['item']['filePath']);
                    data["item"].forEach((e) {
                      listInfo.imgPath = e["unitGuid"];
                      materialList.forEach((i) {
                        if (i.name == name) {
                          i.data.add(listInfo);
                          notifyListeners();
                        }
                      });
                    });
                    MqttClientMsg.instance?.postMessage(
                        json.encode({"code": "2002", "info": materialList}),
                        "/topic/bank/collect/${route.loanOfficerIdCard}");
                    setBottomSheet(() {});
                  }
                });
                notifyListeners();
              }
            });
            if (i + 1 == resultList.length) {
              EasyLoading.dismiss();
            }
        }
      }
    } on Exception catch (e) {
      e.toString();
    }
  }

  delImg(String info, int num, String name, StateSetter setBottomSheet) {
    EasyLoading.show(status: "删除图片中");
    print("+++++删除图片中+++++$info");
    HomeApi.getSingleton().delSmallImg({"unitGuid": info}).then((res) {
      EasyLoading.dismiss();
      if (res['code'] == 200) {
        materialList.forEach((e) {
          if (e.name == name) {
            e.data.removeAt(num);
          }
        });
        MqttClientMsg.instance?.postMessage(
            json.encode({"code": "2002", "info": materialList}),
            "/topic/bank/collect/${route.loanOfficerIdCard}");
        setBottomSheet(() {});
        ToastUtil.showSuccessToast("删除成功！");
      } else {
        ToastUtil.showWarningToast("删除失败，稍后再试！");
      }
      notifyListeners();
    });
  }

  @override
  void clientDataHandler(onData, topic) {
    if (topic == "bank") {
      print('MQTT的消息...$onData');
      var orderData = json.decode(onData);
      socketInfo(orderData);
    }
  }
}
