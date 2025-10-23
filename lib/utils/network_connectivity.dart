import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/services.dart';
import 'package:notarization_station_app/base_framework/utils/toast_util.dart';

import 'common_tools.dart';

//定义变量（网络状态）
ConnectivityResult connectivityResult = ConnectivityResult.none;

class NetWorkConnectivityTools {
  StreamSubscription<ConnectivityResult> _connectivitySubscription;
  // //网络初始状态
  // connectivityInitState() async {
  //   await Connectivity().checkConnectivity();
  //   _connectivitySubscription = Connectivity()
  //       .onConnectivityChanged
  //       .listen((ConnectivityResult result) {
  //     connectivityResult = result;
  //     if (connectivityResult == ConnectivityResult.mobile) {
  //       EasyLoading.showError("当前处在4G网络", dismissOnTap: true);
  //     } else if (connectivityResult == ConnectivityResult.wifi) {
  //       EasyLoading.showError("当前处在wifi网络", dismissOnTap: true);
  //     } else if (connectivityResult == ConnectivityResult.none) {
  //       EasyLoading.showError("网络连接错误", dismissOnTap: true);
  //     }
  //   });
  // }

  //网络结束监听
  connectivityDispose() {
    _connectivitySubscription.cancel();
  }

  //网络进行监听
  initConnectivity() async {
    //平台消息可能会失败，因此我们使用Try/Catch PlatformException。
    try {
      connectivityResult = await Connectivity().checkConnectivity();
      // if(connectivityResult == ConnectivityResult.none){
      //   EasyLoading.showError("网络异常！", dismissOnTap: true);
      // }
      _connectivitySubscription = Connectivity()
          .onConnectivityChanged
          .listen((ConnectivityResult result) {
        connectivityResult = result;
        if (connectivityResult == ConnectivityResult.mobile) {
          ToastUtil.showWarningToast("当前处在4G网络");
        } else if (connectivityResult == ConnectivityResult.wifi) {
          ToastUtil.showWarningToast("当前处在wifi网络");
        } else if (connectivityResult == ConnectivityResult.none) {
          ToastUtil.showWarningToast("网络异常！");
        }
      });
    } on PlatformException catch (e) {
      wjPrint(e.toString());
    }
  }
}

class NetWorkTempConnectivityTools {
  //网络进行监听
  initConnectivity() async {
    //平台消息可能会失败，因此我们使用Try/Catch PlatformException。
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        ToastUtil.showWarningToast("网络异常，请稍后再试", second: 3);
      } else {
        // NetworkSpeed().getNetworkSpeed();
      }
    } on PlatformException catch (e) {
      wjPrint(e.toString());
    }
  }
}
