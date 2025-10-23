import 'dart:async';

import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:fluwx/fluwx.dart';
import 'package:notarization_station_app/base_framework/utils/toast_util.dart';
import 'package:notarization_station_app/base_framework/view_model/single_view_state_model.dart';
import 'package:notarization_station_app/page/login/entity/userInfo.dart';
import 'package:notarization_station_app/page/login/vm/user_view_model.dart';
import 'package:notarization_station_app/routes/router.dart';
import 'package:notarization_station_app/service_api/account_api.dart';
import 'package:notarization_station_app/utils/global.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';


class LoginTypeFileViewModel extends SingleViewStateModel {
  bool isAgree = false;

  // 0: 本机号码一键登录 1：微信登录 2：Apple登录 3:直接注册
  int loginType = 0;

  // 手机号
  String mobile;

  // 微信openid
  String openId;

  // 苹果账号
  String appleId;

  UserViewModel userViewModel;

  void changeAgree(value) async {
    isAgree = value;
    if (value) {
      var prefs = await SharedPreferences.getInstance();
      prefs.setBool("isOne", !value);
      registerWxApi(
          appId: "wx01962cc4ae161f91",
          universalLink: "https://0oyh2i.xinstall.com.cn/tolink/");
    }
    notifyListeners();
  }

  /// 微信登录
  void launchWithWeChat(BuildContext context) {
    if (isAgree) {
      sendWeChatAuth(scope: 'snsapi_userinfo', state: 'qtzhWeChat')
          .then((value) {
        print("是否授权成功------$value");
        int index = 0;
        StreamSubscription streamSubscription;
        streamSubscription = weChatResponseEventHandler.distinct((a, b) => a == b).listen((res) {
          if (res is WeChatAuthResponse) {
            int errCode = res.errCode ?? 888;
            if (errCode == 0) {
              index ++;
              print("index1111------$index");
              String code = res.code ?? "";
              streamSubscription.cancel();
              if(index == 1){
                loginType = 1;
                print("index222222------$index");
                oneClickLogin(context,wxCode: code);
              }
            } else if (errCode == -4) {
              ToastUtil.showToast("用户拒绝授权");
            } else if (errCode == -2) {
              ToastUtil.showToast("用户取消授权");
            }
          }
        });
      });
    } else {
      ToastUtil.showNormalToast("请先同意隐私协议");
    }
  }

  /// 苹果登录
  void appleLogin(BuildContext context) async {
    if (isAgree){
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      webAuthenticationOptions: WebAuthenticationOptions(
        // TODO: Set the `clientId` and `redirectUri` arguments to the values you entered in the Apple Developer portal during the setup
        clientId:
        'com.aboutyou.dart_packages.sign_in_with_apple.example',
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
    loginType = 2;
    oneClickLogin(context,identityToken: credential.identityToken);

    } else {
      ToastUtil.showNormalToast("请先同意隐私协议");
    }
  }

  /// 一键登录
  void oneClickLogin(BuildContext context,{String identityToken = '',String mobile = '',String wxCode = ''}){
    Map<String,String> data = new Map();
    if(identityToken.isNotEmpty){
      data['identityToken'] = identityToken;
    }else if (mobile.isNotEmpty){
      data['mobile'] = mobile;
    }else if (wxCode.isNotEmpty){
      data['wxCode'] = wxCode;
    }
    AccountApi.getSingleton().oneClickLogin(data,errorCallBack: (error){
      ToastUtil.showToast("网络出错了，请稍后再试");
    }).then((value){
      if(value['code']==200 && value['data'] != null){
        if(value['data']['loginInfo'] != null){
          SpUtil.remove("lastUserId");
          AccountApi.getSingleton().getUserInfo(
              {'roleId': value["data"]["loginInfo"]['roleList'][0]['roleId'], 'device': 'app'},
              value["data"]['loginInfo']['token'], errorCallBack: (e) {
            ToastUtil.showWarningToast("登录失败，请稍后再试");
          }).then((res) {
            if (res["code"] == 200) {
              ToastUtil.showSuccessToast("登录成功！");
              res['data']['token'] = value["data"]['loginInfo']['token'];
              UserInfoEntity user = UserInfoEntity.fromJson(res['data']);
              userViewModel.saveUser(user);
              Navigator.pushNamedAndRemoveUntil(context, RoutePaths.HomeIndex, (route) => false);
            } else {
              ToastUtil.showWarningToast("登录失败，请稍后再试");
            }
          });
        }else {
          if(loginType == 0){
            mobile = value['data']['mobile'];
          }else if(loginType == 1){
            openId = value['data']['openId'];
          }else if(loginType == 2){
            appleId = value['data']['appleId'];
          }
          Navigator.pushNamed(context, RoutePaths.Register,arguments: {
            'openId': openId,
            'appleId':appleId,
            'mobile':mobile,
            'loginType':loginType
          });
        }
      } else {
        ToastUtil.showToast(value['message']??value['msg']??value['data']);
      }
    });
  }

  @override
  Future loadData() {
    // TODO: implement loadData

  }

  @override
  onCompleted(data) {
    // TODO: implement onCompleted

  }
}
