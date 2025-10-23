import 'dart:async';
import 'dart:io';

import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluwx/fluwx.dart';
import 'package:notarization_station_app/appTheme.dart';
import 'package:notarization_station_app/base_framework/widget_state/base_state.dart';
import 'package:notarization_station_app/components/throttleUtil.dart';
import 'package:notarization_station_app/routes/router.dart';
import 'package:notarization_station_app/components/throttleUtil.dart';
import 'package:tobias/tobias.dart';

import '../../base_framework/utils/toast_util.dart';
import '../../iconfont/Icon.dart';
import '../../service_api/home_api.dart';
import '../../utils/h5Pay.dart';

class CashierDeskPage extends StatefulWidget {
  final double money;
  final String orderNumber;
  const CashierDeskPage({Key key, this.money, this.orderNumber})
      : super(key: key);

  @override
  State<CashierDeskPage> createState() => _CashierDeskPageState();
}

class _CashierDeskPageState extends BaseState<CashierDeskPage>
    with WidgetsBindingObserver {
  int selectIndex = 1;

  Timer timerPay;

  Timer timerDecrease;

  // 后台获取的倒计时时长
  int timeLength;

  // 本地的倒计时显示
  int localTime;

  int numPay = 1;

  // 微信和支付宝是否跳转
  bool isJump = false;

  // 记录当前下单的方式  // 1:支付宝 2.微信
  int payType = 0;

  H5PayController h5payController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    Future.delayed(Duration.zero,(){
      queryUnifiedOrder();
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    timerPay?.cancel();
    timerDecrease?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        if (isJump && Platform.isIOS) {
          searchOrderStatus();
        }
        queryUnifiedOrder();
        break;

    }
  }

  // 查询当前订单的支付状态
  void queryUnifiedOrder(){
    try {
      HomeApi.getSingleton().queryUnifiedOrder({"unitGuid":widget.orderNumber},errorCallBack: (e){
        print("打印报错信息11111111-----$e");
      }).then((value){
        if (value!=null){
          if (value["code"]==200){
            var locTime = value['data']["paySurplusDate"];
            if (locTime == null || 0 == locTime || 0 > locTime) {
              setState(() {
                timerPay?.cancel();
                payType = 0;
                timerDecrease?.cancel();
                localTime = null;
              });
            }else {
              setState(() {
                localTime = locTime;
                payType = value['data']["payType"];
                selectIndex = payType == 1 ? 2 : 1;
              });
              timerDecrease?.cancel();
              timerDecrease = Timer.periodic(Duration(seconds: 1), (timer) {
                setState(() {
                  localTime --;
                  print("localTime---------$localTime");
                  if (0 >= localTime ){
                    timerPay?.cancel();
                    payType = 0;
                    timer?.cancel();
                    localTime = null;
                  }
                });
              });
            }
          }
        }
      });
    }catch (e){
      print("打印报错信息222222222-----$e");
    }
  }

  void goPay() async {
    int tempPayType;
    if (selectIndex == 2){
      tempPayType = 1;
    }else {
      tempPayType = 2;
    }
    if (Platform.isIOS) {
      isJump = false;
    }
    Map<String, Object> map = {
      "unitGuid": widget.orderNumber,
      "payType":tempPayType,
    };
    EasyLoading.show(status: "付款中...");
    HomeApi.getSingleton().addOrderManagerPay(map,errorCallBack: (e){
      ToastUtil.showErrorToast("付款失败");
      EasyLoading.dismiss();
    }).then((value) async {
      EasyLoading.dismiss();
      if (value != null) {
        if (value['code'] == 200) {
          setState(() {
            payType = tempPayType;
          });
          // 支付支付
          if (tempPayType == 1){
            startTimeDecreaseTimer(value["data"]["paySurplusDate"]);
            isJump = true;
            searchOrderStatus();
            await aliPay(value['data']["aliPay"]);
          }

          // 微信支付
          if (payType == 2){
            startTimeDecreaseTimer(value["data"]["paySurplusDate"]);
            isJump = true;
            searchOrderStatus();
            await payWithWeChat(
                appId: value['data']["wxPay"]['appId'],
                partnerId: value['data']["wxPay"]['partnerId'],
                prepayId: value['data']["wxPay"]['prepayId'],
                packageValue: value['data']["wxPay"]['packageValue'],
                nonceStr: value['data']["wxPay"]['nonceStr'],
                timeStamp: ObjectUtil.isNotEmpty(value['data']["wxPay"]['timeStamp'])
                    ? int.parse(value['data']["wxPay"]['timeStamp'])
                    : 000000000,
                sign: value['data']["wxPay"]['sign']);
          }

        }else if (value["code"]==21001){
          ToastUtil.showToast(value['data']??value['message']??value["msg"]??"该笔订单已支付，请勿重复支付");
        }else if (value["code"]==21002){
          ToastUtil.showToast(value['data']??value['message']??value["msg"]??"支付方式有误，请重新选择");
        }else if (value["code"]==21003){
          ToastUtil.showToast(value['data']??value['message']??value["msg"]??"支付正在进行中，请勿重复下单");
        }else {
          ToastUtil.showToast(value['data']??value['message']??value["msg"]);
        }
      }

    });
  }

  // 启动倒计时定时器
  void startTimeDecreaseTimer(int remoteTime){
    setState(() {
      localTime = null;
    });
    if (null == remoteTime || 0 >= remoteTime){
      timerPay?.cancel();
      payType = 0;
      timerDecrease?.cancel();
    }else {
      setState(() {
        localTime = remoteTime;
      });
      timerDecrease?.cancel();
      timerDecrease = Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          localTime --;
          print("localTime---------$localTime");
          if (0 >= localTime ){
            timerPay?.cancel();
            payType = 0;
            timer?.cancel();
            localTime = null;
            ToastUtil.showErrorToast("支付超时");
          }
        });
      });
    }
  }

  void searchOrderStatus(){
    try {
      timerPay?.cancel();
      numPay = 1;
      timerPay = Timer.periodic(Duration(seconds: 3), (t) {
        numPay++;
        print("numPay--------------$numPay");
        HomeApi.getSingleton().getPayStatus({"unitGuid":widget.orderNumber},errorCallBack: (e){
          EasyLoading.dismiss();
          ToastUtil.showErrorToast("服务异常，请稍后再试！");
        }).then((value){
          EasyLoading.dismiss();
          if (value!=null){
            if ( value["code"]==200){
              if(ObjectUtil.isNotEmpty(value['data'])){
               if (value['data']["payStatus"] == 2){
                 isJump = false;
                 ToastUtil.showSuccessToast("支付成功");
                 t?.cancel();
                 timerDecrease.cancel();
                 payType = 0;
                 Navigator.popUntil(context,ModalRoute.withName(RoutePaths.caseHandleShowPDF));
               }
              }
            }else {
              t?.cancel();
              ToastUtil.showErrorToast(value["msg"]??value["message"]??value["data"]);
            }
          }else {
            t?.cancel();
            ToastUtil.showErrorToast("服务异常，请稍后再试！");
          }
        });
        if (localTime == null){
          timerPay.cancel();
          ToastUtil.showErrorToast("支付失败");
        }
      });

      // if (numPay > 17) {
      //   timerPay.cancel();
      //   ToastUtil.showErrorToast("支付失败");
      // }
    }catch (e){
      ToastUtil.showErrorToast("出错了，请稍后再试！");
    }

  }

  // void _alipayOrderState() {
  //   print("++++++++++++++++++++++++++计数器++$numPay");
  //   Map<String, Object> map1 = {"unitGuid": widget.orderNumber};
  //   print("paySuccessCallBack--------$map1");
  //   EasyLoading.dismiss();
  //   HomeApi.getSingleton().getAliPayStateWithHeadersToken(map1).then((value) {
  //     print("支付包查询订单状态成功后返回的数据------$value");
  //     if (value['code'] == 200 && value['data']['code'] == "10000") {
  //       isAliPayJump = false;
  //       EasyLoading.dismiss();
  //       ToastUtil.showSuccessToast("付款成功");
  //       timerPay?.cancel();
  //       Navigator.pop(context, true);
  //       // // t.cancel();
  //       // refresh();
  //       // notifyListeners();
  //       // // Future.delayed(Duration.zero).then((value) => G.pushNamed(RoutePaths.HomeIndex));
  //     } else {
  //       isAliPayJump = false;
  //       ToastUtil.showErrorToast("付款失败");
  //     }
  //   });
  // }
  //
  //   void queryWXStatus(){
  //     print("++++++++++++++++++++++++++计数器++$numPay");
  //     Map<String, Object> map1 = {"unitGuid": widget.orderNumber};
  //     HomeApi.getSingleton()
  //         .getPayWithHeadersToken(map1,errorCallBack: (e){
  //     })
  //         .then((value) {
  //           isWechatJump = false;
  //       if (value['code'] == 200 &&
  //           value['data']['tradeState'] == "SUCCESS") {
  //         timerPay.cancel();
  //         ToastUtil.showSuccessToast("付款成功");
  //         EasyLoading.dismiss();
  //         Navigator.popUntil(context,ModalRoute.withName(RoutePaths.caseHandleShowPDF));
  //       }else {
  //         ToastUtil.showNormalToast(value['message']??value["msg"]??value["dta"]);
  //       }
  //     });
  //     if (numPay > 17) {
  //       timerPay.cancel();
  //     }
  //   }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, false);
        return Future.value(true);
      },
      child: Scaffold(
        appBar: commonAppBar(title: "收银台"),
        body: Container(
          padding: EdgeInsets.only(
              bottom: getHeightPx(40),top: getHeightPx(120)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: getWidthPx(30)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "待支付",
                      style: TextStyle(
                          color: AppTheme.textBlack, fontSize: getSp(30)),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: getHeightPx(30)),
                      child: RichText(
                        text: TextSpan(
                            text: " ¥  ",
                            style: TextStyle(
                                color: AppTheme.textBlack,
                                fontSize: getSp(30),
                                fontWeight: FontWeight.bold),
                            children: [
                              TextSpan(
                                  text: widget.money == null
                                      ? "0"
                                      : widget.money.toString(),
                                  style: TextStyle(
                                      color: AppTheme.textBlack,
                                      fontSize: getSp(48),
                                      fontWeight: FontWeight.bold))
                            ]),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: getWidthPx(30)),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppTheme.white),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: getWidthPx(40),
                        right: getWidthPx(40),),
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "普通支付",
                            style: TextStyle(
                                color: AppTheme.textBlack,
                                fontSize: getSp(36),
                                fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                          Offstage(
                            offstage: localTime == null,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 10,vertical: 8),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.red
                              ),
                              child: Text(
                                "支付倒计时： $localTime S",
                                style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.white
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(height: 1,color: AppTheme.bg_b,),
                    Container(
                      height: 50,
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(left: getWidthPx(40),
                        right: getWidthPx(40),),
                      decoration: BoxDecoration(
                        color: payType == 1 ? AppTheme.bg_b :  AppTheme.white,
                          border: Border(
                              bottom: BorderSide(
                                  width: 1, color: AppTheme.bg_e))),
                      child: InkWell(
                        onTap: payType != 1 ? () {
                          setState(() {
                            selectIndex = 1;
                          });
                        } : null,
                        child: SizedBox(
                          height: 50,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              weChatIco(
                                color: Colors.green,
                                size: 30,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text("微信支付",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: AppTheme.dark_grey)),
                              const Spacer(),
                              Image.asset(
                                selectIndex == 1
                                    ? "lib/assets/images/done_blue.png"
                                    : "lib/assets/images/stepper_noDone.png",
                                width: getWidthPx(40),
                                height: getWidthPx(40),
                                fit: BoxFit.fill,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: payType != 2 ? () {
                        setState(() {
                          selectIndex = 2;
                        });
                      } : null,
                      child: Container(
                        height: 50,
                        padding: EdgeInsets.only(left: getWidthPx(40),
                          right: getWidthPx(40),),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: payType == 2 ? AppTheme.bg_b : AppTheme.white,
                            border: Border(
                                bottom: BorderSide(
                                    width: 1, color: AppTheme.bg_e))),
                        child: Row(
                          children: <Widget>[
                            aliPayIco(
                              color: Color(0xff3CA4FB),
                              size: 30,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text('支付宝支付',
                                style: TextStyle(
                                    fontSize: 16, color: AppTheme.dark_grey)),
                            const Spacer(),
                            Image.asset(
                              selectIndex == 2
                                  ? "lib/assets/images/done_blue.png"
                                  : "lib/assets/images/stepper_noDone.png",
                              width: getWidthPx(40),
                              height: getWidthPx(40),
                              fit: BoxFit.fill,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Center(child: Text("技术支持：南京国础科学技术研究院有限公司")),
              SizedBox(
                height: getWidthPx(30),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: getWidthPx(40),
                  ),
                  InkWell(
                    onTap: ThrottleUtil().throttle(() {
                      goPay();
                    }),
                    child: Container(
                      width: (MediaQuery.of(context).size.width -
                              getWidthPx(200)) /
                          2,
                      padding: EdgeInsets.symmetric(
                          horizontal: getWidthPx(60), vertical: getWidthPx(20)),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: AppTheme.themeBlue,
                          borderRadius: BorderRadius.circular(10)),
                      child: Text(
                        "确认",
                        style: TextStyle(
                            color: AppTheme.white, fontSize: getSp(32)),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: getWidthPx(40),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context, false);
                    },
                    child: Container(
                      width: (MediaQuery.of(context).size.width -
                              getWidthPx(200)) /
                          2,
                      padding: EdgeInsets.symmetric(
                          horizontal: getWidthPx(60), vertical: getWidthPx(20)),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppTheme.white,
                        border: Border.all(color: AppTheme.bg_e, width: 1.0),
                      ),
                      child: Text(
                        "取消",
                        style: TextStyle(
                            color: AppTheme.textBlack, fontSize: getSp(32)),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: getWidthPx(40),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
