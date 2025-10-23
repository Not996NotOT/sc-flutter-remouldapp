import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter_network_speed/flutter_network_speed.dart';
import 'package:flutter_network_speed/speed_controller.dart';
import 'package:notarization_station_app/base_framework/utils/toast_util.dart';

import 'common_tools.dart';

class NetworkSpeed {
  Future<double> getNetworkSpeed() async {
    final url = 'https://www.baidu.com/img/flexible/logo/plus_logo_web_2.png';
    final httpClient = HttpClient();
    final request = await httpClient.getUrl(Uri.parse(url));
    final response = await request.close();
    final totalBytes = response.contentLength;

    var speedTestTimer = Stopwatch()..start();

    response.listen((List<int> bytes) {}).onDone(() {
      speedTestTimer.stop();
      final downloadTimeInMs = speedTestTimer.elapsedMilliseconds;
      final speedInMbps = ((totalBytes / downloadTimeInMs) * 8) / 1000;
      wjPrint(
          "speedInMbps--------$speedInMbps,totalBytes--------$totalBytes,downloadTimeInMs--------$downloadTimeInMs");
      if (speedInMbps < 10 && 0 < speedInMbps) {
        ToastUtil.showToast("当前网速较差");
      }
      return speedInMbps;
    });
  }

  void listNetworkSpeed() async {
    SpeedController _speedController = SpeedController();
    FlutterNetworkSpeed _flutterNetworkSpeed = FlutterNetworkSpeed();
    _speedController.addListener(() {
      try {
        wjPrint("江苏省远程公证_speedController.value------${_speedController.value}");
        // if(_speedController.value.downloadValue!=null && _speedController.value.downloadValue.isNotEmpty){
        //   if(double.parse(_speedController.value.downloadValue) < 20){
        //     ToastUtil.showWarningToast("网络较差，请检查当前网络环境");
        //   }
        // }
        if (_speedController.value.uploadValue != null &&
            _speedController.value.uploadValue.isNotEmpty) {
          if (double.parse(_speedController.value.uploadValue) < 20) {
            ToastUtil.showWarningToast("网络较差，请检查当前网络环境");
          }
        }
        // _flutterNetworkSpeed.dispose();
        // _speedController.dispose();
      } catch (e) {
        log("网络监听抓取的错误：$e");
      }
    });
    _flutterNetworkSpeed.initInstance();
  }
}
