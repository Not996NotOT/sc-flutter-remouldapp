/*
 * @Author: wangshibo1689@gmail.com WSBwsb123!@#
 * @Date: 2024-01-26 22:15:55
 * @LastEditors: wangshibo1689@gmail.com WSBwsb123!@#
 * @LastEditTime: 2024-07-01 17:14:10
 * @FilePath: /remouldApp/lib/base_framework/config/net/base_http.dart
 * @Description: 
 * 
 * Copyright (c) 2024 by ${git_name_email}, All Rights Reserved. 
 */
// 必须是顶层函数
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dio/native_imp.dart';
import 'package:flutter/foundation.dart';

_parseAndDecode(String response) {
  return jsonDecode(response);
}

parseJson(String text) {
  return compute(_parseAndDecode, text);
}

//具体应用配置http类继承此类
abstract class BaseHttp extends DioForNative {
  final CancelToken rootCancelToken = CancelToken();

  BaseHttp() {
    ///将原始 返回数据 json化
    ///具体可以看源码注释
    (transformer as DefaultTransformer).jsonDecodeCallback = parseJson;
    interceptors
      ..add(new HeaderInterceptor())
      ..add(LogInterceptor(responseBody: true));

    init();
  }

  void init();

  cancelAllRequest() {
    _cancelToken.cancel(['no available net']);
  }
}

///默认项目所有cancelToken使用这一个，用于断网下取消
///如有特殊需要可以 在ApiInterceptor进行覆盖或者注释
final CancelToken _cancelToken = CancelToken();

///添加拦截器
class HeaderInterceptor extends InterceptorsWrapper {}

/// 子类需要重写
abstract class BaseResponseData {
  int code = 0;
  String message;
  dynamic data;

  bool get success;

  BaseResponseData({this.code, this.message, this.data});

  @override
  String toString() {
    return 'BaseRespData{code: $code, message: $message, data: $data}';
  }
}
