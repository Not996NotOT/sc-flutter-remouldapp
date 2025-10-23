import 'dart:io';
import 'dart:isolate';
import 'dart:math';
import 'dart:ui';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:notarization_station_app/base_framework/utils/toast_util.dart';
import 'package:notarization_station_app/service_api/home_api.dart';
import 'package:notarization_station_app/service_api/mine_api.dart';
import 'package:notarization_station_app/utils/event_bus_instance.dart';
import 'package:open_file/open_file.dart';
import 'package:package_info/package_info.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:notarization_station_app/base_framework/utils/toast_util.dart';
import 'package:notarization_station_app/page/mine/vm/apk_update_model.dart';

import 'common_tools.dart';
import 'global.dart';

ReceivePort _port = ReceivePort();

class AppInfo {
  AppInfo();

  String version;

  AppInfo.fromJson(Map<String, dynamic> json) : version = json['version'];
}

class CheckUpdate {
  static String _downloadPath = '';
  static String _filename = '青桐智盒.apk';
  String downloadUrl = '';
  static BuildContext context;

//Function showDialog
  Future check(BuildContext c, bool showNewToast) async {
    context = c;
    var hasNewVersion = await _checkVersion(showNewToast);
    if (hasNewVersion == null) {
      return null;
    }
    await _prepareDownload();
    if (_downloadPath.isNotEmpty) {
      if (Platform.isIOS) {
      } else {
        await download();
      }
    }
    return hasNewVersion;
  }

  // 下载前的准备
  Future<void> _prepareDownload() async {
    _downloadPath = (await _findLocalPath()) + '/Download';
    final savedDir = Directory(_downloadPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }
  }

  // 获取下载地址
  Future<String> _findLocalPath() async {
    final directory = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    return directory.path;
  }

  // 检查版本
  Future _checkVersion(bool showNewToast) async {
//    var options = Options(
//      contentType: Headers.formUrlEncodedContentType,
//    );
    var params = {"editionType": 1};
    var res = await HomeApi.getSingleton().updateVersion(params);
    wjPrint('获取$res');
    if (res != null && res['code'] == 200) {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      if (res['item'] != null && res['item']['appTitle'] != null) {
        if (res['item']["appTitle"].toString().contains(".")) {
          int appVersion = compareAppVersions(res['item']["appTitle"], packageInfo.version);
          wjPrint("appVersion------$appVersion");
          if (appVersion > 0) {
            downloadUrl = res['item']["filePath"];
            return res;
          } else {
            if (showNewToast) {
              ToastUtil.showSuccessToast("当前已是最新版本，无需更新！");
            }
            return null;
          }
        }
      } else {
        if (showNewToast) {
          ToastUtil.showSuccessToast("当前已是最新版本，无需更新！");
        }
        return null;
      }
    }
    return null;
  }

  // 检查权限
  static Future<bool> checkPermission() async {
    if (Platform.isAndroid) {
      return G.requestCameraPermission();
    } else {
      return true;
    }
  }

  // 下载完成之后的回调
  static downloadCallback(id, status, progress) {
    wjPrint('下载完成后$progress    $status');
    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send.send([id, status, progress]);
  }

  // 下载apk
  Future<void> download() async {
    wjPrint('==============开始下载');
    File file = File(_downloadPath + '/' + _filename);
    if (await file.exists()) await file.delete();
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) async {
      var id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];
      eventBus.fire({"name":"downloadApkCallback","progress":progress});
      // Provider.of<ApkUpdateModel>(context, listen: false).setTotal(progress);
      wjPrint('==============_installApkz: $progress');
      if (status == DownloadTaskStatus.complete) {
        // 更新弹窗提示，确认后进行安装
        wjPrint("DownloadTaskStatus-----$status");
        OpenFile.open('$_downloadPath/$_filename');
      }
    });
    FlutterDownloader.cancelAll();
    FlutterDownloader.registerCallback(downloadCallback);
    await FlutterDownloader.enqueue(
        url: downloadUrl,
        savedDir: _downloadPath,
        fileName: _filename,
        showNotification: true,
        openFileFromNotification: true);
  }

  // 安装apk
  static installApk() {
    OpenFile.open('$_downloadPath/$_filename');
  }
}
