import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:notarization_station_app/base_framework/widget/provider_widget.dart';
import 'package:notarization_station_app/base_framework/widget_state/base_state.dart';
import 'package:notarization_station_app/components/a_dialog/a_dialog.dart';
import 'package:notarization_station_app/page/login/vm/user_view_model.dart';
import 'package:notarization_station_app/routes/router.dart';
import 'package:provider/provider.dart';

import '../../../appTheme.dart';
import 'bank_ingVm.dart';

class BankIngPage extends StatefulWidget {
  final arguments;
  BankIngPage({Key key, this.arguments}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return BankIngPageState();
  }
}

class BankIngPageState extends BaseState<BankIngPage> {
  BankIngModel videoVm;
  List<CameraDescription> cameras = [];

  Map oneData = {};
  List applicantList = [];
  List pledgeList = [];

  @override
  void initState() {
    super.initState();
    getCameras();
    print("...22...${widget.arguments}");
    oneData = widget.arguments['info'];
    widget.arguments['info']['userList'].forEach((e) {
      if (e['userType'] != 3) {
        applicantList.add(e);
      }
    });
    pledgeList = widget.arguments['info']['pledge'];
  }

  getCameras() async {
    cameras = await availableCameras();
    videoVm?.setCameras(cameras);
  }


  @override
  void dispose() {
    videoVm.closeSocket();
    videoVm.closeRoom();
    super.dispose();
  }

  changeShowDialog() async {
    await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (ctx, setBottomSheet) {
              return Dialog(
                insetPadding: EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                    height: getHeightPx(900),
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(4)),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: AppTheme.bg_c, width: 1))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                    child: Text(
                                  "上传材料",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                                Icon(Icons.clear, color: Colors.redAccent),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            child: GridView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3, //每行三列
                                  childAspectRatio: 1.0, //显示区域宽高相等
                                  mainAxisSpacing: 10,
                                  crossAxisSpacing: 10,
                                ),
                                itemCount: videoVm.materialList.length + 1,
                                itemBuilder: (context, index) {
                                  return releaseImage(
                                      index == videoVm.materialList.length,
                                      index != videoVm.materialList.length
                                          ? videoVm.materialList[index]
                                          : null,
                                      index,
                                      setBottomSheet);
                                }),
                          ),
                        ),
                      ],
                    )),
              );
            },
          );
        });
  }

  Widget releaseImage(
      bool isDef, Map img, int num, StateSetter setBottomSheet) {
    return isDef
        ? InkWell(
            onTap: () {
              videoVm.requestCameraPermission(setBottomSheet);
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset("lib/assets/images/add_img.png",
                  width: 400, height: 400),
            ))
        : Stack(
            children: [
              Container(
                padding: EdgeInsets.all(20),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    img['path'],
                    width: 400,
                    height: 400,
                  ),
                ),
              ),
              !isDef
                  ? Positioned(
                      top: 0,
                      right: 0,
                      child: InkWell(
                          onTap: () {
                            videoVm.delImg(img, num, setBottomSheet);
                          },
                          child: Icon(Icons.clear, color: Colors.redAccent)))
                  : SizedBox(width: 0, height: 0)
            ],
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: CustomFloatingActionButtonLocation(
          FloatingActionButtonLocation.endFloat, 0, -50),
      floatingActionButton: widget.arguments['isBank']
          ? Container(
              width: getWidthPx(70),
              height: getWidthPx(70),
              child: FloatingActionButton(
                child: Icon(Icons.add_circle_outline, size: getWidthPx(70)),
                onPressed: () {
                  changeShowDialog();
                },
              ),
            )
          : null,
      body: WillPopScope(
        onWillPop: () {
          ADialog.confirm(context,
              content: "是否确认退出公证？",
              cancelButtonText: Text("取消"),
              confirmButtonText: Text("确认"), cancelButtonPress: () {
            Navigator.of(context).pop();
          }, confirmButtonPress: () {
            // videoVm.closeSocket();
            Navigator.of(context).pop();
            Navigator.popUntil(
                context, ModalRoute.withName(RoutePaths.HomeIndex));
          });
          return Future.value(false);
        },
        child: Consumer<UserViewModel>(
          builder: (ctx, userModel, child) {
            return ProviderWidget<BankIngModel>(
                model: BankIngModel(userModel, "${widget.arguments['roomId']}",
                    widget.arguments['info']),
                onModelReady: (model) async {
                  videoVm = model;
                  model.videoHeight = getHeightPx(1334) - getWidthPx(360);
                  model.initData();
                },
                builder: (ctx, vm, child) {
                  return Container(
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          Container(
                              // height: getWidthPx(375),
                              color: Colors.black26,
                              child: _renderWidget()),
                          vm.titleString == ""
                              ? SizedBox()
                              : Padding(
                                  padding: EdgeInsets.only(
                                      top: getWidthPx(20),
                                      left: getWidthPx(20),
                                      right: getWidthPx(20)),
                                  child: Html(
                                    data: vm.titleString,
                                  ),
                                ),
                          Container(
                            width: getWidthPx(750),
                            decoration: BoxDecoration(color: Colors.white),
                            child: Column(
                              children: <Widget>[
                                Container(
                                    padding: EdgeInsets.all(getWidthPx(20)),
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: AppTheme.bg_c,
                                                width: 1))),
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                            width: 5,
                                            height: 15,
                                            decoration: BoxDecoration(
                                                color: AppTheme.themeBlue,
                                                borderRadius:
                                                    BorderRadius.circular(10))),
                                        SizedBox(width: getWidthPx(10)),
                                        Expanded(
                                          child: Text(
                                            "借款信息",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14),
                                          ),
                                        ),
                                      ],
                                    )),
                                Container(
                                  margin: EdgeInsets.only(
                                      left: getWidthPx(40),
                                      top: getWidthPx(15),
                                      right: getWidthPx(40)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Container(
                                        child: Text(
                                          "合同编号",
                                          style:
                                              TextStyle(color: Colors.black45),
                                        ),
                                      ),
                                      Text("${oneData["num"] ?? ""}",
                                          style: TextStyle(color: Colors.black))
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      left: getWidthPx(40),
                                      top: getWidthPx(15),
                                      right: getWidthPx(40)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Container(
                                        child: Text(
                                          "贷款方",
                                          style:
                                              TextStyle(color: Colors.black45),
                                        ),
                                      ),
                                      Text(
                                          oneData["mortgagee"] == null
                                              ? "四川新网银行股份有限公司"
                                              : "四川新网银行股份有限公司/${oneData["mortgagee"]}",
                                          style: TextStyle(color: Colors.black))
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      left: getWidthPx(40),
                                      top: getWidthPx(15),
                                      right: getWidthPx(40)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Container(
                                        child: Text(
                                          "授信额度",
                                          style:
                                              TextStyle(color: Colors.black45),
                                        ),
                                      ),
                                      Text("${oneData["quota"] ?? ""}",
                                          style: TextStyle(color: Colors.black))
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      left: getWidthPx(40),
                                      top: getWidthPx(15),
                                      right: getWidthPx(40)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Container(
                                        child: Text(
                                          "借款期限",
                                          style:
                                              TextStyle(color: Colors.black45),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          "${oneData["term"] ?? ""}天",
                                          style: TextStyle(color: Colors.black),
                                          textAlign: TextAlign.right,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      left: getWidthPx(40),
                                      top: getWidthPx(15),
                                      right: getWidthPx(40)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Container(
                                        child: Text(
                                          "签约地点",
                                          style:
                                              TextStyle(color: Colors.black45),
                                        ),
                                      ),
                                      Text("江苏省南京市",
                                          style: TextStyle(color: Colors.black))
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
                              padding: EdgeInsets.all(getWidthPx(20)),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border(
                                      bottom: BorderSide(
                                          color: AppTheme.bg_c, width: 1))),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                      width: 5,
                                      height: 15,
                                      decoration: BoxDecoration(
                                          color: AppTheme.themeBlue,
                                          borderRadius:
                                              BorderRadius.circular(10))),
                                  SizedBox(width: getWidthPx(10)),
                                  Expanded(
                                    child: Text(
                                      "借款人信息",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14),
                                    ),
                                  ),
                                ],
                              )),
                          Container(
                            color: Colors.white,
                            child: MediaQuery.removePadding(
                              removeTop: true,
                              context: context,
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: applicantList.length,
                                  itemBuilder: (ctx, a) {
                                    return Column(
                                      children: <Widget>[
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: getWidthPx(40),
                                              top: getWidthPx(15),
                                              right: getWidthPx(40)),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text(
                                                "姓名",
                                                style: TextStyle(
                                                    color: Colors.black45),
                                              ),
                                              Text(applicantList[a]["name"],
                                                  style: TextStyle(
                                                      color: Colors.black))
                                            ],
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: getWidthPx(40),
                                              top: getWidthPx(15),
                                              right: getWidthPx(40)),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text(
                                                "电话",
                                                style: TextStyle(
                                                    color: Colors.black45),
                                              ),
                                              Text(
                                                  "${applicantList[a]["mobile"] ?? ""}",
                                                  style: TextStyle(
                                                      color: Colors.black))
                                            ],
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: getWidthPx(40),
                                              top: getWidthPx(15),
                                              right: getWidthPx(40)),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text(
                                                "证件类型",
                                                style: TextStyle(
                                                    color: Colors.black45),
                                              ),
                                              Text(
                                                  applicantList[a]
                                                      ["certificateType"],
                                                  style: TextStyle(
                                                      color: Colors.black))
                                            ],
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: getWidthPx(40),
                                              top: getWidthPx(15),
                                              right: getWidthPx(40)),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text(
                                                "证件号",
                                                style: TextStyle(
                                                    color: Colors.black45),
                                              ),
                                              Text(applicantList[a]["idCard"],
                                                  style: TextStyle(
                                                      color: Colors.black))
                                            ],
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                            left: getWidthPx(40),
                                            top: getWidthPx(15),
                                            right: getWidthPx(40),
                                            bottom: getWidthPx(15),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text(
                                                "地址",
                                                style: TextStyle(
                                                    color: Colors.black45),
                                              ),
                                              SizedBox(
                                                width: getWidthPx(20),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  "${applicantList[a]["address"] ?? ""}",
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                  textAlign: TextAlign.right,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Container(
                                          height: getHeightPx(20),
                                          color: AppTheme.bg_d,
                                        ),
                                      ],
                                    );
                                  }),
                            ),
                          ),
                          Container(
                              padding: EdgeInsets.all(getWidthPx(20)),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border(
                                      bottom: BorderSide(
                                          color: AppTheme.bg_c, width: 1))),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                      width: 5,
                                      height: 15,
                                      decoration: BoxDecoration(
                                          color: AppTheme.themeBlue,
                                          borderRadius:
                                              BorderRadius.circular(10))),
                                  SizedBox(width: getWidthPx(10)),
                                  Expanded(
                                    child: Text(
                                      "抵押物信息",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14),
                                    ),
                                  ),
                                ],
                              )),
                          Container(
                            color: Colors.white,
                            child: MediaQuery.removePadding(
                              removeTop: true,
                              context: context,
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: pledgeList.length,
                                  itemBuilder: (ctx, a) {
                                    return Column(
                                      children: <Widget>[
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: getWidthPx(40),
                                              top: getWidthPx(15),
                                              right: getWidthPx(40)),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text(
                                                "房屋地址",
                                                style: TextStyle(
                                                    color: Colors.black45),
                                              ),
                                              Text(pledgeList[a]["located"],
                                                  style: TextStyle(
                                                      color: Colors.black))
                                            ],
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: getWidthPx(40),
                                              top: getWidthPx(15),
                                              right: getWidthPx(40)),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text(
                                                "房屋类别",
                                                style: TextStyle(
                                                    color: Colors.black45),
                                              ),
                                              Text(pledgeList[a]["sort"],
                                                  style: TextStyle(
                                                      color: Colors.black))
                                            ],
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: getWidthPx(40),
                                              top: getWidthPx(15),
                                              right: getWidthPx(40)),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text(
                                                "权属证明及编号",
                                                style: TextStyle(
                                                    color: Colors.black45),
                                              ),
                                              Text(pledgeList[a]["prove"],
                                                  style: TextStyle(
                                                      color: Colors.black))
                                            ],
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: getWidthPx(40),
                                              top: getWidthPx(15),
                                              right: getWidthPx(40)),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text(
                                                "建筑面积（㎡）",
                                                style: TextStyle(
                                                    color: Colors.black45),
                                              ),
                                              Text(pledgeList[a]["area"],
                                                  style: TextStyle(
                                                      color: Colors.black))
                                            ],
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: getWidthPx(40),
                                              top: getWidthPx(15),
                                              right: getWidthPx(40)),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text(
                                                "评估价值",
                                                style: TextStyle(
                                                    color: Colors.black45),
                                              ),
                                              Text(pledgeList[a]["cost"],
                                                  style: TextStyle(
                                                      color: Colors.black))
                                            ],
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: getWidthPx(40),
                                              top: getWidthPx(15),
                                              right: getWidthPx(40)),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text(
                                                "房屋产权人",
                                                style: TextStyle(
                                                    color: Colors.black45),
                                              ),
                                              Text(
                                                  "${pledgeList[a]["name"] ?? ""}",
                                                  style: TextStyle(
                                                      color: Colors.black))
                                            ],
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: getWidthPx(40),
                                              top: getWidthPx(15),
                                              right: getWidthPx(40)),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text(
                                                "产权人证件类型",
                                                style: TextStyle(
                                                    color: Colors.black45),
                                              ),
                                              Text(
                                                  "${pledgeList[a]["certificateType"] ?? ""}",
                                                  style: TextStyle(
                                                      color: Colors.black))
                                            ],
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: getWidthPx(40),
                                              top: getWidthPx(15),
                                              right: getWidthPx(40)),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text(
                                                "产权人证件号",
                                                style: TextStyle(
                                                    color: Colors.black45),
                                              ),
                                              Text(
                                                  "${pledgeList[a]["idCard"] ?? ""}",
                                                  style: TextStyle(
                                                      color: Colors.black))
                                            ],
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: getWidthPx(40),
                                              top: getWidthPx(15),
                                              right: getWidthPx(40)),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text(
                                                "联系方式",
                                                style: TextStyle(
                                                    color: Colors.black45),
                                              ),
                                              SizedBox(
                                                width: getWidthPx(20),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  "${pledgeList[a]["mobile"] ?? ""}",
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                  textAlign: TextAlign.right,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                            left: getWidthPx(40),
                                            top: getWidthPx(15),
                                            right: getWidthPx(40),
                                            bottom: getWidthPx(15),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text(
                                                "联系地址",
                                                style: TextStyle(
                                                    color: Colors.black45),
                                              ),
                                              SizedBox(
                                                width: getWidthPx(20),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  "${pledgeList[a]["address"] ?? ""}",
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                  textAlign: TextAlign.right,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        pledgeList[a]["shareList"].length > 0
                                            ? Container(
                                                padding: EdgeInsets.all(
                                                    getWidthPx(20)),
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    border: Border(
                                                        bottom: BorderSide(
                                                            color:
                                                                AppTheme.bg_c,
                                                            width: 1))),
                                                child: Row(
                                                  children: <Widget>[
                                                    SizedBox(
                                                        width: getWidthPx(10)),
                                                    Expanded(
                                                      child: Text(
                                                        "该房产下共有人信息",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 14),
                                                      ),
                                                    ),
                                                  ],
                                                ))
                                            : SizedBox(),
                                        pledgeList[a]["shareList"].length > 0
                                            ? Container(
                                                color: Colors.white,
                                                child: ListView.builder(
                                                    shrinkWrap: true,
                                                    physics:
                                                        NeverScrollableScrollPhysics(),
                                                    itemCount: pledgeList[a]
                                                            ["shareList"]
                                                        .length,
                                                    itemBuilder: (ctx, b) {
                                                      var item = pledgeList[a]
                                                          ["shareList"][b];
                                                      return Column(
                                                        children: <Widget>[
                                                          Container(
                                                            margin: EdgeInsets.only(
                                                                left:
                                                                    getWidthPx(
                                                                        40),
                                                                top: getWidthPx(
                                                                    15),
                                                                right:
                                                                    getWidthPx(
                                                                        40)),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: <
                                                                  Widget>[
                                                                Text(
                                                                  "共有人",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black45),
                                                                ),
                                                                Text(
                                                                    "${item["name"] ?? ""}",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black))
                                                              ],
                                                            ),
                                                          ),
                                                          Container(
                                                            margin: EdgeInsets.only(
                                                                left:
                                                                    getWidthPx(
                                                                        40),
                                                                top: getWidthPx(
                                                                    15),
                                                                right:
                                                                    getWidthPx(
                                                                        40)),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: <
                                                                  Widget>[
                                                                Text(
                                                                  "共有人证件类型",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black45),
                                                                ),
                                                                Text(
                                                                    "${item["certificateType"] ?? ""}",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black))
                                                              ],
                                                            ),
                                                          ),
                                                          Container(
                                                            margin: EdgeInsets.only(
                                                                left:
                                                                    getWidthPx(
                                                                        40),
                                                                top: getWidthPx(
                                                                    15),
                                                                right:
                                                                    getWidthPx(
                                                                        40)),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: <
                                                                  Widget>[
                                                                Text(
                                                                  "共有人证件号",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black45),
                                                                ),
                                                                Text(
                                                                    "${item["idCard"] ?? ""}",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black))
                                                              ],
                                                            ),
                                                          ),
                                                          Container(
                                                            margin: EdgeInsets.only(
                                                                left:
                                                                    getWidthPx(
                                                                        40),
                                                                top: getWidthPx(
                                                                    15),
                                                                right:
                                                                    getWidthPx(
                                                                        40)),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: <
                                                                  Widget>[
                                                                Text(
                                                                  "联系方式",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black45),
                                                                ),
                                                                SizedBox(
                                                                  width:
                                                                      getWidthPx(
                                                                          20),
                                                                ),
                                                                Expanded(
                                                                  child: Text(
                                                                    "${item["mobile"] ?? ""}",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .right,
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                          Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                              left: getWidthPx(
                                                                  40),
                                                              top: getWidthPx(
                                                                  15),
                                                              right: getWidthPx(
                                                                  40),
                                                              bottom:
                                                                  getWidthPx(
                                                                      15),
                                                            ),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: <
                                                                  Widget>[
                                                                Text(
                                                                  "联系地址",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black45),
                                                                ),
                                                                SizedBox(
                                                                  width:
                                                                      getWidthPx(
                                                                          20),
                                                                ),
                                                                Expanded(
                                                                  child: Text(
                                                                    "${item["address"] ?? ""}",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .right,
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                          Container(
                                                            height:
                                                                getHeightPx(20),
                                                            color:
                                                                AppTheme.bg_d,
                                                          ),
                                                        ],
                                                      );
                                                    }),
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
                          ),
                        ],
                      ),
                    ),
                  );
                });
          },
        ),
      ),
    );
  }

  Widget _renderWidget() {
    print("++++videoVm.userList.length+++++++++${videoVm.userList.length}");
    if (videoVm.userList == null || videoVm.userList.isEmpty) {
      return SizedBox();
    } else {
      return GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, //每行三列
            childAspectRatio: 1.0, //显示区域宽高相等
            mainAxisSpacing: 0,
            crossAxisSpacing: 0,
          ),
          itemCount: videoVm.userList.length,
          itemBuilder: (context, index) {
            return videoVm.userList[index]['name'] == "自己"
                ? RtcLocalView.SurfaceView()
                : RtcRemoteView.SurfaceView(
                    uid: videoVm.userList[index]['uid']);
          });
    }
  }
}

class CustomFloatingActionButtonLocation extends FloatingActionButtonLocation {
  FloatingActionButtonLocation location;
  double offsetX; // X方向的偏移量
  double offsetY; // Y方向的偏移量
  CustomFloatingActionButtonLocation(this.location, this.offsetX, this.offsetY);

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    Offset offset = location.getOffset(scaffoldGeometry);
    return Offset(offset.dx + offsetX, offset.dy + offsetY);
  }
}
