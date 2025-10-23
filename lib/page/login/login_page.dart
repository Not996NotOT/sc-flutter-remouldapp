import 'dart:io';
import 'dart:ui';

import 'package:flustars/flustars.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluwx/fluwx.dart';
import 'package:notarization_station_app/base_framework/widget/provider_widget.dart';
import 'package:notarization_station_app/base_framework/widget_state/base_state.dart';
import 'package:notarization_station_app/components/throttleUtil.dart';
import 'package:notarization_station_app/config.dart';
import 'package:notarization_station_app/page/login/vm/user_view_model.dart';
import 'package:notarization_station_app/utils/debounce_button.dart';
import 'package:notarization_station_app/utils/global.dart';
import 'package:provider/provider.dart';
import 'package:notarization_station_app/base_framework/widget/provider_widget.dart';
import 'package:notarization_station_app/base_framework/widget_state/base_state.dart';
import 'package:notarization_station_app/page/login/vm/login_view_model.dart';
import 'package:notarization_station_app/routes/router.dart';

import '../../appTheme.dart';
import '../../iconfont/Icon.dart';

class LoginPage extends StatefulWidget {
  Map arguments;

  LoginPage({Key key, this.arguments}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return LoginPageState();
  }
}

class LoginPageState extends BaseState<LoginPage> {
  LoginViewModel loginViewModel;
  UserViewModel userViewModel;
  bool isInstalled = false;


  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () {
      setState(() async{
        isInstalled = await isWeChatInstalled;
      });
    });
  }

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
            return ProviderWidget<LoginViewModel>(
                model: LoginViewModel(userModel),
                onModelReady: (model) {
                  userViewModel = userModel;
                  model.initData();
                },
                builder: (ctx, loginModel, child) {
                  loginViewModel = loginModel;
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
                                                width: 1,
                                                color: Color(0xffe5e5e5))),
                                        // color: AppTheme.chipBackground
                                      ),
                                      height: 55,
                                      child: TextField(
                                        controller:
                                            loginViewModel.nameController,
                                        maxLines: 1,
                                        keyboardType: TextInputType.phone,
                                        // ignore: deprecated_member_use
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly
                                        ], //只允许输入数字
                                        decoration: InputDecoration(
                                            counterText: "",
                                            border: InputBorder.none,
                                            hintText: '请输入账号',
                                            hintStyle: TextStyle(
                                              fontSize: 16,
                                            )),
                                      ),
                                    ),

                                  /// 密码
                                  Container(
                                    height: 55,
                                    decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              width: 1,
                                              color: Color(0xffe5e5e5))),
                                    ),
                                    child: Row(
                                      children: <Widget>[
                                        Flexible(
                                          child: TextField(
                                            maxLength: 20,
                                            controller:
                                                loginViewModel.passController,
                                            keyboardType:
                                                TextInputType.visiblePassword,
                                            obscureText:
                                                !loginViewModel.passwordShow,
                                            decoration: InputDecoration(
                                              counterText: '',
                                              border: InputBorder.none,
                                              hintText: '请输入密码',
                                              hintStyle: TextStyle(
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                            icon: loginViewModel.passwordShow
                                                ? visibilityIco(
                                                    color: Colors.grey)
                                                : visibilityOffIco(
                                                    color: Colors.grey),
                                            onPressed: () {
                                              loginViewModel
                                                  .passwordShowOrHide();
                                            })
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(top: 15),
                                    child: Row(
                                      children: <Widget>[
                                        InkWell(
                                          child: Text('验证码登录',
                                              style: TextStyle(
                                                fontSize: 14,
                                              ),
                                              textAlign: TextAlign.right),
                                          onTap: () {
                                            Navigator.pushNamed(context,
                                                    RoutePaths.CodeLogin);
                                          },
                                        ),
                                        Expanded(
                                          child: Text(''), // 中间用Expanded控件
                                        ),
                                        InkWell(
                                            child: Text('忘记密码?',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                ),
                                                textAlign: TextAlign.right),
                                            onTap: () {
                                              Navigator.pushNamed(context,
                                                  RoutePaths.ModifyPsd,
                                                  arguments: {
                                                    'phoneNumber':loginViewModel.nameController.text,
                                                    'title': "找回密码"
                                                  });
                                            }),
                                      ],
                                    ),
                                  ),
                                  DebounceButton(
                                    isEnable: !loginViewModel.loading,
                                    borderRadius: BorderRadius.circular(10),
                                    margin: EdgeInsets.fromLTRB(
                                        getWidthPx(40),
                                        getWidthPx(80),
                                        getWidthPx(40),
                                        0),
                                    padding: EdgeInsets.all(10),
                                    child: Text(
                                      '立即登录',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.white),
                                    ),
                                    clickTap: () {
                                      loginViewModel.login(context);
                                    },
                                  ),

                                  /// 确认
                                  // Container(
                                  //   margin: EdgeInsets.only(top: 40),
                                  //   child: FLLoadingButton(
                                  //     child: Text('立即登录'),
                                  //     color: AppTheme
                                  //         .themeBlue, //Color(0xFF0F4C81),
                                  //     disabledColor: AppTheme.chipBackground,
                                  //     indicatorColor: Colors.white,
                                  //     disabledTextColor: Colors
                                  //         .white, //Colors.grey.withAlpha(90),
                                  //     textColor: Colors.white,
                                  //     loading: loginViewModel.loading,
                                  //     minWidth: getScreenWidth() - 120,
                                  //     height: 45,
                                  //     onPressed: () {
                                  //       loginViewModel.loading = true;
                                  //       loginViewModel.login();
                                  //       loginViewModel.notifyListeners();
                                  //     },
                                  //   ),
                                  // ),
                                  InkWell(
                                    onTap: ThrottleUtil().throttle((){
                                      Navigator.pushNamed(context, RoutePaths.Register,arguments: {
                                        'unionId': '',
                                        'appleId':"",
                                        'mobile':'',
                                        'loginType':3
                                      });
                                    }),
                                    child: Container(
                                      margin: EdgeInsets.only(top: 15),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              '没有账号？',
                                              style: TextStyle(fontSize: 14),
                                            ),
                                            Text(
                                              '立即注册',
                                              style: TextStyle(
                                                  color: AppTheme.themeBlue,
                                                  fontSize: 14),
                                            ),
                                          ]),
                                    ),
                                  ),

                                  Container(
                                    width: getScreenWidth(),
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.only(top:getWidthPx(80)),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Platform.isAndroid ? GestureDetector(
                                          onTap: () {
                                            loginViewModel.launchWithWeChat(context);
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Image.asset(
                                              'lib/assets/images/icon_wechat.png',
                                              width: getWidthPx(80),
                                              height: getWidthPx(80),
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ) : (isInstalled ?  GestureDetector(
                                          onTap: () {
                                            loginViewModel.launchWithWeChat(context);
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Image.asset(
                                              'lib/assets/images/icon_wechat.png',
                                              width: getWidthPx(80),
                                              height: getWidthPx(80),
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ):SizedBox()),
                                        Platform.isIOS
                                            ? GestureDetector(
                                          onTap: () {
                                            loginViewModel.appleLogin(context);
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Image.asset(
                                              'lib/assets/images/icon_apple.png',
                                              width: getWidthPx(80),
                                              height: getWidthPx(80),
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        )
                                            : SizedBox()
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )),
                      ),

                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Checkbox(
                              value: loginViewModel.isAgree,
                              onChanged: (value) {
                                loginViewModel.changeAgree(value);
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
      )
    );
  }
}
