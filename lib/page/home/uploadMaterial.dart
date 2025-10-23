import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:notarization_station_app/base_framework/widget/provider_widget.dart';
import 'package:notarization_station_app/base_framework/widget/release_widget.dart';
import 'package:notarization_station_app/base_framework/widget_state/base_state.dart';
import 'package:notarization_station_app/page/home/vm/uploadMaterial_vm.dart';
import 'package:notarization_station_app/page/login/vm/user_view_model.dart';
import 'package:notarization_station_app/service_api/helper_api.dart';
import 'package:provider/provider.dart';

import '../../appTheme.dart';
import '../../utils/common_tools.dart';

class UploadMaterialPage extends StatefulWidget {
  final arguments;

  const UploadMaterialPage({Key key, this.arguments}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return UploadMaterialPageState();
  }
}

class UploadMaterialPageState extends BaseState<UploadMaterialPage>
    with AutomaticKeepAliveClientMixin {
  UploadMaterialModel uploadMaterialViewModel;

  Map oneData;
  List lists = [];
  List materialLists = [];
  List orderLogs = [];
  List tempOrderLogs = [];
  int number; //领取份数
  List addPayImgLists = [];
  List applyList = [];
  double supplementFee = 0.0;
  bool isInit = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    var map = {
      "unitGuid": widget.arguments["orderId"],
    };
    HelperApi.getSingleton().getOneNotarizationData(map).then((value) {
      if (value["code"] == 200) {
        oneData = value["item"];
        if (oneData["orderSupplements"] == null) {
          addPayImgLists = [];
        } else {
          oneData["orderSupplements"].forEach((item) {
            item["imagePathBack"].forEach((i) {
              addPayImgLists.add(i);
            });
          });
        }
        lists = oneData["notaryItems"];
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
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppTheme.themeBlue,
          centerTitle: true,
          title: Text(
            "上传材料",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          // leading: IconButton(
          //     icon: Icon(
          //       Icons.navigate_before,
          //       color: Colors.white,
          //       size: 30,
          //     ),
          //     onPressed: () {
          //       G.pushNamed(RoutePaths.HomeIndex);
          //     }),
        ),
        body: !isInit
            ? loadingWidget()
            : Consumer<UserViewModel>(
                builder: (ctx, userModel, child) {
                  return ProviderWidget<UploadMaterialModel>(
                    model: UploadMaterialModel(
                        userModel, lists, materialLists, number, orderLogs),
                    onModelReady: (model) {
                      model.videoHeight = getHeightPx(1334);
                      uploadMaterialViewModel = model;
                      model.loadData();
                    },
                    builder: (ctx, homeModel, child) {
                      return !isInit
                          ? loadingWidget()
                          : SingleChildScrollView(
                              child: Column(
                                children: <Widget>[
                                  SizedBox(
                                    height: getHeightPx(10),
                                  ),
                                  Container(
                                    width: double.maxFinite,
                                    child: Image.asset(
                                      "lib/assets/images/stepFour.png",
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  SizedBox(
                                    height: getHeightPx(40),
                                  ),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: getWidthPx(40),
                                          right: getWidthPx(40)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            "上传材料",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ],
                                      )),
                                  SizedBox(
                                    height: getHeightPx(30),
                                  ),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: getWidthPx(40),
                                          right: getWidthPx(40)),
                                      child: Row(
                                        children: <Widget>[
                                          Text(
                                            "申请人需上传的材料",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black45),
                                          ),
                                        ],
                                      )),
                                  SizedBox(
                                    height: getHeightPx(30),
                                  ),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: getWidthPx(40),
                                          right: getWidthPx(40)),
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: Text(
                                              "1.申请的证件的正反两面，都需要拍照或者扫描",
                                              maxLines: 2,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black45),
                                            ),
                                          ),
                                        ],
                                      )),
                                  SizedBox(
                                    height: getHeightPx(30),
                                  ),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: getWidthPx(40),
                                          right: getWidthPx(40)),
                                      child: Row(
                                        children: <Widget>[
                                          Text(
                                            "2.检查是否在公安部门的年检有效期内",
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black45),
                                          ),
                                        ],
                                      )),
                                  SizedBox(
                                    height: getHeightPx(30),
                                  ),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: getWidthPx(40),
                                          right: getWidthPx(40)),
                                      child: Row(
                                        children: <Widget>[
                                          Text(
                                            "3.文件可以不上传，等待公证员联系您",
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black45),
                                          ),
                                        ],
                                      )),
                                  SizedBox(
                                    height: getHeightPx(40),
                                  ),
                                  uploadMaterialViewModel.materialList.length >
                                          0
                                      ? ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemCount: uploadMaterialViewModel
                                              .materialList.length,
                                          itemBuilder: (context, index) {
                                            return Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        left: getWidthPx(40),
                                                        right: getWidthPx(40)),
                                                    child: Text(
                                                      uploadMaterialViewModel
                                                              .materialList[
                                                          index]["name"],
                                                      maxLines: 2,
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    )),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                    left: getWidthPx(20),
                                                  ),
                                                  child: ReleaseWidget(
                                                    isEdit:
                                                        uploadMaterialViewModel
                                                            .isEdite,
                                                    con: materialLists.isEmpty
                                                        ? uploadMaterialViewModel
                                                            .otherList
                                                        : uploadMaterialViewModel
                                                                .materialList[
                                                            index]['releaseCon'],
                                                    assetCallback:
                                                        (a, b, callBck) {
                                                      List<Asset>
                                                          tempImageList =
                                                          uploadMaterialViewModel
                                                              .uploadMaterialLists;
                                                      wjPrint(
                                                          'tempImageList----$tempImageList');
                                                      bool isHas = false;
                                                      if (tempImageList
                                                          .isNotEmpty) {
                                                        for (int i = 0;
                                                            i <
                                                                tempImageList
                                                                    .length;
                                                            i++) {
                                                          if (tempImageList[i]
                                                                  .name ==
                                                              b.name) {
                                                            isHas = true;
                                                            callBck(true);
                                                          }
                                                        }
                                                        if (!isHas) {
                                                          wjPrint(
                                                              'tempImageList.isNotEmpty------1');
                                                          uploadMaterialViewModel
                                                              .uploadMaterialLists
                                                              .add(b);
                                                          callBck(false);
                                                          uploadMaterialViewModel
                                                              .updateOtherImage(
                                                                  uploadMaterialViewModel
                                                                              .materialList[
                                                                          index]
                                                                      [
                                                                      "unitGuid"],
                                                                  a);
                                                        }
                                                        wjPrint(
                                                            'uploadMaterialViewModel.imageMap----${uploadMaterialViewModel.imageMap}');
                                                      } else {
                                                        wjPrint(
                                                            'tempImageList.isEmpty');
                                                        uploadMaterialViewModel
                                                            .uploadMaterialLists
                                                            .add(b);
                                                        callBck(false);
                                                        uploadMaterialViewModel
                                                            .updateOtherImage(
                                                                uploadMaterialViewModel
                                                                            .materialList[
                                                                        index][
                                                                    "unitGuid"],
                                                                a);
                                                      }
                                                      wjPrint(
                                                          'uploadMaterialViewModel.imageMap----${uploadMaterialViewModel.imageMap}');
                                                    },
                                                    // callback: (MultipartFile file) {
                                                    //   uploadMaterialViewModel
                                                    //       .updateOtherImage(
                                                    //           uploadMaterialViewModel
                                                    //                   .materialList[index]
                                                    //               ["unitGuid"],
                                                    //           file);
                                                    // },
                                                    deleteImgCallback: (int a) {
                                                      uploadMaterialViewModel
                                                          .imageMap[uploadMaterialViewModel
                                                                  .materialList[
                                                              index]["unitGuid"]]
                                                          .removeAt(a);
                                                      uploadMaterialViewModel
                                                          .uploadMaterialLists
                                                          .removeAt(a);
                                                      wjPrint(
                                                          'uploadMaterialViewModel.imageMap----${uploadMaterialViewModel.imageMap}');
                                                    },
                                                  ),
                                                ),
                                              ],
                                            );
                                          })
                                      : Container(
                                          alignment: Alignment.center,
                                          child: Text("暂无可上传的材料"),
                                        ),
                                  InkWell(
                                    onTap: () async {
                                      if (!uploadMaterialViewModel
                                          .alreadyRead) {
                                        // if (!uploadMaterialViewModel.clickNext) {
                                        // uploadMaterialViewModel.clickNext = true;
                                        uploadMaterialViewModel.previewFile();
                                        // }
                                      } else {
                                        uploadMaterialViewModel.showSignature(
                                            userModel.userName,
                                            userModel.idCard,
                                            "zizhu,手印",
                                            "1",
                                            context);
                                      }
                                    },
                                    child: uploadMaterialViewModel
                                                .alreadyRead ==
                                            false
                                        ? Container(
                                            alignment: Alignment.center,
                                            margin: EdgeInsets.only(
                                                top: getWidthPx(50),
                                                left: getWidthPx(40),
                                                right: getWidthPx(40)),
                                            padding: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5)),
                                              color: AppTheme.themeBlue,
                                            ),
                                            child: Text('下一步',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color:
                                                        AppTheme.nearlyWhite)))
                                        : uploadMaterialViewModel.isName == true
                                            ? Container(
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
                                                child: Text('请签字',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: AppTheme
                                                            .nearlyWhite)))
                                            : Container(),
                                  ),
                                  SizedBox(
                                    height: getHeightPx(30),
                                  ),
                                ],
                              ),
                            );
                    },
                  );
                },
              ));
  }

  @override
  bool get wantKeepAlive => true;
}
