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
import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:flutter_h5pay/flutter_h5pay.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http_parser/http_parser.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:notarization_station_app/base_framework/utils/toast_util.dart';
import 'package:notarization_station_app/base_framework/view_model/single_view_state_model.dart';
import 'package:notarization_station_app/base_framework/widget/photo_view/photo_view_gallery.dart';
import 'package:notarization_station_app/base_framework/widget/release_widget.dart';
import 'package:notarization_station_app/iconfont/Icon.dart';
import 'package:notarization_station_app/page/home/entity/contract_entity.dart';
import 'package:notarization_station_app/page/home/vm/bottomsheet/contract_bottomsheet_vm.dart';
import 'package:notarization_station_app/page/login/vm/user_view_model.dart';
import 'package:notarization_station_app/routes/router.dart';
import 'package:notarization_station_app/service_api/home_api.dart';
import 'package:notarization_station_app/socket/mqtt_client.dart';
import 'package:notarization_station_app/utils/global.dart';
import 'package:notarization_station_app/utils/throttle_anti-shake.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tencent_trtc_cloud/trtc_cloud.dart';
import 'package:tencent_trtc_cloud/trtc_cloud_def.dart';
import 'package:tencent_trtc_cloud/trtc_cloud_listener.dart';
import 'package:tencent_trtc_cloud/trtc_cloud_video_view.dart';
import 'package:tencent_trtc_cloud/tx_device_manager.dart';
import 'package:tobias/tobias.dart';

import '../../../appTheme.dart';
import '../../../config.dart';
import '../../../utils/GenerateTestUserSig.dart';
import '../../../utils/h5Pay.dart';

class ContractIngViewModel extends SingleViewStateModel with ClientCallback {
  final UserViewModel userViewModel;
  //  String roomId;
  final ContractEntity orderInfo;
  double videoHeight;
  int showTab = 0;
  ReleaseCon conCtx;
  List materialsList = [];
  List<Asset> imgList = [];
  String htmlInfo = '';
  bool showUpload = true;
  int offSet = 1;
  int showOneImg = 1;
  Map costMap = {
    'address': '',
    'notarize': '',
    'law': '',
    'visit': '',
    'photograph': '',
    'others': '',
  };
  StreamSubscription<ConnectivityResult> subscription;
  Timer timer;
  Timer timerPay;
  int numPay = 1;

  Map contractInfo = {
    "inviterObj": {"idCard": "", "mobile": "", "name": "", "address": ""},
    "thirdpartyusers": [
      {"idCard": "", "mobile": "", "name": "", "address": ""}
    ],
    "agencyArr":[{"name":"1","idCard":"","principal":"","mobile":""}],
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

  List applicationForm = [
    {
      'name': '',
      'idCard': '',
      'address': '',
      'mobile': '',
    }
  ];
  ContractIngViewModel(this.userViewModel, this.orderInfo);
  String getApplication() {
    List nameList = [];
    applicationForm.forEach((e) {
      nameList.add(e['name']);
    });
    return nameList.length == 0 ? "" : nameList.join("、");
  }

  //RTC相关
  RtcEngine engine;
  int remoteUid = 0;
  List userList = [];
  CameraController cameraController;
  List<CameraDescription> cameras = [];
  int camerasNum = 1;

  String captureCode = "";
  bool isBase64 = false;
  bool isPay = true;
  bool isCapture = true;

  String latLng = '';

  Location location;
  /// 获取当前ip信息
  String ipAddress = '';

// 腾讯
  int imgName = 0;

  @override
  onCompleted(data) {}

  @override
  Future loadData() {
    MqttClientMsg.instance.setCallback(this);
    // showTab = orderInfo.unitGuid.currentState;
    notifyListeners();
    MqttClientMsg.instance.postMessage(
        json.encode({
          'code':"retrieveDataHT"
        }),
        "/topic/hetong/collect/${userViewModel.idCard}");
    // initPlatformState();
    print("..................腾讯loadData.....................");
    iniRoom();
    getNetwork();
    return null;
  }

  showType() {
    switch (showTab) {
      case 0:
        return "lib/assets/images/contract1.png";
        break;
      case 1:
        return "lib/assets/images/contract2.png";
        break;
      case 2:
        return "lib/assets/images/contract3.png";
        break;
      case 3:
        return "lib/assets/images/contract4.png";
        break;
      case 4:
        return "lib/assets/images/contract5.png";
        break;
    }
  }

  socketInfo(info) async {
    if (info['code'] == '00') {
      contractInfo.clear();
      contractInfo = info['info'];
    } else if (info['code'] == '001') {
      contentForm = info['info'];
    } else if (info['code'] == '101') {
      //申请表预览
      showImg(info['info'], false);
    } else if (info['code'] == 'next1') {
      //申请表(含有签名)
      showImg(info['info'], false);
    } else if (info['code'] == '102') {
      List personArr = contractInfo['personArr'];
      personArr.forEach((element) {
        if (element['idCard'] == info['userId']) {
          showSignature(element['name'], element["idCard"], 'HT,手印',
              '${info['info']}', '020');
        }
      });
      //申请表签字
      // if(info['userId']==userViewModel.idCard){
      //   showSignature(contractInfo['inviterObj']['name'],userViewModel.idCard,'HT,手印','${info['info']}','020');
      // }
    } else if (info['code'] == '103') {
      //询问笔录签字
      // if(info['userId']==userViewModel.idCard){
      //   showSignature(contractInfo['inviterObj']['name'],userViewModel.idCard,'HT,被接谈人签名：','${info['info']}','220');
      // }
      List personArr = contractInfo['personArr'];
      personArr.forEach((element) {
        if (element['idCard'] == info['userId']) {
          showSignature(element['name'], element["idCard"], 'HT,被接谈人签名：',
              '${info['info']}', '220');
        }
      });
    } else if (info['code'] == '40002') {
      //pc删除图片
//      imgList.removeAt(info['index']);
    } else if (info['code'] == '5001') {
      //被证明文件下一步后禁止用户继续上传材料
      showUpload = false;
    } else if (info['code'] == 'verfi') {
      //截屏
      if (info['info'] == userViewModel.idCard) {
        if (isCapture) {
          // capturePng("verfied",false);
          imgName = 1;
          captureImg();
        }
      }
    } else if (info['code'] == 'realSign') {
      //截屏
      if (info['info'] == userViewModel.idCard) {
        if (isCapture) {
          // capturePng("realSignCB",true);
          imgName = 2;
          captureImg();
        }
      }
    } else if (info['code'] == '500') {
      //上传材料
      showTab = 1;
    } else if (info['code'] == '505') {
      //点击Pc左侧边栏被证明文件
      showTab = 2;
    } else if (info['code'] == '660') {
      //HTML文本
      htmlInfo = info['info'];
    } else if (info['code'] == '511') {
      showTab = 3;
    } else if (info['code'] == '661') {
      //HTML文本的 图片
      showImg(info['info'], false);
    } else if (info['code'] == '700') {
      //第二次签字
      // if(info['userId']==userViewModel.idCard){
      //   showSignature(contractInfo['inviterObj']['name'],userViewModel.idCard,"HT,${info['info']}",'sanfang','780');
      // }
      List personArr = contractInfo['personArr'];
      personArr.forEach((element) {
        if (element['idCard'] == info['userId']) {
          showSignature(element['name'], element["idCard"],
              "HT,${info['info']}", 'sanfang', '780');
        }
      });
    } else if (info['code'] == '666') {
      //签字后合同的图片
      showImg(info['info'], false);
    } else if (info['code'] == '104') {
      //告知书查看
      List uint8List = [];
      // print('盖章： '+info["info"]);
      // info["info"].forEach((e){
      //   Uint8List bytes = Base64Decoder().convert(e.split(',')[1]);
      //   uint8List.add(bytes);
      // });
      // showImg(uint8List,true);
      showImg(info["info"], false);
    } else if (info['code'] == '502') {
      //缴费通知
      showTab = 4;
    } else if (info['code'] == '023') {
      //缴费通知地址
      costMap['address'] = info['info'];
    } else if (info['code'] == '025') {
      //缴费通知公证费
      costMap['notarize'] = info['info'];
    } else if (info['code'] == '026') {
      //缴费通知法律费
      costMap['law'] = info['info'];
    } else if (info['code'] == '027') {
      //缴费通知上门
      costMap['visit'] = info['info'];
    } else if (info['code'] == '028') {
      //缴费通知照片费
      costMap['photograph'] = info['info'];
    } else if (info['code'] == '029') {
      //缴费通知其他费用
      costMap['others'] = info['info'];
    } else if (info['code'] == '110') {
      //询问笔录查看
      showImg(info['info'], false);
    } else if (info['code'] == '106') {
      //缴费通知单查看
      showImg(info['info'], false);
    } else if (info['code'] == '105') {
      //缴费通知单签字
//      showSignature(userViewModel.userName,userViewModel.idCard,'公证当事人（签名、盖章或按手印）：','$offSet','205');
    } else if (info['code'] == '300') {
      //去缴费
      if (isPay) {
        if (info['userId'] == userViewModel.idCard) {
          goPay();
        }
      }
    } else if (info['code'] == '107') {
      //全部预览
      showImg(info['info'], false);
    } else if (info['code'] == '400') {
      //关闭
      closeSocket();
      // destoryRoom();
      EasyLoading.dismiss();
      ToastUtil.showNormalToast("关闭此次合同公证！");
      G.getCurrentState().popUntil(ModalRoute.withName(RoutePaths.HomeIndex));
    } else if (info['code'] == '504') {
      showTab = 0;
    } else if (info['code'] == 'getMeetingLocation'){
     await getLocation();
      G.uploadOrderLocation({
        'busiId':orderInfo.unitGuid,
        'busiType': 3,
        "idCard":userViewModel.idCard,
        'ip':ipAddress,
        "longitude":latLng.isEmpty?'':latLng.split(',')[0],
        "latitude":latLng.isEmpty?'':latLng.split(',')[1]
      },responseSuccess: (value){
        MqttClientMsg.instance.postMessage(
            json.encode({
              "code": "meetingLocationBack",
              "info": value['data']['formattedAddress'] ?? "${value["data"]['province']??''}${value['data']['city']??''}",
            }),
            "/topic/hetong/collect/${userViewModel.idCard}");
      },responseError: (value){
        MqttClientMsg.instance.postMessage(
            json.encode({
              "code": "meetingLocationBack",
              "info": "",
            }),
            "/topic/hetong/collect/${userViewModel.idCard}");
      },errorCallBack: (value){
        MqttClientMsg.instance.postMessage(
            json.encode({
              "code": "meetingLocationBack",
              "info": "",
            }),
            "/topic/hetong/collect/${userViewModel.idCard}");
      });
    }
    notifyListeners();
  }

  closeSocket() {
    MqttClientMsg.instance
        ?.unsubscribe("/topic/hetong/${userViewModel.idCard}");
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
              height: MediaQuery.of(ctx).size.height,
              isBase64: isBase64,
              onWillPop: () {
                showOneImg = 1;
                return Future.value(true);
              },
              onTop: () {
                MqttClientMsg.instance.postMessage(
                    json.encode({
                      "code": "888",
                      "info": '',
                      "userId": orderInfo.roomId,
                    }),
                    "/topic/hetong/collect/${userViewModel.idCard}");
                showOneImg = 1;
                G.pop();
              },
              images: info, //传入图片list
              index: 0, //传入当前点击的图片的index
              heroTag: "1");
        });
  }

  /// 获取定位信息
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
      location = await AmapLocation.instance.fetchLocation();
      print("高德的位置信息：-----$location");
      if (location.latLng.longitude != null && location.latLng.longitude != 0.0 &&
          location.latLng.latitude != null && location.latLng.latitude != 0.0) {
        latLng = "${location.latLng.longitude},${location.latLng.latitude}";
      } else {
        ipAddress = await G.getDeviceIPAddress();
      }
    } else {
      ipAddress = await G.getDeviceIPAddress();
      G.showPermissionDialog(str: "访问定位权限");
    }
  }

  goPay() {
    showModalBottomSheet(
      context: G.getCurrentState().overlay.context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: 150,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
          ),
          width: double.infinity,
          child: Column(
            children: <Widget>[
              InkWell(
                onTap: throttle(() async {
                  EasyLoading.show();
                  await Future.delayed(Duration(milliseconds: 1000));
                  Map<String, Object> map = {
                    "totalAmount": total(),
                    "outTradeNo": orderInfo.orderNo,
                    "subject": '公证费用',
                    "source": "app",
                    'type': 'zz'
                  };
                  HomeApi.getSingleton().aliPay(map).then((res) {
                    EasyLoading.dismiss();
                    if (res != null) {
                      if (res['code'] == 200) {
                        isPay = false;
                        _alipay(res['item']);
                      }
                    }
                  });
                }),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(width: 1, color: AppTheme.bg_e))),
                  padding: EdgeInsets.fromLTRB(30, 30, 10, 20),
                  child: Row(
                    children: <Widget>[
                      aliPayIco(
                        color: Colors.blue,
                        size: 30,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text('支付宝支付',
                          style: TextStyle(
                              fontSize: 16, color: AppTheme.dark_grey)),
                    ],
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(width: 1, color: AppTheme.bg_e))),
                padding: EdgeInsets.fromLTRB(30, 20, 10, 10),
                child: Row(
                  children: <Widget>[
                    weChatIco(
                      color: Colors.green,
                      size: 30,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 30,
                        child: H5PayWidget(
                          timeout: Duration(seconds: 30),
                          refererScheme: Platform.isAndroid
                              ? "https://sc.njguochu.com"
                              : "sc.njguochu.com://",
                          builder: (ctx, controller) {
                            return InkWell(
                                onTap: throttle(() async {
                                  EasyLoading.show();
                                  numPay = 1;
                                  await Future.delayed(
                                      Duration(milliseconds: 1000));
                                  Map<String, Object> map = {
                                    "orderGuid": orderInfo.orderNo
                                  };
                                  print("-----------订单号${orderInfo.orderNo}");
                                  HomeApi.getSingleton().wxPay(map).then((res) {
                                    EasyLoading.dismiss();
                                    if (res != null) {
                                      if (res['code'] == 200) {
                                        controller
                                            .pay(res['result']['mweb_url'],
                                                jumpPayResultCallback: (p) {
                                          print("是否进行了微信支付 ->$p");
                                          if (p == JumpPayResult.SUCCESS) {
                                            print("进行了支付跳转,但是我不知道用户到底有没有进行支付");
                                            timerPay?.cancel();
                                            timerPay = Timer.periodic(
                                                Duration(seconds: 5), (t) {
                                              numPay++;
                                              print(
                                                  "++++++++++++++++++++++++++计数器++$numPay");
                                              Map<String, Object> map1 = {
                                                "outTradeNo": orderInfo.orderNo
                                              };
                                              HomeApi.getSingleton()
                                                  .getPay(map1)
                                                  .then((value) {
                                                if (value['code'] == 200 &&
                                                    value['item']
                                                            ['tradeStatus'] ==
                                                        "SUCCESS") {
                                                  MqttClientMsg.instance
                                                      .postMessage(
                                                          json.encode({
                                                            "code": "301",
                                                            "info": '微信支付成功',
                                                            "userId": orderInfo
                                                                .roomId,
                                                          }),
                                                          "/topic/hetong/collect/${userViewModel.idCard}");
                                                  t.cancel();
                                                }
                                              });
                                              if (numPay > 17) {
                                                t.cancel();
                                              }
                                            });
                                          } else if (p ==
                                              JumpPayResult.TIMEOUT) {
                                            print("支付跳转失败");
                                            ToastUtil.showNormalToast("支付失败");
                                          } else if (p == JumpPayResult.FAIL) {
                                            print("没有安装或者不允许本应用打开微信支付");
                                            ToastUtil.showNormalToast(
                                                "没有安装微信或者不允许本应用打开微信支付");
                                          }
                                          G.pop();
                                        });
                                      } else if (res['code'] == 500) {
                                        ToastUtil.showNormalToast(res['msg']);
                                      } else {
                                        ToastUtil.showNormalToast("支付失败");
                                      }
                                    }
                                  });
                                }),
                                child: Text("微信支付",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: AppTheme.dark_grey)));
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  _alipay(payInfo) async {
    EasyLoading.show(status: "付款中...");
    var result = await aliPay(payInfo);
    print('...........付款$result');
    isPay = true;
    EasyLoading.dismiss();
    if (result['resultStatus'] == "9000") {
      MqttClientMsg.instance.postMessage(
          json.encode({
            "code": "301",
            "info": '支付宝支付成功',
            "userId": orderInfo.roomId,
          }),
          "/topic/hetong/collect/${userViewModel.idCard}");
    } else if (result['resultStatus'] == "6001") {
      MqttClientMsg.instance.postMessage(
          json.encode({
            "code": "3333",
            "info": '支付宝支付失败',
            "userId": orderInfo.roomId,
          }),
          "/topic/hetong/collect/${userViewModel.idCard}");
    }
    G.pop();
  }

  capturePng(String code, bool isBase64) async {
    isCapture = false;
    print("---------------截图-----------------");
    engine.enableLocalVideo(false);
    sleep(Duration(milliseconds: 600));
    try {
      cameras = await availableCameras();
      cameraController =
          CameraController(cameras[camerasNum], ResolutionPreset.medium);
      print('-----------------result--------$cameraController');
      await cameraController.initialize();
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
      if (isBase64) {
        String base64 = base64Encode(result);
        MqttClientMsg.instance.postMessage(
            json.encode({
              "code": code,
              "userId": orderInfo.roomId,
              "info": "data:image/png;base64,$base64"
            }),
            "/topic/hetong/collect/${userViewModel.idCard}");
      } else {
        MultipartFile multipartFile = MultipartFile.fromBytes(
          result,
          filename: '${DateTime.now().millisecondsSinceEpoch}.jpg',
          contentType: MediaType("image", "jpg"),
        );
        HomeApi.getSingleton().uploadPictures(multipartFile).then((res) {
          if (res != null) {
            if (res['code'] == 200) {
              print('-------------------------$res');
              MqttClientMsg.instance.postMessage(
                  json.encode({
                    "code": code,
                    "userId": orderInfo.roomId,
                    "info": res['item']['filePath']
                  }),
                  "/topic/hetong/collect/${userViewModel.idCard}");
            }
          }
        });
      }
      sleep(Duration(milliseconds: 100));
      isCapture = true;
    } catch (e) {
      print("$e，GG报错");
      engine.enableLocalVideo(true);
    }
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
    print('=================orderInfo.roomId: ' + orderInfo.roomId);
    print('=================userViewModel.idCard: ' + userViewModel.idCard);

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
              notarizationMatters: orderInfo.roomId,
              idCard: userViewModel.idCard,
          ),
        );
      },
    );

    // showDialog(
    //     context:G.getCurrentState().overlay.context,
    //     builder: (ctx){
    //       return DemoPage(
    //           label: url,
    //           code: code,
    //           name: name,
    //           roomId:orderInfo.roomId,
    //           idCard:idCard,
    //       );

    //       // return  WebViewPlus(
    //       //   javascriptMode: JavascriptMode.unrestricted,
    //       //   onWebViewCreated: (controller) {
    //       //     controller.loadUrl(url,headers: {});
    //       //   },
    //       //   javascriptChannels: <JavascriptChannel>[
    //       //     JavascriptChannel(
    //       //         name: "share",
    //       //         onMessageReceived: (JavascriptMessage message) {
    //       //           if(message.message!=null){
    //       //             G.pop();
    //       //             Map msg =  json.decode(message.message);
    //       //             List arr = [];
    //       //             arr.add(msg['base64']);
    //       //             Map<String,Object> map1 = {"files": arr,"idCard":'111'};
    //       //             HomeApi.getSingleton().uploadImg(map1).then((res){
    //       //               if(res!=null){
    //       //                 if(res['code']==200){
    //       //                   MqttClientMsg.instance.postMessage(json.encode({"code":code,"encDataFilePath": msg['encDataFilePath'],"formUserId": idCard,"userId": orderInfo.roomId,"info": res['item'][0]['filePath']}),"/topic/hetong/collect/${userViewModel.idCard}");
    //       //                 }
    //       //               }
    //       //             });
    //       //           }
    //       //         }
    //       //     ),
    //       //   ].toSet(),
    //       //   onPageFinished: (url) {
    //       //     print('....$url');
    //       //   },
    //       // );
    //     });
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

//选照片
  Future<void> selectAssets() async {
    try {
      List<Asset> resultList = await MultiImagePicker.pickImages(
        // 选择图片的最大数量
        maxImages: 9,
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
        if (resultList.length == i + 1) {
          EasyLoading.dismiss();
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
                    "code": "010",
                    "info": imgUrl,
                    "userId": orderInfo.roomId
                  }),
                  "/topic/hetong/collect/${userViewModel.idCard}");
            }
          });
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

  // 初始化应用
  // Future<void> initPlatformState() async {
  //   print("111111111111111*--------${Config.aPPId}+++++++++++${Config.token}++++++++");
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
  //           for (var i = 0; i < userList.length; i++) {
  //             if (userList[i]['uid'] == uid) {
  //               userList.removeAt(i);
  //             }
  //           }
  //         notifyListeners();
  //       },
  //       remoteVideoStateChanged:(int uid, VideoRemoteState state, VideoRemoteStateReason reason, int elapsed){
  //         print('远方视频状态 $uid----$state-------------$reason-------------$elapsed');
  //         if(state == VideoRemoteState.Decoding){
  //           if(!userList.any((item) => item['name']==uid)){
  //             userList.add({"name":uid,"uid":uid});
  //           }
  //         }
  //         notifyListeners();
  //       },

  //     ));
  //     print("到底出现到什么错误1");
  //     /// 开启视频
  //     await engine.enableVideo();
  //     print("到底出现到什么错误2");

  //     /// 加入频道
  //     await engine.joinChannel(Config.token, orderInfo.roomId, null, 0);
  //     MqttClientMsg.instance.postMessage(json.encode({"code":"ht_enter","userId": orderInfo.roomId}),"/topic/hetong/collect/${userViewModel.idCard}");
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
    if (topic == "hetong") {
      var orderData = json.decode(onData);
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
    print("腾讯orderInfo.roomId........................${orderInfo.roomId}");

    trtcCloud.enterRoom(
        TRTCParams(
            sdkAppId: Config.sdkAppId, //应用Id
            userId: userViewModel.idCard, // 用户Id
            userSig: userSig, // 用户签名
            strRoomId: orderInfo.roomId), //房间Id
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
    MqttClientMsg.instance.postMessage(
        json.encode({"code": "ht_enter", "userId": orderInfo.roomId}),
        "/topic/hetong/collect/${userViewModel.idCard}");
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
      if (param != 'ScreenShare') {
        userList.add({'userId': param, "widget": addRoom(true, false, param)});
      }
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
            "userId": orderInfo.roomId,
            "info": "data:image/png;base64,$base64"
          }),
          "/topic/hetong/collect/${userViewModel.idCard}");
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
                  "userId": orderInfo.roomId,
                  "info": res['item']['filePath']
                }),
                "/topic/hetong/collect/${userViewModel.idCard}");
          }
        }
      });
    }
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
