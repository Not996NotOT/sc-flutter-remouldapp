import 'package:dart_ipify/dart_ipify.dart';

import 'common_tools.dart';

class IPAddressClass {
  static String apiKey = 'at_XTFAWf1WyWtalHRnNE7GanfvaKl1c';

  // 根据ip获取location
  static getMyGeo() {
    Ipify.geo(apiKey).then((value) {
      wjPrint('getMyGeo---------${value.location}');
      return value.location;
    });
  }

  // 获取ip地址
  static getIp() {
    Ipify.ipv64(format: Format.JSON).then((value) {
      wjPrint('getIp---------$value');
      return value;
    });
  }

  // 根据ip获取
  static getSomeGeo() {
    Ipify.geo(apiKey.toString(), ip: '8.8.8.8').then((value) {
      wjPrint('getSomeGeo---------$value');
      return value;
    });
  }

  static getBalance() {
    Ipify.balance(apiKey.toString()).then((value) {
      wjPrint('getBalance---------$value');
      return value;
    });
  }
}
