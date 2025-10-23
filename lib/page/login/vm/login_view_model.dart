import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluwx/fluwx.dart';
import 'package:notarization_station_app/base_framework/utils/toast_util.dart';
import 'package:notarization_station_app/base_framework/view_model/single_view_state_model.dart';
import 'package:notarization_station_app/page/login/vm/user_view_model.dart';
import 'package:notarization_station_app/service_api/account_api.dart';
import 'package:notarization_station_app/utils/fluwx_pay.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:crypto/crypto.dart';

import '../../../config.dart';
import '../../../routes/router.dart';
import '../../../utils/global.dart';
import '../entity/userInfo.dart';

class LoginViewModel extends SingleViewStateModel {
  TextEditingController nameController = TextEditingController();
  TextEditingController passController = TextEditingController();
  UserViewModel userViewModel;
  LoginViewModel(this.userViewModel);
  bool loading = false;
  int count = 10;
  bool passwordShow = false;
  bool isAgree = false;
  // 0: 本机号码一键登录 1：微信登录 2：Apple登录 3:直接注册
  int loginType = 0;

  // 手机号
  String mobile;

  // 微信unionId
  String unionId;

  // 苹果账号
  String appleId;

  // 是否同意协议
  void changeAgree(bool value) async{
    isAgree = value;
    if(value){
      var prefs = await SharedPreferences.getInstance();
      prefs.setBool("isOne", !value);
    }
    notifyListeners();
  }

  login(BuildContext context) {
    if (nameController.text.isEmpty || passController.text.isEmpty) {
      ToastUtil.showWarningToast("用户名或密码不能为空！");
      return;
    }
    if(isAgree == false){
      ToastUtil.showWarningToast("请先同意隐私协议");
      return;
    }
    loading = true;
    notifyListeners();
    Map<String, String> map = {
      "loginName": nameController.text,
      "password": generateMd5(passController.text),
      "source": "1",
      "type": "2"
    };
    EasyLoading.show(status: "登录中...");
    AccountApi.getSingleton().getLogin(map, errorCallBack: (e) {
      loading = false;
      EasyLoading.dismiss();
      notifyListeners();
    }).then((data) {
      if (data["code"] == 200 && data["items"]['role'].length != 0) {
        SpUtil.remove("lastUserId");
        AccountApi.getSingleton().getUserInfo(
            {'roleId': data["items"]['role'][0]['roleId'], 'device': 'app'},
            data["items"]['token'], errorCallBack: (e) {
          loading = false;
          notifyListeners();
        }).then((res) {
          EasyLoading.dismiss();
          loading = false;
          if (res["code"] == 200) {
            ToastUtil.showSuccessToast("登录成功！");
            res['data']['token'] = data["items"]['token'];
            UserInfoEntity user = UserInfoEntity.fromJson(res['data']);
            userViewModel.saveUser(user);
            Map<String, String> map1 = {
              "loginName": nameController.text,
              "password": passController.text,
            };
            // SpUtil.putObject(Config.lastUserAcc, map1);
            SpUtil.putString(Config.lastUserPhoneNumber, nameController.text);
            SpUtil.putString(Config.lastUserPassWord, passController.text);
            G.getCurrentState().pushNamedAndRemoveUntil(
                RoutePaths.HomeIndex, (Route route) => false);
          } else {
            ToastUtil.showWarningToast("登录失败，请稍后再试");
          }
          notifyListeners();
        });
      } else {
        EasyLoading.dismiss();
        loading = false;
        ToastUtil.showWarningToast(data["msg"]);
      }
      notifyListeners();
    });
  }

  /// 微信登录
  void launchWithWeChat(BuildContext context) async{
    if (isAgree) {
     if (await isWeChatInstalled) {
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
       ToastUtil.showToast("请安装微信客户端");
     }
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
            unionId = value['data']['unionId'];
          }else if(loginType == 2){
            appleId = value['data']['appleId'];
          }
          Navigator.pushNamed(context, RoutePaths.Register,arguments: {
            'unionId': unionId,
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

  //退出
  loginOut() {
    userViewModel.userLogout();
  }

  // 密码是否显示
  void passwordShowOrHide(){
    passwordShow = !passwordShow;
    notifyListeners();
  }

  //密码加密
  String generateMd5(String data) {
    var content = new Utf8Encoder().convert(data);
    var digest = md5.convert(content);
    return digest.toString();
  }

  @override
  Future loadData() {
    return null;
  }

  @override
  onCompleted(data) {}
}
