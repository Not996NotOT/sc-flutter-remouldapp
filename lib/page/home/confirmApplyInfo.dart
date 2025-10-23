import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:notarization_station_app/base_framework/utils/toast_util.dart';
import 'package:notarization_station_app/base_framework/widget/provider_widget.dart';
import 'package:notarization_station_app/base_framework/widget_state/base_state.dart';
import 'package:notarization_station_app/components/throttleUtil.dart';
import 'package:notarization_station_app/page/home/vm/confirmApplyInfo_vm.dart';
import 'package:notarization_station_app/page/home/widget/num_change_widget.dart';
import 'package:notarization_station_app/page/login/vm/user_view_model.dart';
import 'package:notarization_station_app/routes/router.dart';
import 'package:notarization_station_app/service_api/helper_api.dart';
import 'package:notarization_station_app/utils/debounce_button.dart';
import 'package:notarization_station_app/utils/global.dart';
import 'package:pdf_flutter/pdf_flutter.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../appTheme.dart';
import '../../utils/common_tools.dart';

class ConfirmApplyInfoPage extends StatefulWidget {
  final arguments;
  const ConfirmApplyInfoPage({Key key, this.arguments}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ConfirmApplyInfoPageState();
  }
}

class ConfirmApplyInfoPageState extends BaseState<ConfirmApplyInfoPage>
    with AutomaticKeepAliveClientMixin {
  ConfirmApplyInfoModel confirmApplyModel;
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
        isInit = true;
        setState(() {});
      }
    });
  }

  //引入防抖
  ThrottleUtil throttleUtil = ThrottleUtil();

  Future<void> changeAddress() async {
    await showDialog<Map>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text('请选择邮寄地址'),
            children: confirmApplyModel.addressList.map((e) {
              return SimpleDialogOption(
                onPressed: () {
                  confirmApplyModel.orderAddressUpdate(e);
                  Navigator.pop(context);
                  confirmApplyModel.chooseAddress = e["address"];
                  confirmApplyModel.takeAddress = e["address"];
                  confirmApplyModel.unitId = e["unitGuid"];
                  confirmApplyModel.takePhone = e["phone"];
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(width: 1, color: AppTheme.bg_c)),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 6),
                  child: Text(e["address"]),
                ),
              );
            }).toList(),
          );
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
        appBar: commonAppBar(title: "确认订单信息"),
        body: Consumer<UserViewModel>(
          builder: (ctx, userModel, child) {
            return ProviderWidget<ConfirmApplyInfoModel>(
              model: ConfirmApplyInfoModel(userModel, widget.arguments),
              onModelReady: (model) {
                confirmApplyModel = model;
                confirmApplyModel.mobile.text = userModel.mobile;
                confirmApplyModel.number.text = "1";
                model.getAddressList();
              },
              builder: (ctx, homeModel, child) {
                return !isInit
                    ? loadingWidget()
                    : SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            ColoredBox(
                                color: Colors.white,
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      width: double.maxFinite,
                                      margin: EdgeInsets.only(
                                          top: getHeightPx(10),
                                          bottom: getHeightPx(40)),
                                      child: Image.asset(
                                        "lib/assets/images/stepThree.png",
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Padding(
                                            padding: EdgeInsets.only(
                                                left: getWidthPx(40),
                                                right: getWidthPx(40)),
                                            child: const Text(
                                              "申请信息",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w700),
                                            )),
                                      ],
                                    ),
                                    applyList.length == 0
                                        ? Row(
                                            children: <Widget>[
                                              Container(
                                                margin: EdgeInsets.only(
                                                    bottom: getWidthPx(20),
                                                    left: getWidthPx(40),
                                                    top: getWidthPx(20)),
                                                height: getWidthPx(50),
                                                width: getWidthPx(120),
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      width: 1,
                                                      color: Colors.blueAccent),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          getWidthPx(40)),
                                                ),
                                                child: const Text(
                                                  "申请人",
                                                  style: TextStyle(
                                                      color: Colors.blueAccent),
                                                ),
                                              ),
                                              SizedBox(
                                                width: getWidthPx(20),
                                              ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Text(
                                                          userModel.userName !=
                                                                  null
                                                              ? userModel
                                                                  .userName
                                                              : "",
                                                          style: const TextStyle(
                                                              fontSize: 16,
                                                              color: AppTheme
                                                                  .dark_grey),
                                                        ),
                                                        SizedBox(
                                                          width: getWidthPx(10),
                                                        ),
                                                        Text(
                                                          userModel.mobile !=
                                                                  null
                                                              ? userModel.mobile
                                                              : "",
                                                          style: const TextStyle(
                                                              fontSize: 16,
                                                              color: AppTheme
                                                                  .dark_grey),
                                                        )
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Text(
                                                          userModel.idCard ??
                                                              "",
                                                          style: const TextStyle(
                                                              fontSize: 14,
                                                              color: AppTheme
                                                                  .dark_grey),
                                                        ),
                                                        SizedBox(
                                                          width: getWidthPx(10),
                                                        ),
                                                        Text(
                                                          userModel.gender !=
                                                                  null
                                                              ? userModel.gender ==
                                                                      1
                                                                  ? "男"
                                                                  : "女"
                                                              : "",
                                                          style: const TextStyle(
                                                              fontSize: 14,
                                                              color: AppTheme
                                                                  .dark_grey),
                                                        ),
                                                        SizedBox(
                                                          width: getWidthPx(10),
                                                        ),
                                                        Expanded(
                                                            child: Text(
                                                          userModel.birthday !=
                                                                  null
                                                              ? userModel
                                                                  .birthday
                                                              : "",
                                                          style: const TextStyle(
                                                              fontSize: 14,
                                                              color: AppTheme
                                                                  .dark_grey),
                                                        ))
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          )
                                        : Container(
//                                  height: getHeightPx(100),
                                            child: ListView.builder(
                                                shrinkWrap: true,
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                itemCount: applyList.length,
                                                itemBuilder: (ctx, int index) {
                                                  return Row(
                                                    children: <Widget>[
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            bottom:
                                                                getWidthPx(20),
                                                            left:
                                                                getWidthPx(40),
                                                            top:
                                                                getWidthPx(20)),
                                                        height: getWidthPx(50),
                                                        width: getWidthPx(120),
                                                        alignment:
                                                            Alignment.center,
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                              width: 1,
                                                              color: Colors
                                                                  .blueAccent),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      getWidthPx(
                                                                          40)),
                                                        ),
                                                        child: const Text(
                                                          "申请人",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .blueAccent),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: getWidthPx(20),
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: <Widget>[
                                                              Text(
                                                                applyList[index]
                                                                        [
                                                                        "name"] ??
                                                                    '',
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    color: AppTheme
                                                                        .dark_grey),
                                                              ),
                                                              SizedBox(
                                                                width:
                                                                    getWidthPx(
                                                                        10),
                                                              ),
                                                              Text(
                                                                applyList[index]
                                                                        [
                                                                        "mobile"] ??
                                                                    '',
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    color: AppTheme
                                                                        .dark_grey),
                                                              )
                                                            ],
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: <Widget>[
                                                              Text(
                                                                applyList[index]
                                                                        [
                                                                        "idCard"] ??
                                                                    '',
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    color: AppTheme
                                                                        .dark_grey),
                                                              ),
                                                              SizedBox(
                                                                width:
                                                                    getWidthPx(
                                                                        10),
                                                              ),
                                                              Text(
                                                                applyList[index]
                                                                            [
                                                                            "gender"] ==
                                                                        "1"
                                                                    ? "男"
                                                                    : "女",
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    color: AppTheme
                                                                        .dark_grey),
                                                              ),
                                                              SizedBox(
                                                                width:
                                                                    getWidthPx(
                                                                        10),
                                                              ),
                                                              Text(
                                                                applyList[index]["birthday"] !=
                                                                            null &&
                                                                        applyList[index]["birthday"].toString().length >
                                                                            10
                                                                    ? applyList[index]
                                                                            [
                                                                            "birthday"]
                                                                        .toString()
                                                                        .substring(
                                                                            0,
                                                                            10)
                                                                    : applyList[index]
                                                                            [
                                                                            "birthday"] ??
                                                                        '',
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    color: AppTheme
                                                                        .dark_grey),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  );
                                                }),
                                          )
                                  ],
                                )),
                            SizedBox(
                              height: getHeightPx(30),
                            ),
                            ColoredBox(
                              color: Colors.white,
                              child: Column(
                                children: <Widget>[
                                  SizedBox(
                                    height: getHeightPx(30),
                                  ),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: getWidthPx(40),
                                          right: getWidthPx(40)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          const Text(
                                            "公证费用",
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
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: lists.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        var item = lists[index];
                                        return Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Expanded(
                                              child: Container(
                                                margin: EdgeInsets.only(
                                                  bottom: getWidthPx(10),
                                                ),
                                                child: Text(
                                                  "${item["notaryItemName"] ?? ''}" +
                                                      "×1",
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      color:
                                                          AppTheme.dark_grey),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              "${item["price"] ?? ''}" +
                                                  '${item["price"] == null ? '' : "元"}',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: AppTheme.dark_grey),
                                            )
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    height: getHeightPx(30),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: getHeightPx(30),
                            ),
                            ColoredBox(
                              color: Colors.white,
                              child: Column(
                                children: <Widget>[
                                  SizedBox(
                                    height: getHeightPx(30),
                                  ),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: getWidthPx(40),
                                          right: getWidthPx(40)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          const Text(
                                            "联系信息",
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
                                      child: Column(
                                        children: <Widget>[
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              const Text(
                                                "领取份数",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: AppTheme.dark_grey),
                                              ),
                                              ColoredBox(
                                                // width: getWidthPx(270),
                                                // height: getHeightPx(70),
//                                        padding: EdgeInsets.symmetric(vertical:getWidthPx(5)),
                                                color: Color.fromRGBO(
                                                    254, 240, 240, 1),
                                                child: NumChangeWidget(
                                                    num: int.parse(
                                                        confirmApplyModel
                                                            .number.text),
                                                    onValueChanged: (num) {
                                                      // confirmApplyModel.changeNumber(
                                                      //     num.toString());
                                                      confirmApplyModel
                                                              .number.text =
                                                          num.toString();
                                                      Future.delayed(
                                                          const Duration(
                                                              milliseconds:
                                                                  500), () {
                                                        setState(() {});
                                                      });
                                                    }),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: getHeightPx(30),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                              left: getWidthPx(0),
                                            ),
                                            child: Container(
                                                alignment: Alignment.centerLeft,
                                                child: const Text(
                                                  "公证书您需要一式几份？（默认1份）",
                                                  style: TextStyle(
                                                      color: Colors.black45,
                                                      fontSize: 14),
                                                )),
                                          ),
                                          Padding(
                                              padding: EdgeInsets.only(
                                                  top: getWidthPx(20)),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    lists != null && lists.length > 0 ? '公证书x${int.parse(confirmApplyModel.number.text) * lists.length}' : "公证书x${confirmApplyModel.number.text}",
                                                    style: const TextStyle(
                                                        color: Colors.black45,
                                                        fontSize: 14),
                                                  ),
                                                  const Spacer(),
                                                  Text(
                                                      lists != null && lists.length > 0 ? '¥${(20.0 * int.parse(confirmApplyModel.number.text)) * lists.length}' :'￥${20.0 * int.parse(confirmApplyModel.number.text)}',
                                                    style: const TextStyle(
                                                        color: Colors.black45,
                                                        fontSize: 14),
                                                  ),
                                                ],
                                              )),
                                          SizedBox(
                                            height: getHeightPx(30),
                                          ),
                                          Container(
                                            decoration: const BoxDecoration(
                                                border: Border(
                                                    bottom: BorderSide(
                                              width: 0.5, //宽度
                                              color: Colors.black12, //边框颜色
                                            ))),
                                          ),
                                        ],
                                      )),
                                  SizedBox(
                                    height: getHeightPx(30),
                                  ),
//                                   Padding(
//                                       padding: EdgeInsets.only(
//                                           left: getWidthPx(40),
//                                           right: getWidthPx(40)),
//                                       child: Column(
//                                         children: <Widget>[
//                                           Row(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.spaceBetween,
//                                             children: <Widget>[
//                                               const Text(
//                                                 "联系电话",
//                                                 style: TextStyle(
//                                                     fontSize: 16,
//                                                     color: AppTheme.dark_grey),
//                                               ),
//                                               Container(
//                                                 alignment: Alignment.center,
//                                                 width: getWidthPx(270),
//                                                 height: getHeightPx(70),
//                                                 color: Color.fromRGBO(
//                                                     254, 240, 240, 1),
//                                                 child: TextField(
//                                                     keyboardType:
//                                                         TextInputType.number,
// //                                          maxLength: 11,
//                                                     inputFormatters: [
//                                                       FilteringTextInputFormatter
//                                                           .digitsOnly
//                                                     ],
//                                                     controller:
//                                                         confirmApplyModel
//                                                             .mobile,
//                                                     decoration: InputDecoration(
//                                                       counterText: "",
//                                                       border: InputBorder.none,
//                                                       hintText: '',
//                                                       hintStyle: TextStyle(
//                                                         fontSize: 12,
//                                                       ),
//                                                     ),
//                                                     onChanged: (value) {
//                                                       confirmApplyModel
//                                                           .notifyListeners();
//                                                     }),
//                                               )
//                                             ],
//                                           ),
//                                           SizedBox(
//                                             height: getHeightPx(30),
//                                           ),
//                                           Padding(
//                                             padding: EdgeInsets.only(
//                                               left: getWidthPx(0),
//                                             ),
//                                             child: Container(
//                                                 alignment: Alignment.centerLeft,
//                                                 child: const Text(
//                                                   "公证员将与你确认公证细节，请保持手机通畅",
//                                                   style: TextStyle(
//                                                       color: Colors.black45,
//                                                       fontSize: 14),
//                                                 )),
//                                           ),
//                                           SizedBox(
//                                             height: getHeightPx(30),
//                                           ),
//                                           Container(
//                                             decoration: const BoxDecoration(
//                                                 border: Border(
//                                                     bottom: BorderSide(
//                                               width: 0.5, //宽度
//                                               color: Colors.black12, //边框颜色
//                                             ))),
//                                           ),
//                                         ],
//                                       )),
//                                   SizedBox(
//                                     height: getHeightPx(30),
//                                   ),
//                                   Padding(
//                                       padding: EdgeInsets.only(
//                                           left: getWidthPx(40),
//                                           right: getWidthPx(40)),
//                                       child: Column(
//                                         children: <Widget>[
//                                           Row(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.spaceBetween,
//                                             children: <Widget>[
//                                               const Text(
//                                                 "领取方式",
//                                                 style: TextStyle(
//                                                     fontSize: 16,
//                                                     color: AppTheme.dark_grey),
//                                               ),
//                                               DropdownButton(
//                                                   value: confirmApplyModel
//                                                       .selectType,
//                                                   underline: Container(
//                                                       height: 0.0,
//                                                       color: Colors.green
//                                                           .withOpacity(0.7)),
//                                                   items: [
//                                                     DropdownMenuItem(
//                                                       child: const Text(
//                                                         '邮寄',
//                                                         style: TextStyle(
//                                                             fontSize: 16,
//                                                             color: AppTheme
//                                                                 .dark_grey),
//                                                       ),
//                                                       value: "邮寄",
//                                                     ),
//                                                     DropdownMenuItem(
//                                                       child: const Text(
//                                                         '自取',
//                                                         style: TextStyle(
//                                                             fontSize: 16,
//                                                             color: AppTheme
//                                                                 .dark_grey),
//                                                       ),
//                                                       value: "自取",
//                                                     ),
//                                                   ],
//                                                   onChanged: (value) {
//                                                     confirmApplyModel
//                                                         .setSelectType(value);
//                                                     if (value == "邮寄") {
//                                                       // ToastUtil.showWarningToast(
//                                                       //     "请新增地址");
//                                                       // Navigator.pushNamed(context,
//                                                       //     RoutePaths.AddAddress)
//                                                       //     .then((value) =>
//                                                       //     confirmApplyModel
//                                                       //         .getAddressList());
//                                                       //  if (confirmApplyModel
//                                                       //          .addressList.length ==
//                                                       //      0) {
//                                                       //    ToastUtil.showWarningToast(
//                                                       //        "请新增地址");
//                                                       //    Navigator.pushNamed(context,
//                                                       //            RoutePaths.AddAddress)
//                                                       //        .then((value) =>
//                                                       //            confirmApplyModel
//                                                       //                .getAddressList());
//                                                       //  } else {
//                                                       // changeAddress();
//                                                       //  }
//                                                       confirmApplyModel
//                                                           .takeStyle = 2;
//                                                     } else if (value == "自取") {
//                                                       confirmApplyModel
//                                                           .takeStyle = 1;
//                                                     }
//                                                   })
//                                             ],
//                                           ),
//                                           confirmApplyModel.takeStyle == 1
//                                               ? Padding(
//                                                   padding: EdgeInsets.only(
//                                                       left: getWidthPx(0),
//                                                       bottom: getWidthPx(30)),
//                                                   child: Container(
//                                                       alignment:
//                                                           Alignment.centerLeft,
//                                                       child: const Text(
//                                                         "领取时请携带公证时提供的原件去公证现场",
//                                                         style: TextStyle(
//                                                             color:
//                                                                 Colors.black45,
//                                                             fontSize: 14),
//                                                       )),
//                                                 )
//                                               : Padding(
//                                                   padding: EdgeInsets.only(
//                                                     left: getWidthPx(0),
//                                                   ),
//                                                   child: confirmApplyModel
//                                                               .defaultAddress ==
//                                                           ""
//                                                       ? GestureDetector(
//                                                           onTap: () {
//                                                             Navigator.pushNamed(
//                                                                     context,
//                                                                     RoutePaths
//                                                                         .AddAddress)
//                                                                 .then((value) =>
//                                                                     confirmApplyModel
//                                                                         .getAddressList());
//                                                           },
//                                                           child: Container(
//                                                             color: Colors.white,
//                                                             padding: EdgeInsets.only(
//                                                                 left: 0,
//                                                                 bottom:
//                                                                     getHeightPx(
//                                                                         30)),
//                                                             alignment: Alignment
//                                                                 .center,
//                                                             child: Container(
//                                                               padding: EdgeInsets.symmetric(
//                                                                   horizontal:
//                                                                       getWidthPx(
//                                                                           60),
//                                                                   vertical:
//                                                                       getHeightPx(
//                                                                           10)),
//                                                               decoration: BoxDecoration(
//                                                                   borderRadius:
//                                                                       BorderRadius.circular(
//                                                                           getWidthPx(
//                                                                               10)),
//                                                                   border: Border.all(
//                                                                       color: AppTheme
//                                                                           .themeBlue,
//                                                                       width:
//                                                                           1)),
//                                                               child: Row(
//                                                                 mainAxisSize:
//                                                                     MainAxisSize
//                                                                         .min,
//                                                                 children: [
//                                                                   const Icon(
//                                                                     Icons.add,
//                                                                     color: AppTheme
//                                                                         .themeBlue,
//                                                                   ),
//                                                                   SizedBox(
//                                                                     width:
//                                                                         getWidthPx(
//                                                                             20),
//                                                                   ),
//                                                                   const Text(
//                                                                     '新增地址',
//                                                                     style: TextStyle(
//                                                                         color: AppTheme
//                                                                             .themeBlue),
//                                                                   )
//                                                                 ],
//                                                               ),
//                                                             ),
//                                                           ),
//                                                         )
//                                                       : GestureDetector(
//                                                           onTap: () {
//                                                             Navigator.pushNamed(
//                                                                     context,
//                                                                     RoutePaths
//                                                                         .AddAddress,
//                                                                     arguments: AddressItem().fromJson(
//                                                                         confirmApplyModel
//                                                                             .showAddressInformation))
//                                                                 .then((value) =>
//                                                                     confirmApplyModel
//                                                                         .getAddressList());
//                                                           },
//                                                           child: Padding(
//                                                             padding:
//                                                                 EdgeInsets.only(
//                                                               left:
//                                                                   getWidthPx(0),
//                                                             ),
//                                                             child: Container(
//                                                                 color: Colors
//                                                                     .white,
//                                                                 padding: EdgeInsets.only(
//                                                                     left: 0,
//                                                                     bottom:
//                                                                         getHeightPx(
//                                                                             30)),
//                                                                 alignment: Alignment
//                                                                     .centerLeft,
//                                                                 child: Text(
//                                                                   confirmApplyModel
//                                                                       .defaultAddress
//                                                                       .toString(),
//                                                                   maxLines: 3,
//                                                                   style: TextStyle(
//                                                                       color: Colors
//                                                                           .black45,
//                                                                       fontSize:
//                                                                           12),
//                                                                 )),
//                                                           ),
//                                                         )),
//                                           Container(
//                                             decoration: const BoxDecoration(
//                                                 border: Border(
//                                                     bottom: BorderSide(
//                                               width: 0.5, //宽度
//                                               color: Colors.black12, //边框颜色
//                                             ))),
//                                           ),
//                                         ],
//                                       )),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: getWidthPx(40),
                                        right: getWidthPx(40)),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Text("提示",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700)),
                                        Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: getWidthPx(20)),
                                            child: RichText(
                                                text: TextSpan(
                                                    text:
                                                        '此收费只包含中外文公证词费用，涉及公证对象文书的翻译费用按实际发生金额另行收取。',
                                                    style: TextStyle(
                                                        color: Colors.red,
                                                        fontSize: 14,
                                                        height: 1.5),
                                                    children: [
                                                  TextSpan(
                                                      text: " \n（点击查看公证收费标准）",
                                                      style: const TextStyle(
                                                          color: AppTheme
                                                              .themeBlue,
                                                          fontSize: 14,
                                                          height: 1.5),
                                                      recognizer:
                                                          TapGestureRecognizer()
                                                            ..onTap = () {
                                                              showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (context) {
                                                                    return Container(
                                                                      margin: EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              30,
                                                                          vertical:
                                                                              50),
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              10),
                                                                      decoration: BoxDecoration(
                                                                          color: AppTheme
                                                                              .white,
                                                                          borderRadius:
                                                                              BorderRadius.all(Radius.circular(10))),
                                                                      child:
                                                                          PDF.network('https://sc.njguochu.com:46/package/sfbz.pdf'),
                                                                    );
                                                                  });
                                                            })
                                                ]))),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            DebounceButton(
                              clickTap: () async {
//                        if (!RegexUtil.isMobileSimple(confirmApplyModel.mobile.text)) {
//                          ToastUtil.showErrorToast("请输入正确的手机号");
//                        } else {
                                if (confirmApplyModel.mobile.text == "") {
                                  ToastUtil.showErrorToast("请输入联系电话");
                                } else {
                                  if (confirmApplyModel.takeStyle == 2) {
                                    if (confirmApplyModel.addressList.length ==
                                        0) {
                                      ToastUtil.showWarningToast("请新增地址");
                                      Navigator.pushNamed(
                                              context, RoutePaths.AddAddress)
                                          .then((value) => confirmApplyModel
                                              .getAddressList());
                                    } else {
                                      if (confirmApplyModel.defaultAddress ==
                                              "" &&
                                          confirmApplyModel.takeAddress == "") {
                                        ToastUtil.showWarningToast("请设置默认地址");
                                        G.pushNamed(RoutePaths.MineAddressList);
                                      } else if (confirmApplyModel
                                                  .defaultAddress ==
                                              "" &&
                                          confirmApplyModel.takeAddress != "") {
                                        confirmApplyModel.isEnable = false;
                                        confirmApplyModel.notifyListeners();
                                        confirmApplyModel.setTakeType();
                                      } else if (confirmApplyModel
                                              .defaultAddress !=
                                          "") {
                                        if (confirmApplyModel.takeAddress ==
                                            "") {
                                          confirmApplyModel.takeAddress =
                                              confirmApplyModel.defaultAddress;
                                        }
                                        confirmApplyModel.isEnable = false;
                                        confirmApplyModel.notifyListeners();
                                        confirmApplyModel.setTakeType();
                                      }
                                    }
                                  } else {
                                    confirmApplyModel.isEnable = false;
                                    confirmApplyModel.notifyListeners();
                                    confirmApplyModel.setTakeType();
                                  }
                                }
                              },
                              isEnable: confirmApplyModel.isEnable,
                              margin: EdgeInsets.only(
                                  top: getWidthPx(50),
                                  left: getWidthPx(40),
                                  right: getWidthPx(40)),
                              padding: EdgeInsets.all(10),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              child: const Text('下一步',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: AppTheme.nearlyWhite)),
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
