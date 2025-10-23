import 'dart:async';
import 'dart:developer';
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
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tobias/tobias.dart';

import '../../../appTheme.dart';
import '../../../utils/common_tools.dart';
import '../../../utils/h5Pay.dart';

class HelpViewModel extends SingleViewStateModel with WidgetsBindingObserver {
  List shipingLists = []; //公证列表
  RefreshController refreshController;
  UserViewModel userModel;
  int pageNum = 1;
  String pageSize = "10";
  String orderNumber; //单条订单编号
  double totalMoney = 0.0; //需要付款的金额

  Timer timerPay;
  int numPay = 1;
  Timer timerPay1;
  int numPay1 = 1;
  Function paySuccessCallBack;

  /// 1: 自助办证  2: 视屏办证  3：多方公证 4：对公公证 5：自助存证
  int orderNum = 2;

  TextEditingController textEditingController = TextEditingController();
  String orderId = '';
  String remarks = '';
  String score = '';
  bool isBool = true;

  // 是否进行支付宝跳转
  bool isAliPayJump = false;

  // 是否是补缴
  bool isRepair = false;

  HelpViewModel(UserViewModel userModel) {
    this.userModel = userModel;
    refreshController = RefreshController();
    addWidgetsBindingObserver();
  }

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

  void addWidgetsBindingObserver() {
    WidgetsBinding.instance.addObserver(this);
  }

  void removeWidgetsBindingObserver() {
    isAliPayJump = false;
    WidgetsBinding.instance.removeObserver(this);
  }

  //评价
  addScore() {
    if (!isBool) {
      return;
    }
    // ToastUtil.showWarningToast(" orderId:"+orderId+
    //     " remarks:"+textEditingController.text+
    //     " score:"+score);

    if (textEditingController.text.isNotEmpty) {
      isBool = false;

      Map<String, dynamic> map = {
        "orderId": orderId, //订单id
        "remarks": textEditingController.text, //备注
        "score": score, //评分
        // "updateUserId":'', //修改用户Id
      };
      HelperApi.getSingleton().getEvaluateAdd(map).then((res) {
        isBool = true;
        wjPrint('===============================');
        if (res["code"] == 200) {
          ToastUtil.showErrorToast("评价已提交");
          // G.getCurrentState().pop("refresh");
        } else if (res["code"] == 4001) {
          ToastUtil.showErrorToast(res["message"]);
        } else {
          ToastUtil.showErrorToast(res["data"]);
        }
      });
    } else {
      ToastUtil.showWarningToast("请填写评价" + textEditingController.text);
    }
  }

  goPay(bool isRepair, {Function callBack}) {
    //付款
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
                onTap: () {
                  EasyLoading.show();
                  Map<String, Object> map = {
                    "outTradeNo": isRepair ? "$orderNumber-2" : orderNumber,
                    "subject": '公证费用',
                    "source": "app",
                    'type': 'zz'
                  };
                  this.isRepair = isRepair;
                  HomeApi.getSingleton().aliPay(map).then((res) {
                    EasyLoading.dismiss();
                    if (res != null) {
                      if (res['code'] == 200) {
                        _alipay(res['item'], callBack: callBack);
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
                                  timerPay?.cancel();
                                  numPay1 = 1;
                                  await Future.delayed(
                                      Duration(milliseconds: 1000));
                                  Map<String, Object> map = {
                                    "orderGuid": isRepair
                                        ? "$orderNumber-2"
                                        : orderNumber,
                                    "source": "app",
                                    'type': 'zz'
                                  };
                                  wjPrint("-----------订单号$orderNumber");
                                  HomeApi.getSingleton().wxPay(map).then((res) {
                                    EasyLoading.dismiss();
                                    if (res != null) {
                                      if (res['code'] == 200) {
                                        wjPrint(
                                            "----------------------${res['result']['mweb_url']}");
                                        controller
                                            .pay(res["result"]["mweb_url"],
                                                jumpPayResultCallback: (p) {
                                          wjPrint("是否进行了微信支付 ->$p");
                                          if (p == JumpPayResult.SUCCESS) {
                                            wjPrint("进行了支付跳转,但是我不知道用户到底有没有进行支付");
                                            timerPay?.cancel();
                                            timerPay = Timer.periodic(
                                                Duration(seconds: 5), (t) {
                                              numPay++;
                                              wjPrint(
                                                  "++++++++++++++++++++++++++计数器++$numPay");
                                              Map<String, Object> map1 = {
                                                "outTradeNo": isRepair
                                                    ? "$orderNumber-2"
                                                    : orderNumber
                                              };
                                              HomeApi.getSingleton()
                                                  .getPay(map1)
                                                  .then((value) {
                                                if (value['code'] == 200 &&
                                                    value['item']
                                                            ['tradeStatus'] ==
                                                        "SUCCESS") {
                                                  t.cancel();
                                                  ToastUtil.showSuccessToast(
                                                      "付款成功");
                                                  callBack();
                                                  refresh();
                                                }
                                              });
                                              if (numPay1 > 17) {
                                                t.cancel();
                                              }
                                            });
                                          } else if (p ==
                                              JumpPayResult.TIMEOUT) {
                                            wjPrint("支付跳转失败");
                                            ToastUtil.showNormalToast("支付失败");
                                          } else if (p == JumpPayResult.FAIL) {
                                            wjPrint("没有安装或者不允许本应用打开微信支付");
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
                                      notifyListeners();
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
                                    Text("微信支付",
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

  _alipay(payInfo, {Function callBack}) async {
    G.pop();
    if (callBack != null) {
      paySuccessCallBack = callBack;
    }
    EasyLoading.show(status: "付款中...");
    if (Platform.isIOS) {
      isAliPayJump = true;
    }
    var result = await aliPay(payInfo);
    if (Platform.isIOS) {
      isAliPayJump = false;
    }
    EasyLoading.dismiss();
    if (result['resultStatus'] == "9000") {
      ToastUtil.showSuccessToast("付款成功");
      _alipayOrderState();
      if (callBack != null) {
        callBack();
      }
      refresh();
    } else if (result['resultStatus'] == "6001") {
      ToastUtil.showErrorToast("付款失败");
    }
    notifyListeners();
  }

  void _alipayOrderState() {
    // timerPay?.cancel();
    // numPay = 1;
    // timerPay = Timer.periodic(
    //     Duration(seconds: 5), (t) {
    //   numPay++;
    wjPrint("++++++++++++++++++++++++++计数器++$numPay");
    Map<String, Object> map1 = {"outTradeNo": this.isRepair ? "$orderNumber-2" : orderNumber};
    wjPrint("paySuccessCallBack--------$map1");
    EasyLoading.dismiss();
    HomeApi.getSingleton().getAliPayState(map1).then((value) {
      wjPrint("支付包查询订单状态成功后返回的数据------$value");
      if (value['code'] == 200 && value['item']['code'] == "10000") {
        isAliPayJump = false;
        paySuccessCallBack();
        EasyLoading.dismiss();
        ToastUtil.showSuccessToast("付款成功");
        // t.cancel();
        refresh();
        notifyListeners();
        // Future.delayed(Duration.zero).then((value) => G.pushNamed(RoutePaths.HomeIndex));
      } else {
        isAliPayJump = false;

        // t.cancel();

        ToastUtil.showErrorToast("付款失败");
      }
    });
    // if (numPay > 17) {
    //   t.cancel();
    //   numPay = 1;
    // }
    // });
  }

  getShiPingList() {
    //视频公证列表
    pageNum = 1;
    shipingLists?.clear();
    if (orderNum == 4) {
      if (userModel.idCard != null && userModel.idCard.isNotEmpty) {
        var map = {
          "currentPage": pageNum.toString(),
          "pageSize": pageSize,
          "idCard": userModel.idCard,
        };
        HelperApi.getSingleton().getDuiOrderList(map).then((data) {
          setBusy(false);
          wjPrint("........$data");
          if (data["code"] == 200) {
            shipingLists = data["items"];
          }
          notifyListeners();
        });
      } else {
        EasyLoading.dismiss();
        return ToastUtil.showWarningToast("请先实名认证！");
      }
    } else if (orderNum == 5) {
      var map3 = {
        "currentPage": pageNum.toString(),
        "pageSize": pageSize,
        //"userId": userModel.unitGuid,
      };
      wjPrint(map3);
      HelperApi.getSingleton().getAutoOrderList(map3).then((data) {
        setBusy(false);
        if (data["code"] == 200) {
          shipingLists = data["items"];
        }
        notifyListeners();
      });
    } else {
      var map = {
        "currentPage": pageNum.toString(),
        "pageSize": pageSize,
        //"userId": userModel.unitGuid,
        "notaryForm": orderNum
      };
      wjPrint(".......$map");
      HelperApi.getSingleton().getOneListNotarizationData(map).then((data) {
        setBusy(false);
        if (data["code"] == 200) {
          shipingLists = data["items"];
        }
        notifyListeners();
      });
    }
  }

  Future loadData() async {
    setBusy(true);
  }

  refresh() async {
    pageNum = 1;
    refreshController.resetNoData();
    wjPrint("+++++refresh(++++++++++++++$orderNum");
    if (orderNum == 4) {
      if (userModel.idCard != null && userModel.idCard.isNotEmpty) {
        var map = {
          "currentPage": pageNum.toString(),
          "pageSize": pageSize,
          "idCard": userModel.idCard,
        };
        HelperApi.getSingleton().getDuiOrderList(map, errorCallBack: (e) {
          refreshController.refreshFailed();
          setBusy(false);
        }).then((data) {
          if (data["items"] != null) {
            shipingLists = data["items"];
          }
          refreshController.refreshCompleted();
          notifyListeners();
        }).whenComplete(() {
          refreshController.refreshCompleted();
          setBusy(false);
        });
      } else {
        EasyLoading.dismiss();
        return ToastUtil.showWarningToast("请先实名认证！");
      }
    } else if (orderNum == 5) {
      var map3 = {
        "currentPage": pageNum.toString(),
        "pageSize": pageSize,
        //"userId":userModel.unitGuid,
      };
      HelperApi.getSingleton().getAutoOrderList(map3, errorCallBack: (e) {
        refreshController.refreshFailed();
        setBusy(false);
      }).then((data) {
        log("+++++++zhelima $data");
        if (data["items"] != null) {
          shipingLists = data["items"];
        }
        refreshController.refreshCompleted();
        notifyListeners();
      }).whenComplete(() {
        refreshController.refreshCompleted();
        setBusy(false);
      });
    } else {
      var map1 = {
        "currentPage": pageNum.toString(),
        "pageSize": pageSize,
        //"userId":userModel.unitGuid,
        "notaryForm": orderNum
      };
      log("++++map----$map1");
      HelperApi.getSingleton().getOneListNotarizationData(map1,
          errorCallBack: (e) {
        refreshController.refreshFailed();
        setBusy(false);
      }).then((data) {
        shipingLists = data["items"];
        refreshController.refreshCompleted();
        notifyListeners();
      }).whenComplete(() {
        refreshController.refreshCompleted();
        setBusy(false);
      });
    }
  }

  loadMore() async {
    pageNum += 1;

    if (orderNum == 4) {
      wjPrint("+++++refresh++++++++++++++$orderNum");
      if (userModel.idCard != null && userModel.idCard.isNotEmpty) {
        var map = {
          "currentPage": pageNum.toString(),
          "pageSize": pageSize,
          "idCard": userModel.idCard,
        };
        HelperApi.getSingleton().getDuiOrderList(map, errorCallBack: (e) {
          refreshController.loadFailed();
          pageNum -= 1;
        }).then((data) {
          data["items"].forEach((i) {
            shipingLists.add(i);
          });
          if (data["items"].isEmpty) {
            refreshController.loadNoData();
          } else {
            refreshController.loadComplete();
            notifyListeners();
          }
        });
      } else {
        EasyLoading.dismiss();
        return ToastUtil.showWarningToast("请先实名认证！");
      }
    } else if (orderNum == 5) {
      var mapAuto = {
        "currentPage": pageNum.toString(),
        "pageSize": pageSize,
        //"userId": userModel.unitGuid,
      };
      HelperApi.getSingleton().getAutoOrderList(mapAuto, errorCallBack: (e) {
        refreshController.loadFailed();
        pageNum -= 1;
      }).then((data) {
        data["items"].forEach((i) {
          shipingLists.add(i);
        });
        if (data["items"].isEmpty) {
          refreshController.loadNoData();
        } else {
          refreshController.loadComplete();
          notifyListeners();
        }
      });
    } else {
      var mapShiPin = {
        "currentPage": pageNum.toString(),
        "pageSize": pageSize,
        //"userId": userModel.unitGuid,
        "notaryForm": orderNum
      };
      HelperApi.getSingleton().getOneListNotarizationData(mapShiPin,
          errorCallBack: (e) {
        refreshController.loadFailed();
        pageNum -= 1;
      }).then((data) {
        data["items"].forEach((i) {
          shipingLists.add(i);
        });
        if (data["items"].isEmpty) {
          refreshController.loadNoData();
        } else {
          refreshController.loadComplete();
          notifyListeners();
        }
      });
    }
  }

  @override
  onCompleted(data) {
    if (data.items == null || data.items.length == 0) {
      setEmpty();
    } else {
      data["items"].forEach((i) {
        shipingLists.add(i);
      });
    }
  }
}
