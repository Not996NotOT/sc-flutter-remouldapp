import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notarization_station_app/base_framework/widget/provider_widget.dart';
import 'package:notarization_station_app/base_framework/widget_state/base_state.dart';
import 'package:notarization_station_app/config.dart';
import 'package:notarization_station_app/page/login/vm/user_view_model.dart';
import 'package:notarization_station_app/page/mine/vm/attestation_view_model.dart';
import 'package:notarization_station_app/utils/debounce_button.dart';
import 'package:provider/provider.dart';

import '../../appTheme.dart';
import '../../utils/common_tools.dart';

class AttestationPage extends StatefulWidget {
  final arguments;
  const AttestationPage({Key key, this.arguments}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return AttestationPageState();
  }
}

class AttestationPageState extends BaseState<AttestationPage> {
  AttestationViewModel viewModel;
  UserViewModel userViewModel;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "实名认证",
          style: TextStyle(color: AppTheme.white, fontSize: 16),
        ),
        // leading: IconButton(
        //     icon: Icon(
        //       Icons.navigate_before,
        //       color: Colors.black,
        //       size: 30,
        //     ),
        //     onPressed: () {
        //       G.pushNamed(
        //         RoutePaths.HomeIndex,
        //       );
        //     }),
      ),
      body: Consumer<UserViewModel>(
        builder: (ctx, userModel, child) {
          return ProviderWidget<AttestationViewModel>(
            model: AttestationViewModel(userModel, widget.arguments),
            onModelReady: (model) {
              userViewModel = userModel;
              model.initData();
            },
            builder: (ctx, vm, child) {
              viewModel = vm;
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppTheme.themeBlue, Color(0xFF49CFCE)],
                  ),
                ),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          width: getHeightPx(250),
                          height: getHeightPx(250),
                          child: Image.asset(
                            "lib/assets/images/idCard.png",
                          ),
                        ),
                        SizedBox(
                          width: getHeightPx(30),
                        ),
                        Expanded(
                          child: const Text(
                            "带有照片、姓名、年龄的有效证件拍照，必须是原件拍照，不得涂抹、遮挡或修改",
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      ],
                    ),
                    Expanded(
                      child: Container(
                        width: getWidthPx(750),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: getHeightPx(20),
                              ),
                              Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: getHeightPx(20)),
                                  padding: EdgeInsets.symmetric(
                                      vertical: getHeightPx(30)),
                                  width: getWidthPx(750),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border(
                                        bottom: BorderSide(
                                            width: 1,
                                            color: AppTheme.Text_min)),
                                  ),
                                  child: const Text(
                                    '请确认以下信息真实有效并提交',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.Text_max),
                                  )),
                              SizedBox(
                                height: getHeightPx(40),
                              ),
                              Container(
                                width: getWidthPx(750),
                                padding: EdgeInsets.symmetric(
                                    horizontal: getHeightPx(20)),
                                child: TextField(
                                  controller: vm.textControllerName,
//                                maxLength: 5,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp("[\u4e00-\u9fa5]")),
                                  ],
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: getHeightPx(20)),
                                    hintText: '请输入真实姓名',
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        borderSide: BorderSide.none),
                                    filled: true,
                                    fillColor: Color(0xffeeeeee),
                                  ),
                                  onChanged: (v) {
                                    var reg = RegExp("[\u4e00-\u9fa5]");
                                    if (reg.hasMatch(v)) {
                                      vm.textName = v;
                                    }
                                  },
                                ),
                              ),
                              SizedBox(
                                height: getHeightPx(20),
                              ),
                              Container(
                                width: getWidthPx(750),
                                padding: EdgeInsets.symmetric(
                                    horizontal: getHeightPx(20)),
                                child: TextField(
                                  maxLength: 18,
//                                  inputFormatters:[WhitelistingTextInputFormatter.digitsOnly],//只允许输入数字
                                  inputFormatters: [
                                    FilteringTextInputFormatter.deny(
                                        RegExp("[\u4e00-\u9fa5]"))
                                  ],
                                  controller: vm.textControllerIdentity,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: getHeightPx(20)),
                                    hintText: '请输入身份证号',
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        borderSide: BorderSide.none),
                                    filled: true,
                                    fillColor: Color(0xffeeeeee),
                                  ),
                                  onChanged: (v) {
                                    wjPrint(vm.textControllerIdentity);
                                    wjPrint(v);
                                  },
                                ),
                              ),
                              SizedBox(
                                height: getHeightPx(20),
                              ),
                              Container(
                                width: getWidthPx(750),
                                padding: EdgeInsets.symmetric(
                                    horizontal: getHeightPx(20)),
                                child: TextField(
                                  controller: vm.textControllerAddress,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: getHeightPx(20)),
                                    hintText: '请输入住址',
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        borderSide: BorderSide.none),
                                    filled: true,
                                    fillColor: Color(0xffeeeeee),
                                  ),
                                  onChanged: (v) {
                                    wjPrint(vm.textControllerAddress);
                                    wjPrint(v);
                                  },
                                ),
                              ),
                              SizedBox(
                                height: getHeightPx(40),
                              ),
                              Container(
                                width: getWidthPx(750),
                                padding: EdgeInsets.symmetric(
                                    horizontal: getHeightPx(20)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    SizedBox(
                                        width: getWidthPx(280),
                                        child: widget.arguments == null ||
                                                widget.arguments[
                                                        'cardZheng'] ==
                                                    null || widget.arguments[
                                        'cardZheng'].toString().isEmpty
                                            ? const SizedBox()
                                            : RotatedBox(
                                                quarterTurns: 0,
                                                child: Image.network(
                                                    Config.splicingImageUrl(
                                                        widget.arguments[
                                                            "cardZheng"])))),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: getHeightPx(40),
                              ),
                              SizedBox(
                                width: getWidthPx(650),
                                child: DebounceButton(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  isEnable: vm.isEnable,
                                  clickTap: vm.isEnable
                                      ? () {
                                          vm.confirm();
                                        }
                                      : null,
                                  margin: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                          .padding
                                          .bottom),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: const Text(
                                    '确认',
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
