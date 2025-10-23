
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:notarization_station_app/base_framework/utils/toast_util.dart';
import 'package:notarization_station_app/utils/global.dart';
import 'package:notarization_station_app/utils/network_connectivity.dart';
import 'package:notarization_station_app/utils/sentry_log.dart';
import 'package:package_info/package_info.dart';
import 'package:umeng_apm_sdk/umeng_apm_sdk.dart';

import '../config.dart';
import '../routes/router.dart';
import '../socket/mqtt_client.dart';
import '../utils/common_tools.dart';

typedef NetSuccessCallback<T> = Function(T data);
typedef NetErrorCallback = Function(int code, String msg);

class JudicialNetwork {
  String baseUrl = Config.hostUrl;
  int connectTimeout = 60000;
  int receiveTimeout = 60000;

  factory JudicialNetwork() => _singleton;

  static final JudicialNetwork _singleton = JudicialNetwork._();

  static JudicialNetwork get instance => JudicialNetwork();

  static Dio _dio;

  Dio get dio => _dio;

  JudicialNetwork._() {
    final _options = new BaseOptions(
      baseUrl: baseUrl,
      //连接时间为5秒
      connectTimeout: connectTimeout,
      //响应时间为3秒
      receiveTimeout: receiveTimeout,
      //设置请求头
      headers: {},
      //默认值是"application/json; charset=utf-8",Headers.formUrlEncodedContentType会自动编码请求体.
      contentType: Headers.jsonContentType,
      //共有三种方式json,bytes(响应字节),stream（响应流）,plain
      responseType: ResponseType.plain,
    );
    _dio = Dio(_options);

    // if (baseUrl == 'http://test.future-better.com') {
    //   (request.httpClientAdapter as DefaultHttpClientAdapter)
    //       .onHttpClientCreate = (HttpClient client) {
    //     client.findProxy = (uri) {
    //       //proxy all request to localhost:8888
    //       return 'PROXY 192.168.110.68:8888';
    //     };
    //     client.badCertificateCallback =
    //         (X509Certificate cert, String host, int port) => true;
    //   };
    // }
    //
    // /// Fiddler抓包代理配置 https://www.jianshu.com/p/d831b1f7c45b
    // if(baseUrl==Config.hostUrl){
    //   (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
    //       (HttpClient client) {
    //     client.findProxy = (uri) {
    //       //proxy all request to localhost:8888
    //       return 'PROXY 192.168.0.29:8888';
    //     };
    //     client.badCertificateCallback =
    //         (X509Certificate cert, String host, int port) => true;
    //   };
    // }

    // 设置Cookie
    //  _dio.interceptors.add(CookieManager(CookieJar()));

    /// 添加拦截器
    _dio.interceptors
      ..add(BaseInterceptor());
    if (kReleaseMode) {
      _dio.interceptors.add(LogInterceptor(responseBody: false,
          request: false,
          requestBody: false,
          requestHeader: false,
          responseHeader: false));
    } else {
      _dio.interceptors.add(LogInterceptor(responseBody: true,
          request: true,
          requestBody: true,
          requestHeader: true,
          responseHeader: true));
    }
  }

  //get请求方法
  Future<Response> get(url,
      {queryParameters,
        Options options,
        CancelToken cancelToken,
        Function errorCallBack}) async {
    Response response;
    wjPrint('打印请求的方式：get,请求的数据参数：$queryParameters');
    Options tempOptions = options;
    try {
      String sm4PublicKey = getPublicKey();
      String sm4EncryptKey = encryptSM4Key(sm4PublicKey);
      tempOptions??= Options();
      tempOptions.headers['encrypt'] = sm4EncryptKey;
      if (queryParameters != null) {
        String encryptData = wjEncrypt(queryParameters, sm4PublicKey);
        wjPrint("加密后的数据：$encryptData");
        response = await _dio.get(url,
            queryParameters: {
              "encryptStr": encryptData,
            },
            options: tempOptions,
            cancelToken: cancelToken);
      } else {
        wjPrint("加密后的数据：无加密数据");
        response =
        await _dio.get(url, options: tempOptions, cancelToken: cancelToken);
      }
    } catch (e) {
      if (errorCallBack != null) {
        errorCallBack.call(e);
      }
      ExceptionTrace.captureException(
          exception: Exception('url:$url \n error: ${e.toString()}'));
      wjPrint("...请求出错了$e");
    }
    return response;
  }

  //post请求
  Future<Response> post(url,
      {data,
        Map<String, dynamic> queryParameters,
        Options options,
        CancelToken cancelToken,
        Function errorCallBack}) async {
    Response response;
    Options tempOptions = options;
    wjPrint('打印请求的方式：post,请求的数据参数：${data ?? queryParameters}');
    String sm4PublicKey = getPublicKey();
    String sm4EncryptKey = encryptSM4Key(sm4PublicKey);
    if (tempOptions==null){
      tempOptions??= Options();
      tempOptions.headers['encrypt'] = sm4EncryptKey;
    }else {
      if (!tempOptions.headers.keys.contains("encrypt")){
        tempOptions.headers['encrypt'] = sm4EncryptKey;
      }
    }
    try {
      if (data != null) {
        String encryptData;
        if (data is FormData) {
          wjPrint("加密后的数据：直传无加密: $data");
        } else {
          wjPrint("加密后的数据：$encryptData");
          encryptData = wjEncrypt(data, sm4PublicKey);
        }
        response = await _dio.post(url,
            data: (data is FormData)
                ? data
                : {
              "encryptStr": encryptData,
            },
            options: tempOptions,
            cancelToken: cancelToken);
      } else if (queryParameters != null) {
        String encryptData = wjEncrypt(queryParameters, sm4PublicKey);
        wjPrint("加密后的数据：$encryptData");
        response = await _dio.post(url,
            queryParameters: {
              "encryptStr": encryptData,
            },
            options: tempOptions,
            cancelToken: cancelToken);
      } else {
        response = await _dio.post(url,
            data: (data is FormData)
                ? data
                : {
              "encryptStr": wjEncrypt(data, sm4PublicKey),
            },
            queryParameters: {
              "encryptStr": wjEncrypt(queryParameters, sm4PublicKey),
            },
            options: tempOptions,
            cancelToken: cancelToken);
      }
    } catch (e) {
      if (errorCallBack != null) {
        errorCallBack.call(e);
      }
      ExceptionTrace.captureException(
          exception: Exception('url:$url \n error: ${e.toString()}'));
      wjPrint("...请求出错了$e");
    }
    return response;
  }
}

enum Method { get, post, put, patch, delete, head }

class BaseInterceptor extends Interceptor {
  @override
  onRequest(RequestOptions options) async {
      final packageInfo = await PackageInfo.fromPlatform();
      options.headers["version"] = packageInfo.version;
      options.headers['packageName'] = packageInfo.packageName;
      options.headers["token"] = G.userToken;
      options.headers["clientId"] = G.clientId;
      options.headers['secret'] =  encryptSM4Key(G.secret);
      if (Platform.isIOS) {
        options.headers["source"] = "app-qtzh-ios";
      } else if (Platform.isAndroid) {
        options.headers["source"] = "app-qtzh-android";
      }
      wjPrint("在发送之前的拦截信息${G.userToken}");
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

