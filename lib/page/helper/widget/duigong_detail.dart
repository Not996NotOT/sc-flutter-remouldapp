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
import '../../../utils/common_tools.dart';

class DuiGongDetailPage extends StatefulWidget {
  final arguments;
  const DuiGongDetailPage({Key key, this.arguments}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return DuiGongDetailState();
  }
}

class DuiGongDetailState extends BaseState<DuiGongDetailPage>
    with AutomaticKeepAliveClientMixin {
  bool isInput = true;
  int score = 0;
  String remarks = '';

  @override
  void initState() {
    super.initState();
    getData();
    getById();
  }

  Map orderInfo = {};
  getData() async {
    var map = {
      "unitGuid": widget.arguments["data"]["unitGuid"],
    };
    HelperApi.getSingleton().getDuiOrder(map).then((value) {
      wjPrint("33333333333333$value");
      if (value["code"] == 200) {
        orderInfo = value["item"];
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
        appBar: commonAppBar(title: "订单详情"),
        body: Consumer<UserViewModel>(
          builder: (ctx, userModel, child) {
            return ProviderWidget<HelpViewModel>(
                model: HelpViewModel(userModel),
                onModelReady: (model) {
                  quizVm = model;
                },
                builder: (ctx, vm, child) {
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
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
                                  style: TextStyle(fontWeight: FontWeight.w700),
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
                                      style: TextStyle(color: Colors.black45),
                                    ),
                                    Text("${orderInfo['orderNo'] ?? ""}",
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
                                      style: TextStyle(color: Colors.black45),
                                    ),
                                    Text("${orderInfo['notarialName'] ?? ""}",
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
                                      "项目名称",
                                      style: TextStyle(color: Colors.black45),
                                    ),
                                    Text("${orderInfo['projectName'] ?? ""}",
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
                                      "公证时间",
                                      style: TextStyle(color: Colors.black45),
                                    ),
                                    Text("${orderInfo['notaryTime'] ?? ""}",
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
                                      style: TextStyle(color: Colors.black45),
                                    ),
                                    Text(
                                        "${orderInfo["notaryState"] == 10 ? "待受理" : orderInfo["notaryState"] == 20 ? "受理中" : orderInfo["notaryState"] == 31 ? "终止（未完成申办）" : "完成"}",
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
                        Container(
                          color: Colors.white,
                          width: getWidthPx(750),
                          padding: EdgeInsets.only(
                              left: getWidthPx(40), top: getWidthPx(20)),
                          child: const Text(
                            "经办信息",
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                        orderInfo['notaryenterprises'] == null
                            ? SizedBox()
                            : ColoredBox(
                                color: Colors.white,
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount:
                                        orderInfo['notaryenterprises'].length,
                                    itemBuilder: (ctx, a) {
                                      var item =
                                          orderInfo['notaryenterprises'][a];
                                      return Column(
                                        children: <Widget>[
                                          item['unitGuid'] == null
                                              ? SizedBox()
                                              : Padding(
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
                                                        "企业名称",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black45),
                                                      ),
                                                      Text(
                                                          "${item['enterpriseName'] ?? ""}",
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .black))
                                                    ],
                                                  ),
                                                ),
                                          item['unitGuid'] == null
                                              ? SizedBox()
                                              : Padding(
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
                                                        "企业地址",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black45),
                                                      ),
                                                      Text(
                                                          "${item['enterpriseAddress'] ?? ""}",
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .black))
                                                    ],
                                                  ),
                                                ),
                                          ListView.builder(
                                              shrinkWrap: true,
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              itemCount:
                                                  item['publicnotaryusers']
                                                      .length,
                                              itemBuilder: (ctx, b) {
                                                var itemA =
                                                    item['publicnotaryusers']
                                                        [b];
                                                return Column(
                                                  children: <Widget>[
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          left: getWidthPx(40),
                                                          top: getWidthPx(15),
                                                          right:
                                                              getWidthPx(40)),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: <Widget>[
                                                          const Text(
                                                            "名字",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black45),
                                                          ),
                                                          Text(
                                                              "${itemA['userName'] ?? ""}",
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .black))
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          left: getWidthPx(40),
                                                          top: getWidthPx(15),
                                                          right:
                                                              getWidthPx(40)),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: <Widget>[
                                                          const Text(
                                                            "身份证号",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black45),
                                                          ),
                                                          Text(
                                                              "${itemA['idCard'] ?? ""}",
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .black))
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          left: getWidthPx(40),
                                                          top: getWidthPx(15),
                                                          right:
                                                              getWidthPx(40)),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: <Widget>[
                                                          const Text(
                                                            "手机号",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black45),
                                                          ),
                                                          Text(
                                                              "${itemA['mobile'] ?? ""}",
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .black))
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          left: getWidthPx(40),
                                                          top: getWidthPx(15),
                                                          right:
                                                              getWidthPx(40)),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: <Widget>[
                                                          const Text(
                                                            "类型",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black45),
                                                          ),
                                                          Text(
                                                              "${itemA['userType'] == 0 ? "法定代表人" : itemA['userType'] == 0 ? "经办人" : "个人"}",
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .black))
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    )
                                                  ],
                                                );
                                              }),
                                        ],
                                      );
                                    }),
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
                                    left: getWidthPx(40), top: getWidthPx(30)),
                                child: const Text(
                                  "材料",
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                              ),
                              orderInfo['rstMaterial'] != null
                                  ? Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: GridView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 3, //每行三列
                                            childAspectRatio: 1.0, //显示区域宽高相等
                                            mainAxisSpacing: 8,
                                            crossAxisSpacing: 8,
                                          ),
                                          itemCount:
                                              orderInfo['rstMaterial'].length,
                                          itemBuilder: (context, index) {
                                            var item =
                                                orderInfo['rstMaterial'][index];
                                            return InkWell(
                                              onTap: () {
                                                List imgArr = [];
                                                orderInfo['rstMaterial']
                                                    .forEach((element) {
                                                  imgArr
                                                      .add(element['filePath']);
                                                });
                                                Navigator.of(context).push(new FadeRoute(
                                                    page: PhotoViewGalleryScreen(
                                                        images: imgArr, //传入图片list
                                                        index: index, //传入当前点击的图片的index
                                                        heroTag: "1")));
                                              },
                                              child: FadeInImage.assetNetwork(
                                                imageCacheWidth: 800,
                                                imageCacheHeight: 800,
                                                placeholder:
                                                    'lib/assets/images/empty.png',
                                                image:
                                                    item['filePath'].toString(),
                                                fit: BoxFit.cover,
                                              ),
                                            );
                                          }),
                                    )
                                  : SizedBox(),
                              orderInfo['rstScreenshot'] != null
                                  ? Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: GridView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 3, //每行三列
                                            childAspectRatio: 1.0, //显示区域宽高相等
                                            mainAxisSpacing: 8,
                                            crossAxisSpacing: 8,
                                          ),
                                          itemCount:
                                              orderInfo['rstScreenshot'].length,
                                          itemBuilder: (context, index) {
                                            var item =
                                                orderInfo['rstScreenshot']
                                                    [index];
                                            return InkWell(
                                              onTap: () {
                                                Navigator.of(context).push(
                                                    new FadeRoute(
                                                        page:
                                                            PhotoViewGalleryScreen(
                                                                images: orderInfo[
                                                                    'rstScreenshot'], //传入图片list
                                                                index:
                                                                    index, //传入当前点击的图片的index
                                                                heroTag: "1")));
                                              },
                                              child: FadeInImage.assetNetwork(
                                                imageCacheWidth: 800,
                                                imageCacheHeight: 800,
                                                placeholder:
                                                    'lib/assets/images/empty.png',
                                                image: item.toString(),
                                              ),
                                            );
                                          }),
                                    )
                                  : SizedBox(),
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
                                      vm.orderId =
                                          widget.arguments["data"]["unitGuid"];
                                      vm.score = e.toString();
                                      vm.addScore();
                                      setState(() {
                                        score = vm.score != null
                                            ? int.parse(vm.score)
                                            : 0;
                                        isInput = vm.isBool;
                                      });
                                    },
                                  ),
                                ])),
                      ],
                    ),
                  );
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
