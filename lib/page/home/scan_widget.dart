/*
 * @Author: 王士博 wangshibo@gc.com
 * @Date: 2023-07-12 17:15:47
 * @LastEditors: 王士博 wangshibo@gc.com
 * @LastEditTime: 2023-07-18 16:51:27
 * @FilePath: /remouldApp/lib/page/home/scan_widget.dart
 * @Description: 
 * 
 * Copyright (c) 2023 by ${git_name_email}, All Rights Reserved. 
 */
import 'dart:convert';
import 'dart:io';

import 'package:barcode_scan2/gen/protos/protos.pbenum.dart';
import 'package:barcode_scan2/model/android_options.dart';
import 'package:barcode_scan2/model/scan_options.dart';
import 'package:barcode_scan2/platform_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:notarization_station_app/base_framework/utils/toast_util.dart';
import 'package:notarization_station_app/routes/router.dart';
import 'package:notarization_station_app/service_api/home_api.dart';
import 'package:notarization_station_app/utils/global.dart';

import '../../config.dart';
import '../../utils/common_tools.dart';

class ScanWidget extends StatefulWidget {
  const ScanWidget({Key key}) : super(key: key);

  @override
  State<ScanWidget> createState() => _ScanWidgetState();
}

class _ScanWidgetState extends State<ScanWidget> {
  static final _possibleFormats = BarcodeFormat.values.toList()
    ..removeWhere((e) => e == BarcodeFormat.unknown);

  final List<BarcodeFormat> selectedFormats = [..._possibleFormats];

  /// 初始化二维码扫描
  void initScanner(Function callBack) async {
    try {
      final result = await BarcodeScanner.scan(
        options: ScanOptions(
          strings: {
            'cancel': "取消",
            // 'flash_on': "打开",
            // 'flash_off': "关闭",
          },
          restrictFormat: selectedFormats,
          useCamera: -1,
          autoEnableFlash: false,
          android: const AndroidOptions(
            aspectTolerance: 0.00,
            useAutoFocus: true,
          ),
        ),
      );
      callBack(result);
      // setState(() => scanResult = result);
    } on PlatformException catch (e) {
      wjPrint("PlatformException-------$e");
    }
  }

  @override
  void initState() {
    super.initState();
    initScanner((result) {
      if (result != null &&
          result.rawContent != null &&
          result.rawContent.isNotEmpty) {
        try {
          Map<String, dynamic> resultMap = jsonDecode(result.rawContent);
          if (resultMap['type'] == 1) {
            if (resultMap['unitGuid'] == null) {
              ToastUtil.showToast("公证书制作中，请稍后再试");
              G.pop();
            } else {
              EasyLoading.show(status: '证书查询中...');
              HomeApi.getSingleton().selectByOrderGuid(
                  {"unitGuid": resultMap['unitGuid']}, errorCallBack: (e) {
                EasyLoading.dismiss();
              }).then((value) {
                EasyLoading.dismiss();
                if (value['code'] == 200) {
                  if (value['data']) {
                    Navigator.pushNamed(
                        G.getCurrentContext(), RoutePaths.webViewWidget,
                        arguments: {
                          "title": '电子公证书',
                          'url':
                              "${Config.notarialCertificate}?unitGuid=${(jsonDecode(result.rawContent) as Map)['unitGuid']}&device=${Platform.isIOS ? "iOS" : "Android"}"
                        }).then((value) => G.pop());
                  } else {
                    ToastUtil.showToast("公证书制作中，请稍后再试");
                    G.pop();
                  }
                } else {
                  ToastUtil.showToast("${value.data['message']}}");
                  G.pop();
                }
              });
            }
          } else {
            Navigator.pop(G.getCurrentContext(), true);
          }
        } catch (e) {
          Navigator.pop(G.getCurrentContext(), true);
        }
      } else if (result != null &&
          result.rawContent != null &&
          result.rawContent.isEmpty) {
        Navigator.pop(G.getCurrentContext(), false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox();
  }
}
