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
import 'package:notarization_station_app/iconfont/Icon.dart';
import 'package:notarization_station_app/page/home/entity/video_entity.dart';
import 'package:notarization_station_app/page/home/vm/bottomsheet/video_bottomsheet_vm.dart';
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
import 'package:tobias/tobias.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../appTheme.dart';
import '../../../config.dart';
import '../../../utils/GenerateTestUserSig.dart';
import '../../../utils/h5Pay.dart';

class VideoIngViewModel extends SingleViewStateModel with ClientCallback {
  final UserViewModel userViewModel;
  final String roomId;
  final VideoEntity orderInfo;
  List applicationForm = [
    {
      'name': '',
      'idCard': '',
      'address': '',
      'mobile': '',
    }
  ];
  List agentForm = [];
  List enterpriseForm = [];
  Map contentForm = {
    'area': '',
    'cailiaoValue': '',
    'gongzhengValue': '',
    'lang': '',
    'yongtu': '',
    'remark': '',
  };
  double videoHeight;
  int showTab = 0;
  List materialsList = [];
  // List<Asset> imgList = [];
  List imgList = [];
  String htmlInfo = '';
  bool showUpload = true;
  int offSet = 1;
  // int offSet1 = 1;
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
  bool isPay = true;
  CameraController cameraController;
  List<CameraDescription> cameras = [];
  int camerasNum = 1;

  String captureCode = "";
  bool isBase64 = false;
  bool isCapture = true;

  String latLng = '';

  Location location;
  /// 获取当前ip信息
  String ipAddress = '';

  //RTC相关
  RtcEngine engine;
  List userList = [];

  int imgName = 0;
  bool bottomsheet = true;
  // bool num = false;

  // 主要是为了处理使用支付宝时，未登录状态下使用人脸登录，造成的sdk相机被占用问题
  bool isAlipay = false;

  bool isWeChatPay = false;

  BuildContext context;

  bool isCameraReady = false;

  var payAlertResult;

  VideoIngViewModel(
      this.userViewModel, this.roomId, this.orderInfo, this.context);
  String getApplication() {
    List nameList = [];
    applicationForm.forEach((e) {
      nameList.add(e['name']);
    });
    return nameList.length == 0 ? "" : nameList.join("、");
  }

  @override
  onCompleted(data) {}

  @override
  Future loadData() {
    MqttClientMsg.instance.setCallback(this);
    showTab = orderInfo.unitGuid.currentState ?? 0;
    notifyListeners();
    MqttClientMsg.instance.postMessage(
        json.encode({
          'code':"retrieveData"
        }),
        "/topic/shiping/collect/${userViewModel.idCard}");
    // initPlatformState();
    // ifqmbootsheet();

    Future.delayed(Duration(microseconds: 200), () {
      iniRoom();
    });
    getNetwork();
    return null;
  }

  // ifqmbootsheet()async{
  //   SharedPreferences bottomsheet = await SharedPreferences.getInstance();
  //   bottomsheet.getBool("ifbottomsheet");
  // }
  showType() {
    switch (showTab) {
      case 0:
        return "lib/assets/images/tab0.jpg";
        break;
      case 1:
        return "lib/assets/images/tab1.jpg";
        break;
      case 2:
        return "lib/assets/images/tab2.jpg";
        break;
      case 3:
        return "lib/assets/images/tab3.jpg";
        break;
      case 4:
        return "lib/assets/images/tab4.jpg";
        break;
    }
  }

  socketInfo(info) async {
    if (info['code'] == '00') {
      List numList = [];
      for (int i = 0; i < info['info'].length; i++) {
        if (info['info'][i] != null &&
            info['info'][i]['name'] == '' &&
            info['info'][i]['idCard'] == '' &&
            info['info'][i]['address'] == '' &&
            info['info'][i]['mobile'] == '') {
          numList.add(info['info'][i]);
        }
      }
      numList.forEach((element) {
        info['info'].remove(element);
      });
      if (info['info'].length != 0) {
        applicationForm = info['info'];
        notifyListeners();
      } else {
        applicationForm = [
          {
            'name': '',
            'idCard': '',
            'address': '',
            'mobile': '',
          }
        ];
      }
    } else if (info['code'] == '01') {
      List numList = [];
      for (int i = 0; i < info['info'].length; i++) {
        if (info['info'][i]['name'] == '' &&
            info['info'][i]['idCard'] == '' &&
            info['info'][i]['principal'] == '' &&
            info['info'][i]['mobile'] == '' &&
            info['info'][i]['gender'] == '') {
          numList.add(info['info'][i]);
        }
      }
      numList.forEach((element) {
        info['info'].remove(element);
      });
      print("--------------${info['info'].length}");
      agentForm = info['info'];
    } else if (info['code'] == '02') {
      List numList = [];
      for (int i = 0; i < info['info'].length; i++) {
        if (info['info'][i]['companyName'] == '' &&
            info['info'][i]['statutoryPerson'] == '' &&
            info['info'][i]['statutoryMobile'] == '' &&
            info['info'][i]['companyAdd'] == '') {
          numList.add(info['info'][i]);
        }
      }
      numList.forEach((element) {
        info['info'].remove(element);
      });
      enterpriseForm = info['info'];
    } else if (info['code'] == '001') {
      contentForm = info['info'];
    } else if (info['code'] == '102') {
      //签字 info['name']
      showSignature(
          info['name'], info['idCard'], 'shiping,手印', '$offSet', '020');
    } else if (info['code'] == '101') {
      showImg(info['info'], false);
    } else if (info['code'] == '500') {
      //切换到第二个tab
      showTab = 1;
    } else if (info['code'] == 'next1') {
      showImg(info['info'], false);
    } else if (info['code'] == '505') {
      showTab = 2;
    } else if (info['code'] == '510') {
      htmlInfo = info['info'];
    } else if (info['code'] == '1002') {
      //被证明文件签字
      print(info['info']);
      if (info['keyWordIndex'] == null) {
        if (!info['isUpload_pdf']) {
          showSignature(info['info']['name'], info['info']['idCard'],
              "shiping,${info['info']['keyWord']}", 'ZMsame', '2002');
        } else {
          showSignature(info['info']['name'], info['info']['idCard'],
              "shiping,${info['info']['keyWord']}", 'ZMsame_ispdf', '2002');
        }
      } else {
        showSignature(
            info['info']['name'],
            info['info']['idCard'],
            "shiping,${info['info']['keyWord']}",
            'ZMsame,${info['keyWordIndex']}',
            '2002');
      }
    } else if (info['code'] == 40002) {
      //删除对应的图片
      imgList.removeAt(info['index']);
    } else if (info['code'] == '110') {
      //被证明文件预览
      showImg(info['info'], false);
    } else if (info['code'] == 'next2') {
      //被证明文件完成预览
      showImg(info['info'], false);
    } else if (info['code'] == '5001') {
      //禁止图片上传
      showUpload = false;
    } else if (info['code'] == '511') {
      showTab = 3;
    } else if (info['code'] == '103') {
      //询问笔录签字
      print(info['info']);
      showSignature(info['info'], info['curidCard'], 'shiping,被接谈人签名：',
          "${info['offset']}", '220');
      // offSet1++;
    } else if (info['code'] == '110') {
      //询问笔录预览
      showImg(info['info'], false);
    } else if (info['code'] == '201') {
      //询问笔录完成预览
      print(showOneImg);
      showImg(info['info'], false);
      // if(info['resttingsignNum3']){
      //   offSet1 = 1;
      // }
    } else if (info['code'] == '502') {
      showTab = 4;
    } else if (info['code'] == '504') {
      showTab = 0;
    }else if (info['code'] == '023') {
      //发证地点
      costMap['address'] = info['info'];
      print("发证地点");
//      showTab = 4;
    } else if (info['code'] == '025') {
      //公证费
      costMap['notarize'] = info['info'];
    } else if (info['code'] == '026') {
      //法律服务费
      costMap['law'] = info['info'];
    } else if (info['code'] == '027') {
      //上门服务费
      costMap['visit'] = info['info'];
    } else if (info['code'] == '028') {
      //拍照服务费
      costMap['photograph'] = info['info'];
    } else if (info['code'] == '029') {
      //其他服务费
      costMap['others'] = info['info'];
    } else if (info['code'] == '106') {
      showImg(info['info'], false);
    } else if (info['code'] == '300') {
      //去付款
      if (isPay) {
        goPay();
      }
    } else if (info['code'] == '107') {
      showImg(info['info'], false);
    } else if (info['code'] == '400') {
      print("++++++1111112232445");
      closeSocket();
      closeRoom();
      ToastUtil.showNormalToast("关闭此次视频公证！");
      G.getCurrentState().popUntil(ModalRoute.withName(RoutePaths.HomeIndex));
    } else if (info['code'] == 'verfi') {
      //偷拍照
      if (isCapture) {
        // capturePng("verfied",false);
        imgName = 1;
        captureImg();
      }
    } else if (info['code'] == 'gongAnQian') {
      //公安签字
      showSignature(info['info']['name'], info['info']['idCard'],
          'shiping,当事人签名', "1", 'gongAnQianCB');
    } else if (info['code'] == 'realSign') {
      //拍照
      if (isCapture) {
        // capturePng("realSignCB",true);
        imgName = 2;
        captureImg();
      }
    } else if (info['code'] == '104') {
      List uint8List = [];
      // info["info"].forEach((e){
      //   Uint8List bytes = Base64Decoder().convert(e.split(',')[0]);
      //   uint8List.add(bytes);
      // });
      // showImg(uint8List,false);
      showImg(info['info'], false);
    } else if (info['code'] == 'getLocation'){
     await getLocation();
      G.uploadOrderLocation({
        'busiId':orderInfo.unitGuid.unitGuid,
        'busiType': 2,
        "idCard":userViewModel.idCard,
        'ip':ipAddress,
        "longitude":latLng.isEmpty?'':latLng.split(',')[0],
        "latitude":latLng.isEmpty?'':latLng.split(',')[1]
      },responseSuccess: (value){
        MqttClientMsg.instance.postMessage(
            json.encode({
              "code": "locationBack",
              "info":value['data']['formattedAddress'] ?? "${value["data"]['province']??''}${value['data']['city']??''}",
            }),
            "/topic/shiping/collect/${userViewModel.idCard}");
      },responseError: (value){
        MqttClientMsg.instance.postMessage(
            json.encode({
              "code": "locationBack",
              "info": "",
            }),
            "/topic/shiping/collect/${userViewModel.idCard}");
      },errorCallBack: (value){
        MqttClientMsg.instance.postMessage(
            json.encode({
              "code": "locationBack",
              "info": "",
            }),
            "/topic/shiping/collect/${userViewModel.idCard}");
      });
    }

    notifyListeners();
  }

  closeSocket() {
    MqttClientMsg.instance
        ?.unsubscribe("/topic/shiping/${userViewModel.idCard}");
  }

  closeRoom() async {
    log("------------退出房间的1111");
    try {
      destoryRoom();
      // await MqttClientMsg.instance?.postMessage(json.encode({"code":'close',"userId": roomId,"info": '关闭了本次视频公证'}),"/topic/shiping/collect/${userViewModel.idCard}");
      subscription?.cancel();
      cameraController?.dispose();
      timer?.cancel();
      // MqttClientMsg.instance?.unsubscribe("/topic/shiping/${userViewModel.idCard}");
    } catch (e) {
      log("------------退出房间的时候发生错误$e");
    }
  }

  callBack(text) {
    print('子组件的值是: ' + text);
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
      notarize = int.parse(costMap['notarize'].toString());
    }
    if (costMap['law'] == '') {
      law = 0;
    } else {
      law = int.parse(costMap['law'].toString());
    }
    if (costMap['visit'] == '') {
      visit = 0;
    } else {
      visit = int.parse(costMap['visit'].toString());
    }
    if (costMap['photograph'] == '') {
      photograph = 0;
    } else {
      photograph = int.parse(costMap['photograph'].toString());
    }
    if (costMap['others'] == '') {
      others = 0;
    } else {
      others = int.parse(costMap['others'].toString());
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
                      "userId": roomId,
                    }),
                    "/topic/shiping/collect/${userViewModel.idCard}");
                showOneImg = 1;
                G.pop();
              },
              images: info, //传入图片list
              index: 0, //传入当前点击的图片的index
              heroTag: "1");
        });
  }

  goPay() async{
    payAlertResult = null;
  payAlertResult = await showDialog(
        context: G.getCurrentState().overlay.context,
        barrierDismissible: false,
        useSafeArea: false,
        builder: (context) {
          return Material(
            color: Colors.transparent,
            child: Column(
              children: [
                const Spacer(),
                Container(
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
                      Container(
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    width: 1, color: AppTheme.bg_e))),
                        padding: EdgeInsets.fromLTRB(30, 10, 10, 10),
                        child: Row(
                          children: [
                            const Spacer(),
                            IconButton(
                              icon: Icon(Icons.close),
                              iconSize: 20,
                              onPressed: () {
                                if(payAlertResult == null){
                                  Navigator.pop(context,"");
                                }
                                MqttClientMsg.instance.postMessage(
                                    json.encode({
                                      "code": "3333",
                                      "info": '用户取消支付',
                                      "userId": roomId,
                                    }),
                                    "/topic/shiping/collect/${userViewModel.idCard}");
                              },
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          EasyLoading.show();
                          Map<String, Object> map = {
                            "totalAmount": total(),
                            "outTradeNo": orderInfo.unitGuid.orderNo,
                            "subject": '公证费用',
                            "source": "app",
                            'type': 'zz'
                          };
                          HomeApi.getSingleton().aliPay(map).then((res) {
                            EasyLoading.dismiss();
                            if (res != null) {
                              if (res['code'] == 200) {
                                isPay = false;
                                MqttClientMsg.instance.postMessage(
                                    json.encode({
                                      "code": "302",
                                      "info": '1',
                                      "userId": roomId,
                                    }),
                                    "/topic/shiping/collect/${userViewModel.idCard}");
                                _alipay(res['item']);
                              }
                            }
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      width: 1, color: AppTheme.bg_e))),
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
                                bottom: BorderSide(
                                    width: 1, color: AppTheme.bg_e))),
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
                                        onTap: ()async{
                                          EasyLoading.show();
                                          numPay = 1;
                                          await Future.delayed(
                                              Duration(milliseconds: 1000));
                                          Map<String, Object> map = {
                                            "orderGuid":
                                            orderInfo.unitGuid.orderNo,
                                            "source": "app",
                                            'type': 'zz'
                                          };
                                          isWeChatPay = false;
                                          print(
                                              "-----------订单号${orderInfo.unitGuid.orderNo}");
                                          HomeApi.getSingleton()
                                              .wxPay(map)
                                              .then((res) {
                                            EasyLoading.dismiss();
                                            if (res != null) {
                                              if (res['code'] == 200) {
                                                MqttClientMsg.instance.postMessage(
                                                    json.encode({
                                                      "code": "302",
                                                      "info": '2',
                                                      "userId": roomId,
                                                    }),
                                                    "/topic/shiping/collect/${userViewModel.idCard}");
                                                isWeChatPay = true;
                                                print(
                                                    "-----------准备下单");
                                                if(payAlertResult==null){
                                                  controller.pay(
                                                      res['result']['mweb_url'],
                                                      jumpPayResultCallback: (p) {
                                                        print("是否进行了微信支付 ->$p");
                                                        if (p ==
                                                            JumpPayResult.SUCCESS) {
                                                          print(
                                                              "进行了支付跳转,但是我不知道用户到底有没有进行支付");
                                                          // timerPay?.cancel();
                                                          // timerPay = Timer.periodic(
                                                          //     Duration(seconds: 5),
                                                          //     (t) {
                                                          //   numPay++;
                                                          //   print(
                                                          //       "++++++++++++++++++++++++++计数器++$numPay");
                                                          //   queryWechatResult();
                                                          //   if (numPay > 17) {
                                                          //     t.cancel();
                                                          //     MqttClientMsg.instance.postMessage(
                                                          //         json.encode({
                                                          //           "code": "3333",
                                                          //           "info": '用户取消微信支付',
                                                          //           "userId": roomId,
                                                          //         }),
                                                          //         "/topic/shiping/collect/${userViewModel.idCard}");
                                                          //   }
                                                          // });
                                                        } else if (p ==
                                                            JumpPayResult.TIMEOUT) {
                                                          print("支付跳转失败");
                                                          ToastUtil.showNormalToast(
                                                              "支付失败");
                                                          MqttClientMsg.instance
                                                              .postMessage(
                                                              json.encode({
                                                                "code": "3333",
                                                                "info": '微信支付失败',
                                                                "userId": roomId,
                                                              }),
                                                              "/topic/shiping/collect/${userViewModel.idCard}");
                                                        } else if (p ==
                                                            JumpPayResult.FAIL) {
                                                          print("没有安装或者不允许本应用打开微信支付");
                                                          ToastUtil.showNormalToast(
                                                              "没有安装微信或者不允许本应用打开微信支付");
                                                          MqttClientMsg.instance
                                                              .postMessage(
                                                              json.encode({
                                                                "code": "3333",
                                                                "info": '微信支付失败',
                                                                "userId": roomId,
                                                              }),
                                                              "/topic/shiping/collect/${userViewModel.idCard}");
                                                        }
                                                        G.pop();
                                                      });
                                                }else{
                                                  MqttClientMsg.instance.postMessage(
                                                      json.encode({
                                                        "code": "3333",
                                                        "info": '用户取消微信支付',
                                                        "userId": roomId,
                                                      }),
                                                      "/topic/shiping/collect/${userViewModel.idCard}");
                                                }
                                              } else if (res['code'] == 500) {
                                                ToastUtil.showNormalToast(
                                                    res['msg']);
                                                MqttClientMsg.instance.postMessage(
                                                    json.encode({
                                                      "code": "3333",
                                                      "info": '微信支付失败',
                                                      "userId": roomId,
                                                    }),
                                                    "/topic/shiping/collect/${userViewModel.idCard}");
                                              } else {
                                                ToastUtil.showNormalToast(
                                                    "支付失败");
                                                MqttClientMsg.instance.postMessage(
                                                    json.encode({
                                                      "code": "3333",
                                                      "info": '微信支付失败',
                                                      "userId": roomId,
                                                    }),
                                                    "/topic/shiping/collect/${userViewModel.idCard}");
                                              }
                                            }
                                          });
                                        },
                                        child: SizedBox(
                                          width: MediaQuery.of(context).size.width,
                                          child: Text("微信支付",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: AppTheme.dark_grey)),
                                        ));
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                      ),

                    ],
                  ),
                )
              ],
            ),
          );
        });
  print("payAlertResult ======= $payAlertResult");
  }

  // 微信支付结果查询
  queryWechatResult({bool isFront = false}) {
    Map<String, Object> map1 = {"outTradeNo": orderInfo.unitGuid.orderNo};
    HomeApi.getSingleton().getPay(map1, errorCallBack: (e) {
      isWeChatPay = false;
    }).then((value) {
      if (value['code'] == 200) {
        if(!isFront){
          if (value["item"]['tradeStatus'] == "SUCCESS") {
            isWeChatPay = false;
            MqttClientMsg.instance.postMessage(
                json.encode({
                  "code": "301",
                  "info": '微信支付成功',
                  "userId": roomId,
                }),
                "/topic/shiping/collect/${userViewModel.idCard}");
            // timerPay?.cancel();
          }
        }else{
          isWeChatPay = false;
          if (value["item"]['tradeStatus'] == "SUCCESS") {
            MqttClientMsg.instance.postMessage(
                json.encode({
                  "code": "301",
                  "info": '微信支付成功',
                  "userId": roomId,
                }),
                "/topic/shiping/collect/${userViewModel.idCard}");
            // timerPay?.cancel();
          }
          if (value["item"]['tradeStatus'] == "NOTPAY") {
            MqttClientMsg.instance.postMessage(
                json.encode({
                  "code": "3333",
                  "info": '用户取消微信支付',
                  "userId": roomId,
                }),
                "/topic/shiping/collect/${userViewModel.idCard}");
            // timerPay?.cancel();
          }
        }
      }
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

  _alipay(payInfo) async {
    EasyLoading.show(status: "付款中...");
    isAlipay = true;
    var result = await aliPay(payInfo);
    print('...........付款$result');
    EasyLoading.dismiss();
    isPay = true;
    if (result['resultStatus'] == "9000") {
      MqttClientMsg.instance.postMessage(
          json.encode({
            "code": "301",
            "info": '支付宝支付成功',
            "userId": roomId,
          }),
          "/topic/shiping/collect/${userViewModel.idCard}");
    } else if (result['resultStatus'] == "6001") {
      MqttClientMsg.instance.postMessage(
          json.encode({
            "code": "3333",
            "info": '支付宝支付失败',
            "userId": roomId,
          }),
          "/topic/shiping/collect/${userViewModel.idCard}");
    } else {
      MqttClientMsg.instance.postMessage(
          json.encode({
            "code": "3333",
            "info": '${result["memo"] ?? ''}',
            "userId": roomId,
          }),
          "/topic/shiping/collect/${userViewModel.idCard}");
    }
    if(payAlertResult==null){
     Navigator.pop(context,"");
    }
  }

  // capturePng(String code,bool isBase64) async {
  //   isCapture = false;
  //   print("---------------截图-----------------");
  //   engine.enableLocalVideo(false);
  //   sleep(Duration(milliseconds:300));
  //   try {
  //     cameras = await availableCameras();
  //     cameraController = CameraController(cameras[camerasNum], ResolutionPreset.medium);
  //     await cameraController.initialize();
  //     if(cameraController.value.isInitialized) {
  //       sleep(Duration(milliseconds: 500));
  //       XFile info = await cameraController.takePicture();
  //       sleep(Duration(milliseconds:100));
  //       cameraController.dispose();
  //       engine.enableLocalVideo(true);
  //       final result = await FlutterImageCompress.compressWithFile(
  //         info.path,
  //         minWidth: 2300, //压缩后的最小宽度
  //         minHeight: 1500, //压缩后的最小高度
  //         quality: 20, //压缩质量
  //         rotate: 0, //旋转角度
  //       );
  //       if (isBase64) {
  //         String base64 = base64Encode(result);
  //         MqttClientMsg.instance.postMessage(json.encode({"code": code, "userId": roomId, "info": "data:image/png;base64,$base64"}), "/topic/shiping/collect/${userViewModel.idCard}");
  //       } else {
  //         MultipartFile multipartFile = MultipartFile.fromBytes(
  //           result,
  //           filename: '${DateTime.now().millisecondsSinceEpoch}.jpg',
  //           contentType: MediaType("image", "jpg"),
  //         );
  //         HomeApi.getSingleton().uploadPictures(multipartFile).then((res) {
  //           if (res != null) {
  //             if (res['code'] == 200) {
  //               MqttClientMsg.instance.postMessage(json.encode({"code": code, "userId": roomId, "info": res['item']['filePath']}), "/topic/shiping/collect/${userViewModel.idCard}");
  //             }
  //           }
  //         });
  //       }
  //       isCapture = true;
  //     }
  //   } catch (e) {
  //     engine.enableLocalVideo(true);
  //   }
  // }

  showSignature(String name, String idCard, String tyKeyword, String offSet,
      String code) async {
    print('-------521$name,$idCard,$tyKeyword,$offSet,$code');
    String url =
        "${Config.caUrl}?name=$name&idCard=${idCard == "" ? "未填写身份证号" : idCard}&tyKeyword=$tyKeyword&offSet=$offSet&terminalType=flutter";
    if (Platform.isIOS) {
      url = Uri.encodeFull(url);
    }

    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      print("当前屏幕方向：${MediaQuery.of(context).orientation}");
      return qmDemoPage1(
          name: name,
          unitGuid: code,
          notarizationMatters: roomId,
          idCard: userViewModel.idCard,
          userIdCard: idCard);
    }));

    // showModalBottomSheet<int>(
    //     enableDrag: false,
    //     backgroundColor: Colors.transparent,
    //     isScrollControlled: true,
    //     context: context,
    //     builder: (BuildContext context) {
    //       return qmDemoPage1(
    //           name: name,
    //           unitGuid: code,
    //           notarizationMatters: roomId,
    //           idCard: userViewModel.idCard,
    //           userIdCard: idCard);
    //     });
  }

  Future<void> requestCameraPermission() async {
    if (Platform.isAndroid) {
      if (!await Permission.storage.status.isGranted ||
          !await Permission.camera.status.isGranted) {
        G.showCustomToast(
            context: G.getCurrentContext(),
            titleText: "相机、存储权限使用说明：",
            subTitleText: "用于拍摄、录制视频、文件存储等场景",
            time: 2);
      }
      if (await Permission.storage.request().isGranted &&
          await Permission.camera.request().isGranted) {
        selectAssets();
      } else {
        G.showPermissionDialog(str: "访问内部相机、相册及文件权限");
      }
    }
    if (Platform.isIOS) {
      if (await Permission.photos.request().isGranted &&
          await Permission.camera.request().isGranted) {
        selectAssets();
      } else {
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
        checkNet();
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
          print("上传图片中${i}");
          // imgList.addAll(resultList);
          if (resultList.length == i + 1) {
            print("上传成功resultList.length: ${resultList.length}  i+1: ${i + 1}");
            EasyLoading.dismiss();
            Map<String, Object> map1 = {"files": imgBase64, "idCard": '111'};
            HomeApi.getSingleton().uploadImg(map1).then((res) {
              if (res != null) {
                if (res['code'] == 200) {
                  List imgUrl = [];
                  res['item'].forEach((e) {
                    materialsList.add(e);
                    imgUrl.add({
                      "annexFileList": e['unitGuid'],
                      "imgPathList": Config.splicingImageUrl(e['filePath']),
                    });
                  });
                  // for(int j=0;j<imgUrl.length;j++){
                  //   imgList.add(imgUrl[j]['imgPathList']);
                  // }
                  // print('上传imgList= : '+imgList.toString());
                  MqttClientMsg.instance.postMessage(
                      json.encode(
                          {"code": "010", "info": imgUrl, "userId": roomId}),
                      "/topic/shiping/collect.${userViewModel.idCard}");
                }
              }
            });
          } else {
            print('上传中resultList.length: ${resultList.length}  i+1: ${i + 1}');
          }
        }
      }
      notifyListeners();
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
  //   print("111111111111--------${Config.aPPId}+++++++++++${Config.token}++++++++$roomId");
  //  try{
  //    /// 创建 RTC 客户端实例
  //    engine = await RtcEngine.create(Config.aPPId);
  //    /// 定义事件处理逻辑
  //    engine.setEventHandler(RtcEngineEventHandler(
  //      ///回调事件处理
  //      joinChannelSuccess: (String channel, int uid, int elapsed) {
  //        print('加入频道回调 $channel $uid');
  //        userList.add({"name":"自己","uid":uid});
  //        notifyListeners();
  //      },
  //      userJoined: (int uid, int elapsed) {
  //        //远方视频加入
  //        print('远方视频加入 $uid');
  //        // notifyListeners();
  //      },
  //      userOffline: (int uid, UserOfflineReason reason) {
  //        //远方视频离开
  //        print('远方视频离开 $uid');
  //        for (var i = 0; i < userList.length; i++) {
  //          if (userList[i]['uid'] == uid) {
  //            userList.removeAt(i);
  //          }
  //        }
  //        notifyListeners();
  //      },
  //      remoteVideoStateChanged:(int uid, VideoRemoteState state, VideoRemoteStateReason reason, int elapsed){
  //        print('远方视频状态 $uid----$state-------------$reason-------------$elapsed');
  //        if(state == VideoRemoteState.Decoding){
  //          if(!userList.any((item) => item['name']==uid)){
  //            userList.add({"name":uid,"uid":uid});
  //          }
  //        }
  //        notifyListeners();
  //      },
  //      localVideoStats:(LocalVideoStats stats){
  //        print('我的视频1 ${stats.codecType}');
  //     }
  //    ));
  //    /// 开启视频
  //    await engine.enableVideo();
  //    /// 加入频道
  //    await engine.joinChannel(Config.token, "$roomId", null, 0);
  //  }catch(e){
  //    print("到底出现到什么错误$e");
  //  }
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
    if (topic == "shiping") {
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

  iniRoom() async {
    //在这边设置签字弹框为true
    // SharedPreferences qmsheet = await SharedPreferences.getInstance();
    // qmsheet.setBool("ifbottomsheet", true);

    // 创建 TRTCCloud 单例
    trtcCloud = await TRTCCloud.sharedInstance();
    // 获取设备管理模块
    txDeviceManager = trtcCloud.getDeviceManager();
    trtcCloud.setVideoEncoderParam(TRTCVideoEncParam());
    // 注册事件回调
    trtcCloud.registerListener(onRtcListener);
    // 进房
    enterRoom();
    // 使用默认模式，采样率48kHz，适合音视频通话场景，减少加速问题
    await trtcCloud.startLocalAudio(TRTCCloudDef.TRTC_AUDIO_QUALITY_DEFAULT);
  }

  // 进入房间
  enterRoom() async {
    String userSig = await GenerateTestUserSig.genTestSig(userViewModel.idCard);

    trtcCloud.enterRoom(
        TRTCParams(
            sdkAppId: Config.sdkAppId, //应用Id
            userId: userViewModel.idCard, // 用户Id
            userSig: userSig,// 用户签名
            strRoomId: roomId), //房间Id
        TRTCCloudDef.TRTC_APP_SCENE_VIDEOCALL);
    print(
        ".......................................1${userList.length}----${userViewModel.idCard}-----$roomId");
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
          : SizedBox(),
    );
  }

  ///开启当前界面录屏功能
  _startShareFunction() {
    print("=== TRTC进房成功，延迟10秒后开始屏幕分享 ===");
    // 延迟5秒后开始屏幕分享，避免音频冲突
    Future.delayed(const Duration(seconds: 5), () {
      print("=== TRTC延迟结束，开始屏幕分享 ===");
      // 配置屏幕分享参数，优化录制和通话稳定性
      TRTCVideoEncParam screenParam = TRTCVideoEncParam(
        videoBitrate: 1000,        // 适中的码率，保证稳定性
        videoResolution: TRTCCloudDef.TRTC_VIDEO_RESOLUTION_640_360, // 640x360分辨率，适合屏幕分享
        videoResolutionMode: TRTCCloudDef.TRTC_VIDEO_RESOLUTION_MODE_PORTRAIT, // 竖屏模式
        videoFps: 15,              // 15fps帧率，流畅且不过载
        minVideoBitrate: 600,      // 最小码率
        enableAdjustRes: true      // 启用自动分辨率调整，根据网络情况智能调整
      );
      
      if (Platform.isAndroid) {
        // Android端屏幕分享，保持通话音频
        trtcCloud.startScreenCapture(
            TRTCCloudDef.TRTC_VIDEO_STREAM_TYPE_SUB,
            screenParam);
      } else if (Platform.isIOS) {
        // iOS端屏幕分享，保持通话音频
        trtcCloud.startScreenCapture(
          TRTCCloudDef.TRTC_VIDEO_STREAM_TYPE_SUB,
          screenParam,
        );
        // 'group.com.guochu.sharevideo'
        // ReplayKitLauncher.launchReplayKitBroadcast("GuoChuVideoShare");
      }
      
      print("=== TRTC屏幕分享已启动，保持通话音频 ===");
    });
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
        _startShareFunction();
      } else {
        log("进房失败------进房失败的错误码$param");
      }
    }
    if (type == TRTCCloudListener.onCameraDidReady) {
      isCameraReady = true;
      print("摄像头是否准备完毕------$param");

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
      print("++++++++++截图回调++++$param+");
      if (param['errCode'] == 0) {
        if (imgName == 1) {
          faceComparison(param['path'], "verfied", false);
        } else {
          faceComparison(param['path'], "realSignCB", true);
        }
      }
    }
    if (type == TRTCCloudListener.onScreenCaptureStarted) {
      print("++++++++++屏幕分享++++$param+");
    }
    if (type == TRTCCloudListener.onNetworkQuality) {
      print("++++++++++网络质量检测++++$param+");
      if (param != null && param.isNotEmpty) {
        if (param['localQuality']['quality'] > 5) {
          ToastUtil.showWarningToast("当前网络较差，无法保证通讯质量");
        }
      }
    }
  }

  captureImg() async {
    final directory = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    String _downloadPath =
        '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.png';
    print("+++++++++++++++截图+++++++++++++++$_downloadPath");
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
      MqttClientMsg.instance.postMessage(
          json.encode({
            "code": code,
            "userId": roomId,
            "info": "data:image/png;base64,$base64"
          }),
          "/topic/shiping/collect/${userViewModel.idCard}");
    } else {
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
                  "info": res['item']['filePath']
                }),
                "/topic/shiping/collect/${userViewModel.idCard}");
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
    print('房间是否销毁了！');
  }
}

// 签名webview
final webViewKey = GlobalKey<WebViewContainerState>();

class WebViewContainer extends StatefulWidget {
  WebViewContainer({Key key}) : super(key: key);

  @override
  WebViewContainerState createState() => WebViewContainerState();
}

class WebViewContainerState extends State<WebViewContainer> {
  WebViewController _webViewController;
  var url =
      'https://scgzdt.com:9007?name=张三&idCard=320882199509213611&tyKeyword=shiping,手印&offSet=1&terminalType=flutter';
  @override
  Widget build(BuildContext context) {
    return WebView(
        onWebViewCreated: (controller) {
          _webViewController = controller;
        },
        // initialUrl: "https://www.baidu.com",
        javascriptMode: JavascriptMode.unrestricted,
        initialUrl: url);
  }

  void reloadWebView() {
    _webViewController?.reload();
  }
}
