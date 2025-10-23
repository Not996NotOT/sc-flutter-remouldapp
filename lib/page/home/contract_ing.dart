import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:notarization_station_app/appTheme.dart';
import 'package:notarization_station_app/base_framework/widget/provider_widget.dart';
import 'package:notarization_station_app/base_framework/widget_state/base_state.dart';
import 'package:notarization_station_app/components/a_dialog/a_dialog.dart';
import 'package:notarization_station_app/page/home/vm/contract_ing_model.dart';
import 'package:notarization_station_app/page/login/entity/user_info_entity.dart';
import 'package:notarization_station_app/page/login/vm/user_view_model.dart';
import 'package:notarization_station_app/routes/router.dart';
import 'package:notarization_station_app/utils/common_tools.dart';
import 'package:notarization_station_app/utils/global.dart';
import 'package:provider/provider.dart';

class ContractIngPage extends StatefulWidget {
  final arguments;
  // final ContractEntity  arguments;

  ContractIngPage({Key key, this.arguments}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return ContractIngPageState();
  }
}

class ContractIngPageState extends BaseState<ContractIngPage>
    with WidgetsBindingObserver {
  ContractIngViewModel contractVm;
  UserInfoEntity userInfo;

  @override
  void initState() {
    super.initState();
    // Wakelock.enable();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    wjPrint("--" + state.toString());
    // switch (state) {
    //   case AppLifecycleState.inactive: // 处于这种状态的应用程序应该假设它们可能在任何时候暂停。
    //     contractVm.engine.enableLocalVideo(false);
    //     break;
    //   case AppLifecycleState.resumed: // 应用程序可见，前台
    //     contractVm.engine.enableLocalVideo(true);
    //     break;
    //   case AppLifecycleState.paused: // 应用程序不可见，后台
    //     break;
    //   case AppLifecycleState.detached: // 申请将暂时暂停
    //     break;
    // }
  }

  @override
  void dispose() {
    super.dispose();
    contractVm.closeRoom();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () {
          ADialog.confirm(context,
              content: "是否确认退出合同公证？",
              cancelButtonText: Text("取消"),
              confirmButtonText: Text("确认"), cancelButtonPress: () {
            Navigator.of(context).pop();
          }, confirmButtonPress: () {
            contractVm.closeSocket();
            contractVm.destoryRoom();
            G.pop();
            G
                .getCurrentState()
                .popUntil(ModalRoute.withName(RoutePaths.HomeIndex));
          });
          return Future.value(false);
        },
        child: Consumer<UserViewModel>(
          builder: (ctx, userModel, child) {
            return ProviderWidget<ContractIngViewModel>(
                model: ContractIngViewModel(userModel, widget.arguments),
                onModelReady: (model) async {
                  contractVm = model;
                  model.videoHeight = getHeightPx(1334) - getWidthPx(400);
                  model.initData();
                },
                builder: (ctx, vm, child) {
                  wjPrint('vm.contractInfo: ' + vm.contractInfo.toString());
                  return SingleChildScrollView(
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
                                      padding: const EdgeInsets.only(left: 5),
                                      child: const Text(' 邀请人信息',
                                          style: TextStyle(
                                            fontSize: 16,
                                          )),
                                    )
                                  ],
                                ),
                              ),
                              // Text(widget.arguments.toString()),
                              // Text(vm.contractInfo.toString()),
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
                                    const Text('姓名',
                                        style: TextStyle(
                                          fontSize: 16,
                                        )),
                                    Expanded(
                                        child: Text(
                                      vm.contractInfo['inviterObj']['name'] ??
                                          '',
                                      style: const TextStyle(
                                          fontSize: 16,
                                          color: AppTheme.deactivatedText),
                                      textAlign: TextAlign.right,
                                    )),
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
                                    const Text('身份证号',
                                        style: TextStyle(
                                          fontSize: 16,
                                        )),
                                    Expanded(
                                        child: Text(
                                            vm.contractInfo['inviterObj']
                                                    ['idCard'] ??
                                                '',
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
                                    const Text("地址"),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Text(
                                        "${vm.contractInfo['inviterObj']['address'] ?? ""}",
                                        style: const TextStyle(
                                            fontSize: 16,
                                            color: AppTheme.deactivatedText),
                                        textAlign: TextAlign.right,
                                      ),
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
                                    const Text('联系电话',
                                        style: TextStyle(
                                          fontSize: 16,
                                        )),
                                    Expanded(
                                        child: Text(
                                            vm.contractInfo['inviterObj']
                                                    ['mobile'] ??
                                                '',
                                            style: const TextStyle(
                                                fontSize: 16,
                                                color:
                                                    AppTheme.deactivatedText),
                                            textAlign: TextAlign.right)),
                                  ],
                                ),
                              ),
                              Container(
                                color: AppTheme.bg_e,
                                height: getWidthPx(20),
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
                                        borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(10),
                                            bottom: Radius.circular(10)),
                                      ),
                                      height: getHeightPx(30),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.only(left: 5.0),
                                      child: Text(
                                        ' 被邀请人信息',
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              MediaQuery.removePadding(
                                removeTop: true,
                                removeBottom: true,
                                context: context,
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: vm
                                        .contractInfo['thirdpartyusers'].length,
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
                                                  vm.contractInfo[
                                                              'thirdpartyusers']
                                                          [a]['name'] ??
                                                      '',
                                                  style: const TextStyle(
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
                                                const Text('身份证号',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                    )),
                                                Expanded(
                                                    child: Text(
                                                        vm.contractInfo[
                                                                    'thirdpartyusers']
                                                                [a]['idCard'] ??
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
                                                const Text("地址"),
                                                Expanded(
                                                  child: Text(
                                                    vm.contractInfo[
                                                                'thirdpartyusers']
                                                            [a]['address'] ??
                                                        "",
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        color: AppTheme
                                                            .deactivatedText),
                                                    textAlign: TextAlign.right,
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
                                                        vm.contractInfo[
                                                                    'thirdpartyusers']
                                                                [a]['mobile'] ??
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
                                            color: AppTheme.bg_e,
                                            height: getWidthPx(20),
                                          ),
                                        ],
                                      );
                                    }),
                              ),
                              vm.contractInfo['agencyArr'] != null &&
                                      vm.contractInfo['agencyArr'].isNotEmpty
                                  ? Column(
                                      children: [
                                        Container(
                                          padding:
                                              EdgeInsets.all(getWidthPx(20)),
                                          decoration: BoxDecoration(
                                            border: Border(
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
                                                  borderRadius:
                                                      BorderRadius.vertical(
                                                          top: Radius.circular(
                                                              10),
                                                          bottom:
                                                              Radius.circular(
                                                                  10)),
                                                ),
                                                height: getHeightPx(30),
                                              ),
                                              Text(' 代理人')
                                            ],
                                          ),
                                        ),
                                        // Text(widget.arguments.toString()),
                                        // Text(vm.contractInfo.toString()),
                                        MediaQuery.removePadding(
                                          removeTop: true,
                                          context: context,
                                          child: ListView.builder(
                                              itemCount: vm
                                                  .contractInfo['agencyArr']
                                                  .length,
                                              shrinkWrap: true,
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              itemBuilder: (context, index) {
                                                var item =
                                                    vm.contractInfo['agencyArr']
                                                        [index];
                                                return Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
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
                                                                  getWidthPx(
                                                                      10)),
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              getWidthPx(40),
                                                              getWidthPx(20),
                                                              getWidthPx(40),
                                                              getWidthPx(20)),
                                                      child: Row(
                                                        children: <Widget>[
                                                          Text('姓名',
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                              )),
                                                          Expanded(
                                                              child: Text(
                                                            item['name'] ?? '',
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                color: AppTheme
                                                                    .deactivatedText),
                                                            textAlign:
                                                                TextAlign.right,
                                                          )),
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
                                                                  getWidthPx(
                                                                      10)),
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              getWidthPx(40),
                                                              getWidthPx(20),
                                                              getWidthPx(40),
                                                              getWidthPx(20)),
                                                      child: Row(
                                                        children: <Widget>[
                                                          Text('身份证号',
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                              )),
                                                          Expanded(
                                                              child: Text(
                                                                  item['idCard'] ??
                                                                      '',
                                                                  style: TextStyle(
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
                                                                  getWidthPx(
                                                                      10)),
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              getWidthPx(40),
                                                              getWidthPx(20),
                                                              getWidthPx(40),
                                                              getWidthPx(20)),
                                                      child: Row(
                                                        children: <Widget>[
                                                          Text("被代理人"),
                                                          Expanded(
                                                            child: Text(
                                                              "${item['principal'] ?? ""}",
                                                              style: TextStyle(
                                                                  fontSize: 16,
                                                                  color: AppTheme
                                                                      .deactivatedText),
                                                              textAlign:
                                                                  TextAlign
                                                                      .right,
                                                            ),
                                                          )
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
                                                                  getWidthPx(
                                                                      10)),
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              getWidthPx(40),
                                                              getWidthPx(20),
                                                              getWidthPx(40),
                                                              getWidthPx(20)),
                                                      child: Row(
                                                        children: <Widget>[
                                                          Text('联系电话',
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                              )),
                                                          Expanded(
                                                              child: Text(
                                                                  item['mobile'] ??
                                                                      '',
                                                                  style: TextStyle(
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
                                      ],
                                    )
                                  : SizedBox(),
                              Offstage(
                                offstage: vm.contractInfo['Companys'] == null ||
                                    vm.contractInfo['Companys'] != null &&
                                        vm.contractInfo['Companys'].isEmpty,
                                child: Container(
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
                                          borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(10),
                                              bottom: Radius.circular(10)),
                                        ),
                                        height: getHeightPx(30),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.only(left: 5.0),
                                        child: Text(
                                          ' 公司信息',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              MediaQuery.removePadding(
                                removeTop: true,
                                removeBottom: true,
                                context: context,
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount:
                                        vm.contractInfo['Companys'].length,
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
                                                const Text('名称',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                    )),
                                                Expanded(
                                                    child: Text(
                                                  vm.contractInfo['Companys'][a]
                                                          ['companyName'] ??
                                                      "",
                                                  style: const TextStyle(
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
                                                const Text('法定代表人',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                    )),
                                                Expanded(
                                                    child: Text(
                                                        vm.contractInfo[
                                                                    'Companys'][a]
                                                                [
                                                                'statutoryPerson'] ??
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
                                                const Text("地址"),
                                                Expanded(
                                                  child: Text(
                                                    vm.contractInfo['Companys']
                                                            [a]['companyAdd'] ??
                                                        "",
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        color: AppTheme
                                                            .deactivatedText),
                                                    textAlign: TextAlign.right,
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
                                                        vm.contractInfo[
                                                                    'Companys'][a]
                                                                [
                                                                'statutoryMobile'] ??
                                                            "",
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
                                            color: AppTheme.bg_e,
                                            height: getWidthPx(20),
                                          ),
                                        ],
                                      );
                                    }),
                              ),

                              Container(
                                padding: EdgeInsets.all(getWidthPx(20)),
                                decoration: BoxDecoration(
                                  border: Border(
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
                                    const Padding(
                                      padding: const EdgeInsets.only(left: 5.0),
                                      child: Text(
                                        ' 公证内容',
                                        style: TextStyle(fontSize: 16),
                                      ),
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
                                            vm.contentForm['gongzhengValue'] ==
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
                                  border: Border(
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
                            padding: const EdgeInsets.symmetric(horizontal: 10),
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
                                  itemCount: vm.imgList.length == 9
                                      ? 9
                                      : vm.imgList.length + 1,
                                  itemBuilder: (context, index) {
                                    if (index != 9) {
                                      return releaseImage(
                                          index == vm.imgList.length &&
                                              index != 9,
                                          index != vm.imgList.length
                                              ? vm.imgList[index]
                                              : null);
                                    } else {
                                      return null;
                                    }
                                  }),
                            ),
                          ),
                        ),
                        Offstage(
                          offstage: vm.showTab != 2,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: Html(
                              data: vm.htmlInfo,
                            ),
                          ),
                        ),
                        Offstage(
                          offstage: vm.showTab != 3,
                          child: const Padding(
                            padding: EdgeInsets.all(20),
                            child: Text(
                              '请如实回答公证员的提问',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Offstage(
                          offstage: vm.showTab != 4,
                          child: Padding(
                            padding:
                                EdgeInsets.symmetric(horizontal: getWidthPx(8)),
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
                                    border: Border.all(
                                        width: 1, color: Colors.black),
                                  ),
                                  child: Text(
                                      '受理单号:   ${vm.orderInfo.orderNo ?? ''}'),
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
                                              width: 1, color: Colors.black))),
                                  child: Text(
                                      '受理日期:   ${vm.orderInfo.createDate != null && vm.orderInfo.createDate.length > 10 ? vm.orderInfo.createDate.substring(0, 10) : vm.orderInfo.createDate}'),
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
                                      child: const Text('申请人'),
                                    ),
                                    Container(
                                      width: getWidthPx(183.5),
                                      height: 50,
                                      alignment: Alignment.centerLeft,
                                      // padding: EdgeInsets.symmetric(
                                      //     vertical: getWidthPx(20)),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: const Border(
                                            right: BorderSide(
                                                width: 1, color: Colors.black),
                                            bottom: BorderSide(
                                                width: 1, color: Colors.black)),
                                      ),
                                      child: AutoSizeText(
                                        '${userModel.userName ?? ''}',
                                        maxLines: 6,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Container(
                                      width: getWidthPx(183.5),
                                      height: 50,
                                      alignment: Alignment.centerLeft,
                                      padding: EdgeInsets.symmetric(
                                          vertical: getWidthPx(20)),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: const Border(
                                            right: BorderSide(
                                                width: 1, color: Colors.black),
                                            bottom: BorderSide(
                                                width: 1, color: Colors.black)),
                                      ),
                                      child: const Text('承办人'),
                                    ),
                                    Container(
                                      width: getWidthPx(183.5),
                                      height: 50,
                                      alignment: Alignment.centerLeft,
                                      padding: EdgeInsets.symmetric(
                                          vertical: getWidthPx(20)),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: const Border(
                                            right: BorderSide(
                                                width: 1, color: Colors.black),
                                            bottom: BorderSide(
                                                width: 1, color: Colors.black)),
                                      ),
                                      child: Text(
                                        widget.arguments.greffierName == null
                                            ? ""
                                            : widget.arguments.greffierName,
                                        overflow: TextOverflow.ellipsis,
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
                                        child: Text(
                                            vm.contentForm['yongtu'] == null
                                                ? ""
                                                : vm.contentForm['yongtu']),
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
                                        child: Text(
                                          ''
                                          '${vm.costMap['address'] == null ? "" : vm.costMap['address']}',
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
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
                                        child: Text(
                                          vm.contentForm['gongzhengValue'] ==
                                                  null
                                              ? ""
                                              : vm.contentForm[
                                                  'gongzhengValue'],
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
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
                                                width: 1, color: Colors.black),
                                            bottom: BorderSide(
                                                width: 1, color: Colors.black)),
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
                                                width: 1, color: Colors.black),
                                            bottom: BorderSide(
                                                width: 1, color: Colors.black)),
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
                                                width: 1, color: Colors.black),
                                            bottom: BorderSide(
                                                width: 1, color: Colors.black)),
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
                                                width: 1, color: Colors.black),
                                            bottom: BorderSide(
                                                width: 1, color: Colors.black)),
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
                                                width: 1, color: Colors.black),
                                            bottom: BorderSide(
                                                width: 1, color: Colors.black)),
                                      ),
                                      child: Text(vm.costMap['photograph'] == ''
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
                                                width: 1, color: Colors.black),
                                            bottom: BorderSide(
                                                width: 1, color: Colors.black)),
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
                                              width: 1, color: Colors.black))),
                                  child: Text(
                                      '其他收费：${vm.costMap['others'] == '' ? '  0 元' : '  ${vm.costMap['others']}元'}'),
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
                                              width: 1, color: Colors.black))),
                                  child: Text('合计：${vm.total() ?? 0}元'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                });
          },
        ),
      ),
    );
  }

  Widget releaseImage(bool isDef, Asset asset) {
    return isDef && contractVm.showUpload
        ? InkWell(
            onTap: () {
              contractVm.requestCameraPermission();
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

// 声网
  // Widget _renderWidget() {
  //   if (contractVm.userList == null || contractVm.userList.isEmpty) {
  //     return SizedBox();
  //   } else {
  //     wjPrint("1111111---------${contractVm.userList}");
  //     return  GridView.builder(
  //         shrinkWrap: true,
  //         physics: NeverScrollableScrollPhysics(),
  //         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //           crossAxisCount: 2,
  //           childAspectRatio:1,//显示区域宽高相等
  //           mainAxisSpacing: 3,
  //           crossAxisSpacing:3,
  //         ),
  //         itemCount:contractVm.userList.length,
  //         itemBuilder: (context, index) {
  //           return contractVm.userList[index]['name']=="自己"?RtcLocalView.SurfaceView() :RtcRemoteView.SurfaceView(uid: contractVm.userList[index]['uid']);
  //         });
  //     //   Row(
  //     //   mainAxisSize : MainAxisSize.min,
  //     //   crossAxisAlignment : CrossAxisAlignment.start,
  //     //   children: <Widget>[
  //     //     Expanded(
  //     //         flex: 3,
  //     //         child: contractVm.remoteUid!=0?RtcRemoteView.SurfaceView(uid: contractVm.remoteUid):SizedBox()),
  //     //     SizedBox(width: 6,),
  //     //     Expanded(
  //     //       flex: 2,
  //     //       child: GridView.builder(
  //     //           shrinkWrap: true,
  //     //           physics: NeverScrollableScrollPhysics(),
  //     //           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //     //             crossAxisCount: contractVm.userList.length<3?1:2,
  //     //             childAspectRatio:contractVm.userList.length<3?1.8:contractVm.userList.length<5?0.86:1.3 ,//显示区域宽高相等
  //     //             mainAxisSpacing: 3,
  //     //             crossAxisSpacing:3,
  //     //           ),
  //     //           itemCount:contractVm.userList.length,
  //     //           itemBuilder: (context, index) {
  //     //             return contractVm.userList[index]['name']=="自己"?RtcLocalView.SurfaceView() :RtcRemoteView.SurfaceView(uid: contractVm.userList[index]['uid']);
  //     //           }),
  //     //     ),
  //     //     ],
  //     // );
  //   }
  // }

  // 腾讯
  Widget _renderWidget() {
    wjPrint("++++contractVm.userList+++++++++${contractVm.userList}");
    wjPrint(
        "++++contractVm.userList.length+++++++++${contractVm.userList.length}");
    if (contractVm.userList == null || contractVm.userList.isEmpty) {
      wjPrint("表示当前为contractVm.userList == null");
      return SizedBox();
    } else {
      wjPrint("表示当前为contractVm.userList 有参数");
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
            itemCount: contractVm.userList.length,
            itemBuilder: (context, index) {
              // return videoVm.userList[index]['widget']!=null?videoVm.userList[index]['widget']:SizedBox();
              return Stack(
                children: [
                  // contractVm.userList[index]['name']=="自己"?RtcLocalView.SurfaceView() :RtcRemoteView.SurfaceView(uid: contractVm.userList[index]['uid'])
                  contractVm.userList[index]['widget'] != null
                      ? contractVm.userList[index]['widget']
                      : SizedBox(),
                  contractVm.userList[index]['userId'] ==
                          contractVm.userViewModel.idCard
                      ? Positioned(
                          right: 0,
                          child: InkWell(
                            onTap: () {
                              contractVm.txDeviceManager.switchCamera(
                                  contractVm.camerasNum == 0 ? true : false);
                              contractVm.camerasNum =
                                  contractVm.camerasNum == 0 ? 1 : 0;
                              // videoVm.trtcCloud.stopScreenCapture();
                              setState(() {});
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
