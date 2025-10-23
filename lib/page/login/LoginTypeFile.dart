import 'dart:io';
import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:notarization_station_app/base_framework/widget_state/base_state.dart';
import 'package:notarization_station_app/components/throttleUtil.dart';
import 'package:notarization_station_app/page/login/vm/LoginTypeFileViewModel.dart';
import 'package:notarization_station_app/page/login/vm/user_view_model.dart';
import 'package:notarization_station_app/utils/debounce_button.dart';
import 'package:provider/provider.dart';

import '../../appTheme.dart';
import '../../base_framework/widget/provider_widget.dart';
import '../../routes/router.dart';
import '../../utils/global.dart';

class LoginTypeFile extends StatefulWidget {
  dynamic  arguments;
  LoginTypeFile({Key key,this.arguments}) : super(key: key);

  @override
  State<LoginTypeFile> createState() => _LoginTypeFileState();
}

class _LoginTypeFileState extends BaseState<LoginTypeFile> {
  LoginTypeFileViewModel loginTypeFileViewModel;
  UserViewModel userViewModel;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.arguments != null &&
            widget.arguments.isNotEmpty &&
            widget.arguments['isMine']) {
          userViewModel.currentIndex = 4;
        } else {
          userViewModel.currentIndex = 0;
        }
        Navigator.pushNamedAndRemoveUntil(
            context, RoutePaths.HomeIndex, (route) => false);
        return Future.value(false);
      },
      child: Scaffold(
        body: Consumer<UserViewModel>(
          builder: (ctx, userModel, child) {
            return ProviderWidget<LoginTypeFileViewModel>(
                model: LoginTypeFileViewModel(),
                onModelReady: (model) {
                  loginTypeFileViewModel = model;
                  loginTypeFileViewModel.userViewModel = userModel;
                  model.initData();
                },
                builder: (ctx, typeFileViewModel, child) {

                  return Container(
                      color: Colors.white,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: Column(children: [
                        InkWell(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
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
                            if (widget.arguments != null &&
                                widget.arguments.isNotEmpty &&
                                widget.arguments['isMine']) {
                              userViewModel.currentIndex = 4;
                            } else {
                              userViewModel.currentIndex = 0;
                            }
                            Navigator.pushNamedAndRemoveUntil(context,
                                RoutePaths.HomeIndex, (route) => false);
                            return Future.value(false);
                            Navigator.pushNamedAndRemoveUntil(context,
                                RoutePaths.HomeIndex, (route) => false);
                          },
                        ),
                        Expanded(
                          child: Padding(
                              padding: EdgeInsets.only(left: 35, right: 35),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.only(
                                          top: 26, bottom: getHeightPx(10)),
                                      width: 192,
                                      height: 192,
                                      child: Image.asset(
                                          'lib/assets/images/logo2.jpg',
                                          fit: BoxFit.contain),
                                    ),
                                    Text(
                                      "青桐智盒",
                                      style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    DebounceButton(
                                      isEnable: true,
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10),
                                      borderRadius:
                                          BorderRadius.circular(getWidthPx(30)),
                                      margin:
                                          EdgeInsets.only(top: 50, bottom: 10),
                                      child: Text(
                                        "本机号码一键登录",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    DebounceButton(
                                      isEnable: true,
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10),
                                      backgroundColor: Colors.white,
                                      clickTap: (){
                                        Navigator.pushNamed(context,
                                            RoutePaths.CodeLogin);
                                      },
                                      child: Text(
                                        "使用验证码登录",
                                        style: TextStyle(
                                            color: AppTheme.themeBlue),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                        ),
                        Stack(
                          alignment: Alignment.centerRight,
                          children: [
                            Container(
                              width: getScreenWidth(),
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      loginTypeFileViewModel.launchWithWeChat(context);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Image.asset(
                                        'lib/assets/images/icon_wechat.png',
                                        width: getWidthPx(60),
                                        height: getWidthPx(60),
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                  Platform.isIOS
                                      ? GestureDetector(
                                          onTap: () {
                                            loginTypeFileViewModel.appleLogin(context);
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Image.asset(
                                              'lib/assets/images/icon_apple.png',
                                              width: getWidthPx(60),
                                              height: getWidthPx(60),
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        )
                                      : SizedBox()
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: getWidthPx(40)),
                              child: GestureDetector(
                                onTap: ThrottleUtil().throttle((){
                                  loginTypeFileViewModel.loginType = 3;
                                  Navigator.pushNamed(context, RoutePaths.Register,arguments: {
                                    'openId': '',
                                    'appleId':"",
                                    'mobile':'',
                                    'loginType':3
                                  });
                                }),
                                child: Text('注册账号'),
                              ),
                            )
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Checkbox(
                                value: loginTypeFileViewModel.isAgree,
                                onChanged: (value) {
                                  loginTypeFileViewModel.changeAgree(value);
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
                      ]));
                });
          },
        ),
      ),
    );
  }
}
