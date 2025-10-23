import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:flutter_h5pay/flutter_h5pay.dart';
import 'package:notarization_station_app/base_framework/utils/toast_util.dart';
import 'package:notarization_station_app/base_framework/view_model/single_view_state_model.dart';
import 'package:notarization_station_app/iconfont/Icon.dart';
import 'package:notarization_station_app/page/login/vm/user_view_model.dart';
import 'package:notarization_station_app/service_api/helper_api.dart';
import 'package:notarization_station_app/service_api/home_api.dart';
import 'package:notarization_station_app/utils/global.dart';
import 'package:notarization_station_app/utils/throttle_anti-shake.dart';
import 'package:tobias/tobias.dart';

import '../../../appTheme.dart';
import '../../../utils/common_tools.dart';
import '../../../utils/h5Pay.dart';

class SubmitOrderListModel extends SingleViewStateModel
    with WidgetsBindingObserver {
  final UserViewModel userViewModel;
  final arguments;
  double totalMoney = 0.0;
  String orderNumber;
  String number = "0"; //领取份数
  Timer timerPay;
  int numPay = 1;
  bool isShow = true;
  List<OrderLogModel> orderLogsList = [];

  Map oneData;
  List lists = [];
  List materialLists = [];
  List orderLogs = [];
  int numberCount; //领取份数
  List addPayImgLists = [];
  List applyList = [];
  double supplementFee = 0.0;
  bool isInit = false;
  int currentNotaryState = 0;
  // 是否进行支付宝跳转
  bool isAliPayJump = false;

  SubmitOrderListModel(this.userViewModel, this.arguments);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        if (isAliPayJump && Platform.isIOS) {
          _alipayOrderState();
        }
        break;
    }
  }

  getData() async {
    lists.clear();
    isInit = false;
    supplementFee = 0;
    orderLogsList.clear();
    totalMoney = 0;
    var map = {
      "unitGuid": arguments["orderId"],
    };
    HelperApi.getSingleton().getOneNotarizationData(map).then((value) {
      if (value["code"] == 200) {
        oneData = value["item"];
        wjPrint("submitOrderList----onData-----$oneData");
        if (oneData["orderSupplements"] == null) {
          addPayImgLists = [];
        } else {
          oneData["orderSupplements"].forEach((item) {
            if(item["imagePathBack"]!=null){
              item["imagePathBack"].forEach((i) {
                addPayImgLists.add(i);
              });
            }else{
              addPayImgLists = [];
            }
          });
        }
        lists = oneData["notaryItems"];
        if (lists != null) {
          for (int i = 0; i < lists.length; i++) {
            totalMoney += double.parse(lists[i]["price"].toString());
          }
        }
        numberCount = oneData["order"]["notaryNum"] == null
            ? 0
            : oneData["order"]["notaryNum"];
        oneData["orderLogs"].forEach((item) {
          // currentNotaryState = item['notaryState'] > currentNotaryState
          orderLogs.add(item);
        });
        if (oneData["materials"] != null) {
          materialLists = oneData['materials'];
        }

        if (oneData["order"]["isDaiBan"] == 1) {
          oneData["applyuser"].forEach((item) {
            if (item["principal"] == null) {
              applyList.add(item);
            }
          });
        }
        if (oneData["orderSupplements"] != null) {
          oneData["orderSupplements"].forEach((item) {
            supplementFee += item["supplementFee"];
          });
        }
        isInit = true;
        notifyListeners();
      }
    });
  }

  goPay() {
    showModalBottomSheet(
      context: G.getCurrentState().overlay.context,
      backgroundColor: Colors.transparent,
//      isDismissible:false,
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
                onTap: () {
                  Map<String, Object> map = {
                    "totalAmount": totalMoney.toString(),
                    "outTradeNo": this.orderNumber,
                    "subject": '公证费用',
                    "source": "app",
                    'type': 'zz'
                  };
                  HomeApi.getSingleton().aliPay(map).then((res) {
                    if (res != null) {
                      if (res['code'] == 200) {
                        _alipay(res['item']);
                      }
                    }
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(width: 1, color: AppTheme.bg_e))),
                  padding: EdgeInsets.fromLTRB(30, 30, 10, 20),
                  child: Row(
                    children: <Widget>[
                      aliPayIco(
                        color: Color(0xff3CA4FB),
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
                                  if (Platform.isIOS) {
                                    isAliPayJump = false;
                                  }
                                  EasyLoading.show();
                                  numPay = 1;
                                  await Future.delayed(
                                      Duration(milliseconds: 1000));
                                  Map<String, Object> map = {
                                    "orderGuid": orderNumber,
                                    "source": "app",
                                    'type': 'zz'
                                  };
                                  print("-----------订单号$orderNumber");
                                  HomeApi.getSingleton().wxPay(map,
                                      errorCallBack: (e) {
                                    EasyLoading.dismiss();
                                  }).then((res) {
                                    EasyLoading.dismiss();
                                    if (res != null) {
                                      if (res['code'] == 200) {
                                        print("----------------------$res");
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
                                                "outTradeNo": orderNumber
                                              };
                                              HomeApi.getSingleton()
                                                  .getPay(map1)
                                                  .then((value) {
                                                if (value['code'] == 200 &&
                                                    value['item']
                                                            ['tradeStatus'] ==
                                                        "SUCCESS") {
                                                  t.cancel();
                                                  numPay = 1;
                                                  getData();
                                                  ToastUtil.showSuccessToast(
                                                      "付款成功");
                                                  isShow = false;
                                                  notifyListeners();
                                                  // Future.delayed(Duration.zero).then((value) => G.pushNamed(RoutePaths.HomeIndex));
                                                }
                                              });
                                              if (numPay > 17) {
                                                numPay = 1;
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
                                child: Row(
                                  children: [
                                    weChatIco(
                                      color: Colors.green,
                                      size: 30,
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    const Text("微信支付",
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: AppTheme.dark_grey)),
                                  ],
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
        );
      },
    );
  }

  _alipay(payInfo) async {
    G.pop();
    EasyLoading.show(status: "付款中...");
    if (Platform.isIOS) {
      isAliPayJump = true;
    }
    var result = await aliPay(payInfo);
    if (Platform.isIOS) {
      isAliPayJump = false;
    }
    print("payInfo-----------------$payInfo");
    EasyLoading.dismiss();
    print('...........付款$result');
    if (result['resultStatus'] == "9000") {
      ToastUtil.showSuccessToast("付款成功");
      _alipayOrderState();
      isShow = false;
      getData();
      notifyListeners();
    } else if (result['resultStatus'] == "6001") {
      ToastUtil.showErrorToast("付款失败");
    }
  }

  void _alipayOrderState() {
    // timerPay?.cancel();
    // numPay = 1;
    // timerPay = Timer.periodic(
    //     Duration(seconds: 5), (t) {
    //   numPay++;
    print("++++++++++++++++++++++++++计数器++$numPay");
    Map<String, Object> map1 = {"outTradeNo": orderNumber};
    EasyLoading.dismiss();
    HomeApi.getSingleton().getAliPayState(map1).then((value) {
      print("支付包查询订单状态成功后返回的数据------$value");
      if (value['code'] == 200 && value['item']['code'] == "10000") {
        isAliPayJump = false;
        EasyLoading.dismiss();
        ToastUtil.showSuccessToast("付款成功");
        // t.cancel();
        numPay = 1;
        getData();
        isShow = false;
        notifyListeners();
        // Future.delayed(Duration.zero).then((value) => G.pushNamed(RoutePaths.HomeIndex));
      } else {
        isAliPayJump = false;
        // t.cancel();
        numPay = 1;
        ToastUtil.showErrorToast("付款失败");
      }
    });
    // if (numPay > 17) {
    //   t.cancel();
    //   numPay = 1;
    // }
    // });
  }

  @override
  onCompleted(data) {}

  void addWidgetsBindingObserver() {
    WidgetsBinding.instance.addObserver(this);
  }

  void removeWidgetsBindingObserver() {
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Future loadData() {
    addWidgetsBindingObserver();
    getOneNotarizationData();
    // if (NotaryData.notaryId != "666c2421-b2e1-4076-80aa-8e63cf287de4") {
    //   doSetState();
    // }
    return null;
  }

  void getOneNotarizationData() {
    var map = {
      "unitGuid": arguments["orderId"],
    };
    print('unitGuid-------${arguments["orderId"]}');
    HelperApi.getSingleton().getOneNotarizationData(map).then((value) {
      setBusy(false);
      if (value["code"] == 200) {
        this.orderNumber = value["item"]["order"]["orderNo"];
        number = value["item"]["order"]["notaryNum"].toString();
        List tempData = value['item']['orderLogs'];
        if (tempData != null && tempData.isNotEmpty) {
          tempData.forEach((element) {
            orderLogsList.add(OrderLogModel.formJson(element));
          });
        }
        notifyListeners();
        print(
            'orderLogsList[orderLogsList.length -1].notaryState ---- ${orderLogsList[orderLogsList.length - 1].notaryState}');

        print('orderLogs-----${value['item']['orderLogs']}');
      }
    });
  }

  doSetState() {
    var map = {
      "unitGuid": arguments["orderId"],
      "notaryState": 30,
      "payType": "pt006"
    };
    HomeApi.getSingleton().setTakeType(map);
  }
}

class OrderLogModel {
  String unitGuid;
  String orderId;
  int notaryState;
  String createDate;
  String reason;
  String notaryStateName;

  OrderLogModel(
    this.unitGuid,
    this.orderId,
    this.notaryState,
    this.createDate,
    this.reason,
    this.notaryStateName,
  );

  OrderLogModel.formJson(Map<String, dynamic> json) {
    this.unitGuid = json['unitGuid'];
    this.orderId = json['orderId'];
    this.notaryState = json['notaryState'];
    this.createDate = json['createDate'];
    this.reason = json['reason'];
    this.notaryStateName = json['notaryStateName'];
  }

  toMap() {
    Map<String, dynamic> data = Map();
    data['unitGuid'] = this.unitGuid;
    data['orderId'] = this.orderId;
    data['notaryState'] = this.notaryState;
    data['createDate'] = this.createDate;
    data['reason'] = this.reason;
    data['notaryStateName'] = this.notaryStateName;
    return data;
  }
}
