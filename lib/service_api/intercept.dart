/*
 * @Author: wangshibo1689@gmail.com WSBwsb123!@#
 * @Date: 2023-09-20 14:38:29
 * @LastEditors: wangshibo1689@gmail.com WSBwsb123!@#
 * @LastEditTime: 2024-07-04 10:41:02
 * @FilePath: /remouldApp/lib/service_api/intercept.dart
 * @Description: 
 * 
 * Copyright (c) 2023 by ${git_name_email}, All Rights Reserved. 
 */
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:notarization_station_app/base_framework/utils/toast_util.dart';
import 'package:notarization_station_app/page/login/entity/userInfo.dart';
import 'package:notarization_station_app/routes/router.dart';
import 'package:notarization_station_app/socket/mqtt_client.dart';
import 'package:notarization_station_app/utils/global.dart';
import 'package:notarization_station_app/utils/network_connectivity.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';

import '../page/login/vm/user_view_model.dart';
import '../utils/common_tools.dart';

class BaseInterceptor extends Interceptor {
  @override
  onRequest(RequestOptions options) async {
    UserInfoEntity data;
    var entity = SpUtil.getObject("lastUserId");
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    if (entity != null) {
      data = UserInfoEntity.fromJson(entity);
       String token = data.token;
      options.headers["token"] = token;
    }
    options.headers["version"] = packageInfo.version;
    options.headers['packageName'] = packageInfo.packageName;
    options.headers["clientId"] = G.clientId;
    options.headers['secret'] =  encryptSM4Key(G.secret);
    if (Platform.isIOS) {
      options.headers["source"] = "app-qtzh-ios";
    } else if (Platform.isAndroid) {
      options.headers["source"] = "app-qtzh-android";
    }
    wjPrint("options.headers---------${options.headers}");
    NetWorkTempConnectivityTools().initConnectivity();
    super.onRequest(options);
  }

  @override
  onResponse(Response response) async {
    wjPrint("解密前的数据$response");
    dynamic data = response.data;
    if (data is String) {
      data = wjDecrypt(response.data);
      wjPrint("拦截解析后的数据-----$data");
    }
    if (data is Map) {
      if (data != null && data['code'] == 401) {
        EasyLoading.dismiss();
        SpUtil.remove("lastUserId");
        Provider.of<UserViewModel>(G.getCurrentContext(), listen: false).clearUserInformation();
        wjPrint(
            'ModalRoute.of(G.getGlobalContext()).settings.name--------${G.getCurrentContext()}');
        if (G.currentPath != RoutePaths.LOGIN) {
          G.getCurrentState().pushNamedAndRemoveUntil(
              RoutePaths.LOGIN, (router) => router == null);
        }
        MqttClientMsg.instance.disconnect();
      }
      if (data['code'] != 200) {
        Future.error(response.data);
      }
    }
    response.data = data;
    super.onResponse(response);
  }

  @override
  onError(DioError err) async {
    wjPrint("在错误之前的拦截信息${err.response}");
    EasyLoading.dismiss();
    if (err.type == DioErrorType.CONNECT_TIMEOUT) {
      ToastUtil.showErrorToast("网络较差，请求超时");
    }
    if (err.response != null && err.response.statusCode == 503) {
      ToastUtil.showErrorToast("网络异常，请稍后再试");
    }
    if (err.response != null && err.response.statusCode == 502) {
      ToastUtil.showErrorToast(err.response.data['msg'] ??
          err.response.data["messsage"] ??
          "网络异常，请稍后再试");
    }
    if (err.response != null && err.response.statusCode == 401) {
      EasyLoading.dismiss();
      ToastUtil.showErrorToast("请重新登录");
      SpUtil.remove("lastUserId");
      Provider.of<UserViewModel>(G.getCurrentContext(), listen: false).clearUserInformation();
      wjPrint(
          'ModalRoute.of(G.getGlobalContext()).settings.name--------${G.getCurrentContext()}');
      if (G.currentPath != RoutePaths.LOGIN) {
        G.getCurrentState().pushNamedAndRemoveUntil(
            RoutePaths.LOGIN, (router) => router == null);
      }
      MqttClientMsg.instance.disconnect();
    }
    Future.error(err);
    super.onError(err);
  }
}
