import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:notarization_station_app/utils/common_tools.dart';
import 'package:notarization_station_app/utils/global.dart';
import 'package:package_info/package_info.dart';
import 'package:umeng_apm_sdk/umeng_apm_sdk.dart';

import '../config.dart';
import 'intercept.dart';

typedef NetSuccessCallback<T> = Function(T data);
typedef NetErrorCallback = Function(int code, String msg);

class HttpManager {
  String baseUrl = Config.hostUrl;
  int connectTimeout = 60000;
  int receiveTimeout = 60000;

  factory HttpManager() => _singleton;

  static final HttpManager _singleton = HttpManager._();

  static HttpManager get instance => HttpManager();

  static Dio _dio;

  Dio get dio => _dio;

  HttpManager._() {
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
    /// Fiddler抓包代理配置 https://www.jianshu.com/p/d831b1f7c45b
    // if(baseUrl==Config.hostUrl){
    //   (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
    //       (HttpClient client) {
    //     client.findProxy = (uri) {
    //       //proxy all request to localhost:8888
    //       return 'PROXY 172.16.100.27:8888';
    //     };
    //     client.badCertificateCallback =
    //         (X509Certificate cert, String host, int port) => true;
    //   };
    // }

    // 设置Cookie
    //  _dio.interceptors.add(CookieManager(CookieJar()));

    /// 添加拦截器
    _dio.interceptors..add(BaseInterceptor());
    if (kReleaseMode) {
      _dio.interceptors.add(LogInterceptor(
          responseBody: false,
          request: false,
          requestBody: false,
          requestHeader: false,
          responseHeader: false));
    } else {
      _dio.interceptors.add(LogInterceptor(
          responseBody: true,
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
    try {
      Options tempOptions = options;
      String sm4PublicKey = getPublicKey();
      String sm4EncryptKey = encryptSM4Key(sm4PublicKey);
      tempOptions ??= Options();
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
    wjPrint('打印请求的方式：post,请求的数据参数：${queryParameters ?? data}');
    Response response;
    try {
      Options tempOptions = options;
      String sm4PublicKey = getPublicKey();
      String sm4EncryptKey = encryptSM4Key(sm4PublicKey);
      if (tempOptions == null) {
        tempOptions ??= Options();
        tempOptions.headers['encrypt'] = sm4EncryptKey;
      } else {
        if (!tempOptions.headers.keys.contains("encrypt")) {
          tempOptions.headers['encrypt'] = sm4EncryptKey;
        }
      }
      if (data != null) {
        String encryptData;
        if (data is FormData) {
          wjPrint("加密后的数据：直传无加密: $data");
        } else {
          encryptData = wjEncrypt(data, sm4PublicKey);
          wjPrint("加密后的数据：$encryptData");
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

//   _addObserver()async{
//     // await FlutterNetworkConnection.startSampling();
//     // await FlutterNetworkConnection.start('http://baidu.com',sourceData: (value){
//     //   wjPrint('value--------$value');
//     // });
//     // FlutterNetworkConnection.getCurrentBandwidthQuality().then((value1){
//     //   wjPrint("获取当前的网络质量：$value1");
//     // });

//     bool isToast = false;
//     InternetSpeedObserver.uploadSpeedObserver(
//         onProgress: (value1, value2, unit) {
//           if (unit == SpeedUnit.Kbps) {
//             if (value2 < 300) {
//               if(isToast){
//                 ToastUtil.showWarningToast("网络开小差了");
//                 isToast = true;
//               }
//             }
//           } else if (unit == SpeedUnit.Mbps) {
//             if (value2 * 1024 < 300) {
//               if(isToast){
//                 ToastUtil.showWarningToast("网络开小差了");
//                 isToast = true;
//               }
//             }
//           }
//         }, onDone: (value, unit) {
//       if (unit == SpeedUnit.Kbps) {
//         if (value < 300) {
//           if(isToast){
//             ToastUtil.showWarningToast("网络开小差了");
//             isToast = true;
//           }
//         }
//       } else if (unit == SpeedUnit.Mbps) {
//         if (value * 1024 < 300) {
//           if(isToast){
//             ToastUtil.showWarningToast("网络开小差了");
//             isToast = true;
//           }
//         }
//       }
//     });
//   }
}

enum Method { get, post, put, patch, delete, head }

/// 使用拓展枚举替代 switch判断取值
// extension MethodExtension on Method {
//   String get value => ['GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'HEAD'][index];
// }
