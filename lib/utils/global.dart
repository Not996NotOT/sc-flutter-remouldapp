import 'dart:convert';
import 'dart:io';

import 'package:android_foreground_service/android_foreground_service.dart';
import 'package:connectivity/connectivity.dart';
import 'package:crypto/crypto.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:notarization_station_app/base_framework/utils/toast_util.dart';
import 'package:notarization_station_app/service_api/home_api.dart';
import 'package:permission_handler/permission_handler.dart';

import '../appTheme.dart';
import 'common_tools.dart';

class G {
  static bool isColorFiltered = false;

  static int isGranted = 0;

  static String currentPath = '';
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  /// toolbar routeName
  static final List toobarRouteNameList = ['mainIndex', 'codeLogin', 'login'];

  static NavigatorState getCurrentState() => navigatorKey.currentState;

  /// 获取当前的state
  static BuildContext getCurrentContext() => navigatorKey.currentContext;


  // /// sm4key使用sm2加密后的字符串
  // static String sm4EncryptString = "";
  // /// 国密加密sm4公钥
  // static String sm4PublicKey = "";
  /// 国密加密sm2公钥
  static String sm2PublicKey = "";
  /// 国密加密sm2私钥
  static String sm2PrivateKey = "";
  /// 国密加密sm2公钥
  static String clientId = "";
  /// 国密加密sm2私钥
  static String secret = "";


  static String iosClientId = "Q0pt5zzBMlBUuaVKjDVIVuITta74TnFZ";
  static String iosSecret = "IAALfCMiohhqrBZDXSceHlyjFuThr7IG";
  static String iosRequestPublic = "0459b5c7f2c2e11b2f055b5fe1020e0252056aab35e51de6b1c230a944492a32a0bc1c0fba5dc7d0c1ee1ea0b2dc35da1fd80e79767e9502512d9f095c0badd4d1";
  static String iosResponsePrivate = "0098ae71a88daedac22ef89f4e18efeb2fe2f352354f4d4669355e10a08ce371a8";


  static String androidClientId = "EcMzMyyXv9Iz9xLnOgM4IiECU7mCkbvL";
  static String androidSecret = "OiL3colPMtTzBJ0iK6jLyUwTh2ouKynT";
  static String androidRequestPublic = "0481d53c610004a37493ce55971ae5ee292252032c73a4b250b7cdd82c4e1288507626c6531776e992562e599ad14f109a677416dc9b3cec39cbc7e0266f039120";
  static String androidResponsePrivate = "41850ede04f9f0cb6cbe9a20332b55ade59af58303327c91285d460f67a962c9";



  // 司法鉴定用户身份证号
  static String _userIdCard = '';

  static String get userIdCard => _userIdCard;

  static set userIdCard(String value) {
    _userIdCard = value;
  }

  static String get userToken => _userToken;

  static set userToken(String value) {
    _userToken = value;
  }

  static String _indentyId = '';
  static String get indentyId => _indentyId;

  static set indentyId(value) => _indentyId = value;

  static String _userName = '';
  static String _userToken = '';

  static String get userName => _userName;

  static set userName(String value) {
    _userName = value;
  }

  ///html标签
  static String removeHtmlTag(String s) {
    var re = new RegExp('<[^<>]+>');
    return s.replaceAll(re, "");
  }

  /// 跳转页面使用 G.pushNamed
  static void pushNamed(String routeName, {Object arguments}) {
    // 如果跳转到toolbar页面  不能返回
    if (toobarRouteNameList.indexOf(routeName) > -1) {
      getCurrentState().pushReplacementNamed(
        routeName,
        arguments: arguments,
      );
    } else {
      getCurrentState().pushNamed(routeName, arguments: arguments);
    }
  }

  /// 返回页面,后退
  static void pop() => getCurrentState().pop();

  static Future<bool> requestCameraPermission() async {
    if (!await Permission.camera.status.isGranted ||
        !await Permission.storage.status.isGranted) {
      G.showCustomToast(
          context: G.getCurrentContext(),
          titleText: "相机、存储权限使用说明：",
          subTitleText: "用于拍摄、录制视频、文件存储等场景",
          time: 2);
    }
    final status = await Permission.storage.request();
    if (status == PermissionStatus.granted) {
      return true;
    } else {
      ToastUtil.showWarningToast('需要读写存储权限!');
      return false;
    }
  }

  //密码加密
  static String generateMd5(String data) {
    var content = new Utf8Encoder().convert(data);
    var digest = md5.convert(content);
    return digest.toString();
  }

  //设备信息
  static Future<String> phoneInfo(String latLng) async {
    String phoneInfo = "";
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      phoneInfo = json.encode({
        "machine": iosInfo.utsname.machine,
        "name": iosInfo.name,
        "systemName": iosInfo.systemName,
        "id": iosInfo.identifierForVendor,
        "systemVersion": iosInfo.systemVersion,
        "latLng": latLng,
      });
    } else {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      phoneInfo = json.encode({
        "fingerprint": androidInfo.fingerprint,
        "host": androidInfo.host,
        "model": androidInfo.model,
        "id": androidInfo.id,
        "androidId": androidInfo.androidId,
        "brand": androidInfo.brand,
        "latLng": latLng,
      });
    }
    return phoneInfo;
  }

  /// 获取ip信息
  static Future<String> getDeviceIPAddress() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      var wifiInfo = await NetworkInfo().getWifiIP();
      print("打印获取的ip地址：$wifiInfo");
      return wifiInfo;
    }
    return "";
  }

  /// 上传定位信息
  static uploadOrderLocation(map,{Function errorCallBack,Function responseError,Function responseSuccess}){
    print('定位的传参-----$map');
    HomeApi.getSingleton().uploadLocationInformation(map,errorCallBack: errorCallBack).then((value){
      if(value['code'] == 200){
        responseSuccess(value);
      }else {
        responseError(value);
      }
    });
  }

  // 弹出权限对话框
  static Future<bool> showPermissionDialog(
      {String str = "", Function cancelCallBack, Function settingCallBack}) {
    return showDialog<bool>(
      barrierDismissible: false,
      context: getCurrentContext(),
      builder: (context) {
        return WillPopScope(
          onWillPop: () async {
            return Future.value(false);
          },
          child: AlertDialog(
            title: Text("权限提示"),
            content: Text(
              "使用我们服务，需要你允许相关权限${str.isEmpty ? "" : "(" + str + ")"}，请到手机权限设置中设置",
              style: TextStyle(color: Colors.black, fontSize: 18.0),
            ),
            actions: <Widget>[
              // ignore: deprecated_member_use
              FlatButton(
                child: Text("拒绝"),
                onPressed: () {
                  Navigator.of(context).pop(true);
                  cancelCallBack();
                },
              ),
              // ignore: deprecated_member_use
              FlatButton(
                child: Text("确认"),
                onPressed: () async {
                  //关闭对话框并返回true
                  Navigator.of(context).pop(true);
                  openAppSettings();
                  settingCallBack();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // 前台服务权限请求
  static void requestForegroundService(
      {Function decideBack, Function cancelBack, Function iosBack}) {
    if (Platform.isAndroid) {
      Future.delayed(const Duration(milliseconds: 100), () {
        showCupertinoDialog(
            context: G.getCurrentContext(),
            builder: (context) {
              return CupertinoAlertDialog(
                title: Text("权限请求"),
                content: Text("为了保证您视频公证和摇号时能正常使用，青桐智盒需要向您请求前台服务权限"),
                actions: [
                  CupertinoDialogAction(
                    child: Text('同意'),
                    onPressed: () {
                      AndroidForegroundService.requestForegroundService
                          .then((value1) {
                        G.pop();
                        G.isGranted = 1;
                        AndroidForegroundService.startForegroundService();
                        decideBack.call();
                      });
                    },
                  ),
                  CupertinoDialogAction(
                      child: Text('拒绝'),
                      onPressed: () {
                        G.isGranted = 2;
                        G.pop();
                        cancelBack.call();
                      }),
                ],
              );
            });
      });
    } else if (Platform.isIOS) {
      iosBack.call();
    }
  }

  // 密码校验
  static bool checkPassWord(String pas) {
    int i = 0;
    RegExp regExp1 = RegExp('[0-9]');
    RegExp regExp2 = RegExp('[A-Z]');
    RegExp regExp3 = RegExp('[a-z]');
    RegExp regExp4 = RegExp('[\x21-\x2f]|[\x3a-\x40]|[\x5b-\x60]|[\x7b-\x7e]');

    if (regExp1.hasMatch(pas)) i++;
    if (regExp2.hasMatch(pas)) i++;
    if (regExp3.hasMatch(pas)) i++;
    if (regExp4.hasMatch(pas)) i++;
    if (i < 3) {
      return false;
    } else {
      return true;
    }
  }

// 根据身份证获取性别
  static String getGender(String idNumber) {
    int genderDigit = int.parse(idNumber.substring(16, 17));
    return genderDigit % 2 == 0 ? '女' : '男';
  }

// 根据身份证获取生日
  static String getBirthday(String idNumber) {
    String year = idNumber.substring(6, 10);
    String month = idNumber.substring(10, 12);
    String day = idNumber.substring(12, 14);
    return '$year-$month-$day';
  }

  // 校验身份证合法性
  static bool verifyCardId(String cardId) {
    const Map city = {
      11: "北京",
      12: "天津",
      13: "河北",
      14: "山西",
      15: "内蒙古",
      21: "辽宁",
      22: "吉林",
      23: "黑龙江 ",
      31: "上海",
      32: "江苏",
      33: "浙江",
      34: "安徽",
      35: "福建",
      36: "江西",
      37: "山东",
      41: "河南",
      42: "湖北 ",
      43: "湖南",
      44: "广东",
      45: "广西",
      46: "海南",
      50: "重庆",
      51: "四川",
      52: "贵州",
      53: "云南",
      54: "西藏 ",
      61: "陕西",
      62: "甘肃",
      63: "青海",
      64: "宁夏",
      65: "新疆",
      71: "台湾",
      81: "香港",
      82: "澳门",
      91: "国外 "
    };
    String tip = '';
    bool pass = true;

    RegExp cardReg = RegExp(
        r'^\d{6}(18|19|20)?\d{2}(0[1-9]|1[012])(0[1-9]|[12]\d|3[01])\d{3}(\d|X)$');
    if (cardId == null || cardId.isEmpty || !cardReg.hasMatch(cardId)) {
      tip = '身份证号格式错误';
      wjPrint(tip);
      pass = false;
      return pass;
    }
    if (city[int.parse(cardId.substring(0, 2))] == null) {
      tip = '地址编码错误';
      wjPrint(tip);
      pass = false;
      return pass;
    }
    // 18位身份证需要验证最后一位校验位，15位不检测了，现在也没15位的了
    if (cardId.length == 18) {
      List numList = cardId.split('');
      //∑(ai×Wi)(mod 11)
      //加权因子
      List factor = [7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2];
      //校验位
      List parity = [1, 0, 'X', 9, 8, 7, 6, 5, 4, 3, 2];
      int sum = 0;
      int ai = 0;
      int wi = 0;
      for (var i = 0; i < 17; i++) {
        ai = int.parse(numList[i]);
        wi = factor[i];
        sum += ai * wi;
      }
      var last = parity[sum % 11];
      if (parity[sum % 11].toString() != numList[17]) {
        tip = "校验位错误";
        wjPrint(tip);
        pass = false;
      }
    } else {
      tip = '身份证号不是18位';
      wjPrint(tip);
      pass = false;
    }
//  wjPrint('证件格式$pass');
    return pass;
  }

  // 根据身份证号获取年龄
  static String getBirthDayFromCardId(String cardId) {
    bool isRight = verifyCardId(cardId);
    if (!isRight) {
      return "";
    }
    int len = (cardId + "").length;
    String strBirthday = "";
    if (len == 18) {
      //处理18位的身份证号码从号码中得到生日和性别代码
      strBirthday = cardId.substring(6, 10) +
          "-" +
          cardId.substring(10, 12) +
          "-" +
          cardId.substring(12, 14);
    }
    if (len == 15) {
      strBirthday = "19" +
          cardId.substring(6, 8) +
          "-" +
          cardId.substring(8, 10) +
          "-" +
          cardId.substring(10, 12);
    }
    return strBirthday;
  }

// 根据出生日期获取年龄
  static int getAgeFromBirthday(String strBirthday) {
    if (strBirthday == null || strBirthday.isEmpty) {
      wjPrint('生日错误');
      return 0;
    }
    DateTime birth = DateTime.parse(strBirthday);
    DateTime now = DateTime.now();

    int age = now.year - birth.year;
    //再考虑月、天的因素
    if (now.month < birth.month ||
        (now.month == birth.month && now.day <= birth.day)) {
      age--;
    }
    return age;
  }

// 根据身份证获取性别
  static String getSexFromCardId(String cardId) {
    String sex = "";
    bool isRight = verifyCardId(cardId);
    if (!isRight) {
      return sex;
    }
    if (cardId.length == 18) {
      if (int.parse(cardId.substring(16, 17)) % 2 == 1) {
        sex = "男";
      } else {
        sex = "女";
      }
    }
    if (cardId.length == 15) {
      if (int.parse(cardId.substring(14, 15)) % 2 == 1) {
        sex = "男";
      } else {
        sex = "女";
      }
    }
    return sex;
  }

  //  checkPassword(String password) {
  // //数字
  //   final String REG_NUMBER = ".*\\d+.*";
  // //小写字母
  //   final String REG_UPPERCASE = ".*[A-Z]+.*";
  // //大写字母
  // final String REG_LOWERCASE = ".*[a-z]+.*";
  // //特殊符号
  //  final String REG_SYMBOL = ".*[~!@#$%^&*()_+|<>,.?/:;'\\[\\]{}\"]+.*";
  //
  //
  // //密码为空或者长度小于8位则返回false
  // if (password == null || password.length <8 ) return false;
  // int i = 0;
  // if (password.matches(REG_NUMBER)) i++;
  // if (password.matches(REG_LOWERCASE))i++;
  // if (password.matches(REG_UPPERCASE)) i++;
  // if (password.matches(REG_SYMBOL)) i++;
  //
  // if (i  < 3 )  return false;
  //
  // return true;
  // }

  // 自定的Dialog提示
  static void showCustomToast(
      {BuildContext context, String titleText, String subTitleText, int time}) {
    if (Platform.isAndroid) {
      final overlay = Overlay.of(context);
      OverlayEntry overlayEntry;

      overlayEntry = OverlayEntry(builder: (context) {
        return Material(
          color: Colors.transparent,
          child: Container(
            alignment: Alignment.topCenter,
            margin: EdgeInsets.only(top: 30),
            width: MediaQuery.of(context).size.width,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              decoration: BoxDecoration(
                color: AppTheme.nearlyWhite,
                borderRadius: BorderRadius.circular(10.0),
              ),
              margin: EdgeInsets.symmetric(horizontal: 10.0),
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titleText ?? '',
                    style: TextStyle(
                        color: AppTheme.textBlack,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    subTitleText ?? '',
                    style: TextStyle(color: AppTheme.textBlack, fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        );
      });

      overlay.insert(overlayEntry);

      Future.delayed(Duration(seconds: time ?? 3), () {
        overlayEntry.remove();
      });
    }
  }

  static const List<Map<String, dynamic>> phoneArea = [
    {"dictCode": "60", "dictName": "马来西亚", "dictValue": "2"},
    {"dictCode": "63", "dictName": "菲律宾", "dictValue": "2"},
    {"dictCode": "66", "dictName": "泰国", "dictValue": "2"},
    {"dictCode": "81", "dictName": "日本", "dictValue": "2"},
    {"dictCode": "84", "dictName": "越南", "dictValue": "2"},
    {"dictCode": "852", "dictName": "香港", "dictValue": "2"},
    {"dictCode": "855", "dictName": "柬埔寨", "dictValue": "2"},
    {"dictCode": "86", "dictName": "中国", "dictValue": "1"},
    {"dictCode": "880", "dictName": "孟加拉国", "dictValue": "2"},
    {"dictCode": "91", "dictName": "印度", "dictValue": "2"},
    {"dictCode": "93", "dictName": "阿富汗", "dictValue": "2"},
    {"dictCode": "95", "dictName": "缅甸", "dictValue": "2"},
    {"dictCode": "961", "dictName": "黎巴嫩", "dictValue": "2"},
    {"dictCode": "963", "dictName": "叙利亚", "dictValue": "2"},
    {"dictCode": "965", "dictName": "科威特", "dictValue": "2"},
    {"dictCode": "968", "dictName": "阿曼", "dictValue": "2"},
    {"dictCode": "973", "dictName": "巴林", "dictValue": "2"},
    {"dictCode": "975", "dictName": "不丹", "dictValue": "2"},
    {"dictCode": "977", "dictName": "尼泊尔", "dictValue": "2"},
    {"dictCode": "62", "dictName": "印度尼西亚", "dictValue": "2"},
    {"dictCode": "65", "dictName": "新加坡", "dictValue": "2"},
    {"dictCode": "673", "dictName": "文莱", "dictValue": "2"},
    {"dictCode": "82", "dictName": "韩国", "dictValue": "2"},
    {"dictCode": "850", "dictName": "朝鲜", "dictValue": "2"},
    {"dictCode": "853", "dictName": "澳门", "dictValue": "2"},
    {"dictCode": "856", "dictName": "老挝", "dictValue": "2"},
    {"dictCode": "886", "dictName": "台湾", "dictValue": "2"},
    {"dictCode": "90", "dictName": "土耳其", "dictValue": "2"},
    {"dictCode": "92", "dictName": "巴基斯坦", "dictValue": "2"},
    {"dictCode": "94", "dictName": "斯里兰卡", "dictValue": "2"},
    {"dictCode": "960", "dictName": "马尔代夫", "dictValue": "2"},
    {"dictCode": "962", "dictName": "约旦", "dictValue": "2"},
    {"dictCode": "964", "dictName": "伊拉克", "dictValue": "2"},
    {"dictCode": "966", "dictName": "沙特阿拉伯", "dictValue": "2"},
    {"dictCode": "972", "dictName": "以色列", "dictValue": "2"},
    {"dictCode": "974", "dictName": "卡塔尔", "dictValue": "2"},
    {"dictCode": "976", "dictName": "蒙古", "dictValue": "2"},
    {"dictCode": "98", "dictName": "伊朗", "dictValue": "2"},
    {"dictCode": "7", "dictName": "俄罗斯", "dictValue": "2"},
    {"dictCode": "31", "dictName": "荷兰", "dictValue": "2"},
    {"dictCode": "33", "dictName": "法国", "dictValue": "2"},
    {"dictCode": "350", "dictName": "直布罗陀", "dictValue": "2"},
    {"dictCode": "352", "dictName": "卢森堡", "dictValue": "2"},
    {"dictCode": "354", "dictName": "冰岛", "dictValue": "2"},
    {"dictCode": "356", "dictName": "马耳他", "dictValue": "2"},
    {"dictCode": "358", "dictName": "芬兰", "dictValue": "2"},
    {"dictCode": "336", "dictName": "匈牙利", "dictValue": "2"},
    {"dictCode": "338", "dictName": "南斯拉夫", "dictValue": "2"},
    {"dictCode": "223", "dictName": "圣马力诺", "dictValue": "2"},
    {"dictCode": "40", "dictName": "罗马尼亚", "dictValue": "2"},
    {"dictCode": "4175", "dictName": "列支敦士登", "dictValue": "2"},
    {"dictCode": "44", "dictName": "英国", "dictValue": "2"},
    {"dictCode": "46", "dictName": "瑞典", "dictValue": "2"},
    {"dictCode": "48", "dictName": "波兰", "dictValue": "2"},
    {"dictCode": "30", "dictName": "希腊", "dictValue": "2"},
    {"dictCode": "32", "dictName": "比利时", "dictValue": "2"},
    {"dictCode": "34", "dictName": "西班牙", "dictValue": "2"},
    {"dictCode": "351", "dictName": "葡萄牙", "dictValue": "2"},
    {"dictCode": "353", "dictName": "爱尔兰", "dictValue": "2"},
    {"dictCode": "355", "dictName": "阿尔巴尼亚", "dictValue": "2"},
    {"dictCode": "357", "dictName": "塞浦路斯", "dictValue": "2"},
    {"dictCode": "359", "dictName": "保加利亚", "dictValue": "2"},
    {"dictCode": "49", "dictName": "德国", "dictValue": "2"},
    {"dictCode": "39", "dictName": "意大利", "dictValue": "2"},
    {"dictCode": "396", "dictName": "梵蒂冈", "dictValue": "2"},
    {"dictCode": "41", "dictName": "瑞士", "dictValue": "2"},
    {"dictCode": "43", "dictName": "奥地利", "dictValue": "2"},
    {"dictCode": "45", "dictName": "丹麦", "dictValue": "2"},
    {"dictCode": "47", "dictName": "挪威", "dictValue": "2"},
    {"dictCode": "20", "dictName": "埃及", "dictValue": "2"},
    {"dictCode": "213", "dictName": "阿尔及利亚", "dictValue": "2"},
    {"dictCode": "218", "dictName": "利比亚", "dictValue": "2"},
    {"dictCode": "221", "dictName": "塞内加尔", "dictValue": "2"},
    {"dictCode": "223", "dictName": "马里", "dictValue": "2"},
    {"dictCode": "225", "dictName": "科特迪瓦", "dictValue": "2"},
    {"dictCode": "227", "dictName": "尼日尔", "dictValue": "2"},
    {"dictCode": "229", "dictName": "贝宁", "dictValue": "2"},
    {"dictCode": "231", "dictName": "利比里亚", "dictValue": "2"},
    {"dictCode": "233", "dictName": "加纳", "dictValue": "2"},
    {"dictCode": "235", "dictName": "乍得", "dictValue": "2"},
    {"dictCode": "237", "dictName": "喀麦隆", "dictValue": "2"},
    {"dictCode": "239", "dictName": "圣多美", "dictValue": "2"},
    {"dictCode": "240", "dictName": "赤道几内亚", "dictValue": "2"},
    {"dictCode": "242", "dictName": "刚果", "dictValue": "2"},
    {"dictCode": "244", "dictName": "安哥拉", "dictValue": "2"},
    {"dictCode": "247", "dictName": "阿森松", "dictValue": "2"},
    {"dictCode": "249", "dictName": "苏丹", "dictValue": "2"},
    {"dictCode": "251", "dictName": "埃塞俄比亚", "dictValue": "2"},
    {"dictCode": "253", "dictName": "吉布提", "dictValue": "2"},
    {"dictCode": "255", "dictName": "坦桑尼亚", "dictValue": "2"},
    {"dictCode": "257", "dictName": "布隆迪", "dictValue": "2"},
    {"dictCode": "260", "dictName": "赞比亚", "dictValue": "2"},
    {"dictCode": "262", "dictName": "留尼旺岛", "dictValue": "2"},
    {"dictCode": "264", "dictName": "纳米比亚", "dictValue": "2"},
    {"dictCode": "266", "dictName": "莱索托", "dictValue": "2"},
    {"dictCode": "268", "dictName": "斯威士兰", "dictValue": "2"},
    {"dictCode": "27", "dictName": "南非", "dictValue": "2"},
    {"dictCode": "297", "dictName": "阿鲁巴岛", "dictValue": "2"},
    {"dictCode": "210", "dictName": "摩洛哥", "dictValue": "2"},
    {"dictCode": "216", "dictName": "突尼斯", "dictValue": "2"},
    {"dictCode": "220", "dictName": "冈比亚", "dictValue": "2"},
    {"dictCode": "222", "dictName": "毛里塔尼亚", "dictValue": "2"},
    {"dictCode": "224", "dictName": "几内亚", "dictValue": "2"},
    {"dictCode": "226", "dictName": "布基拉法索", "dictValue": "2"},
    {"dictCode": "228", "dictName": "多哥", "dictValue": "2"},
    {"dictCode": "230", "dictName": "毛里求斯", "dictValue": "2"},
    {"dictCode": "232", "dictName": "塞拉利昂", "dictValue": "2"},
    {"dictCode": "234", "dictName": "尼日利亚", "dictValue": "2"},
    {"dictCode": "236", "dictName": "中非", "dictValue": "2"},
    {"dictCode": "238", "dictName": "佛得角", "dictValue": "2"},
    {"dictCode": "239", "dictName": "普林西比", "dictValue": "2"},
    {"dictCode": "241", "dictName": "加蓬", "dictValue": "2"},
    {"dictCode": "243", "dictName": "扎伊尔", "dictValue": "2"},
    {"dictCode": "245", "dictName": "几内亚比绍", "dictValue": "2"},
    {"dictCode": "248", "dictName": "塞舌尔", "dictValue": "2"},
    {"dictCode": "250", "dictName": "卢旺达", "dictValue": "2"},
    {"dictCode": "252", "dictName": "索马里", "dictValue": "2"},
    {"dictCode": "254", "dictName": "肯尼亚", "dictValue": "2"},
    {"dictCode": "256", "dictName": "乌干达", "dictValue": "2"},
    {"dictCode": "258", "dictName": "莫桑比克", "dictValue": "2"},
    {"dictCode": "261", "dictName": "马达加斯加", "dictValue": "2"},
    {"dictCode": "263", "dictName": "津巴布韦", "dictValue": "2"},
    {"dictCode": "265", "dictName": "马拉维", "dictValue": "2"},
    {"dictCode": "267", "dictName": "博茨瓦纳", "dictValue": "2"},
    {"dictCode": "269", "dictName": "科摩罗", "dictValue": "2"},
    {"dictCode": "290", "dictName": "圣赫勒拿", "dictValue": "2"},
    {"dictCode": "298", "dictName": "法罗群岛", "dictValue": "2"},
    {"dictCode": "1", "dictName": "美国", "dictValue": "2"},
    {"dictCode": "1808", "dictName": "中途岛", "dictValue": "2"},
    {"dictCode": "1808", "dictName": "威克岛", "dictValue": "2"},
    {"dictCode": "1809", "dictName": "维尔京群岛", "dictValue": "2"},
    {"dictCode": "1809", "dictName": "波多黎各", "dictValue": "2"},
    {"dictCode": "1809", "dictName": "巴哈马", "dictValue": "2"},
    {"dictCode": "1907", "dictName": "阿拉斯加", "dictValue": "2"},
    {"dictCode": "1", "dictName": "加拿大", "dictValue": "2"},
    {"dictCode": "1808", "dictName": "夏威夷", "dictValue": "2"},
    {"dictCode": "1809", "dictName": "安圭拉岛", "dictValue": "2"},
    {"dictCode": "1809", "dictName": "圣卢西亚", "dictValue": "2"},
    {"dictCode": "1809", "dictName": "牙买加", "dictValue": "2"},
    {"dictCode": "1809", "dictName": "巴巴多斯", "dictValue": "2"},
    {"dictCode": "299", "dictName": "格陵兰岛", "dictValue": "2"},
    {"dictCode": "500", "dictName": "福克兰群岛", "dictValue": "2"},
    {"dictCode": "502", "dictName": "危地马拉", "dictValue": "2"},
    {"dictCode": "504", "dictName": "洪都拉斯", "dictValue": "2"},
    {"dictCode": "506", "dictName": "哥斯达黎加", "dictValue": "2"},
    {"dictCode": "509", "dictName": "海地", "dictValue": "2"},
    {"dictCode": "52", "dictName": "墨西哥", "dictValue": "2"},
    {"dictCode": "54", "dictName": "阿根廷", "dictValue": "2"},
    {"dictCode": "56", "dictName": "智利", "dictValue": "2"},
    {"dictCode": "58", "dictName": "委内瑞拉", "dictValue": "2"},
    {"dictCode": "592", "dictName": "圭亚那", "dictValue": "2"},
    {"dictCode": "594", "dictName": "法属圭亚那", "dictValue": "2"},
    {"dictCode": "596", "dictName": "马提尼克", "dictValue": "2"},
    {"dictCode": "598", "dictName": "乌拉圭", "dictValue": "2"},
    {"dictCode": "501", "dictName": "伯利兹", "dictValue": "2"},
    {"dictCode": "503", "dictName": "萨尔瓦多", "dictValue": "2"},
    {"dictCode": "505", "dictName": "尼加拉瓜", "dictValue": "2"},
    {"dictCode": "507", "dictName": "巴拿马", "dictValue": "2"},
    {"dictCode": "51", "dictName": "秘鲁", "dictValue": "2"},
    {"dictCode": "53", "dictName": "古巴", "dictValue": "2"},
    {"dictCode": "55", "dictName": "巴西", "dictValue": "2"},
    {"dictCode": "57", "dictName": "哥伦比亚", "dictValue": "2"},
    {"dictCode": "591", "dictName": "玻利维亚", "dictValue": "2"},
    {"dictCode": "593", "dictName": "厄瓜多尔", "dictValue": "2"},
    {"dictCode": "595", "dictName": "巴拉圭", "dictValue": "2"},
    {"dictCode": "597", "dictName": "苏里南", "dictValue": "2"},
    {"dictCode": "61", "dictName": "澳大利亚", "dictValue": "2"},
    {"dictCode": "671", "dictName": "关岛", "dictValue": "2"},
    {"dictCode": "6723", "dictName": "诺福克岛", "dictValue": "2"},
    {"dictCode": "674", "dictName": "瑙鲁", "dictValue": "2"},
    {"dictCode": "677", "dictName": "所罗门群岛", "dictValue": "2"},
    {"dictCode": "679", "dictName": "斐济", "dictValue": "2"},
    {"dictCode": "683", "dictName": "纽埃岛", "dictValue": "2"},
    {"dictCode": "685", "dictName": "西萨摩亚", "dictValue": "2"},
    {"dictCode": "688", "dictName": "图瓦卢", "dictValue": "2"},
    {"dictCode": "64", "dictName": "新西兰", "dictValue": "2"},
    {"dictCode": "6722", "dictName": "科科斯岛", "dictValue": "2"},
    {"dictCode": "6724", "dictName": "圣诞岛", "dictValue": "2"},
    {"dictCode": "676", "dictName": "汤加", "dictValue": "2"},
    {"dictCode": "678", "dictName": "瓦努阿图", "dictValue": "2"},
    {"dictCode": "682", "dictName": "科克群岛", "dictValue": "2"},
    {"dictCode": "684", "dictName": "东萨摩亚", "dictValue": "2"},
    {"dictCode": "686", "dictName": "基里巴斯", "dictValue": "2"}
  ];
}
