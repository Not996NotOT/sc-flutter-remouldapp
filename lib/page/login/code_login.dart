import 'dart:ui';

import 'package:color_dart/RgbaColor.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notarization_station_app/base_framework/widget/a_button/index.dart';
import 'package:notarization_station_app/base_framework/widget/provider_widget.dart';
import 'package:notarization_station_app/base_framework/widget_state/base_state.dart';
import 'package:notarization_station_app/components/throttleUtil.dart';
import 'package:notarization_station_app/config.dart';
import 'package:notarization_station_app/page/login/vm/code_view_model.dart';
import 'package:notarization_station_app/page/login/vm/user_view_model.dart';
import 'package:notarization_station_app/routes/router.dart';
import 'package:notarization_station_app/utils/debounce_button.dart';
import 'package:notarization_station_app/utils/global.dart';
import 'package:provider/provider.dart';

import '../../appTheme.dart';

class CodeLoginPage extends StatefulWidget {
  CodeLoginPage({Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return CodeLoginPageState();
  }
}

class CodeLoginPageState extends BaseState<CodeLoginPage> {
  CodeViewModel codeLoginViewModel;
  UserViewModel userViewModel;

  @override
  void dispose() {
    super.dispose();
    codeLoginViewModel.countdownTimer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Consumer<UserViewModel>(
        builder: (ctx, userModel, child) {
          userViewModel = userModel;
          return ProviderWidget<CodeViewModel>(
            model: CodeViewModel(userModel),
            onModelReady: (model) {
              codeLoginViewModel = model;
              model.initData();
            },
            builder: (ctx, vm, child) {
              codeLoginViewModel = vm;
              return Container(
                color: Colors.white,
                width: getWidthPx(750),
                height: getHeightPx(1334),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      InkWell(
                        child: Container(
                          width: getWidthPx(750),
                          height: MediaQuery.of(context).padding.top +
                              kToolbarHeight,
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.fromLTRB(
                              getWidthPx(40),
                              MediaQueryData.fromWindow(window).padding.top,
                              0,
                              0),
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.black,
                            size: 22,
                          ),
                        ),
                        onTap: () {
                          G.pop();
                        },
                      ),
                      Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.only(left: 35, right: 35),
                        child: SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          child: Column(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(
                                    top: 25, bottom: getHeightPx(20)),
                                width: 250,
                                height: 250,
                                child: Image.asset(
                                    'lib/assets/images/logoimg.png',
                                    fit: BoxFit.contain),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          width: 1, color: Color(0xffe5e5e5))),
                                ),
                                height: 55,
                                child: TextField(
                                  maxLines: 1,
                                  controller: vm.phoneController,
                                  keyboardType: TextInputType.phone,
                                  // inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],//只允许输入数字
                                  decoration: InputDecoration(
                                      counterText: "",
                                      border: InputBorder.none,
                                      hintText: '请输入账号',
                                      hintStyle: TextStyle(
                                          fontSize: getSp(32),
                                          color: Color(0xFF999999))),
                                ),
                              ),
                              Container(
                                height: 55,
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            width: 1,
                                            color: Color(0xffe5e5e5)))),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: TextField(
                                        inputFormatters: [
                                          // ignore: deprecated_member_use
                                          FilteringTextInputFormatter.allow(
                                              RegExp('[0-9]')), //只允许输入数
                                          // WhitelistingTextInputFormatter(RegExp("[0-9]")),
                                        ],
                                        maxLength: 6,
                                        controller: vm.codeController,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                            counterText: '',
                                            border: InputBorder.none,
                                            hintText: '请输入短信验证码',
                                            hintStyle: TextStyle(
                                                fontSize: getSp(32),
                                                color: Color(0xFF999999))),
                                      ),
                                    ),
                                    Container(
                                      height: 25,
                                      decoration: BoxDecoration(
                                          border: Border(
                                              left: BorderSide(
                                                  color:
                                                  rgba(242, 242, 242, 1)))),
                                    ),
                                    buildGetEmailCode(),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(top: 15),
                                child: Row(
                                  children: <Widget>[
                                    InkWell(
                                      child: Text('账号密码登录',
                                          style:
                                          TextStyle(fontSize: getSp(28))),
                                      onTap: () => Navigator.pop(
                                          context,
                                          codeLoginViewModel
                                              .phoneController.text),
                                    ),
                                    Expanded(
                                      child: Text(''), // 中间用Expanded控件
                                    ),
                                    InkWell(
                                      child: Text('忘记密码?',
                                          style: TextStyle(
                                            fontSize: getSp(28),
                                          )),
                                      onTap: () {
                                        Navigator.pushNamed(context,
                                            RoutePaths.ModifyPsd,
                                            arguments: {
                                              'phoneNumber': codeLoginViewModel.phoneController.text,
                                              'title': "找回密码"
                                            });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              DebounceButton(
                                isEnable: !vm.loading,
                                borderRadius: BorderRadius.circular(10),
                                margin: EdgeInsets.fromLTRB(getWidthPx(40),
                                    getWidthPx(80), getWidthPx(40), 0),
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  '立即登录',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                                clickTap: () {
                                  vm.login(context);
                                  vm.notifyListeners();
                                },
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 15),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        '没有账号？',
                                        style: TextStyle(fontSize: getSp(28)),
                                      ),
                                      InkWell(
                                        child: Text(
                                          '立即注册',
                                          style: TextStyle(
                                              color: AppTheme.themeBlue,
                                              fontSize: getSp(28)),
                                        ),
                                        onTap: ThrottleUtil().throttle((){
                                          Navigator.pushNamed(context, RoutePaths.Register,arguments: {
                                            'unionId': '',
                                            'appleId':"",
                                            'mobile':'',
                                            'loginType':3
                                          });
                                        }),
                                      )
                                    ]),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 140),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Checkbox(
                                value: codeLoginViewModel.isAgree,
                                onChanged: (value) {
                                  codeLoginViewModel.changeAgree(value);
                                }),
                            Container(
                                padding: EdgeInsets.only(top: 20),
                                margin: EdgeInsets.only(bottom: 20),
                                child: RichText(
                                  text: TextSpan(
                                      text: '登录即代表您已阅读并同意',
                                      style: TextStyle(
                                          fontSize: 13, color: Colors.black),
                                      children: [
                                        TextSpan(
                                            text: '《青桐智盒隐私政策》',
                                            style: TextStyle(
                                                fontSize: 13,
                                                color: AppTheme.themeBlue),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                G.pushNamed(RoutePaths.Privacy);
                                              })
                                      ]),
                                )),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  /// 获取验证码
  Container buildGetEmailCode() {
    return Container(
        child: AButton.normal(
            onPressed: codeLoginViewModel.codeCountDownIsEnable
                ? () {
                    codeLoginViewModel.getImageCode(context);
                  }
                : null,
            child: Text(
              codeLoginViewModel.codeCountdownStr,
              style: TextStyle(fontSize: getSp(26)),
            ),
            color: codeLoginViewModel.codeCountdownStr == "获取验证码" ? AppTheme.themeBlue : AppTheme.themeBlue.withOpacity(0.8)));
  }
}
