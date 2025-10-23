import 'package:notarization_station_app/base_framework/config/storage_manager.dart';

abstract class AppConfig {
  String getHostUrl();

  static init() async {
    ///启动本地存储工具
    await StorageManager.init();
  }
}
