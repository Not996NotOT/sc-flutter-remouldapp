/*
 * @Author: wangshibo wangshibo@gc.com
 * @Date: 2023-03-27 14:57:57
 * @LastEditors: 王士博 wangshibo@gc.com
 * @LastEditTime: 2023-07-12 14:47:41
 * @FilePath: /notarization-quzheng-flutter/lib/app/utils/javascript_channel_method.dart
 * @Description: 
 * 
 * Copyright (c) 2023 by ${git_name_email}, All Rights Reserved. 
 */

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:notarization_station_app/utils/global.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'alert_view.dart';

class JavascriptChannelMethod {
  JavascriptChannel _baseJavaChannel(
      BuildContext context, String methodName, ValueChanged<String> received) {
    String eventName = methodName;
    return JavascriptChannel(
        name: eventName,
        onMessageReceived: (JavascriptMessage message) {
          if (message.message.isNotEmpty) {
            received(message.message);
          } else {
            EasyLoading.showError("居然什么都没有给我😭");
          }
        });
  }

  Set<JavascriptChannel> loadJavascriptChannel(BuildContext context) {
    // _webViewController = controller;
    final Set<JavascriptChannel> channels = <JavascriptChannel>{};
    channels.add(testDownload(context));
    return channels;
  }


  JavascriptChannel testDownload(BuildContext context) {
    return _baseJavaChannel(context, "toFlutterMessage", (value) async{
      if(!await Permission.storage.status.isGranted){
        G.showCustomToast(
          context: G.getCurrentState().overlay.context,
          titleText: "文件存储权限使用说明：",
          subTitleText: "用于文件存储等场景",
          time: 2,);
      }
      if(await Permission.storage.request().isGranted){
        if (value.isNotEmpty) {
          Map<String, dynamic> result = jsonDecode(value);
          showCopyLinkAlert(
              url: result['url'],
              context: context,
              onConfirm: () {
                showDownloadFileNoPauseAlert(
                  url: result['url'],
                  fileSize: result['fileSize'],
                  fileName: result['fileName'],
                  type: DownloadType.electronicNotarialFileDownload,
                );
              });
        } else {
          EasyLoading.showError("无法获取到有效信息");
        }
      }else{
        G.showPermissionDialog(str: '访问内部存储权限');
      }
    });
  }
}
