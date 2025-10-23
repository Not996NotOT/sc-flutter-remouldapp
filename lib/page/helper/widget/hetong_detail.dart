import 'package:flutter/material.dart';
import 'package:notarization_station_app/base_framework/widget/photo_view/fade_route.dart';
import 'package:notarization_station_app/base_framework/widget/provider_widget.dart';
import 'package:notarization_station_app/base_framework/widget_state/base_state.dart';
import 'package:notarization_station_app/components/photo_view_gallery.dart';
import 'package:notarization_station_app/components/star/span_rating_widget.dart';
import 'package:notarization_station_app/page/helper/vm/helper_vm.dart';
import 'package:notarization_station_app/page/login/vm/user_view_model.dart';
import 'package:notarization_station_app/service_api/helper_api.dart';
import 'package:provider/provider.dart';

import '../../../appTheme.dart';
import '../../../config.dart';

class HeTongDetailPage extends StatefulWidget {
  final arguments;

  const HeTongDetailPage({Key key, this.arguments}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return HeTongDetailState();
  }
}

class HeTongDetailState extends BaseState<HeTongDetailPage>
    with AutomaticKeepAliveClientMixin {
  Map oneData;
  List lists = [];
  List materialLists = [];
  List orderLogs = [];
  List addPayImgLists = [];
  List applicantList = [];
  bool isInit = false;

  bool isInput = true;
  int score = 0;
  String remarks = '';

  @override
  void initState() {
    super.initState();
    getData();
    getById();
  }

  getData() async {
    var map = {
      "unitGuid": widget.arguments["data"]["unitGuid"],
    };
    HelperApi.getSingleton().getOneNotarizationData(map).then((value) {
      if (value["code"] == 200) {
        oneData = value["item"];
        lists = oneData["notaryItems"];
        applicantList = oneData["applyuser"];
        oneData["orderLogs"].forEach((item) {
          orderLogs.add(item);
        });
        if (oneData["materials"] != null) {
          oneData["materials"].forEach((item) {
            item["annexs"].forEach((i) {
              materialLists.add(i["filePath"]);
            });
          });
        }
        oneData["orderSupplements"]?.forEach((item) {
          if (item["imagePathBack"] != null) {
            item["imagePathBack"].forEach((i) {
              addPayImgLists.add(i);
            });
          }
        });
        materialLists = materialLists.toSet().toList();
        isInit = true;
        setState(() {});
      }
    });
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
        appBar: commonAppBar(title: "多方公证订单详情"),
        body: Consumer<UserViewModel>(
          builder: (ctx, userModel, child) {
            return ProviderWidget<HelpViewModel>(
                model: HelpViewModel(userModel),
                onModelReady: (model) {
                  quizVm = model;
                },
                builder: (ctx, vm, child) {
                  return isInit
                      ? SingleChildScrollView(
                          child: Column(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(top: getHeightPx(20)),
                                width: getWidthPx(750),
                                decoration: BoxDecoration(color: Colors.white),
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: orderLogs.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    var item = orderLogs[index];
                                    return Row(
                                      children: <Widget>[
                                        Container(
                                          margin: EdgeInsets.only(
                                            left: getWidthPx(30),
                                          ),
                                          width: getWidthPx(180),
                                          child: Text(
                                            item["createDate"] ?? '',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: index == 0
                                                    ? Colors.black
                                                    : Colors.black45),
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
                                              index == 0
                                                  ? Image.asset(
                                                      "lib/assets/images/stepImg.png",
                                                      width: getWidthPx(25),
                                                    )
                                                  : Container(
                                                      width: getWidthPx(10),
                                                      height: getHeightPx(10),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          color:
                                                              Colors.black12),
                                                    ),
                                              Container(
                                                width: getWidthPx(2),
                                                height: getHeightPx(88),
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        width: 1,
                                                        color: Colors.black12)),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            children: <Widget>[
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: getWidthPx(30),
                                                    top: getWidthPx(20)),
                                                child: Text(
                                                  item["notaryStateName"] ?? '',
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: index == 0
                                                          ? Colors.black
                                                          : Colors.black45,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: getWidthPx(30),
                                                    top: getWidthPx(5)),
                                                child: Text(
                                                  item["reason"] ?? '',
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: index == 0
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
                                      child: const Text(
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
                                              oneData["order"]["orderNo"] ?? '',
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
                                          Text(oneData["order"]["notaryName"],
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
                                              oneData["order"]
                                                      ["notaryItemNames"] ??
                                                  '',
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
                                          Text(
                                              oneData["order"]["createDate"] ??
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
                                          bottom: getWidthPx(15),
                                          right: getWidthPx(40)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          const Text(
                                            "支付状态",
                                            style: TextStyle(
                                                color: Colors.black45),
                                          ),
                                          Text(
                                              oneData["order"]
                                                      ["notaryStateName"] ??
                                                  '',
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
                              ColoredBox(
                                color: Colors.white,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                    ColoredBox(
                                      color: Colors.white,
                                      child: ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemCount: applicantList.length,
                                          itemBuilder: (ctx, a) {
                                            return Column(
                                              children: <Widget>[
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
                                                          applicantList[a]
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
                                                        "身份证号",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black45),
                                                      ),
                                                      Text(
                                                          applicantList[a]
                                                                  ["idCard"] ??
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
                                                            color:
                                                                Colors.black45),
                                                      ),
                                                      Text(
                                                          applicantList[a]
                                                                  ["mobile"] ??
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
                                                    right: getWidthPx(40),
                                                    bottom: getWidthPx(15),
                                                  ),
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
                                                          applicantList[a]
                                                                  ["address"] ??
                                                              "",
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
                                                applicantList[a]["principal"] !=
                                                        null
                                                    ? Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                          left: getWidthPx(40),
                                                          top: 0,
                                                          right: getWidthPx(40),
                                                          bottom:
                                                              getWidthPx(15),
                                                        ),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: <Widget>[
                                                            const Text(
                                                              "代理人",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black45),
                                                            ),
                                                            SizedBox(
                                                              width: getWidthPx(
                                                                  20),
                                                            ),
                                                            Expanded(
                                                              child: Text(
                                                                applicantList[a]
                                                                        [
                                                                        "principal"] ??
                                                                    "",
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .black),
                                                                textAlign:
                                                                    TextAlign
                                                                        .right,
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      )
                                                    : SizedBox(),
                                                Container(
                                                  height: getHeightPx(20),
                                                  color: AppTheme.bg_d,
                                                ),
                                              ],
                                            );
                                          }),
                                    ),
                                  ],
                                ),
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
                                          top: getWidthPx(30)),
                                      child: const Text(
                                        "公证费用",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700),
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
                                            "总费用",
                                            style: TextStyle(
                                                color: Colors.black45),
                                          ),
                                          Text(
                                              "￥${oneData["order"]["fee"] ?? "0.0"}元",
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
                              ColoredBox(
                                color: Colors.white,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: getWidthPx(40),
                                          top: getWidthPx(30)),
                                      child: const Text(
                                        "材料",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                    materialLists.length != 0
                                        ? Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: GridView.builder(
                                                shrinkWrap: true,
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                gridDelegate:
                                                    const SliverGridDelegateWithFixedCrossAxisCount(
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
                                                              page:
                                                                  PhotoViewGalleryScreen(
                                                                      images:
                                                                          imgArr, //传入图片list
                                                                      index:
                                                                          index, //传入当前点击的图片的index
                                                                      heroTag:
                                                                          "1")));
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
                                                                      index]
                                                                  .toString()),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  );
                                                }),
                                          )
                                        : Padding(
                                            padding: EdgeInsets.only(
                                                left: getWidthPx(40),
                                                top: getWidthPx(30)),
                                            child: const Center(
                                                child: Text("暂无数据")),
                                          ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: getWidthPx(40),
                                          top: getWidthPx(30)),
                                      child: Text(
                                        "费用补缴",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                    oneData["orderSupplements"] != null
                                        ? Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: GridView.builder(
                                                shrinkWrap: true,
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                gridDelegate:
                                                    const SliverGridDelegateWithFixedCrossAxisCount(
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
                                                              page:
                                                                  PhotoViewGalleryScreen(
                                                                      images:
                                                                          addPayImgLists, //传入图片list
                                                                      index:
                                                                          index, //传入当前点击的图片的index
                                                                      heroTag:
                                                                          "1")));
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
                                                                  index]),
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
                              SizedBox(
                                height: getHeightPx(20),
                              ),
                              ColoredBox(
                                  color: Colors.white,
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
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
                                            vm.orderId = widget
                                                .arguments["data"]["unitGuid"];
                                            vm.score = e.toString();
                                            vm.addScore();
                                            setState(() {
                                              score = int.parse(vm.score);
                                              isInput = vm.isBool;
                                            });
                                          },
                                        ),
                                      ])),
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
