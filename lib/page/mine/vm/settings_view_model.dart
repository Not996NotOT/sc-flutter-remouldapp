import 'dart:io';

import 'package:notarization_station_app/base_framework/view_model/single_view_state_model.dart';
import 'package:notarization_station_app/page/login/vm/user_view_model.dart';
import 'package:path_provider/path_provider.dart';

import '../../../utils/common_tools.dart';

class SettingsViewModel extends SingleViewStateModel {
  final UserViewModel userViewModel;
  String cacheStr = '';

  SettingsViewModel(this.userViewModel);

  /// 获取缓存
  Future<double> loadApplicationCache() async {
    /// 获取文件夹
    Directory directory = await getApplicationDocumentsDirectory();

    /// 获取缓存大小
    double value = await getTotalSizeOfFilesInDir(directory);
    return value;
  }

  /// 循环计算文件的大小（递归）
  Future<double> getTotalSizeOfFilesInDir(final FileSystemEntity file) async {
    if (file is File) {
      int length = await file.length();
      return double.parse(length.toString());
    }
    if (file is Directory) {
      final List<FileSystemEntity> children = file.listSync();
      double total = 0;
      if (children != null)
        for (final FileSystemEntity child in children)
          total += await getTotalSizeOfFilesInDir(child);
      return total;
    }
    return 0;
  }

  /// 缓存大小格式转换
  String formatSize(double value) {
    if (null == value) {
      return '0';
    }
    List<String> unitArr = List()..add('B')..add('K')..add('M')..add('G');
    int index = 0;
    while (value > 1024) {
      index++;
      value = value / 1024;
    }
    String size = value.toStringAsFixed(2);
    return size + unitArr[index];
  }

  /// 删除缓存
  void clearApplicationCache() async {
    Directory directory = await getApplicationDocumentsDirectory();
    wjPrint("缓存路径${directory}");
    //删除缓存目录
    await deleteDirectory(directory);
    getCache();
  }

  /// 递归方式删除目录
  Future<Null> deleteDirectory(FileSystemEntity file) async {
    try {
      if (file is Directory) {
        final List<FileSystemEntity> children = file.listSync();
        for (final FileSystemEntity child in children) {
          await deleteDirectory(child);
        }
      }
      await file.delete();
    } catch (e) {
      wjPrint("缓存路径sss$file");
    }
  }

  getCache() async {
    double value = await loadApplicationCache();
    cacheStr = formatSize(value);
    wjPrint('获取app缓存: ' + cacheStr);
    notifyListeners();
  }

  @override
  Future loadData() {
    getCache();
    return null;
  }

  @override
  onCompleted(data) {}
}
