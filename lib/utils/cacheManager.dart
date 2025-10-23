import 'dart:io';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:notarization_station_app/base_framework/utils/toast_util.dart';
import 'package:path_provider/path_provider.dart';

/*
 * 下载和缓存的文件存放在app的缓存目录，提供设置缓存的时效
 */
class CustomCacheManager extends BaseCacheManager {
  static const key = "customCache";

  static CustomCacheManager _instance;

  factory CustomCacheManager() {
    if (_instance == null) {
      _instance = new CustomCacheManager._();
    }
    return _instance;
  }

  CustomCacheManager._()
      : super(key,
            maxAgeCacheObject: Duration(days: 7), maxNrOfCacheObjects: 20);

  @override
  Future<String> getFilePath() async {
    var directory = await getTemporaryDirectory();
    var p;
    return p.join(directory.path, key);
  }

  //获取文件时，先从缓存中读取，缓存中没有对应文件和时间失效的情况下，再进行网络下载
  Future<File> getSingleFile(String url,
      {Map<String, String> headers, bool force = false}) async {
    var cacheFile = await getFileFromCache(url);
    if (cacheFile != null) {
      if (cacheFile.validTill.isBefore(DateTime.now())) {
        webHelper.downloadFile(url, authHeaders: headers);
      }
      return cacheFile.file;
    }
    try {
      FileInfo f;
      var download = //await webHelper.downloadFile(url, authHeaders: headers);
          await webHelper
              .downloadFile(url, authHeaders: headers, ignoreMemCache: force)
              .firstWhere((r) => r is FileInfo);
      f = download as FileInfo;
      return f.file;
    } catch (e) {
      return null;
    }
  }
}

//缓存操作类
class CacheManager {
  ///获取缓存
  static Future loadCache() async {
    Directory tempDir = await getTemporaryDirectory();
    double value = await _getTotalSizeOfFilesInDir(tempDir);
    //  wjPrint('临时目录大小: ' + tempDir.parent.path + value.toString());
    String d = _renderSize(value).toString();
    // wjPrint(d);
    return d;
  }

  //删除缓存
  static Future clearCache() async {
    Directory tempDir = await getTemporaryDirectory();
    //删除缓存目录
    await delDir(tempDir);
    await loadCache();
    ToastUtil.showSuccessToast("缓存清除成功");
  }

  //循环计算文件的大小（递归）
  static Future<double> _getTotalSizeOfFilesInDir(
      final FileSystemEntity file) async {
    if (file is File) {
//      wjPrint('缓存文件: ' + file.path);
      int length = await file.length();
      return double.parse(length.toString());
    }
    if (file is Directory) {
//      wjPrint('缓存文件夹: ' + file.path);
      final List<FileSystemEntity> children = file.listSync();
      double total = 0;
      if (children != null)
        for (final FileSystemEntity child in children)
          total += await _getTotalSizeOfFilesInDir(child);
      return total;
    }
    return 0;
  }

  //格式化缓存大小
  static String _renderSize(double value) {
    if (null == value) {
      return "0";
    }
    List<String> unitArr = List()..add('B')..add('K')..add('M')..add('G');
    int index = 0;
    while (value > 1024) {
      index++;
      value = value / 1024;
    }
    String size = value.toStringAsFixed(2);
    return (size + unitArr[index]).toString();
  }

  //递归方式删除目录
  static Future<Null> delDir(FileSystemEntity file) async {
    if (file is Directory) {
      final List<FileSystemEntity> children = file.listSync();
      for (final FileSystemEntity child in children) {
        await delDir(child);
      }
    }
    await file.delete();
  }
}
