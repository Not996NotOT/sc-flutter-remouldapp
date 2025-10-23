import 'package:flutter/material.dart';
import 'package:notarization_station_app/base_framework/widget/provider_widget.dart';
import 'package:notarization_station_app/base_framework/widget/stepper_widget.dart';
import 'package:notarization_station_app/base_framework/widget_state/base_state.dart';
import 'package:notarization_station_app/page/home/entity/notarialData.dart';
import 'package:notarization_station_app/page/home/vm/submitOrderList_vm.dart';
import 'package:notarization_station_app/page/login/vm/user_view_model.dart';
import 'package:notarization_station_app/routes/router.dart';
import 'package:notarization_station_app/utils/global.dart';
import 'package:provider/provider.dart';

import '../../appTheme.dart';
import '../../utils/common_tools.dart';

class SubmitOrderListPage extends StatefulWidget {
  final arguments;
  const SubmitOrderListPage({Key key, this.arguments}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SubmitOrderListState();
  }
}

class SubmitOrderListState extends BaseState<SubmitOrderListPage>
    with AutomaticKeepAliveClientMixin {
  SubmitOrderListModel submitViewModel;
  int totalMoney = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    submitViewModel.isAliPayJump = false;
    submitViewModel.removeWidgetsBindingObserver();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // wjPrint('orderLogsList[submitViewModel.orderLogsList.length -1].notaryState ---- ${submitViewModel.orderLogsList[submitViewModel.orderLogsList.length -1].notaryState}');
    return Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: AppTheme.App_bar,
              ),
            ),
          ),
          centerTitle: true,
          title: const Text(
            "提交订单",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          leading: IconButton(
              icon: const Icon(
                Icons.navigate_before,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () {
                G.pushNamed(RoutePaths.HomeIndex);
              }),
        ),
        body: WillPopScope(
          onWillPop: () {
            G.pushNamed(RoutePaths.HomeIndex);
            return Future.value(true);
          },
          child: Consumer<UserViewModel>(
            builder: (ctx, userModel, child) {
              return ProviderWidget<SubmitOrderListModel>(
                model: SubmitOrderListModel(userModel, widget.arguments),
                onModelReady: (model) {
                  submitViewModel = model;
                  model.getData();
                  model.loadData();
                },
                builder: (ctx, homeModel, child) {
                  return !submitViewModel.isInit
                      ? loadingWidget()
                      : SingleChildScrollView(
                          child: Column(
                            children: <Widget>[
                              Container(
                                width: getWidthPx(700),
                                margin: EdgeInsets.only(top: getHeightPx(40)),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.circular(getWidthPx(10)),
                                    boxShadow: <BoxShadow>[
                                      //设置阴影
                                      new BoxShadow(
                                        color: Colors.grey, //阴影颜色
                                        blurRadius: getWidthPx(5), //阴影大小
                                      ),
                                    ]),
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: getWidthPx(30),
                                          top: getHeightPx(20)),
                                      child: Row(
                                        children: <Widget>[
                                          const Icon(
                                            Icons.monetization_on,
                                            color: Colors.orange,
                                            size: 20,
                                          ),
                                          SizedBox(
                                            width: getWidthPx(10),
                                          ),
                                          const Text(
                                            "公证事项明细",
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700),
                                          )
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: getWidthPx(40),
                                          top: getHeightPx(20),
                                          right: getWidthPx(40)),
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: submitViewModel.lists.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          var item =
                                              submitViewModel.lists[index];
                                          return Column(
                                            children: <Widget>[
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                      bottom: getWidthPx(10),
                                                    ),
                                                    child: Text(
                                                      item["notaryItemName"] +
                                                          "×${item["notaryNum"]}",
                                                      style: const TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                      bottom: getWidthPx(10),
                                                    ),
                                                    child: Text(
                                                      "￥" +
                                                          item["price"]
                                                              .toString() +
                                                          "元",
                                                      style: const TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              // SizedBox(
                                              //   height: getHeightPx(10),
                                              // ),
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: getWidthPx(40),
                                          right: getWidthPx(40)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Container(
                                            margin: EdgeInsets.only(
                                              bottom: getWidthPx(10),
                                            ),
                                            child: Text(
                                              submitViewModel.lists != null &&
                                                  submitViewModel.lists.length >
                                                      0
                                                  ? "公证书×${submitViewModel.numberCount * submitViewModel.lists.length}":
                                              "公证书×${submitViewModel.numberCount
                                                  .toString()}",
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(
                                              bottom: getWidthPx(10),
                                            ),
                                            child: Text(
                  submitViewModel.lists != null &&
                  submitViewModel.lists.length >
                  0 ? "￥${20*submitViewModel.numberCount * submitViewModel.lists.length}.0元" :
                                              "￥${(20 *
                                                  submitViewModel
                                                      .numberCount)
                                                  .toString()}.0元",
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: getWidthPx(40),
                                          top: getHeightPx(20),
                                          bottom: getHeightPx(20),
                                          right: getWidthPx(40)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Container(
                                            margin: EdgeInsets.only(
                                              bottom: getWidthPx(10),
                                            ),
                                            child: const Text(
                                              "总费用",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(
                                              bottom: getWidthPx(10),
                                            ),
                                            child: Text(
                                              "￥" +
                                                 submitViewModel.oneData['order']['fee'].toString() == "null" ? "" :  submitViewModel.oneData['order']['fee'].toString() +
                                                  "元",
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  // G.pushNamed(RoutePaths.ListInformation,arguments: {"orderId":widget.arguments["orderId"],"totalMoney":submitViewModel.totalMoney});
                                  Navigator.of(context).pushNamed(
                                      RoutePaths.ZaiXianDetail,
                                      arguments: {
                                        "data": {
                                          "unitGuid":
                                              widget.arguments["orderId"]
                                        }
                                      }).then((value) {
                                    submitViewModel.getData();
                                    submitViewModel.getOneNotarizationData();
                                  });
                                },
                                child: Container(
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.only(
                                        top: getWidthPx(50),
                                        left: getWidthPx(40),
                                        right: getWidthPx(40)),
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(getWidthPx(10))),
                                        color: Colors.white,
                                        border: Border.all(
                                            color: AppTheme.themeBlue)),
                                    child: const Text('查看订单',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: AppTheme.themeBlue))),
                              ),
                              NotaryData.notaryId ==
                                      "666c2421-b2e1-4076-80aa-8e63cf287de4"
                                  ? submitViewModel.orderLogsList.isNotEmpty
                                      ? Offstage(
                                          offstage: submitViewModel
                                                  .orderLogsList[0]
                                                  .notaryState >=
                                              30,
                                          child: InkWell(
                                            onTap: () {
                                              wjPrint("点击了立即付款");
                                              submitViewModel.goPay();
                                            },
                                            child: Container(
                                                alignment: Alignment.center,
                                                margin: EdgeInsets.only(
                                                    top: getWidthPx(50),
                                                    left: getWidthPx(40),
                                                    right: getWidthPx(40)),
                                                padding: EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5)),
                                                  color: AppTheme.themeBlue,
                                                ),
                                                child: const Text('线上支付',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: AppTheme
                                                            .nearlyWhite))),
                                          ),
                                        )
                                      : SizedBox()
                                  : SizedBox(),
                          submitViewModel.orderLogsList.isNotEmpty
                                      ? Offstage(
                                          offstage: !(submitViewModel
                                              .orderLogsList[0]
                                              .notaryState ==15),
                                          child: InkWell(
                                            onTap: () {
                                              userModel.currentIndex = 1;
                                              submitViewModel.doSetState();
                                              Navigator.of(context)
                                                  .pushNamedAndRemoveUntil(
                                                      RoutePaths.HomeIndex,
                                                      (Route route) => false);
                                            },
                                            child: Container(
                                                alignment: Alignment.center,
                                                margin: EdgeInsets.only(
                                                    top: getWidthPx(50),
                                                    left: getWidthPx(40),
                                                    right: getWidthPx(40)),
                                                padding: EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5)),
                                                  color: AppTheme.themeBlue,
                                                ),
                                                child: const Text('线下支付',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: AppTheme
                                                            .nearlyWhite))),
                                          ),
                                        )
                                      : SizedBox(),
                              Container(
                                width: getWidthPx(700),
                                margin: EdgeInsets.only(
                                    top: getHeightPx(30),
                                    bottom: getHeightPx(60)),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.circular(getWidthPx(10)),
                                  boxShadow: <BoxShadow>[
                                    //设置阴影
                                    new BoxShadow(
                                      color: Colors.grey, //阴影颜色
                                      blurRadius: getWidthPx(5), //阴影大小
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: getWidthPx(20),
                                          bottom: getWidthPx(30),
                                          top: getWidthPx(30)),
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            'lib/assets/images/result_list.png',
                                            width: getWidthPx(34),
                                            height: getWidthPx(34),
                                          ),
                                          SizedBox(
                                            width: getWidthPx(20),
                                          ),
                                          const Text(
                                            '后续流程',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14),
                                          )
                                        ],
                                      ),
                                    ),
                                    StepsVehticalWidget(
                                      data: [
                                        '提交订单',
                                        '支付完成，公证员审查信息后联系',
                                        '审查通过，分配公证员办理',
                                        '根据公证员提示存放原件至指定位置',
                                        '制证中',
                                        '制证完成，待领证'
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                },
              );
            },
          ),
        ));
  }

  @override
  bool get wantKeepAlive => true;
}
