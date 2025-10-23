import 'package:flutter/material.dart';
import 'package:notarization_station_app/base_framework/utils/refresh_helper.dart';
import 'package:notarization_station_app/base_framework/widget/provider_widget.dart';
import 'package:notarization_station_app/base_framework/widget_state/base_state.dart';
import 'package:notarization_station_app/page/helper/vm/helper_vm.dart';
import 'package:notarization_station_app/page/login/vm/user_view_model.dart';
import 'package:notarization_station_app/routes/router.dart';
import 'package:notarization_station_app/utils/global.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../appTheme.dart';

class HelperPage extends StatefulWidget {
  @override
  _HelperPageState createState() => _HelperPageState();
}

class _HelperPageState extends BaseState<HelperPage>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin{
  HelpViewModel viewModel;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    viewModel.removeWidgetsBindingObserver();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          leading: Container(),
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            "订单查询",
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
        body: Consumer<UserViewModel>(builder: (ctx, userModel, child) {
          return ProviderWidget<HelpViewModel>(
              model: HelpViewModel(userModel),
              onModelReady: (model) {
                viewModel = model;
                model.getShiPingList();
              },
              builder: (ctx, helpModel, child) {
                return Offstage(
                  offstage: userModel.hasUser == true ? false : true,
                  child: Row(
                    children: [
                      _orderTypeWidget,
                      Expanded(
                        child: ColoredBox(
                            color: Color.fromRGBO(247, 247, 247, 1),
                            child: viewModel.shipingLists.length > 0
                                ? SmartRefresher(
                                    enablePullDown: true,
                                    enablePullUp: true,
                                    header: HomeRefreshHeader(Colors.black),
                                    footer: RefresherFooter(),
                                    controller: helpModel.refreshController,
                                    onRefresh: helpModel.refresh,
                                    onLoading: helpModel.loadMore,
                                    child: ListView.builder(
                                      itemCount: viewModel.shipingLists.length,
                                      itemBuilder: (context, index) {
                                        final item =
                                            viewModel.shipingLists[index];
                                        return Container(
                                          color: Colors.white,
                                          margin: EdgeInsets.fromLTRB(
                                              0, getWidthPx(16), 0, 0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Container(
                                                  padding: EdgeInsets.all(
                                                      getWidthPx(24)),
                                                  alignment: Alignment.center,
                                                  child: Row(
                                                    children: <Widget>[
                                                      Image.asset(
                                                        item["notaryForm"] == 1
                                                            ? "lib/assets/images/zzbz.png"
                                                            : item["notaryForm"] ==
                                                                    2
                                                                ? "lib/assets/images/shiping.png"
                                                                : item["notaryForm"] ==
                                                                        3
                                                                    ? "lib/assets/images/dfgz.png"
                                                                    : "lib/assets/images/dggz.png",
                                                        width: getWidthPx(40),
                                                      ),
                                                      SizedBox(
                                                        width: getWidthPx(12),
                                                      ),
                                                      Text(
                                                        item["notaryForm"] == 1
                                                            ? "自助办证"
                                                            : item["notaryForm"] ==
                                                                    2
                                                                ? "视频办证"
                                                                : item["notaryForm"] ==
                                                                        3
                                                                    ? "多方公证"
                                                                    : "对公公证",
                                                        style: TextStyle(
                                                            color: AppTheme
                                                                .textBlack,
                                                            fontSize:
                                                                getWidthPx(30)),
                                                      ),
                                                      Expanded(
                                                        child: Container(
                                                          alignment: Alignment
                                                              .centerRight,
                                                          child: Text(
                                                            viewModel.orderNum ==
                                                                    4
                                                                ? "${item["notaryState"] == 10 ? "待受理" : item["notaryState"] == 20 ? "受理中" : item["notaryState"] == 31 ? "终止（未完成申办）" : "完成"}"
                                                                : "${item["notaryState"] ?? ""}",
                                                            style: TextStyle(
                                                                fontSize:
                                                                    getWidthPx(
                                                                        24),
                                                                color: AppTheme
                                                                    .textBlue),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  )),
                                              Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    getWidthPx(24),
                                                    0,
                                                    getWidthPx(24),
                                                    0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    Text(
                                                      "申请号",
                                                      style: TextStyle(
                                                          color: AppTheme
                                                              .textBlack_1,
                                                          fontSize:
                                                              getWidthPx(24)),
                                                    ),
                                                    Text(
                                                        "${item["orderNo"] ?? ""}",
                                                        style: TextStyle(
                                                            color: AppTheme
                                                                .textBlack_1,
                                                            fontSize:
                                                                getWidthPx(24)))
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                padding: EdgeInsets.fromLTRB(
                                                    getWidthPx(24),
                                                    getWidthPx(22),
                                                    getWidthPx(24),
                                                    0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    Text(
                                                      "公证事项  ",
                                                      style: TextStyle(
                                                          color: AppTheme
                                                              .textBlack_1,
                                                          fontSize:
                                                              getWidthPx(24)),
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                          viewModel.orderNum ==
                                                                  5
                                                              ? "多方合同公证"
                                                              : viewModel.orderNum ==
                                                                      4
                                                                  ? "对公公证"
                                                                  : "${item["notaryItemName"] ?? ""}",
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          textAlign:
                                                              TextAlign.right,
                                                          style: TextStyle(
                                                              color: AppTheme
                                                                  .textBlack_1,
                                                              fontSize:
                                                                  getWidthPx(
                                                                      24))),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    getWidthPx(24),
                                                    getWidthPx(22),
                                                    getWidthPx(24),
                                                    0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    Text(
                                                      "申请时间",
                                                      style: TextStyle(
                                                          color: AppTheme
                                                              .textBlack_1,
                                                          fontSize:
                                                              getWidthPx(24)),
                                                    ),
                                                    Text(
                                                      "${item["createDate"] ?? ""}",
                                                      style: TextStyle(
                                                          color: AppTheme
                                                              .textBlack_1,
                                                          fontSize:
                                                              getWidthPx(24)),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: <Widget>[
                                                  // item["notaryState"] == "待支付"
                                                  //     ? InkWell(
                                                  //         onTap: () {
                                                  //           viewModel
                                                  //                   .orderNumber =
                                                  //               item["orderNo"];
                                                  //           viewModel
                                                  //                   .totalMoney =
                                                  //               item["fee"];
                                                  //           viewModel
                                                  //               .goPay(false);
                                                  //         },
                                                  //         child: Container(
                                                  //           margin: EdgeInsets.only(
                                                  //               right:
                                                  //                   getWidthPx(
                                                  //                       20)),
                                                  //           height:
                                                  //               getWidthPx(50),
                                                  //           width:
                                                  //               getWidthPx(135),
                                                  //           alignment: Alignment
                                                  //               .center,
                                                  //           decoration:
                                                  //               BoxDecoration(
                                                  //             border: Border.all(
                                                  //                 width: 1,
                                                  //                 color: AppTheme
                                                  //                     .textGreen),
                                                  //             borderRadius:
                                                  //                 BorderRadius
                                                  //                     .circular(
                                                  //                         getWidthPx(
                                                  //                             25)),
                                                  //           ),
                                                  //           child: Text(
                                                  //             "支付",
                                                  //             style: TextStyle(
                                                  //                 color: AppTheme
                                                  //                     .textGreen,
                                                  //                 fontSize:
                                                  //                     getWidthPx(
                                                  //                         24)),
                                                  //           ),
                                                  //         ),
                                                  //       )
                                                  //     : item["notaryState"] ==
                                                  //             "待补缴费用"
                                                  //         ? InkWell(
                                                  //             onTap: () {
                                                  //               viewModel
                                                  //                       .orderNumber =
                                                  //                   item[
                                                  //                       "orderNo"];
                                                  //               viewModel
                                                  //                       .totalMoney =
                                                  //                   item["fee"];
                                                  //               viewModel.goPay(
                                                  //                   true);
                                                  //             },
                                                  //             child: Container(
                                                  //               height:
                                                  //                   getWidthPx(
                                                  //                       50),
                                                  //               width:
                                                  //                   getWidthPx(
                                                  //                       135),
                                                  //               alignment:
                                                  //                   Alignment
                                                  //                       .center,
                                                  //               decoration:
                                                  //                   BoxDecoration(
                                                  //                 border: Border.all(
                                                  //                     width: 1,
                                                  //                     color: AppTheme
                                                  //                         .textGreen),
                                                  //                 borderRadius:
                                                  //                     BorderRadius
                                                  //                         .circular(
                                                  //                             getWidthPx(25)),
                                                  //               ),
                                                  //               child: Text(
                                                  //                 "补缴",
                                                  //                 style: TextStyle(
                                                  //                     color: AppTheme
                                                  //                         .textGreen,
                                                  //                     fontSize:
                                                  //                         getWidthPx(
                                                  //                             24)),
                                                  //               ),
                                                  //             ),
                                                  //           )
                                                  //         : SizedBox(),
                                                  InkWell(
                                                    onTap: () {
                                                      if (viewModel.orderNum ==
                                                          1) {
                                                        G.pushNamed(
                                                            RoutePaths
                                                                .ZaiXianDetail,
                                                            arguments: {
                                                              "data": item
                                                            });
                                                      } else if (viewModel
                                                              .orderNum ==
                                                          2) {
                                                        G.pushNamed(
                                                            RoutePaths
                                                                .ShiPinDetail,
                                                            arguments: {
                                                              "data": item
                                                            });
                                                      } else if (viewModel
                                                              .orderNum ==
                                                          3) {
                                                        G.pushNamed(
                                                            RoutePaths
                                                                .HeTongDetail,
                                                            arguments: {
                                                              "data": item
                                                            });
                                                      } else if (viewModel
                                                              .orderNum ==
                                                          4) {
                                                        G.pushNamed(
                                                            RoutePaths
                                                                .duiGongDetail,
                                                            arguments: {
                                                              "data": item
                                                            });
                                                      }
                                                    },
                                                    child: Container(
                                                      margin:
                                                          EdgeInsets.fromLTRB(
                                                              getWidthPx(20),
                                                              getWidthPx(20),
                                                              getWidthPx(20),
                                                              getWidthPx(20)),
                                                      height: getWidthPx(50),
                                                      width: getWidthPx(135),
                                                      alignment:
                                                          Alignment.center,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            width: 1,
                                                            color: AppTheme
                                                                .textBlue),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    getWidthPx(
                                                                        25)),
                                                      ),
                                                      child: Text(
                                                        "详情",
                                                        style: TextStyle(
                                                            color: AppTheme
                                                                .textBlue,
                                                            fontSize:
                                                                getWidthPx(24)),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        );
                                      },
                                    ))
                                : Center(
                                    child: Text("抱歉，暂无记录"),
                                  )),
                      ),
                    ],
                  ),
                );
              });
        }));
  }

  /// 右边订单类型
  Widget get _orderTypeWidget => Container(
        color: Colors.white,
        margin: EdgeInsets.fromLTRB(0, getWidthPx(16), getWidthPx(16), 0),
        height: getHeightPx(1334),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                viewModel.orderNum = 2;
                viewModel.getShiPingList();
                viewModel.notifyListeners();
              },
              child: Container(
                  color: viewModel.orderNum == 2
                      ? AppTheme.textBlue
                      : AppTheme.white,
                  alignment: Alignment.center,
                  width: getWidthPx(200),
                  padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                  child: Text(
                    "视频办证",
                    style: TextStyle(
                        color: viewModel.orderNum == 2
                            ? Colors.white
                            : AppTheme.textBlack_1,
                        fontSize: 16),
                  )),
            ),
            InkWell(
              onTap: () {
                viewModel.orderNum = 1;
                viewModel.getShiPingList();
                viewModel.notifyListeners();
              },
              child: Container(
                  color: viewModel.orderNum == 1
                      ? AppTheme.textBlue
                      : AppTheme.white,
                  alignment: Alignment.center,
                  width: getWidthPx(200),
                  padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                  child: Text(
                    "自助办证",
                    style: TextStyle(
                        color: viewModel.orderNum == 1
                            ? Colors.white
                            : AppTheme.textBlack_1,
                        fontSize: 16),
                  )),
            ),
            InkWell(
              onTap: () {
                viewModel.orderNum = 3;
                viewModel.getShiPingList();
                viewModel.notifyListeners();
              },
              child: Container(
                  color: viewModel.orderNum == 3
                      ? AppTheme.textBlue
                      : AppTheme.white,
                  alignment: Alignment.center,
                  width: getWidthPx(200),
                  padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                  child: Text(
                    "多方公证",
                    style: TextStyle(
                        color: viewModel.orderNum == 3
                            ? Colors.white
                            : AppTheme.textBlack_1,
                        fontSize: 16),
                  )),
            ),
            InkWell(
              onTap: () {
                viewModel.orderNum = 4;
                viewModel.getShiPingList();
                viewModel.notifyListeners();
              },
              child: Container(
                  color: viewModel.orderNum == 4
                      ? AppTheme.textBlue
                      : AppTheme.white,
                  alignment: Alignment.center,
                  width: getWidthPx(200),
                  padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                  child: Text(
                    "对公公证",
                    style: TextStyle(
                        color: viewModel.orderNum == 4
                            ? Colors.white
                            : AppTheme.textBlack_1,
                        fontSize: 16),
                  )),
            ),
            // InkWell(
            //   onTap: () {
            //     viewModel.orderNum = 5;
            //     viewModel.getShiPingList();
            //     viewModel.notifyListeners();
            //   },
            //   child: Container(
            //       color: viewModel.orderNum == 5
            //           ? AppTheme.textBlue
            //           : AppTheme.white,
            //       alignment: Alignment.center,
            //       width: getWidthPx(200),
            //       padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
            //       child: Text(
            //         "自助存证",
            //         style: TextStyle(
            //             color: viewModel.orderNum == 5
            //                 ? Colors.white
            //                 : AppTheme.textBlack_1,
            //             fontSize: 16),
            //       )),
            // ),
          ],
        ),
      );

  @override
  bool get wantKeepAlive => false;
}
