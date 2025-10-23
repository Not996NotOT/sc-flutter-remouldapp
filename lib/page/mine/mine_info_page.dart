import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluwx/fluwx.dart';
import 'package:notarization_station_app/base_framework/utils/toast_util.dart';
import 'package:notarization_station_app/base_framework/widget_state/base_state.dart';
import 'package:notarization_station_app/components/throttleUtil.dart';
import 'package:notarization_station_app/page/login/vm/user_view_model.dart';
import 'package:notarization_station_app/routes/router.dart';
import 'package:notarization_station_app/service_api/account_api.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../appTheme.dart';
import '../../config.dart';

class MineInfoPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MineInfoPageState();
  }
}

class _MineInfoPageState extends BaseState<MineInfoPage> {
  UserViewModel userModel;

  /// 绑定微信和apple账号
  bindingWechatAndAppleAccount({String identityToken, String wxCode}) {
    EasyLoading.show();
    final map = {"identityToken": identityToken, "wxCode": wxCode};
    AccountApi.getSingleton().bindUser(map, errorCallBack: (error) {
      EasyLoading.dismiss();
      ToastUtil.showToast('出错了，请稍后再试！');
    }).then((value) {
      EasyLoading.dismiss();
      if (value['code'] == 200) {
        if (identityToken != null && identityToken.isNotEmpty) {
          userModel.setAppleId('11111');
        } else if (wxCode != null && wxCode.isNotEmpty) {
          userModel.setUnionId('11111');
        }
        ToastUtil.showToast("绑定成功！");
      } else {
        ToastUtil.showErrorToast(
            value['message'] ?? value['msg'] ?? value['data']);
      }
    });
  }

  /// 微信绑定
  void bindingWithWeChat() {
    sendWeChatAuth(scope: 'snsapi_userinfo', state: 'qtzhWeChat').then((value) {
      print("是否授权成功------$value");
      int index = 0;
      StreamSubscription streamSubscription;
      streamSubscription =
          weChatResponseEventHandler.distinct((a, b) => a == b).listen((res) {
        if (res is WeChatAuthResponse) {
          int errCode = res.errCode ?? 888;
          if (errCode == 0) {
            index++;
            print("index1111------$index");
            String code = res.code ?? "";
            streamSubscription.cancel();
            if (index == 1) {
              print("index222222------$index");
              bindingWechatAndAppleAccount(wxCode: code);
            }
          } else if (errCode == -4) {
            ToastUtil.showToast("用户拒绝授权");
          } else if (errCode == -2) {
            ToastUtil.showToast("用户取消授权");
          }
        }
      });
    });
  }

  /// 苹果登录
  void bindingAppleId() async {
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      webAuthenticationOptions: WebAuthenticationOptions(
        // TODO: Set the `clientId` and `redirectUri` arguments to the values you entered in the Apple Developer portal during the setup
        clientId: 'com.aboutyou.dart_packages.sign_in_with_apple.example',
        redirectUri: Uri.parse(
          'https://flutter-sign-in-with-apple-example.glitch.me/callbacks/sign_in_with_apple',
        ),
      ),
      // TODO: Remove these if you have no need for them
      nonce: 'example-nonce',
      state: 'example-state',
    );

    print("credential------$credential");
    print(
        "打印苹果鉴权的结果：---code:${credential.authorizationCode},\n---email:${credential.email},\n----familyName:${credential.familyName},\n-----userIdentifier:${credential.userIdentifier},\n----givenName:${credential.givenName},\n------identityToken:${credential.identityToken},\n-----state:${credential.state},\n");

    bindingWechatAndAppleAccount(identityToken: credential.identityToken);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBar(title: "个人资料"),
      body: Consumer<UserViewModel>(
        builder: (ctx, userModel, child) {
          this.userModel = userModel;
          return buildWidget();
        },
      ),
    );
  }

  Widget buildWidget() {
    return Column(
      children: <Widget>[
        InkWell(
          onTap: () {
            Navigator.pushNamed(context, RoutePaths.EditPortrait);
          },
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.fromLTRB(getWidthPx(30), getHeightPx(20),
                getWidthPx(30), getHeightPx(20)),
            child: Row(
              children: <Widget>[
                Expanded(
                    child: const Text(
                  "头像",
                  style: TextStyle(fontSize: 16, color: AppTheme.dark_grey),
                )),
                ClipRRect(
                    borderRadius: new BorderRadius.circular(getWidthPx(100)),
                    child: userModel.headIcon != null
                        ? FadeInImage.assetNetwork(
                            width: getWidthPx(100),
                            height: getWidthPx(100),
                            placeholder: 'lib/assets/images/on-boy.jpg',
                            image: userModel.hasUser
                                ? Config.splicingImageUrl(userModel.headIcon)
                                : "",
                            fit: BoxFit.fill,
                      imageErrorBuilder: (context,obj,str){
                              return Image.asset(
                                'lib/assets/images/on-boy.jpg',
                                width: getWidthPx(100),
                                height: getWidthPx(100),
                              );
                      },
                          )
                        : Image.asset(
                            'lib/assets/images/on-boy.jpg',
                            width: getWidthPx(100),
                            height: getWidthPx(100),
                          ))
              ],
            ),
          ),
        ),
        SizedBox(height: 1),
        Container(
          color: Colors.white,
          padding: EdgeInsets.fromLTRB(
              getWidthPx(30), getHeightPx(20), getWidthPx(30), getHeightPx(20)),
          child: Row(
            children: <Widget>[
              Expanded(
                  child: const Text(
                "姓名",
                style: TextStyle(fontSize: 16, color: AppTheme.dark_grey),
              )),
              Text(
                userModel.userName == null
                    ? "用户${userModel.mobile}"
                    : userModel.userName,
                style: const TextStyle(fontSize: 16, color: AppTheme.dark_grey),
              )
            ],
          ),
        ),
        SizedBox(height: 1),
        Container(
          color: Colors.white,
          padding: EdgeInsets.fromLTRB(
              getWidthPx(30), getHeightPx(20), getWidthPx(30), getHeightPx(20)),
          child: Row(
            children: <Widget>[
              Expanded(
                  child: const Text(
                "手机号",
                style: TextStyle(fontSize: 16, color: AppTheme.dark_grey),
              )),
              Text(
                userModel.mobile ?? "",
                style: const TextStyle(fontSize: 16, color: AppTheme.dark_grey),
              )
            ],
          ),
        ),
        SizedBox(height: 1),
        InkWell(
          onTap: ThrottleUtil().throttle(() {
            if (userModel.unionId == null || userModel.unionId.isEmpty) {
              bindingWithWeChat();
            }
          }),
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.fromLTRB(getWidthPx(30), getHeightPx(20),
                getWidthPx(30), getHeightPx(20)),
            child: Row(
              children: <Widget>[
                Expanded(
                    child: const Text(
                  "微信",
                  style: TextStyle(fontSize: 16, color: AppTheme.dark_grey),
                )),
                Text(
                  userModel.unionId != null && userModel.unionId.isNotEmpty
                      ? "已绑定"
                      : "未绑定",
                  style:
                      const TextStyle(fontSize: 16, color: AppTheme.dark_grey),
                )
              ],
            ),
          ),
        ),
        SizedBox(height: 1),
        Offstage(
          offstage: !Platform.isIOS,
          child: InkWell(
            onTap: ThrottleUtil().throttle(() {
              if (userModel.appleId == null || userModel.appleId.isEmpty) {
                bindingAppleId();
              }
            }),
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.fromLTRB(getWidthPx(30), getHeightPx(20),
                  getWidthPx(30), getHeightPx(20)),
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: const Text(
                        "苹果账号",
                        style: TextStyle(fontSize: 16, color: AppTheme.dark_grey),
                      )),
                  Text(
                    userModel.appleId != null && userModel.appleId.isNotEmpty
                        ? "已绑定"
                        : "未绑定",
                    style:
                    const TextStyle(fontSize: 16, color: AppTheme.dark_grey),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
