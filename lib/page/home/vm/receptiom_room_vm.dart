import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:amap_location_fluttify/amap_location_fluttify.dart';
import 'package:camera/camera.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http_parser/http_parser.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:notarization_station_app/base_framework/utils/toast_util.dart';
import 'package:notarization_station_app/base_framework/view_model/single_view_state_model.dart';
import 'package:notarization_station_app/base_framework/widget/photo_view/photo_view_gallery.dart';
import 'package:notarization_station_app/base_framework/widget/release_widget.dart';
import 'package:notarization_station_app/components/pdf_view.dart';
import 'package:notarization_station_app/page/home/entity/Launch_room_infor_model.dart';
import 'package:notarization_station_app/page/home/entity/reception_common_user_information.dart';
import 'package:notarization_station_app/page/login/vm/user_view_model.dart';
import 'package:notarization_station_app/routes/router.dart';
import 'package:notarization_station_app/service_api/home_api.dart';
import 'package:notarization_station_app/socket/mqtt_client.dart';
import 'package:notarization_station_app/utils/GenerateTestUserSig.dart';
import 'package:notarization_station_app/utils/global.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tencent_trtc_cloud/trtc_cloud.dart';
import 'package:tencent_trtc_cloud/trtc_cloud_def.dart';
import 'package:tencent_trtc_cloud/trtc_cloud_listener.dart';
import 'package:tencent_trtc_cloud/trtc_cloud_video_view.dart';
import 'package:tencent_trtc_cloud/tx_device_manager.dart';

import '../../../config.dart';
import 'bottomsheet/contract_bottomsheet_vm.dart';

class ReceptionRoomViewModel extends SingleViewStateModel with ClientCallback {
  UserViewModel userViewModel;

  LaunchRoomInforModel orderInfo;

  // 判断是否是简易模版进入
  bool isCommon;

  ReceptionRoomViewModel(this.userViewModel, this.orderInfo, this.isCommon);

  double videoHeight;
  ReleaseCon conCtx;
  List materialsList = [];
  List<Asset> imgList = [];
  String htmlInfo = '';
  bool showUpload = true;
  int offSet = 1;
  int showOneImg = 1;
  PageController pageController = PageController(initialPage: 0);
  Map costMap = {
    'address': '',
    'notarize': '',
    'law': '',
    'visit': '',
    'photograph': '',
    'others': '',
  };

  // 用户信息列表
  List userInforList = [];
  StreamSubscription<ConnectivityResult> subscription;
  Timer timer;
  Timer timerPay;
  int numPay = 1;

  // 当前tabbar的index
  int index = 0;

  Map contractInfo = {
    "inviterObj": {"idCard": "", "mobile": "", "name": "", "address": ""},
    "thirdpartyusers": [
      {"idCard": "", "mobile": "", "name": "", "address": ""}
    ],
    "Companys": [
      {
        "companyName": "",
        "statutoryPerson": "",
        "statutoryMobile": "",
        "companyAdd": ""
      }
    ]
  };
  Map contentForm = {
    'area': '',
    'cailiaoValue': '',
    'gongzhengValue': '',
    'lang': '',
    'yongtu': '',
    'remark': '',
  };

  // 订单详情数据信息
  List orderDetailList = new List();

  // 顶部的tab数量
  List tabList = [];

  List applicationForm = [
    {
      'name': '',
      'idCard': '',
      'address': '',
      'mobile': '',
    }
  ];

  String getApplication() {
    List nameList = [];
    applicationForm.forEach((e) {
      nameList.add(e['name']);
    });
    return nameList.length == 0 ? "" : nameList.join("、");
  }

  int remoteUid = 0;
  List userList = [];
  CameraController cameraController;
  List<CameraDescription> cameras = [];
  int camerasNum = 1;

  String captureCode = "";
  bool isBase64 = false;
  bool isPay = true;
  bool isCapture = true;

// 腾讯
  int imgName = 0;

  // tabIndex
  int tabIndex = 0;

  //是否静音
  bool onMuteAudio = false;

  // 顶部top数据类型
  List tabTypeList = [];

  // 获取重复的tab个数
  List typeAmoutList = [];

  // 自然人信息列表
  List<ReceptionCommonUserInformation> commonUserList = [];

  // 当前用户身份证号码
  String currentIdCard = "";

  @override
  Future loadData() {
    MqttClientMsg.instance.setCallback(this);

    iniRoom();
    getNetwork();
    if (isCommon) {
      getUserInfor();
    } else {
      _getKeyWord();
    }
    return null;
  }

  //

  @override
  onCompleted(data) {
    throw UnimplementedError();
  }

  // 获取自然人信息
  void getUserInfor() {
    Map params = {
      'unitGuid': orderInfo.unitGuid,
    };
    HomeApi.getSingleton().getCommonUser(params).then((value) {
      if (value['code'] == 200 && value['data'] != null) {
        List tempList = value['data'];
        commonUserList.addAll(tempList
            .map((e) => ReceptionCommonUserInformation.fromJson(e))
            .toList());
        commonUserList.sort((a, b) {
          return a.sort.compareTo(b.sort);
        });
      }
      notifyListeners();
    });
  }

  /// 获取主键数据
  _getKeyWord() {
    Map<String, dynamic> map = new Map();
    map["keyword"] = 'tyfqRoleType';
    HomeApi.getSingleton().getSelectAllTop(map).then((value) {
      if (value["code"] == 200 && value['data'] != null) {
        String unitGuid = value['data'][0]["unitGuid"];
        _getTopTab(unitGuid);
      } else {
        ToastUtil.showErrorToast("获取主键信息错误");
      }
    });
  }

  /// 获取顶部的tab信息
  _getTopTab(String unitGuid) {
    Map<String, dynamic> map = new Map();
    map["currentPage"] = 1;
    map["pageSize"] = 500;
    map['unitGuid'] = unitGuid;
    HomeApi.getSingleton().selectPage(map).then((value) {
      if (value['code'] == 200 && value["data"] != null) {
        if (value["data"]["item"] != null) {
          tabTypeList = value['data']['item'];
          _getDetails();
        }
      } else {
        ToastUtil.showErrorToast("${value["msg"]}");
      }
      print("获取顶部的tab信息-------$value");
    });
  }

  // 获取受理室订单详情
  _getDetails() {
    Map<String, dynamic> map = new Map();
    map["unitGuid"] = orderInfo.unitGuid;
    HomeApi.getSingleton().blockOrderGetPartyDetails(map).then((value) {
      if (value != null) {
        if (value['code'] != 200) {
          ToastUtil.showErrorToast('${value['message']}');
        }
        if (value['data'] != null) {
          userInforList.addAll(value['data']);
          _dealData();
        }
      } else {
        ToastUtil.showErrorToast("网络出错了，请稍后再试...");
      }
    });
  }

  _dealData() {
    tabTypeList.forEach((element) {
      int index = 0;
      userInforList.forEach((value) {
        if ("${value["userType"]}" == element["dictCode"]) {
          index++;
          if (index > 1) {
            value["userTypeName"] = "${element["dictName"]}${index - 1}";
          } else {
            value["userTypeName"] = element["dictName"];
          }
        } else {
          index = 0;
        }
      });
    });
    // tempList.forEach((e) {
    //   List otherList = [];
    //   e.keys.forEach((element) {
    //     Map cellData = new Map();
    //     if (element == "userName") {
    //       Map tabMap = new Map();
    //       tabTypeList.forEach((value) {
    //         if(value['dictCode']==e["userType"]){
    //           tabMap["typeName"] = value["dictName"];
    //           tabMap['userType'] = e['userType'];
    //           tabMap['idCard'] = e['idCard'];
    //           tabList.add(cellData);
    //           cellData["key"] = value["dictName"];
    //         }
    //       });
    //       cellData["value"] = e[element];
    //     } else if (element == "idCard") {
    //       cellData['key'] = "身份证号码";
    //       if(e[element]!=null){
    //         cellData["value"] = e[element].toString().replaceRange(5, 15, "**********");
    //       }else{
    //         cellData["value"] = "XXXXXXX";
    //       }
    //
    //       otherList.add(cellData);
    //     } else if (element == "address") {
    //       cellData['key'] = "地址";
    //       cellData["value"] = e[element];
    //       otherList.add(cellData);
    //     } else if (element == 'phoneNumber') {
    //       cellData['key'] = "联系电话";
    //       cellData["value"] = e[element];
    //       otherList.add(cellData);
    //     }else if(element == "otherField"){
    //       if(e[element]!=null){
    //         cellData['key'] = "邮编";
    //         cellData["value"] = jsonDecode(e[element])["fieldCode"];
    //         otherList.add(cellData);
    //       }
    //     }
    //   });
    //   if(userViewModel.user.idCard==e["idCard"]){
    //     orderDetailList.insert(0,otherList);
    //   }else{
    //     orderDetailList.add(otherList);
    //   }
    // });
    // print("tabList------$tabList,orderDetailList------$orderDetailList");
    notifyListeners();
  }

  /// 切换用户角色
  void changeUserRole(index) {
    tabIndex = index;
    pageController.animateToPage(index,
        duration: Duration(microseconds: 500), curve: Curves.bounceInOut);
    notifyListeners();
  }

  // mqtt数据处理
  socketInfo(info) {
    if (info['code'] == 'changePeople') {
      if (isCommon) {
        commonUserList.forEach((element) {
          int index = commonUserList.indexOf(element);
          if (element.idCard == info['info']) {
            currentIdCard = info['info'];
            changeUserRole(index);
          }
        });
      } else {
        userInforList.forEach((element) {
          int index = userInforList.indexOf(element);
          if (element['idCard'] == info['info'] &&
              element['userType'] == info['userType']) {
            currentIdCard = info['info'];
            changeUserRole(index);
          }
        });
      }
      notifyListeners();
    } else if (info['code'] == 'realSign') {
      //截屏
      // if (info['info'] == userViewModel.idCard) {
      if (isCapture) {
        // capturePng("realSignCB",true);
        imgName = 2;
        captureImg();
      }
      // }
    } else if (info['code'] == 'toLocation') {
      // if (userViewModel.user.idCard == info['idCard']) {
      //获取定位
      getLocation();
      // }
    } else if (info['code'] == 'toSign') {
      //弹出签字框
      if (isCommon) {
        commonUserList.forEach((element) {
          if (element.idCard == info['idCard']) {
            currentIdCard = info['idCard'];
            showSignature(element.userName, element.idCard,
                "HT,${info['info']}", 'sanfang', '780');
          }
        });
      } else {
        userInforList.forEach((element) {
          if (element['idCard'] == info['idCard']) {
            currentIdCard = info['idCard'];
            showSignature(element['userName'], element['idCard'],
                "HT,${info['info']}", 'sanfang', '780');
          }
        });
      }
    } else if (info['code'] == 'showFile') {
      // if (userViewModel.user.idCard == info['idCard']) {
      //签字后合同的图片
      // showImg(info['info'],false);
      showPdf(info['info']);
      // }
    } else if (info['code'] == '400') {
      //关闭
      closeSocket();
      EasyLoading.dismiss();
      ToastUtil.showNormalToast("关闭此次公证！");
      G.getCurrentState().popUntil(ModalRoute.withName(RoutePaths.HomeIndex));
    } else if (info['code'] == 'unmuteAudio') {
      // mute	true：静音；false：取消静音
      onMuteAudio = false;
      trtcCloud.muteLocalAudio(false);
    } else if (info['code'] == 'muteAudio') {
      // mute	true：静音；false：取消静音
      onMuteAudio = true;
      trtcCloud.muteLocalAudio(true);
    }
    notifyListeners();
  }

  closeSocket() {
    MqttClientMsg.instance
        ?.unsubscribe("/topic/commonBank/${userViewModel.idCard}");
    // closeRoom();
  }

  closeRoom() {
    print("------------退出房间的2222");
    try {
      destoryRoom();
      subscription?.cancel();
      timer?.cancel();
    } catch (e) {
      print("------------退出房间的时候发生错误$e");
    }
  }

  total() {
    int notarize = 0;
    int law = 0;
    int visit = 0;
    int photograph = 0;
    int others = 0;
    if (costMap['notarize'] == '') {
      notarize = 0;
    } else {
      notarize = int.parse(costMap['notarize']);
    }
    if (costMap['law'] == '') {
      law = 0;
    } else {
      law = int.parse(costMap['law']);
    }
    if (costMap['visit'] == '') {
      visit = 0;
    } else {
      visit = int.parse(costMap['visit']);
    }
    if (costMap['photograph'] == '') {
      photograph = 0;
    } else {
      photograph = int.parse(costMap['photograph']);
    }
    if (costMap['others'] == '') {
      others = 0;
    } else {
      others = int.parse(costMap['others']);
    }
    return notarize + law + visit + photograph + others;
  }

  showPdf(info) {
    if (showOneImg == 1) {
      showOneImg = 2;
    } else {
      G.pop();
    }
    List temp = jsonDecode(info);
    List data = [];
    temp.forEach((element) {
      data.add(element['filePath']);
    });
    showDialog(
        context: G.getCurrentState().overlay.context,
        builder: (ctx) {
          return PdfViewPage(
              height: videoHeight,
              onWillPop: () {
                showOneImg = 1;
                return Future.value(true);
              },
              onTop: () {
                MqttClientMsg.instance.postMessage(
                    json.encode({
                      "code": "CB003",
                      "info": '',
                      "idCard": orderInfo.unitGuid,
                    }),
                    "/topic/commonBank/collect/${orderInfo.unitGuid}");
                showOneImg = 1;
                G.pop();
              },
              images: data);
        });
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
                      "code": "CB003",
                      "info": '',
                      "idCard": currentIdCard,
                    }),
                    "/topic/commonBank/collect/${orderInfo.unitGuid}");
                showOneImg = 1;
                G.pop();
              },
              images: info, //传入图片list
              index: 0, //传入当前点击的图片的index
              heroTag: "1");
        });
  }

  showSignature(String name, String idCard, String tyKeyword, String offSet,
      String code) {
    print('-------521$name,$idCard,$tyKeyword,$offSet,$code');
    String url =
        "${Config.caUrl}?name=$name&idCard=$idCard&tyKeyword=$tyKeyword&offSet=$offSet&terminalType=flutter";
    print(url);
    if (Platform.isIOS) {
      url = Uri.encodeFull(url);
      print("$url-------ios");
    }
    print('=================url: ' + url);
    print('=================code: ' + code);
    print('=================orderInfo.roomId: ${orderInfo.unitGuid}');
    print('=================userViewModel.idCard: ' + idCard);

    showModalBottomSheet<int>(
      enableDrag: false,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: G.getCurrentState().overlay.context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
            child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(20.0),
              topRight: const Radius.circular(20.0),
            ),
          ),
          // height: MediaQuery.of(context).size.height / 1.5,
          // height: 800,
          child: Column(children: [
            SizedBox(
              height: 50,
              child: Stack(
                textDirection: TextDirection.rtl,
                children: [
                  Center(
                    child: Text(
                      '签名区域(请逐字签署)',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16.0),
                    ),
                  ),
                  IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        Navigator.of(context).pop();
                      }),
                ],
              ),
            ),
            Divider(height: 1.0),
            qmDemoPage1(
              unitGuid: code,
              name: name,
              notarizationMatters: orderInfo.unitGuid.toString(),
              idCard: idCard,
              callBack: (infor) {
                MqttClientMsg.instance.postMessage(
                    json.encode(
                        {"code": "CB002", "idCard": idCard, 'info': infor}),
                    "/topic/commonBank/collect/${orderInfo.unitGuid}");
              },
            )
          ]),
        ));
      },
    );
  }

  Future<void> requestCameraPermission() async {
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
        selectAssets();
      }else{
        G.showPermissionDialog(str: "访问内部相机、相册及文件权限");
      }
    }
    if(Platform.isIOS){
      if(await Permission.photos.request().isGranted && await Permission.camera.request().isGranted){
        selectAssets();
      }else{
        G.showPermissionDialog(str: "访问相机、相册权限");
      }
    }
  }

  // 获取定位信息
  getLocation() async {
    if(!await Permission.location.status.isGranted){
      G.showCustomToast(
          context: G.getCurrentContext(),
          titleText: "定位权限使用说明：",
          subTitleText: "用于获取当前位置信息",
          time: 2
      );
    }
    if (await Permission.location.request().isGranted) {
      Location location = await AmapLocation.instance.fetchLocation();
      print("位置信息：-----$location");
      String latLng =
          "${location.latLng.longitude},${location.latLng.latitude}";
      MqttClientMsg.instance.postMessage(
          json.encode({
            "code": "CB001",
            "idCard": currentIdCard,
            'info': latLng,
            'address': location.address
          }),
          "/topic/commonBank/collect/${orderInfo.unitGuid}");
    } else {
      G.showPermissionDialog(str: "访问定位权限");
    }
  }

//选照片
  Future<void> selectAssets() async {
    try {
      List<Asset> resultList = await MultiImagePicker.pickImages(
        // 选择图片的最大数量
        maxImages: 9 - imgList.length,
        // 是否支持拍照
        enableCamera: false,
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
      List imgBase64 = [];
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
          imgList.add(asset);
            ByteData oldBd = await asset.getByteData(quality: 30);
            List<int> imageData = oldBd.buffer.asUint8List();
            List<int> result = await FlutterImageCompress.compressWithList(
              imageData,
              minWidth: 2300, //压缩后的最小宽度
              minHeight: 1500, //压缩后的最小高度
              quality: 20, //压缩质量
              rotate: 0, //旋转角度
            );
            String base64 = base64Encode(result);
            imgBase64.add("data:image/png;base64,$base64");
            EasyLoading.dismiss();
            if (isCommon) {
              String fileName = resultList[i].name;
              MultipartFile file =
                  MultipartFile.fromBytes(result, filename: fileName);
              HomeApi.getSingleton().uploadPictures(file).then((res) {
                if (res != null && res['code'] == 200) {
                  debugPrint(
                      'res【item】【ilePath] uploadPictures ---------${res['item']['filePath']}');
                  List imgUrl = [];
                  imgUrl.add({
                    "annexFileList": res['item']['unitGuid'],
                    "imgPathList":
                        Config.splicingImageUrl(res['item']['filePath']),
                  });

                  Map<String, dynamic> map = {
                    "annexId": res['item']['unitGuid'],
                    "orderGuid": orderInfo.unitGuid,
                  };
                  HomeApi.getSingleton().uploadCommonFile(map).then((value) {
                    if (value['code'] == 200) {
                      debugPrint(
                          'res【item】【ilePath]---------${res['item']['filePath']}');
                      MqttClientMsg.instance.postMessage(
                          json.encode({
                            "code": "CB004",
                            "info": res['item']['filePath'],
                            "idCard": currentIdCard
                          }),
                          "/topic/commonBank/collect/${orderInfo.unitGuid}");
                    } else {
                      G.showPermissionDialog(str: value['msg'].toString());
                    }
                  });
                }
              });
            } else {
              Map<String, Object> map1 = {"files": imgBase64, "idCard": '111'};
              HomeApi.getSingleton().uploadImg(map1).then((res) {
                if (res != null && res['code'] == 200) {
                  List imgUrl = [];
                  res['item'].forEach((e) {
                    materialsList.add(e);
                    imgUrl.add({
                      "annexFileList": e['unitGuid'],
                      "imgPathList": Config.splicingImageUrl(e['filePath']),
                    });
                  });
                  MqttClientMsg.instance.postMessage(
                      json.encode({
                        "code": "CB004",
                        "info": imgUrl,
                        "idCard": currentIdCard
                      }),
                      "/topic/commonBank/collect/${orderInfo.unitGuid}");
                }
              });
            }
        }
        notifyListeners();
      }
    } on Exception catch (e) {
      e.toString();
    }
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
          EasyLoading.dismiss();
          ToastUtil.showErrorToast("你的网络断开了，请检查网络状态！");
        });
      }
    });
  }

  //腾讯音视频
  //RTC相关
  TRTCCloud trtcCloud;
  TXDeviceManager txDeviceManager;
  // List userList = []; //远端所有的视频用户
  Map otherUser = {}; //主持人的视频
  Map notaryInfo = {}; //公证员的视频
  List allowList = []; //允许在麦上的用户
  // final String roomId;

  iniRoom() async {
    // print("..................腾讯iniRoom.....................");
    // 创建 TRTCCloud 单例
    trtcCloud = await TRTCCloud.sharedInstance();
    // 获取设备管理模块
    txDeviceManager = trtcCloud.getDeviceManager();
    trtcCloud.setVideoEncoderParam(TRTCVideoEncParam());
    // print("..................腾讯onRtcListener.....................");
    // 注册事件回调
    trtcCloud.registerListener(onRtcListener);
    // print("..................腾讯enterRoom.....................");
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
    print("腾讯orderInfo.roomId........................${orderInfo.unitGuid}");

    print(
        "userName-----userIdCard------${userViewModel.user.userName}-${userViewModel.idCard}");
    trtcCloud.enterRoom(
        TRTCParams(
            sdkAppId: Config.sdkAppId, //应用Id
            userId: userViewModel
                .idCard, //"${userViewModel.user.userName}-${userViewModel.idCard}", // 用户Id
            userSig: userSig, // 用户签名
            strRoomId: orderInfo.unitGuid), //房间Id
        TRTCCloudDef.TRTC_APP_SCENE_VIDEOCALL);
    // print("腾讯.......................................1：${userList.length}");
    // print("腾讯.......................................2：${userViewModel.idCard}");
    // print("腾讯.......................................3：${orderInfo.roomId}");
    print(
        "腾讯.......................................4：${userList.length}----${userViewModel.idCard}-----${orderInfo.roomId}");
    userList.add({
      'userId': userViewModel.idCard,
      "widget": addRoom(true, true, userViewModel.idCard)
    });
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
          : Container(color: Color(0xFFF2F2F2)),
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
        print("进入房间成功");
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
      if (param['errCode'] == 0) {
        if (imgName == 1) {
          // print("++++++++++param['path']截图回调++++${param['path']}");
          faceComparison(param['path'], "verfied", false);
          // print("++++++++++verfied截图回调++++$param+");
        } else {
          // print("++++++++++param['path']截图回调++++${param['path']}");
          faceComparison(param['path'], "realSignCB", true);
          // print("++++++++++realSignCB截图回调++++$param+");
        }
      }
    }
    if (type == TRTCCloudListener.onScreenCaptureStarted) {
      print("++++++++++屏幕分享++++$param+");
    }
  }

  captureImg() async {
    final directory = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    String _downloadPath =
        '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.png';
    // print("+++++++++++++++截图+++++++++++++++$_downloadPath");
    trtcCloud.snapshotVideo(
        "", TRTCCloudDef.TRTC_VIDEO_STREAM_TYPE_BIG, 0, _downloadPath);
  }

  faceComparison(String path, String code, bool isBase64) async {
    final result = await FlutterImageCompress.compressWithFile(
      path,
      minWidth: 2300, //压缩后的最小宽度
      minHeight: 1500, //压缩后的最小高度
      quality: 20, //压缩质量
      rotate: 0, //旋转角度
    );
    String name = path.substring(path.lastIndexOf("/") + 1, path.length);
    if (isBase64) {
      String base64 = base64Encode(result);
      // print("+++++++++++++++base64截图+++++++++++++++${base64}+++++ code:$code +++++++idCard: ${userViewModel.idCard} +int.parse(orderInfo.roomId)");
      MqttClientMsg.instance.postMessage(
          json.encode({
            "code": code,
            "idCard": currentIdCard,
            "info": "data:image/png;base64,$base64"
          }),
          "/topic/commonBank/collect/${orderInfo.unitGuid}");
    } else {
      MultipartFile multipartFile = MultipartFile.fromBytes(
        result,
        filename: name,
        contentType: MediaType("image", "jpg"),
      );
      HomeApi.getSingleton().uploadPictures(multipartFile).then((res) {
        // print("+++++++++++++++multipartFile截图+++++++++++++++${res['item']['filePath']}++++++ code:$code +++++++idCard: ${userViewModel.idCard}");
        if (res != null) {
          if (res['code'] == 200) {
            MqttClientMsg.instance.postMessage(
                json.encode({
                  "code": code,
                  "idCard": currentIdCard,
                  "info": res['item']['filePath']
                }),
                "/topic/commonBank/collect/${orderInfo.unitGuid}");
          }
        }
      });
    }
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
  }

  // 切换相机
  changeCamera() {
    txDeviceManager.switchCamera(camerasNum == 0 ? true : false);
    camerasNum = camerasNum == 0 ? 1 : 0;
    notifyListeners();
  }

  @override
  void clientDataHandler(onData, topic) {
    print("receptiom--mqtt----message------$onData,$topic");
    if (topic == "commonBank") {
      var orderData = json.decode(onData);
      socketInfo(orderData);
    }
  }
}
