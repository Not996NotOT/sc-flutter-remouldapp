/*
 * @Author: wangshibo1689@gmail.com WSBwsb123!@#
 * @Date: 2023-09-21 21:40:51
 * @LastEditors: wangshibo1689@gmail.com WSBwsb123!@#
 * @LastEditTime: 2023-12-15 11:23:55
 * @FilePath: /notarization-quzheng-flutter-noPay/lib/app/utils/log_utils.dart
 * @Description: 
 * 
 * Copyright (c) 2023 by ${git_name_email}, All Rights Reserved. 
 */

import 'dart:io';

import 'package:notarization_station_app/utils/isolate_tools.dart';
import 'package:path_provider/path_provider.dart';

import 'common_tools.dart';

class LogUtils {
  
  /// 初始化
  static initial() async {
    String path = '';
    if(Platform.isIOS){
    path = (await getApplicationDocumentsDirectory()).path;
    }else if(Platform.isAndroid){
      path = (await getExternalStorageDirectory()).path;
    }

    path = "$path/logs";
    var file = Directory(path);
    String filePath = "";
    try {
      bool exists = file.existsSync();
      if (!exists) {
        file.createSync();
      }
      filePath = "$path/log.txt";
    } catch (e) {
      wjPrint("e------$e");
    }
    return filePath;
  }

  // 文件写入
  static void writeDataToFilePath(String data) async {
    // if(File(filePath).existsSync()){
    String filePath = await initial();
    if (filePath.isNotEmpty) {
      IsoLateTools().writeDataToFilePath(
          data: {"path": filePath, 'content': data},
          callBack: (value) {
            wjPrint("文件写入的结果:$value");
          });
    }

    // }else{
    //   File.cr
    // }
  }

}
