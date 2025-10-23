import 'package:dio/dio.dart';
import 'package:notarization_station_app/config.dart';

import 'bedrock_http.dart';

class AccountApi {
  static AccountApi _singleton;

  factory AccountApi() => getSingleton();

  static AccountApi getSingleton() {
    if (_singleton == null) {
      _singleton = AccountApi._internal();
    }
    return _singleton;
  }

  AccountApi._internal() {
    //do stuff
  }

  //登录
  Future getLogin(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.post(
        "${Config.userModule}/sys/login/loginOn",
        data: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  Future getLoginOut(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.post(
        "${Config.userModule}/sys/login/loginOut",
        data: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  Future getUserInfo(map, String token, {Function errorCallBack}) async {
    Options options = Options(headers: {"token": token});
    final response = await HttpManager.instance.get(
        "${Config.userModule}/cgz/user/getUserInfo",
        queryParameters: map,
        options: options,
        errorCallBack: errorCallBack);
    return response.data;
  }

  //验证码登录
  Future getCodeLogin(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.post(
        "${Config.userModule}/sys/login/obAuthCodeNewApp",
        data: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  //验证吗
  Future getCode(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance
        .get("${Config.userModule}/sys/Sms/domesticSend",
            queryParameters: map,
            options: Options(
              contentType: 'urlencoded',
            ),
            errorCallBack: errorCallBack);
    return response.data;
  }

  // 境外用户忘记密码时发送邮箱验证码
  Future sendEmailCodeByForget(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance
        .post("${Config.userModule}/cgz/userApp/sendEmailCodeByForget",
        data: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  //忘记密码时获取的图形验证码
  Future sendCaptchaCodeForget(map,{Function errorCallBack}) async {
    final response = await HttpManager.instance
        .get("${Config.userModule}/cgz/userApp/sendCaptchaCodeForget", queryParameters: map,errorCallBack: errorCallBack,options: Options(
      contentType: 'urlencoded',
    ));
    return response.data;
  }


  //忘记密码验证
  Future authCode(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.post(
        "${Config.userModule}/sys/login/authCodeForApp",
        data: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  //修改密码
  Future forgetPassword(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.post(
        "${Config.userModule}/sys/login/forgetPassword",
        data: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  //境外用户忘记密码
  Future doForgetPassword(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.post(
        "${Config.userModule}/cgz/userApp/doForgetPassword",
        data: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  // 境外用户绑定邮件
  Future doSetEmail(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.post(
        "${Config.userModule}/cgz/userApp/doSetEmail",
        data: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  // 获取图形验证码
  Future sendCaptchaCode(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.get(
        "${Config.userModule}/cgz/userApp/sendCaptchaCode",
        queryParameters: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  //用户注册
  Future register(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.post(
        "${Config.userModule}/cgz/userApp/appRegister",
        data: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  /// 一键登录按钮
  /// {
  //   "identityToken": "",
  //   "mobile": "",
  //   "wxCode": ""
  // }
  Future oneClickLogin(map,{Function errorCallBack})async{
    final response = await HttpManager.instance.post("${Config.userModule}/sys/login/oneClickLogin",data: map,errorCallBack: errorCallBack);
    return response.data;
  }

  /// 一键注册
  /// {
  //   "confirmPassword": "",
  //   "email": "",
  //   "emailCode": "",
  //   "identityToken": "",
  //   "mobile": "",
  //   "openId": "",
  //   "password": "",
  //   "smsCode": ""
  // }
  Future oneClickRegister(map,{Function errorCallBack})async{
    final response = await HttpManager.instance.post("${Config.userModule}/sys/login/oneClickRegist",data: map,errorCallBack: errorCallBack);
    return response.data;
  }

  /// 微信和苹果账号绑定
  /// {
  //   "identityToken": "",
  //   "wxCode": ""
  // }
  Future bindUser(map,{Function errorCallBack})async{
    final response = await HttpManager.instance.post("${Config.userModule}/sys/login/bindUser",data: map,errorCallBack: errorCallBack);
    return response.data;
  }

  //上传图片
  Future upperFile(String path, {Function errorCallBack}) async {
    var name = path.substring(path.lastIndexOf("/") + 1, path.length);
    var image = await MultipartFile.fromFile(
      path,
      filename: name,
    );
    FormData formData = FormData.fromMap({
      "file": image,
    });
    final response = await HttpManager.instance.post(
        "${Config.annexModule}/sys/annex/fastDFSUpload",
        data: formData,
        errorCallBack: errorCallBack);
    return response.data;
  }

  //上传身份证正反面
  Future upperCard(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.post(
        "${Config.annexModule}/sys/annex/discern",
        data: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  // 境外识别 /overIdAuth/idAuth
  Future overIdAuth(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.post(
        "${Config.identificationModule}/overIdAuth/idAuth",
        queryParameters: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  //身份认证
  Future identityUser(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.post(
        "${Config.userModule}/cgz/user/appUserUpdate",
        data: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  // 生成图片拖拽验证码
  Future generateCaptchaGif(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.get(
        "${Config.userModule}/cgz/userApp/generateCaptchaGif",
        queryParameters: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  /// 验证图片验证码
   Future checkCode(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.post(
        "${Config.userModule}/cgz/userApp/checkCode",
        data: map,
        errorCallBack: errorCallBack);
    return response.data;
  }
}
