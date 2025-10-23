import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:notarization_station_app/appTheme.dart';
import 'package:notarization_station_app/base_framework/widget/provider_widget.dart';
import 'package:notarization_station_app/components/a_dialog/a_dialog.dart';
import 'package:notarization_station_app/page/home/vm/video_ing_model.dart';
import 'package:notarization_station_app/page/login/entity/user_info_entity.dart';
import 'package:notarization_station_app/page/login/vm/user_view_model.dart';
import 'package:notarization_station_app/routes/router.dart';
import 'package:notarization_station_app/utils/global.dart';
import 'package:provider/provider.dart';
import 'package:notarization_station_app/base_framework/widget_state/base_state.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../utils/common_tools.dart';

class VideoIngPage extends StatefulWidget {
  final arguments;

  VideoIngPage({Key key, this.arguments}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return VideoIngPageState();
  }
}

class VideoIngPageState extends BaseState<VideoIngPage>
    with WidgetsBindingObserver {
  VideoIngViewModel videoVm;
  UserInfoEntity userInfo;

  DateTime lastTopTime;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    wjPrint("--" + state.toString());
    switch (state) {
      case AppLifecycleState.inactive: // 处于这种状态的应用程序应该假设它们可能在任何时候暂停。
        // videoVm.engine.enableLocalVideo(false);
        break;
      case AppLifecycleState.resumed: // 应用程序可见，前台
        // videoVm.engine.enableLocalVideo(true);
        if (videoVm.isAlipay) {
          wjPrint('是否进入此代码块');
          videoVm.trtcCloud.muteLocalVideo(false);
        }
        if (videoVm.isWeChatPay) {
          videoVm.queryWechatResult(isFront: true);
        }
        break;
      case AppLifecycleState.paused: // 应用程序不可见，后台
        if (videoVm.isAlipay) {
          videoVm.trtcCloud.muteLocalVideo(true);
        }
        break;
      case AppLifecycleState.detached: // 申请将暂时暂停
        break;
    }
  }

  @override
  void dispose() {
    super.dispose();
    EasyLoading.dismiss();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () {
          if (lastTopTime == null ||
              DateTime.now().difference(lastTopTime) > Duration(seconds: 1)) {
            ADialog.confirm(context,
                content: "是否确认退出视频公证？",
                cancelButtonText: Text("取消"),
                confirmButtonText: Text("确认"), cancelButtonPress: () {
              Navigator.of(context).pop();
            }, confirmButtonPress: () {
              videoVm.closeSocket();
              videoVm.closeRoom();
              G.pop();
              G
                  .getCurrentState()
                  .popUntil(ModalRoute.withName(RoutePaths.HomeIndex));
            });
          }
          return Future.value(false);
        },
        child: Consumer<UserViewModel>(
          builder: (ctx, userModel, child) {
            return ProviderWidget<VideoIngViewModel>(
                model: VideoIngViewModel(userModel, widget.arguments['roomId'],
                    widget.arguments['orderInfo'], context),
                onModelReady: (model) async {
                  videoVm = model;
                  model.videoHeight = getHeightPx(1334) - getWidthPx(375);
                  model.initData();
                },
                builder: (ctx, vm, child) {
                  return Container(
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          _renderWidget(),
                          Container(
                            width: double.maxFinite,
                            height: getScreenWidth() / 8.5,
                            color: AppTheme.bg_d,
                            child: Image.asset(
                              vm.showType(),
                              fit: BoxFit.fill,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Offstage(
                            offstage: vm.showTab != 0,
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(getWidthPx(20)),
                                  decoration: BoxDecoration(
                                    border: const Border(
                                        bottom: BorderSide(
                                            width: 1, color: AppTheme.bg_c)),
                                  ),
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        width: getWidthPx(10),
                                        decoration: BoxDecoration(
                                          color: AppTheme.themeBlue,
                                          borderRadius:
                                              const BorderRadius.vertical(
                                                  top: Radius.circular(10),
                                                  bottom: Radius.circular(10)),
                                        ),
                                        height: getHeightPx(30),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 5.0),
                                        child: const Text(' 申请表'),
                                      )
                                    ],
                                  ),
                                ),
                                // Text(videoVm.userList.toString()),
                                MediaQuery.removePadding(
                                  removeTop: true,
                                  context: context,
                                  removeBottom: true,
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: vm.applicationForm.length,
                                      itemBuilder: (ctx, a) {
                                        return Column(
                                          children: <Widget>[
                                            Container(
                                              decoration: BoxDecoration(
                                                border: const Border(
                                                    bottom: BorderSide(
                                                        width: 1,
                                                        color: AppTheme.bg_c)),
                                              ),
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: getWidthPx(10)),
                                              padding: EdgeInsets.fromLTRB(
                                                  getWidthPx(40),
                                                  getWidthPx(20),
                                                  getWidthPx(40),
                                                  getWidthPx(20)),
                                              child: Row(
                                                children: <Widget>[
                                                  const Text('姓名',
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                      )),
                                                  Expanded(
                                                      child: Text(
                                                    "${vm.applicationForm[a]['name'] ?? ""}",
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: AppTheme
                                                            .deactivatedText),
                                                    textAlign: TextAlign.right,
                                                  )),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                border: Border(
                                                    bottom: const BorderSide(
                                                        width: 1,
                                                        color: AppTheme.bg_c)),
                                              ),
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: getWidthPx(10)),
                                              padding: EdgeInsets.fromLTRB(
                                                  getWidthPx(40),
                                                  getWidthPx(20),
                                                  getWidthPx(40),
                                                  getWidthPx(20)),
                                              child: Row(
                                                children: <Widget>[
                                                  const Text('身份证号',
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                      )),
                                                  Expanded(
                                                      child: Text(
                                                          vm.applicationForm[a]
                                                                  ['idCard'] ??
                                                              '',
                                                          style: const TextStyle(
                                                              fontSize: 16,
                                                              color: AppTheme
                                                                  .deactivatedText),
                                                          textAlign:
                                                              TextAlign.right)),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                border: Border(
                                                    bottom: const BorderSide(
                                                        width: 1,
                                                        color: AppTheme.bg_c)),
                                              ),
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: getWidthPx(10)),
                                              padding: EdgeInsets.fromLTRB(
                                                  getWidthPx(40),
                                                  getWidthPx(20),
                                                  getWidthPx(40),
                                                  getWidthPx(20)),
                                              child: Row(
                                                children: <Widget>[
                                                  const Text("地址"),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      "${vm.applicationForm[a]['address'] ?? ""}",
                                                      style: const TextStyle(
                                                          fontSize: 16,
                                                          color: AppTheme
                                                              .deactivatedText),
                                                      textAlign:
                                                          TextAlign.right,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                border: const Border(
                                                    bottom: BorderSide(
                                                        width: 1,
                                                        color: AppTheme.bg_c)),
                                              ),
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: getWidthPx(10)),
                                              padding: EdgeInsets.fromLTRB(
                                                  getWidthPx(40),
                                                  getWidthPx(20),
                                                  getWidthPx(40),
                                                  getWidthPx(20)),
                                              child: Row(
                                                children: <Widget>[
                                                  const Text('联系电话',
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                      )),
                                                  Expanded(
                                                      child: Text(
                                                          vm.applicationForm[a]
                                                                  ['mobile'] ??
                                                              '',
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              color: AppTheme
                                                                  .deactivatedText),
                                                          textAlign:
                                                              TextAlign.right)),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              color: AppTheme.bg_e,
                                              height: getWidthPx(20),
                                            ),
                                          ],
                                        );
                                      }),
                                ),

                                vm.agentForm.length != 0
                                    ? MediaQuery.removePadding(
                                        removeTop: true,
                                        context: context,
                                        removeBottom: true,
                                        child: ListView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            itemCount: vm.agentForm.length,
                                            itemBuilder: (ctx, a) {
                                              return Column(
                                                children: <Widget>[
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      border: const Border(
                                                          bottom: BorderSide(
                                                              width: 1,
                                                              color: AppTheme
                                                                  .bg_c)),
                                                    ),
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            horizontal:
                                                                getWidthPx(10)),
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            getWidthPx(40),
                                                            getWidthPx(20),
                                                            getWidthPx(40),
                                                            getWidthPx(20)),
                                                    child: Row(
                                                      children: <Widget>[
                                                        const Text('姓名',
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                            )),
                                                        Expanded(
                                                            child: Text(
                                                                vm.agentForm[a][
                                                                        'name'] ??
                                                                    '',
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    color: AppTheme
                                                                        .deactivatedText),
                                                                textAlign:
                                                                    TextAlign
                                                                        .right)),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      border: const Border(
                                                          bottom: BorderSide(
                                                              width: 1,
                                                              color: AppTheme
                                                                  .bg_c)),
                                                    ),
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            horizontal:
                                                                getWidthPx(10)),
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            getWidthPx(40),
                                                            getWidthPx(20),
                                                            getWidthPx(40),
                                                            getWidthPx(20)),
                                                    child: Row(
                                                      children: <Widget>[
                                                        const Expanded(
                                                          child: Text('性别',
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                              )),
                                                        ),
                                                        Text(
                                                          vm.agentForm[a][
                                                                      'gender'] ==
                                                                  1
                                                              ? '男'
                                                              : vm.agentForm[a][
                                                                          'gender'] ==
                                                                      0
                                                                  ? '女'
                                                                  : '',
                                                          style: const TextStyle(
                                                              fontSize: 16,
                                                              color: AppTheme
                                                                  .deactivatedText),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      border: const Border(
                                                          bottom: BorderSide(
                                                              width: 1,
                                                              color: AppTheme
                                                                  .bg_c)),
                                                    ),
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            horizontal:
                                                                getWidthPx(10)),
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            getWidthPx(40),
                                                            getWidthPx(20),
                                                            getWidthPx(40),
                                                            getWidthPx(20)),
                                                    child: Row(
                                                      children: <Widget>[
                                                        const Text('身份证号',
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                            )),
                                                        Expanded(
                                                            child: Text(
                                                                vm.agentForm[a][
                                                                        'idCard'] ??
                                                                    '',
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    color: AppTheme
                                                                        .deactivatedText),
                                                                textAlign:
                                                                    TextAlign
                                                                        .right)),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      border: Border(
                                                          bottom: BorderSide(
                                                              width: 1,
                                                              color: AppTheme
                                                                  .bg_c)),
                                                    ),
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            horizontal:
                                                                getWidthPx(10)),
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            getWidthPx(40),
                                                            getWidthPx(20),
                                                            getWidthPx(40),
                                                            getWidthPx(20)),
                                                    child: Row(
                                                      children: <Widget>[
                                                        const Text('被代理人',
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                            )),
                                                        Expanded(
                                                            child: Text(
                                                                vm.agentForm[a][
                                                                        'principal'] ??
                                                                    '',
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    color: AppTheme
                                                                        .deactivatedText),
                                                                textAlign:
                                                                    TextAlign
                                                                        .right)),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      border: const Border(
                                                          bottom: BorderSide(
                                                              width: 1,
                                                              color: AppTheme
                                                                  .bg_c)),
                                                    ),
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            horizontal:
                                                                getWidthPx(10)),
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            getWidthPx(40),
                                                            getWidthPx(20),
                                                            getWidthPx(40),
                                                            getWidthPx(20)),
                                                    child: Row(
                                                      children: <Widget>[
                                                        const Text('联系电话',
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                            )),
                                                        Expanded(
                                                            child: Text(
                                                                vm.agentForm[a][
                                                                        'mobile'] ??
                                                                    '',
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    color: AppTheme
                                                                        .deactivatedText),
                                                                textAlign:
                                                                    TextAlign
                                                                        .right)),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    color: AppTheme.bg_e,
                                                    height: getWidthPx(20),
                                                  ),
                                                ],
                                              );
                                            }),
                                      )
                                    : SizedBox(),

                                Container(
                                  color: AppTheme.bg_e,
                                  height: getWidthPx(30),
                                ),
                                vm.enterpriseForm.length != 0
                                    ? Container(
                                        padding: EdgeInsets.all(getWidthPx(20)),
                                        decoration: BoxDecoration(
                                          border: const Border(
                                              bottom: BorderSide(
                                                  width: 1,
                                                  color: AppTheme.bg_c)),
                                        ),
                                        child: Row(
                                          children: <Widget>[
                                            Container(
                                              width: getWidthPx(10),
                                              decoration: BoxDecoration(
                                                color: AppTheme.themeBlue,
                                                borderRadius: const BorderRadius
                                                        .vertical(
                                                    top: Radius.circular(10),
                                                    bottom:
                                                        Radius.circular(10)),
                                              ),
                                              height: getHeightPx(50),
                                            ),
                                            const Text(' 企业内容')
                                          ],
                                        ),
                                      )
                                    : SizedBox(),
                                vm.enterpriseForm.length != 0
                                    ? MediaQuery.removePadding(
                                        removeTop: true,
                                        context: context,
                                        removeBottom: true,
                                        child: ListView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            itemCount: vm.enterpriseForm.length,
                                            itemBuilder: (ctx, a) {
                                              return Column(
                                                children: <Widget>[
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      border: const Border(
                                                          bottom: BorderSide(
                                                              width: 1,
                                                              color: AppTheme
                                                                  .bg_c)),
                                                    ),
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            horizontal:
                                                                getWidthPx(10)),
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            getWidthPx(40),
                                                            getWidthPx(20),
                                                            getWidthPx(40),
                                                            getWidthPx(20)),
                                                    child: Row(
                                                      children: <Widget>[
                                                        const Text('单位名称',
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                            )),
                                                        Expanded(
                                                            child: Text(
                                                                vm.enterpriseForm[
                                                                            a][
                                                                        'companyName'] ??
                                                                    '',
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    color: AppTheme
                                                                        .deactivatedText),
                                                                textAlign:
                                                                    TextAlign
                                                                        .right)),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      border: const Border(
                                                          bottom: BorderSide(
                                                              width: 1,
                                                              color: AppTheme
                                                                  .bg_c)),
                                                    ),
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            horizontal:
                                                                getWidthPx(10)),
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            getWidthPx(40),
                                                            getWidthPx(20),
                                                            getWidthPx(40),
                                                            getWidthPx(20)),
                                                    child: Row(
                                                      children: <Widget>[
                                                        const Text('法定代表人',
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                            )),
                                                        Expanded(
                                                            child: Text(
                                                                vm.enterpriseForm[
                                                                            a][
                                                                        'statutoryPerson'] ??
                                                                    '',
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    color: AppTheme
                                                                        .deactivatedText),
                                                                textAlign:
                                                                    TextAlign
                                                                        .right)),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      border: const Border(
                                                          bottom: BorderSide(
                                                              width: 1,
                                                              color: AppTheme
                                                                  .bg_c)),
                                                    ),
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            horizontal:
                                                                getWidthPx(10)),
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            getWidthPx(40),
                                                            getWidthPx(20),
                                                            getWidthPx(40),
                                                            getWidthPx(20)),
                                                    child: Row(
                                                      children: <Widget>[
                                                        const Text('电话',
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                            )),
                                                        Expanded(
                                                            child: Text(
                                                                vm.enterpriseForm[
                                                                            a][
                                                                        'statutoryMobile'] ??
                                                                    '',
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    color: AppTheme
                                                                        .deactivatedText),
                                                                textAlign:
                                                                    TextAlign
                                                                        .right)),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      border: const Border(
                                                          bottom: BorderSide(
                                                              width: 1,
                                                              color: AppTheme
                                                                  .bg_c)),
                                                    ),
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            horizontal:
                                                                getWidthPx(10)),
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            getWidthPx(40),
                                                            getWidthPx(20),
                                                            getWidthPx(40),
                                                            getWidthPx(20)),
                                                    child: Row(
                                                      children: <Widget>[
                                                        const Text('地址',
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                            )),
                                                        Expanded(
                                                            child: Text(
                                                                vm.enterpriseForm[
                                                                            a][
                                                                        'companyAdd'] ??
                                                                    '',
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    color: AppTheme
                                                                        .deactivatedText),
                                                                textAlign:
                                                                    TextAlign
                                                                        .right)),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    color: AppTheme.bg_e,
                                                    height: getWidthPx(20),
                                                  ),
                                                ],
                                              );
                                            }),
                                      )
                                    : SizedBox(),

                                Container(
                                  color: AppTheme.bg_e,
                                  height: vm.enterpriseForm.length != 0
                                      ? getWidthPx(30)
                                      : 0,
                                ),
                                Container(
                                  padding: EdgeInsets.all(getWidthPx(20)),
                                  decoration: BoxDecoration(
                                    border: const Border(
                                        bottom: BorderSide(
                                            width: 1, color: AppTheme.bg_c)),
                                  ),
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        width: getWidthPx(10),
                                        decoration: BoxDecoration(
                                          color: AppTheme.themeBlue,
                                          borderRadius:
                                              const BorderRadius.vertical(
                                                  top: Radius.circular(10),
                                                  bottom: Radius.circular(10)),
                                        ),
                                        height: getHeightPx(30),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 5),
                                        child: const Text(' 公证内容'),
                                      )
                                    ],
                                  ),
                                ),

                                Container(
                                  decoration: BoxDecoration(
                                    border: const Border(
                                        bottom: BorderSide(
                                            width: 1, color: AppTheme.bg_c)),
                                  ),
                                  margin: EdgeInsets.symmetric(
                                      horizontal: getWidthPx(10)),
                                  padding: EdgeInsets.fromLTRB(
                                      getWidthPx(40),
                                      getWidthPx(20),
                                      getWidthPx(40),
                                      getWidthPx(20)),
                                  child: Row(
                                    children: <Widget>[
                                      const Text('证书用途',
                                          style: TextStyle(
                                            fontSize: 16,
                                          )),
                                      Expanded(
                                          child: Text(
                                              vm.contentForm['yongtu'] == null
                                                  ? ""
                                                  : vm.contentForm['yongtu'],
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  color:
                                                      AppTheme.deactivatedText),
                                              textAlign: TextAlign.right)),
                                    ],
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    border: const Border(
                                        bottom: BorderSide(
                                            width: 1, color: AppTheme.bg_c)),
                                  ),
                                  margin: EdgeInsets.symmetric(
                                      horizontal: getWidthPx(10)),
                                  padding: EdgeInsets.fromLTRB(
                                      getWidthPx(40),
                                      getWidthPx(20),
                                      getWidthPx(40),
                                      getWidthPx(20)),
                                  child: Row(
                                    children: <Widget>[
                                      const Text('使用地',
                                          style: TextStyle(
                                            fontSize: 16,
                                          )),
                                      Expanded(
                                          child: Text(
                                              vm.contentForm['area'] == null
                                                  ? ""
                                                  : vm.contentForm['area'],
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  color:
                                                      AppTheme.deactivatedText),
                                              textAlign: TextAlign.right)),
                                    ],
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    border: const Border(
                                        bottom: BorderSide(
                                            width: 1, color: AppTheme.bg_c)),
                                  ),
                                  margin: EdgeInsets.symmetric(
                                      horizontal: getWidthPx(10)),
                                  padding: EdgeInsets.fromLTRB(
                                      getWidthPx(40),
                                      getWidthPx(20),
                                      getWidthPx(40),
                                      getWidthPx(20)),
                                  child: Row(
                                    children: <Widget>[
                                      const Text('翻译语种',
                                          style: TextStyle(
                                            fontSize: 16,
                                          )),
                                      Expanded(
                                          child: Text(
                                              vm.contentForm['lang'] == null
                                                  ? ""
                                                  : vm.contentForm['lang'],
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  color:
                                                      AppTheme.deactivatedText),
                                              textAlign: TextAlign.right)),
                                    ],
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    border: const Border(
                                        bottom: BorderSide(
                                            width: 1, color: AppTheme.bg_c)),
                                  ),
                                  margin: EdgeInsets.symmetric(
                                      horizontal: getWidthPx(10)),
                                  padding: EdgeInsets.fromLTRB(
                                      getWidthPx(40),
                                      getWidthPx(20),
                                      getWidthPx(40),
                                      getWidthPx(20)),
                                  child: Row(
                                    children: <Widget>[
                                      const Text('公证事项',
                                          style: TextStyle(
                                            fontSize: 16,
                                          )),
                                      Expanded(
                                          child: Text(
                                              vm.contentForm[
                                                          'gongzhengValue'] ==
                                                      null
                                                  ? ""
                                                  : vm.contentForm[
                                                      'gongzhengValue'],
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  color:
                                                      AppTheme.deactivatedText),
                                              textAlign: TextAlign.right)),
                                    ],
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    border: const Border(
                                        bottom: BorderSide(
                                            width: 1, color: AppTheme.bg_c)),
                                  ),
                                  margin: EdgeInsets.symmetric(
                                      horizontal: getWidthPx(10)),
                                  padding: EdgeInsets.fromLTRB(
                                      getWidthPx(40),
                                      getWidthPx(20),
                                      getWidthPx(40),
                                      getWidthPx(20)),
                                  child: Row(
                                    children: <Widget>[
                                      const Text('公证材料',
                                          style: TextStyle(
                                            fontSize: 16,
                                          )),
                                      Expanded(
                                          child: Text(
                                              vm.contentForm['cailiaoValue'] ==
                                                      null
                                                  ? ""
                                                  : vm.contentForm[
                                                      'cailiaoValue'],
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  color:
                                                      AppTheme.deactivatedText),
                                              textAlign: TextAlign.right)),
                                    ],
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    border: const Border(
                                        bottom: BorderSide(
                                            width: 1, color: AppTheme.bg_c)),
                                  ),
                                  margin: EdgeInsets.symmetric(
                                      horizontal: getWidthPx(10)),
                                  padding: EdgeInsets.fromLTRB(
                                      getWidthPx(40),
                                      getWidthPx(20),
                                      getWidthPx(40),
                                      getWidthPx(20)),
                                  child: Row(
                                    children: <Widget>[
                                      const Text('备注',
                                          style: TextStyle(
                                            fontSize: 16,
                                          )),
                                      Expanded(
                                          child: Text(
                                              vm.contentForm['remark'] == null
                                                  ? ""
                                                  : vm.contentForm['remark'],
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  color:
                                                      AppTheme.deactivatedText),
                                              textAlign: TextAlign.right)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Offstage(
                            offstage: vm.showTab != 1,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: MediaQuery.removePadding(
                                context: context,
                                removeTop: true,
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
                                    itemCount: vm.imgList.length + 1,
                                    itemBuilder: (context, index) {
                                      return releaseImage(
                                          index == vm.imgList.length,
                                          index != vm.imgList.length
                                              ? vm.imgList[index]
                                              : null);
                                    }),
                              ),
                            ),
                          ),
                          Offstage(
                            offstage: vm.showTab != 2,
                            child: Padding(
                              padding: EdgeInsets.all(20),
                              child: const Text(
                                '公证员正在编辑文书，请稍等',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Offstage(
                            offstage: vm.showTab != 3,
                            child: Padding(
                              padding: EdgeInsets.all(20),
                              child: const Text(
                                '请如实回答公证员的提问',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Offstage(
                            offstage: vm.showTab != 4,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: getWidthPx(8)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    width: getWidthPx(750),
                                    height: 50,
                                    alignment: Alignment.centerLeft,
                                    padding: EdgeInsets.symmetric(
                                        vertical: getWidthPx(20)),
                                    decoration: new BoxDecoration(
                                      color: Colors.white,
                                      border: new Border.all(
                                          width: 1, color: Colors.black),
                                    ),
                                    child: Text(
                                        '受理单号:   ${vm.orderInfo.unitGuid.orderNo ?? ''}'),
                                  ),
                                  Container(
                                    width: getWidthPx(750),
                                    height: 50,
                                    alignment: Alignment.centerLeft,
                                    padding: EdgeInsets.symmetric(
                                        vertical: getWidthPx(20)),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: const Border(
                                            left: BorderSide(
                                                width: 1, color: Colors.black),
                                            right: BorderSide(
                                                width: 1, color: Colors.black),
                                            bottom: BorderSide(
                                                width: 1,
                                                color: Colors.black))),
                                    child: Text(
                                        '受理日期:   ${vm.orderInfo.unitGuid.createDate != null && vm.orderInfo.unitGuid.createDate.length > 10 ? vm.orderInfo.unitGuid.createDate.substring(0,10):vm.orderInfo.unitGuid.createDate}'),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        width: getWidthPx(183.5),
                                        height: 60,
                                        alignment: Alignment.centerLeft,
                                        padding: EdgeInsets.symmetric(
                                            vertical: getWidthPx(20)),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: const Border(
                                                left: BorderSide(
                                                    width: 1,
                                                    color: Colors.black),
                                                right: BorderSide(
                                                    width: 1,
                                                    color: Colors.black),
                                                bottom: BorderSide(
                                                    width: 1,
                                                    color: Colors.black))),
                                        child: const Text('申请人'),
                                      ),
                                      Container(
                                        width: getWidthPx(183.5),
                                        height: 60,
                                        alignment: Alignment.centerLeft,
                                        // padding: EdgeInsets.symmetric(
                                        //     vertical: getWidthPx(20)),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: const Border(
                                              right: BorderSide(
                                                  width: 1,
                                                  color: Colors.black),
                                              bottom: BorderSide(
                                                  width: 1,
                                                  color: Colors.black)),
                                        ),
                                        child: AutoSizeText(
                                          "${vm.getApplication()}",
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 6,
                                        ),
                                      ),
                                      Container(
                                        width: getWidthPx(183.5),
                                        height: 60,
                                        alignment: Alignment.centerLeft,
                                        padding: EdgeInsets.symmetric(
                                            vertical: getWidthPx(20)),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: const Border(
                                              right: BorderSide(
                                                  width: 1,
                                                  color: Colors.black),
                                              bottom: BorderSide(
                                                  width: 1,
                                                  color: Colors.black)),
                                        ),
                                        child: const Text('承办人'),
                                      ),
                                      Container(
                                        width: getWidthPx(183.5),
                                        height: 60,
                                        alignment: Alignment.centerLeft,
                                        padding: EdgeInsets.symmetric(
                                            vertical: getWidthPx(20)),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: const Border(
                                              right: BorderSide(
                                                  width: 1,
                                                  color: Colors.black),
                                              bottom: BorderSide(
                                                  width: 1,
                                                  color: Colors.black)),
                                        ),
                                        child: AutoSizeText(
                                          widget.arguments['greffierName'] ??
                                              '',
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 6,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        width: getWidthPx(183.5),
                                        height: 50,
                                        alignment: Alignment.centerLeft,
                                        padding: EdgeInsets.symmetric(
                                            vertical: getWidthPx(20)),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: const Border(
                                                left: BorderSide(
                                                    width: 1,
                                                    color: Colors.black),
                                                right: BorderSide(
                                                    width: 1,
                                                    color: Colors.black),
                                                bottom: BorderSide(
                                                    width: 1,
                                                    color: Colors.black))),
                                        child: const Text('公证用途'),
                                      ),
                                      Expanded(
                                        child: Container(
                                          height: 50,
                                          alignment: Alignment.centerLeft,
                                          padding: EdgeInsets.symmetric(
                                              vertical: getWidthPx(20)),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: const Border(
                                                right: BorderSide(
                                                    width: 1,
                                                    color: Colors.black),
                                                bottom: BorderSide(
                                                    width: 1,
                                                    color: Colors.black)),
                                          ),
                                          child: AutoSizeText(
                                            vm.contentForm['yongtu'] == null
                                                ? ""
                                                : vm.contentForm['yongtu'],
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 6,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        width: getWidthPx(183.5),
                                        height: 80,
                                        alignment: Alignment.centerLeft,
                                        padding: EdgeInsets.symmetric(
                                            vertical: getWidthPx(20)),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: const Border(
                                                left: BorderSide(
                                                    width: 1,
                                                    color: Colors.black),
                                                right: BorderSide(
                                                    width: 1,
                                                    color: Colors.black),
                                                bottom: BorderSide(
                                                    width: 1,
                                                    color: Colors.black))),
                                        child: const Text('发证地点'),
                                      ),
                                      Expanded(
                                        child: Container(
                                          height: 80,
                                          alignment: Alignment.centerLeft,
                                          padding: EdgeInsets.symmetric(
                                              vertical: getWidthPx(20)),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: const Border(
                                                right: BorderSide(
                                                    width: 1,
                                                    color: Colors.black),
                                                bottom: BorderSide(
                                                    width: 1,
                                                    color: Colors.black)),
                                          ),
                                          child: AutoSizeText(
                                            '${vm.costMap['address'] == null ? "" : vm.costMap['address']}',
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 6,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        width: getWidthPx(183.5),
                                        height: 80,
                                        alignment: Alignment.centerLeft,
                                        padding: EdgeInsets.symmetric(
                                            vertical: getWidthPx(20)),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: const Border(
                                                left: BorderSide(
                                                    width: 1,
                                                    color: Colors.black),
                                                right: BorderSide(
                                                    width: 1,
                                                    color: Colors.black),
                                                bottom: BorderSide(
                                                    width: 1,
                                                    color: Colors.black))),
                                        child: const Text('公证事项'),
                                      ),
                                      Expanded(
                                        child: Container(
                                          height: 80,
                                          alignment: Alignment.centerLeft,
                                          padding: EdgeInsets.symmetric(
                                              vertical: getWidthPx(20)),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: const Border(
                                                right: BorderSide(
                                                    width: 1,
                                                    color: Colors.black),
                                                bottom: BorderSide(
                                                    width: 1,
                                                    color: Colors.black)),
                                          ),
                                          child: AutoSizeText(
                                            vm.contentForm['gongzhengValue'] ==
                                                    null
                                                ? ""
                                                : vm.contentForm[
                                                    'gongzhengValue'],
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 6,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        width: getWidthPx(180),
                                        height: 50,
                                        alignment: Alignment.centerLeft,
                                        padding: EdgeInsets.symmetric(
                                            vertical: getWidthPx(20)),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: const Border(
                                                left: BorderSide(
                                                    width: 1,
                                                    color: Colors.black),
                                                right: BorderSide(
                                                    width: 1,
                                                    color: Colors.black),
                                                bottom: BorderSide(
                                                    width: 1,
                                                    color: Colors.black))),
                                        child: const Text('公证费'),
                                      ),
                                      Container(
                                        width: getWidthPx(180),
                                        height: 50,
                                        alignment: Alignment.centerLeft,
                                        padding: EdgeInsets.symmetric(
                                            vertical: getWidthPx(20)),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: const Border(
                                              right: BorderSide(
                                                  width: 1,
                                                  color: Colors.black),
                                              bottom: BorderSide(
                                                  width: 1,
                                                  color: Colors.black)),
                                        ),
                                        child: const Text('法律服务费'),
                                      ),
                                      Container(
                                        width: getWidthPx(194),
                                        height: 50,
                                        alignment: Alignment.centerLeft,
                                        padding: EdgeInsets.symmetric(
                                            vertical: getWidthPx(20)),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: const Border(
                                              right: BorderSide(
                                                  width: 1,
                                                  color: Colors.black),
                                              bottom: BorderSide(
                                                  width: 1,
                                                  color: Colors.black)),
                                        ),
                                        child: const Text('摄像、拍照费'),
                                      ),
                                      Container(
                                        width: getWidthPx(180),
                                        height: 50,
                                        alignment: Alignment.centerLeft,
                                        padding: EdgeInsets.symmetric(
                                            vertical: getWidthPx(20)),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: const Border(
                                              right: BorderSide(
                                                  width: 1,
                                                  color: Colors.black),
                                              bottom: BorderSide(
                                                  width: 1,
                                                  color: Colors.black)),
                                        ),
                                        child: const Text('上门服务费'),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        width: getWidthPx(180),
                                        height: 50,
                                        alignment: Alignment.centerLeft,
                                        padding: EdgeInsets.symmetric(
                                            vertical: getWidthPx(20)),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: const Border(
                                                left: BorderSide(
                                                    width: 1,
                                                    color: Colors.black),
                                                right: BorderSide(
                                                    width: 1,
                                                    color: Colors.black),
                                                bottom: BorderSide(
                                                    width: 1,
                                                    color: Colors.black))),
                                        child: Text(vm.costMap['notarize'] == ''
                                            ? '  0 元'
                                            : '  ${vm.costMap['notarize']}元'),
                                      ),
                                      Container(
                                        width: getWidthPx(180),
                                        height: 50,
                                        alignment: Alignment.centerLeft,
                                        padding: EdgeInsets.symmetric(
                                            vertical: getWidthPx(20)),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: const Border(
                                              right: BorderSide(
                                                  width: 1,
                                                  color: Colors.black),
                                              bottom: BorderSide(
                                                  width: 1,
                                                  color: Colors.black)),
                                        ),
                                        child: Text(vm.costMap['law'] == ''
                                            ? '  0 元'
                                            : '  ${vm.costMap['law']}元'),
                                      ),
                                      Container(
                                        width: getWidthPx(194),
                                        height: 50,
                                        alignment: Alignment.centerLeft,
                                        padding: EdgeInsets.symmetric(
                                            vertical: getWidthPx(20)),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: const Border(
                                              right: BorderSide(
                                                  width: 1,
                                                  color: Colors.black),
                                              bottom: BorderSide(
                                                  width: 1,
                                                  color: Colors.black)),
                                        ),
                                        child: Text(vm.costMap['photograph'] ==
                                                ''
                                            ? '  0 元'
                                            : '  ${vm.costMap['photograph']}元'),
                                      ),
                                      Container(
                                        width: getWidthPx(180),
                                        height: 50,
                                        alignment: Alignment.centerLeft,
                                        padding: EdgeInsets.symmetric(
                                            vertical: getWidthPx(20)),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: const Border(
                                              right: BorderSide(
                                                  width: 1,
                                                  color: Colors.black),
                                              bottom: BorderSide(
                                                  width: 1,
                                                  color: Colors.black)),
                                        ),
                                        child: Text(vm.costMap['visit'] == ''
                                            ? '  0 元'
                                            : '  ${vm.costMap['visit']}元'),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    width: getWidthPx(750),
                                    height: 50,
                                    alignment: Alignment.centerLeft,
                                    padding: EdgeInsets.symmetric(
                                        vertical: getWidthPx(20)),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: const Border(
                                            left: BorderSide(
                                                width: 1, color: Colors.black),
                                            right: BorderSide(
                                                width: 1, color: Colors.black),
                                            bottom: BorderSide(
                                                width: 1,
                                                color: Colors.black))),
                                    child: Text(
                                        '其他收费：${vm.costMap['others'] ?? ''}元'),
                                  ),
                                  Container(
                                    width: getWidthPx(750),
                                    height: 50,
                                    alignment: Alignment.centerLeft,
                                    padding: EdgeInsets.symmetric(
                                        vertical: getWidthPx(20)),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: const Border(
                                            left: BorderSide(
                                                width: 1, color: Colors.black),
                                            right: BorderSide(
                                                width: 1, color: Colors.black),
                                            bottom: BorderSide(
                                                width: 1,
                                                color: Colors.black))),
                                    child: Text('合计：${vm.total()}元'),
                                  ),
                                ],
                              ),
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

  Widget releaseImage(bool isDef, Asset asset) {
    return isDef && videoVm.showUpload
        ? InkWell(
            onTap: () {
              videoVm.requestCameraPermission();
            },
            child: Image.asset("lib/assets/images/add_img.png"))
        : ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: AssetThumb(
              asset: asset,
              width: 500,
              height: 500,
            ),
          );
  }

  Widget _renderWidget() {
    wjPrint("++++videoVm.userList+++++++++${videoVm.userList}");
    if (videoVm.userList == null || videoVm.userList.isEmpty) {
      return SizedBox();
    } else {
      return MediaQuery.removePadding(
        context: context,
        removeBottom: true,
        child: GridView.builder(
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
              // return videoVm.userList[index]['widget']!=null?videoVm.userList[index]['widget']:SizedBox();
              return Stack(
                children: [
                  videoVm.userList[index]['widget'] != null
                      ? videoVm.userList[index]['widget']
                      : SizedBox(),
                  videoVm.userList[index]['userId'] ==
                          videoVm.userViewModel.idCard
                      ? Positioned(
                          right: 0,
                          child: InkWell(
                            onTap: () {
                              if(videoVm.isCameraReady){
                                videoVm.txDeviceManager.switchCamera(
                                    videoVm.camerasNum == 0 ? true : false);
                                videoVm.camerasNum =
                                videoVm.camerasNum == 0 ? 1 : 0;
                                // videoVm.trtcCloud.stopScreenCapture();
                                setState(() {});
                              }
                            },
                            child: ColoredBox(
                              color: Color(0x66ffffff),
                              child: Icon(Icons.autorenew),
                            ),
                          ),
                        )
                      : SizedBox()
                ],
              );
            }),
      );
    }
  }
}
