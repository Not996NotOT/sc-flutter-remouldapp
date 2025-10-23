import 'package:flutter/material.dart';
import 'package:notarization_station_app/appTheme.dart';
import 'package:notarization_station_app/base_framework/widget/photo_view/fade_route.dart';
import 'package:notarization_station_app/base_framework/widget/provider_widget.dart';
import 'package:notarization_station_app/base_framework/widget_state/base_state.dart';
import 'package:notarization_station_app/components/photo_view_gallery.dart';
import 'package:notarization_station_app/components/star/span_rating_widget.dart';
import 'package:notarization_station_app/config.dart';
import 'package:notarization_station_app/page/helper/vm/helper_vm.dart';
import 'package:notarization_station_app/page/home/entity/notarialData.dart';
import 'package:notarization_station_app/page/login/vm/user_view_model.dart';
import 'package:notarization_station_app/routes/router.dart';
import 'package:notarization_station_app/service_api/helper_api.dart';
import 'package:notarization_station_app/utils/global.dart';
import 'package:provider/provider.dart';

import '../../../service_api/home_api.dart';
import '../../../utils/common_tools.dart';

class ZaiXianDetailPage extends StatefulWidget {
  final arguments;

  const ZaiXianDetailPage({Key key, this.arguments}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ZaiXianDetailState();
  }
}

class ZaiXianDetailState extends BaseState<ZaiXianDetailPage>
    with AutomaticKeepAliveClientMixin {
  Map oneData;
  List lists = [];
  List materialLists = [];
  List orderLogs = [];
  List tempOrderLogs = [];
  int number; //领取份数
  List addPayImgLists = [];
  List applyList = [];
  List payInfor = [];
  double supplementFee = 0.0;
  bool isInit = false;
  bool isShowMore = false;

  bool isInput = true;
  int score = 0;
  String remarks = '';

  List orderSupplements = [];

  bool isOrderSupplement = false;

  @override
  void initState() {
    super.initState();
    getData();
    getById();
  }

  getData() async {
    isInit = false;
    setState(() {

    });
    var map = {
      "unitGuid": widget.arguments["data"]["unitGuid"],
    };
    HelperApi.getSingleton().getOneNotarizationData(map).then((value) {
      if (value["code"] == 200) {
        orderLogs.clear();
        tempOrderLogs.clear();
        materialLists.clear();
        applyList.clear();
        addPayImgLists.clear();
        isOrderSupplement = false;
        oneData = value["item"];
        if (oneData["orderSupplements"] == null) {
          addPayImgLists = [];
        } else {
          oneData["orderSupplements"].forEach((item) {
            if (item["imagePathBack"] != null &&
                item["imagePathBack"].isNotEmpty) {
              item["imagePathBack"].forEach((i) {
                addPayImgLists.add(i);
              });
            }
            if (item["wordPathBack"] != null &&
                item["wordPathBack"].isNotEmpty) {
              item["wordPathBack"].forEach((i) {
                addPayImgLists.add(i);
              });
            }
            if (item["pdfPathBack"] != null &&
                item["pdfPathBack"].isNotEmpty) {
              item["pdfPathBack"].forEach((i) {
                addPayImgLists.add(i);
              });
            }
          });
        }
        lists = oneData["notaryItems"];
        payInfor = oneData['order']['pay'];

        number = oneData["order"]["notaryNum"] == null
            ? 0
            : oneData["order"]["notaryNum"];
        oneData["orderLogs"].forEach((item) {
          orderLogs.add(item);
        });
        if (orderLogs.length < 3) {
          tempOrderLogs.addAll(orderLogs);
        } else {
          tempOrderLogs.addAll(orderLogs.sublist(0, 3));
        }
        wjPrint('notaryState -----${tempOrderLogs[0]['notaryState']}');
        if (oneData["materials"] != null) {
          oneData["materials"].forEach((item) {
            item["annexs"].forEach((i) {
              materialLists.add(i["filePath"]);
            });
          });
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
        orderSupplements = oneData["orderSupplements"];
        if(orderSupplements!=null && orderSupplements.isNotEmpty){
          for(int i = 0;i<orderSupplements.length;i++){
            if(orderSupplements[i]['status']==0){
              isOrderSupplement = true;
            }
          }
        }else{
          isOrderSupplement = false;
        }
        isInit = true;
        setState(() {});
      }
    });
  }

  doSetState() {
    isInit = false;
    setState(() {

    });
    var map = {
      "unitGuid": widget.arguments["data"]["unitGuid"],
      "notaryState": 30,
      "payType": "pt006"
    };
    HomeApi.getSingleton().setTakeType(map).then((value) => getData());
  }

  //公证评分详情
  getById() async {
    var map = {
      "orderId": widget.arguments["data"]["unitGuid"],
    };
    HelperApi.getSingleton().getById(map).then((value) {
      // wjPrint('=====================================value========================================= '+value.toString());
      // wjPrint('======value["code"]====== '+value["code"].toString());
      // wjPrint('======value["data"]["score"]====== '+value["data"]["score"].toString());
      // wjPrint('======value["data"]["remarks"]====== '+value["data"]["remarks"].toString());
      if (value["data"] != null) {
        // wjPrint('获取评价详情');
        isInput = false;
        score = value["data"]["score"] != null
            ? int.parse(value["data"]["score"])
            : 0;
        remarks = value["data"]["remarks"] ?? '';
        setState(() {});
      } else {
        // wjPrint('添加评价详情');
        isInput = true;
        setState(() {});
      }
    });
  }

  HelpViewModel quizVm;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GestureDetector(
      child: Scaffold(
        appBar: commonAppBar(title: "自助办证订单详情"),
        body: Consumer<UserViewModel>(
          builder: (ctx, userModel, child) {
            return ProviderWidget<HelpViewModel>(
                model: HelpViewModel(userModel),
                onModelReady: (model) {
                  quizVm = model;
                },
                builder: (ctx, vm, child) {
                  if (isInit) {
                    quizVm.orderNumber = oneData["order"]["orderNo"];
                  }
                  return isInit
                      ? SingleChildScrollView(
                          child: Column(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(top: getHeightPx(20)),
                                color: Colors.white,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: tempOrderLogs.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    var item =
                                        tempOrderLogs.reversed.toList()[index];
                                    return Row(
                                      children: <Widget>[
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: getWidthPx(30),
                                              top: getWidthPx(30)),
                                          width: getWidthPx(180),
                                          child: Column(
                                            children: [
                                              Text(
                                                item["createDate"] != null &&
                                                        item['createDate']
                                                            .toString()
                                                            .isNotEmpty &&
                                                        item['createDate']
                                                                .toString()
                                                                .length >
                                                            10
                                                    ? item['createDate']
                                                        .toString()
                                                        .substring(0, 10)
                                                    : '',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: index ==
                                                            tempOrderLogs
                                                                    .length -
                                                                1
                                                        ? Colors.black
                                                        : Colors.black45),
                                              ),
                                              Text(
                                                item["createDate"] != null &&
                                                        item['createDate']
                                                            .toString()
                                                            .isNotEmpty &&
                                                        item['createDate']
                                                                .toString()
                                                                .length >
                                                            11
                                                    ? item['createDate']
                                                        .toString()
                                                        .substring(
                                                            11,
                                                            item['createDate']
                                                                .toString()
                                                                .length)
                                                    : '',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: index ==
                                                            tempOrderLogs
                                                                    .length -
                                                                1
                                                        ? Colors.black
                                                        : Colors.black45),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          width: getWidthPx(25),
                                          alignment: Alignment.center,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Container(
                                                width: getWidthPx(2),
                                                height: getHeightPx(40),
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        width: 1,
                                                        color: Colors.black12)),
                                              ),
                                              index == tempOrderLogs.length - 1
                                                  ? Image.asset(
                                                      "lib/assets/images/stepper_now.png",
                                                      width: getWidthPx(25),
                                                    )
                                                  : Image.asset(
                                                      'lib/assets/images/stepper_noDone.png',
                                                      width: getWidthPx(25),
                                                    ),
                                              index == tempOrderLogs.length - 1
                                                  ? Container(
                                                      height: getWidthPx(40),
                                                    )
                                                  : Container(
                                                      width: getWidthPx(2),
                                                      height: getHeightPx(20),
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              width: 1,
                                                              color: Colors
                                                                  .black12)),
                                                    ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            children: <Widget>[
                                              Container(
                                                alignment: Alignment.centerLeft,
                                                margin: EdgeInsets.only(
                                                    left: getWidthPx(30),
                                                    top: getWidthPx(20)),
                                                child: Text(
                                                  item["reason"],
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: index ==
                                                              tempOrderLogs
                                                                      .length -
                                                                  1
                                                          ? Colors.black
                                                          : Colors.black45,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                              SizedBox(
                                height: getHeightPx(20),
                              ),
                              InkWell(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        '点击查看更多流程',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                      Icon(
                                        !isShowMore
                                            ? Icons.arrow_drop_down
                                            : Icons.arrow_drop_up,
                                        size: 20,
                                        color: Colors.grey,
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                    setState(() {
                                      tempOrderLogs.clear();
                                      if (!isShowMore) {
                                        tempOrderLogs.addAll(orderLogs);
                                      } else {
                                        if (orderLogs.length < 3) {
                                          tempOrderLogs.addAll(orderLogs);
                                        } else {
                                          tempOrderLogs
                                              .addAll(orderLogs.sublist(0, 3));
                                        }
                                      }
                                      isShowMore = !isShowMore;
                                    });
                                  }),
                              SizedBox(
                                height: getHeightPx(20),
                              ),
                              ColoredBox(
                                color: Colors.white,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(
                                        left: getWidthPx(40),
                                        top: getWidthPx(30),
                                      ),
                                      child: Text(
                                        "基本信息",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: getWidthPx(40),
                                          top: getWidthPx(15),
                                          right: getWidthPx(40)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          const Text(
                                            "申请号",
                                            style: TextStyle(
                                                color: Colors.black45),
                                          ),
                                          Text(
                                              "${oneData["order"]["orderNo"] ?? ""}",
                                              style: const TextStyle(
                                                  color: Colors.black))
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: getWidthPx(40),
                                          top: getWidthPx(15),
                                          right: getWidthPx(40)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          const Text(
                                            "服务机构",
                                            style: TextStyle(
                                                color: Colors.black45),
                                          ),
                                          Text(
                                              "${oneData["order"]["notaryName"] ?? ""}",
                                              style: const TextStyle(
                                                  color: Colors.black))
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: getWidthPx(40),
                                          top: getWidthPx(15),
                                          right: getWidthPx(40)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          const Text(
                                            "公证事项",
                                            style: TextStyle(
                                                color: Colors.black45),
                                          ),
                                          Expanded(
                                              child: Text(
                                            oneData["order"]["notaryItemNames"],
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                color: Colors.black),
                                            textAlign: TextAlign.right,
                                          ))
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: getWidthPx(40),
                                          top: getWidthPx(15),
                                          right: getWidthPx(40)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          const Text(
                                            "申请时间",
                                            style: TextStyle(
                                                color: Colors.black45),
                                          ),
                                          Text(oneData["order"]["createDate"],
                                              style: const TextStyle(
                                                  color: Colors.black))
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: getWidthPx(40),
                                          top: getWidthPx(15),
                                          bottom: getWidthPx(15),
                                          right: getWidthPx(40)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          const Text(
                                            "公证状态",
                                            style: TextStyle(
                                                color: Colors.black45),
                                          ),
                                          Text(
                                              oneData["order"]
                                                  ["notaryStateName"],
                                              style: const TextStyle(
                                                  color: Colors.black))
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: getHeightPx(20),
                              ),
                              applyList.length == 0
                                  ? ColoredBox(
                                      color: Colors.white,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: getWidthPx(40),
                                                top: getWidthPx(30)),
                                            child: const Text(
                                              "申请人信息",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: getWidthPx(40),
                                                top: getWidthPx(15),
                                                right: getWidthPx(40)),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                const Text(
                                                  "姓名",
                                                  style: TextStyle(
                                                      color: Colors.black45),
                                                ),
                                                Text(
                                                    oneData["order"]["name"] ??
                                                        '',
                                                    style: const TextStyle(
                                                        color: Colors.black))
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: getWidthPx(40),
                                                top: getWidthPx(15),
                                                right: getWidthPx(40)),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                const Text(
                                                  "证件类型",
                                                  style: TextStyle(
                                                      color: Colors.black45),
                                                ),
                                                const Text("身份证",
                                                    style: TextStyle(
                                                        color: Colors.black))
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: getWidthPx(40),
                                                top: getWidthPx(15),
                                                right: getWidthPx(40)),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                const Text(
                                                  "证件号码",
                                                  style: TextStyle(
                                                      color: Colors.black45),
                                                ),
                                                Text(
                                                    oneData["user"]["idCard"] ??
                                                        '',
                                                    style: const TextStyle(
                                                        color: Colors.black))
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: getWidthPx(40),
                                                top: getWidthPx(15),
                                                right: getWidthPx(40)),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                const Text(
                                                  "电话",
                                                  style: TextStyle(
                                                      color: Colors.black45),
                                                ),
                                                Text(
                                                    oneData["user"]["mobile"] ??
                                                        "",
                                                    style: const TextStyle(
                                                        color: Colors.black))
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: getWidthPx(40),
                                                top: getWidthPx(15),
                                                right: getWidthPx(40)),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                const Text(
                                                  "地址",
                                                  style: TextStyle(
                                                      color: Colors.black45),
                                                ),
                                                SizedBox(
                                                  width: getWidthPx(20),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    oneData["user"][
                                                            "registeAddress"] ?? oneData["user"][
                                                    "address"] ??
                                                        "",
                                                    style: const TextStyle(
                                                        color: Colors.black),
                                                    textAlign: TextAlign.right,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: getWidthPx(40),
                                                top: getWidthPx(15),
                                                bottom: getWidthPx(15),
                                                right: getWidthPx(40)),
                                            child: Row(
                                              children: <Widget>[
                                                const Text(
                                                  "邮寄地址",
                                                  style: TextStyle(
                                                      color: Colors.black45),
                                                ),
                                                SizedBox(
                                                  width: getWidthPx(20),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    "${oneData["order"]["takeAddress"] ?? "自取"}",
                                                    style: const TextStyle(
                                                        color: Colors.black),
                                                    textAlign: TextAlign.right,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Column(
                                      children: <Widget>[
                                        ColoredBox(
                                          color: Colors.white,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: getWidthPx(40),
                                                    right: getWidthPx(40),
                                                    top: getWidthPx(30)),
                                                child: const Text(
                                                  "代理人信息",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: getWidthPx(40),
                                                    top: getWidthPx(15),
                                                    right: getWidthPx(40)),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    const Text(
                                                      "姓名",
                                                      style: TextStyle(
                                                          color:
                                                              Colors.black45),
                                                    ),
                                                    Text(
                                                        oneData["order"]
                                                                ["name"] ??
                                                            '',
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.black))
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: getWidthPx(40),
                                                    top: getWidthPx(15),
                                                    right: getWidthPx(40)),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    const Text(
                                                      "证件类型",
                                                      style: TextStyle(
                                                          color:
                                                              Colors.black45),
                                                    ),
                                                    const Text("身份证",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black))
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: getWidthPx(40),
                                                    top: getWidthPx(15),
                                                    right: getWidthPx(40)),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    const Text(
                                                      "证件号码",
                                                      style: TextStyle(
                                                          color:
                                                              Colors.black45),
                                                    ),
                                                    Text(
                                                        oneData["user"]
                                                                ["idCard"] ??
                                                            '',
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.black))
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: getWidthPx(40),
                                                    top: getWidthPx(15),
                                                    right: getWidthPx(40)),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    const Text(
                                                      "电话",
                                                      style: TextStyle(
                                                          color:
                                                              Colors.black45),
                                                    ),
                                                    Text(
                                                        oneData["user"]
                                                                ["mobile"] ??
                                                            '',
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.black))
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: getWidthPx(40),
                                                    top: getWidthPx(15),
                                                    right: getWidthPx(40)),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    const Text(
                                                      "地址",
                                                      style: TextStyle(
                                                          color:
                                                              Colors.black45),
                                                    ),
                                                    SizedBox(
                                                      width: getWidthPx(20),
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        oneData["user"][
                                                                "registeAddress"] ??
                                                            '',
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.black),
                                                        textAlign:
                                                            TextAlign.right,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: getWidthPx(40),
                                                    top: getWidthPx(15),
                                                    bottom: getWidthPx(15),
                                                    right: getWidthPx(40)),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    const Text(
                                                      "邮寄地址",
                                                      style: TextStyle(
                                                          color:
                                                              Colors.black45),
                                                    ),
                                                    SizedBox(
                                                      width: getWidthPx(20),
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        "${oneData["order"]["takeAddress"] ?? "自取"}",
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.black),
                                                        textAlign:
                                                            TextAlign.right,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemCount: applyList.length,
                                          itemBuilder: (ctx, index) {
                                            return ColoredBox(
                                              color: Colors.white,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: getWidthPx(40),
                                                        right: getWidthPx(40),
                                                        top: getWidthPx(30)),
                                                    child: const Text(
                                                      "申请人信息",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w700),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: getWidthPx(40),
                                                        top: getWidthPx(15),
                                                        right: getWidthPx(40)),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: <Widget>[
                                                        const Text(
                                                          "姓名",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black45),
                                                        ),
                                                        Text(
                                                            applyList[index]
                                                                    ["name"] ??
                                                                '',
                                                            style:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .black))
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: getWidthPx(40),
                                                        top: getWidthPx(15),
                                                        right: getWidthPx(40)),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: <Widget>[
                                                        const Text(
                                                          "证件类型",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black45),
                                                        ),
                                                        const Text("身份证",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black))
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: getWidthPx(40),
                                                        top: getWidthPx(15),
                                                        right: getWidthPx(40)),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: <Widget>[
                                                        const Text(
                                                          "证件号码",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black45),
                                                        ),
                                                        Text(
                                                            applyList[index][
                                                                    "idCard"] ??
                                                                '',
                                                            style:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .black))
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: getWidthPx(40),
                                                        top: getWidthPx(15),
                                                        right: getWidthPx(40)),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: <Widget>[
                                                        const Text(
                                                          "电话",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black45),
                                                        ),
                                                        Text(
                                                            applyList[index][
                                                                    "mobile"] ??
                                                                '',
                                                            style:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .black))
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: getWidthPx(40),
                                                        top: getWidthPx(15),
                                                        right: getWidthPx(40)),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: <Widget>[
                                                        const Text(
                                                          "地址",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black45),
                                                        ),
                                                        SizedBox(
                                                          width: getWidthPx(20),
                                                        ),
                                                        Expanded(
                                                          child: Text(
                                                            applyList[index][
                                                                    "address"] ??
                                                                '',
                                                            style:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .black),
                                                            textAlign:
                                                                TextAlign.right,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: getWidthPx(40),
                                                        top: getWidthPx(15),
                                                        bottom: getWidthPx(15),
                                                        right: getWidthPx(40)),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: <Widget>[
                                                        const Text(
                                                          "邮寄地址",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black45),
                                                        ),
                                                        SizedBox(
                                                          width: getWidthPx(20),
                                                        ),
                                                        Expanded(
                                                          child: Text(
                                                            oneData["order"][
                                                                    "takeAddress"] ??
                                                                "自取",
                                                            style:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .black),
                                                            textAlign:
                                                                TextAlign.right,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        )
                                      ],
                                    ),
                              Container(
                                height: getHeightPx(20),
                                color: AppTheme.bg_d,
                              ),
                              SizedBox(
                                height: getHeightPx(20),
                              ),
                              ColoredBox(
                                color: Colors.white,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(
                                        left: getWidthPx(40),
                                        right: getWidthPx(40),
                                        top: getWidthPx(30),
                                      ),
                                      child: const Text(
                                        "公证费用",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                          left: getWidthPx(40),
                                          top: getWidthPx(15),
                                          bottom: getWidthPx(15),
                                          right: getWidthPx(40)),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text(
                                                "总费用",
                                                style: TextStyle(
                                                    color: Colors.black45),
                                              ),
                                              Text(
                                                  oneData["order"]["fee"] !=
                                                          null
                                                      ? "￥${oneData["order"]["fee"]}元"
                                                      : "￥0.0元",
                                                  style: TextStyle(
                                                      color: Colors.black))
                                            ],
                                          ),
                                          // Padding(
                                          //   padding: EdgeInsets.symmetric(
                                          //       vertical: 10),
                                          //   child: Row(
                                          //     mainAxisAlignment:
                                          //         MainAxisAlignment
                                          //             .spaceBetween,
                                          //     children: <Widget>[
                                          //       Text(
                                          //         "支付状态",
                                          //         style: TextStyle(
                                          //             color: Colors.black45),
                                          //       ),
                                          //       Text(
                                          //           payInfor == null ||
                                          //                   payInfor.isEmpty
                                          //               ? "线下支付"
                                          //               : "线上支付",
                                          //           style: TextStyle(
                                          //               color: Colors.black))
                                          //     ],
                                          //   ),
                                          // ),
                                          // Row(
                                          //   mainAxisAlignment:
                                          //       MainAxisAlignment.spaceBetween,
                                          //   children: <Widget>[
                                          //     Text(
                                          //       "订单金额",
                                          //       style: TextStyle(
                                          //           color: Colors.black45),
                                          //     ),
                                          //     Text(oneData["order"]["itemFee"] !=
                                          //                 null
                                          //             ? "￥${oneData["order"]["itemFee"]}元"
                                          //             : "￥0.0元",
                                          //         style: TextStyle(
                                          //             color: Colors.black))
                                          //   ],
                                          // ),
                                          // Offstage(
                                          //   offstage: !(payInfor != null &&
                                          //       payInfor.isNotEmpty),
                                          //   child: Container(
                                          //     color: Colors.white,
                                          //     margin: EdgeInsets.only(
                                          //         bottom: getWidthPx(20)),
                                          //     // padding: EdgeInsets.only(
                                          //     //     bottom: getHeightPx(20),
                                          //     //     left: getWidthPx(40),
                                          //     //     right: getWidthPx(40)),
                                          //     child: Column(
                                          //       crossAxisAlignment:
                                          //           CrossAxisAlignment.start,
                                          //       children: [
                                          //         Padding(
                                          //           padding:
                                          //               EdgeInsets.symmetric(
                                          //                   vertical:
                                          //                       getWidthPx(20)),
                                          //           child: Text(
                                          //             "支付信息",
                                          //             style: TextStyle(
                                          //                 fontWeight:
                                          //                     FontWeight.w700),
                                          //           ),
                                          //         ),
                                          //         ListView.builder(
                                          //             shrinkWrap: true,
                                          //             physics:
                                          //                 NeverScrollableScrollPhysics(),
                                          //             itemCount:
                                          //                 payInfor.length,
                                          //             itemBuilder:
                                          //                 (context, index) {
                                          //               return Column(
                                          //                 mainAxisSize:
                                          //                     MainAxisSize.min,
                                          //                 children: [
                                          //                   Row(
                                          //                     mainAxisAlignment:
                                          //                         MainAxisAlignment
                                          //                             .spaceBetween,
                                          //                     children: [
                                          //                       Text("支付时间",
                                          //                           style: TextStyle(
                                          //                               color: Colors
                                          //                                   .black45)),
                                          //                       Text(payInfor[index]
                                          //                               [
                                          //                               'payDate'] ??
                                          //                           ''),
                                          //                     ],
                                          //                   ),
                                          //                   SizedBox(
                                          //                     height:
                                          //                         getWidthPx(
                                          //                             20),
                                          //                   ),
                                          //                   Row(
                                          //                     mainAxisAlignment:
                                          //                         MainAxisAlignment
                                          //                             .spaceBetween,
                                          //                     children: [
                                          //                       Text("流水号",
                                          //                           style: TextStyle(
                                          //                               color: Colors
                                          //                                   .black45)),
                                          //                       SizedBox(width: getWidthPx(20),),
                                          //                       Expanded(
                                          //                         child: Text(payInfor[index]['payOrderNum'] ?? '',textAlign: TextAlign.end,),
                                          //                       ),
                                          //                     ],
                                          //                   ),
                                          //                   // 'payType' 支付类型 1、通常支付 2、数币支付'，
                                          //                   SizedBox(
                                          //                     height:
                                          //                         getWidthPx(
                                          //                             20),
                                          //                   ),
                                          //
                                          //                   Container(
                                          //                     width: double
                                          //                         .infinity,
                                          //                     child: Row(
                                          //                       mainAxisAlignment:
                                          //                           MainAxisAlignment
                                          //                               .spaceBetween,
                                          //                       children: [
                                          //                         Text("支付渠道",
                                          //                             style: TextStyle(
                                          //                                 color:
                                          //                                     Colors.black45)),
                                          //                         Text(payInfor[index]
                                          //                                     [
                                          //                                     'payTypeName']??''),
                                          //                       ],
                                          //                     ),
                                          //                   ),
                                          //                   SizedBox(
                                          //                     height:
                                          //                     getWidthPx(
                                          //                         20),
                                          //                   ),
                                          //                 ],
                                          //               );
                                          //             }),
                                          //       ],
                                          //     ),
                                          //   ),
                                          // ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: getHeightPx(20),
                              ),
                              ColoredBox(
                                color: Colors.white,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: getWidthPx(40),
                                          right: getWidthPx(40),
                                          top: getWidthPx(30)),
                                      child: const Text(
                                        "材料",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                    materialLists.length > 0
                                        ? Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: GridView.builder(
                                                shrinkWrap: true,
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                gridDelegate:
                                                    SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 3, //每行三列
                                                  childAspectRatio:
                                                      1.0, //显示区域宽高相等
                                                  mainAxisSpacing: 8,
                                                  crossAxisSpacing: 8,
                                                ),
                                                itemCount: materialLists.length,
                                                itemBuilder: (context, index) {
                                                  return InkWell(
                                                    onTap: () {
                                                      List imgArr = [];
                                                      materialLists
                                                          .forEach((element) {
                                                        imgArr.add(Config
                                                            .splicingImageUrl(
                                                                element));
                                                      });
                                                      Navigator.of(context)
                                                          .push(new FadeRoute(
                                                              page: PhotoViewGalleryScreen(
                                                                  images: imgArr,
                                                                  //传入图片list
                                                                  index: index,
                                                                  //传入当前点击的图片的index
                                                                  heroTag: "1")));
                                                    },
                                                    child: FadeInImage
                                                        .assetNetwork(
                                                      imageCacheWidth: 800,
                                                      imageCacheHeight: 800,
                                                      placeholder:
                                                          'lib/assets/images/empty.png',
                                                      image: Config
                                                          .splicingImageUrl(
                                                              materialLists[
                                                                  index]),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  );
                                                }),
                                          )
                                        : Padding(
                                            padding: EdgeInsets.only(
                                                left: getWidthPx(40),
                                                right: getWidthPx(40),
                                                top: getWidthPx(30)),
                                            child: const Center(
                                                child: Text("暂无数据")),
                                          ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: getWidthPx(40),
                                          top: getWidthPx(30)),
                                      child: const Text(
                                        "费用补缴",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                    addPayImgLists.length != 0
                                        ? Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: GridView.builder(
                                                shrinkWrap: true,
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                gridDelegate:
                                                    SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 3, //每行三列
                                                  childAspectRatio:
                                                      1.0, //显示区域宽高相等
                                                  mainAxisSpacing: 8,
                                                  crossAxisSpacing: 8,
                                                ),
                                                itemCount:
                                                    addPayImgLists.length,
                                                itemBuilder: (context, index) {
                                                  return InkWell(
                                                    onTap: () {
                                                      Navigator.of(context)
                                                          .push(new FadeRoute(
                                                              page: PhotoViewGalleryScreen(
                                                                  images: addPayImgLists,
                                                                  //传入图片list
                                                                  index: index,
                                                                  //传入当前点击的图片的index
                                                                  heroTag: "1")));
                                                    },
                                                    child: FadeInImage
                                                        .assetNetwork(
                                                      imageCacheWidth: 800,
                                                      imageCacheHeight: 800,
                                                      placeholder:
                                                          'lib/assets/images/empty.png',
                                                      image: Config
                                                          .splicingImageUrl(
                                                              addPayImgLists[
                                                                      index]
                                                                  .toString()),
                                                    ),
                                                  );
                                                }),
                                          )
                                        : Padding(
                                            padding: EdgeInsets.only(
                                                left: getWidthPx(40),
                                                top: getWidthPx(30),
                                                bottom: getWidthPx(30)),
                                            child: const Center(
                                                child: Text("暂无数据")),
                                          ),
                                  ],
                                ),
                              ),
                              Offstage(
                                offstage: !(oneData["order"]["notaryState"] ==
                                        10) &&
                                    !(oneData["order"]["notaryState"] == 11) &&
                                    !(oneData["order"]["notaryState"] == 12),
                                child: Container(
                                  height: getWidthPx(80),
                                  width: getWidthPx(400),
                                  margin: EdgeInsets.only(top: getWidthPx(20)),
                                  child: InkWell(
                                    onTap: () {
                                      NotaryData.notaryId =
                                          oneData['order']['notaryId'];
                                      if (oneData["order"]["notaryState"] ==
                                          10) {
                                        G.pushNamed(RoutePaths.ConfirmApplyInfo,
                                            arguments: {
                                              "orderId":
                                                  widget.arguments["data"]
                                                      ["unitGuid"],
                                            });
                                      } else if (oneData["order"]
                                              ["notaryState"] ==
                                          11) {
                                        G.pushNamed(RoutePaths.UploadMaterial,
                                            arguments: {
                                              "orderId":
                                                  widget.arguments["data"]
                                                      ["unitGuid"],
                                            });
                                      } else {
                                        G.pushNamed(RoutePaths.UploadMaterial,
                                            arguments: {
                                              "orderId":
                                                  widget.arguments["data"]
                                                      ["unitGuid"],
                                            });
                                      }
                                    },
                                    child: Container(
                                      width: getWidthPx(160),
                                      height: getWidthPx(40),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: AppTheme.themeBlue,
                                        borderRadius: BorderRadius.circular(
                                          getWidthPx(10),
                                        ),
                                      ),
                                      child: Text(
                                        '继续申办',
                                        style: TextStyle(
                                            fontSize: getSp(28),
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Offstage(
                                offstage:
                                    !(oneData['order']['reason'] != null &&
                                        oneData['order']['reason']
                                            .toString()
                                            .isNotEmpty),
                                child: Container(
                                  width: double.infinity,
                                  margin: EdgeInsets.symmetric(
                                      vertical: getHeightPx(20)),
                                  padding: EdgeInsets.only(
                                      left: getWidthPx(40),
                                      top: getHeightPx(20),
                                      bottom: getHeightPx(20)),
                                  color: Colors.white,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text('审核不通过原因',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700)),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(oneData['order']['reason'] ?? ''),
                                    ],
                                  ),
                                ),
                              ),
                              Offstage(
                                offstage:
                                    !(oneData["order"]["notaryState"] == 31),
                                child: Container(
                                  height: getWidthPx(80),
                                  width: getWidthPx(400),
                                  margin: EdgeInsets.only(top: getWidthPx(20)),
                                  child: InkWell(
                                    onTap: () {
                                      NotaryData.notaryId =
                                          oneData['order']['notaryId'];
                                      G.pushNamed(RoutePaths.UploadMaterial,
                                          arguments: {
                                            "orderId": widget.arguments["data"]
                                                ["unitGuid"],
                                          });
                                    },
                                    child: Container(
                                      width: getWidthPx(160),
                                      height: getWidthPx(40),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: AppTheme.themeBlue,
                                        borderRadius: BorderRadius.circular(
                                          getWidthPx(10),
                                        ),
                                      ),
                                      child: Text(
                                        '重新申办',
                                        style: TextStyle(
                                            fontSize: getSp(28),
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Offstage(
                                offstage: oneData['order']['notaryId'] ==
                                    '666c2421-b2e1-4076-80aa-8e63cf287de4',
                                child: Offstage(
                                  offstage:
                                      !(oneData["order"]["notaryState"] == 15),
                                  child: Container(
                                    height: getWidthPx(120),
                                    margin:
                                        EdgeInsets.only(top: getWidthPx(20)),
                                    child: InkWell(
                                      onTap: () {
                                        NotaryData.notaryId =
                                            oneData['order']['notaryId'];
                                        doSetState();
                                      },
                                      child: Container(
                                        width: getWidthPx(500),
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: getWidthPx(40),
                                            vertical: getWidthPx(10)),
                                        decoration: BoxDecoration(
                                          color: AppTheme.themeBlue,
                                          borderRadius: BorderRadius.circular(
                                            getWidthPx(10),
                                          ),
                                        ),
                                        child: Text(
                                          '请线下支付 \n 待公证员联系您指导支付',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: getSp(28),
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Offstage(
                                offstage: !(oneData['order']['notaryId'] ==
                                    '666c2421-b2e1-4076-80aa-8e63cf287de4'),
                                child: Offstage(
                                  offstage:
                                      !(oneData["order"]["notaryState"] == 15),
                                  child: Container(
                                    margin:
                                        EdgeInsets.only(top: getWidthPx(20)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            quizVm.goPay(false, callBack: () {
                                              getData();
                                            });
                                          },
                                          child: Container(
                                            width: getWidthPx(200),
                                            height: getWidthPx(80),
                                            alignment: Alignment.center,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: getWidthPx(40),
                                                vertical: getWidthPx(10)),
                                            decoration: BoxDecoration(
                                              color: AppTheme.themeBlue,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                getWidthPx(10),
                                              ),
                                            ),
                                            child: Text(
                                              '线上支付',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: getSp(28),
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: getWidthPx(40),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            NotaryData.notaryId =
                                                oneData['order']['notaryId'];
                                            doSetState();
                                          },
                                          child: Container(
                                            width: getWidthPx(200),
                                            height: getWidthPx(80),
                                            alignment: Alignment.center,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: getWidthPx(40),
                                                vertical: getWidthPx(10)),
                                            decoration: BoxDecoration(
                                              color: AppTheme.themeBlue,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                getWidthPx(10),
                                              ),
                                            ),
                                            child: Text(
                                              '线下支付',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: getSp(28),
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              // 不缴费用
                              Offstage(
                                offstage: !(oneData['order']['notaryId'] ==
                                    '666c2421-b2e1-4076-80aa-8e63cf287de4'),
                                child: Offstage(
                                  offstage:
                                      oneData["order"]["notaryState"] == 15 ,
                                  child: Offstage(
                                    offstage: !isOrderSupplement,
                                    child: Container(
                                      margin:
                                          EdgeInsets.only(top: getWidthPx(20)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              quizVm.goPay(true, callBack: () {
                                                getData();
                                              });
                                            },
                                            child: Container(
                                              width: getWidthPx(200),
                                              height: getWidthPx(80),
                                              alignment: Alignment.center,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: getWidthPx(40),
                                                  vertical: getWidthPx(10)),
                                              decoration: BoxDecoration(
                                                color: AppTheme.themeBlue,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  getWidthPx(10),
                                                ),
                                              ),
                                              child: Text(
                                                '线上补缴',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: getSp(28),
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: getWidthPx(40),
                                          ),
                                          Offstage(
                                            offstage: isOrderSupplement,
                                            child: InkWell(
                                              onTap: () {
                                                NotaryData.notaryId =
                                                    oneData['order']['notaryId'];
                                                doSetState();
                                              },
                                              child: Container(
                                                width: getWidthPx(200),
                                                height: getWidthPx(80),
                                                alignment: Alignment.center,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: getWidthPx(40),
                                                    vertical: getWidthPx(10)),
                                                decoration: BoxDecoration(
                                                  color: AppTheme.themeBlue,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    getWidthPx(10),
                                                  ),
                                                ),
                                                child: Text(
                                                  '线下支付',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: getSp(28),
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: getHeightPx(20),
                              ),
                              Offstage(
                                offstage:
                                    !(oneData["order"]["notaryState"] == 70),
                                child: ColoredBox(
                                    color: Colors.white,
                                    child: Column(children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(
                                          left: getWidthPx(40),
                                          top: getWidthPx(30),
                                        ),
                                        child: const Text(
                                          "服务评价",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                      SponRatingWidget(
                                        value: score,
                                        evaluate: remarks,
                                        isInput: isInput,
                                        onRatingUpdate: (e, str) async {
                                          // wjPrint("服务评价: $e   $str");
                                          vm.textEditingController.text = str;
                                          vm.orderId = widget.arguments["data"]
                                              ["unitGuid"];
                                          vm.score = e.toString();
                                          vm.addScore();
                                          setState(() {
                                            score = int.parse(vm.score);
                                            isInput = vm.isBool;
                                          });
                                        },
                                      ),
                                    ])),
                              ),
                            ],
                          ),
                        )
                      : loadingWidget();
                });
          },
        ),
      ),
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
    );
  }

  @override
  bool get wantKeepAlive => false;
}
