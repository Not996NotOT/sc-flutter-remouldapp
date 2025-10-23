import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:amap_location_fluttify/amap_location_fluttify.dart';
import 'package:dart_sm/dart_sm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluwx/fluwx.dart';
import 'package:notarization_station_app/base_framework/utils/toast_util.dart';
import 'package:notarization_station_app/utils/global.dart';
import 'package:notarization_station_app/utils/string_common.dart';
import 'package:notarization_station_app/utils/updateEntity.dart';
import 'package:package_info/package_info.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:umeng_common_sdk/umeng_common_sdk.dart';
import 'package:url_launcher/url_launcher.dart';

import '../appTheme.dart';
import '../routes/router.dart';
import '../service_api/home_api.dart';
import 'alert_view.dart';
import 'check_update.dart';


DateTime _lastPressedAt;


/// s4 数据加密
String wjEncrypt(dynamic data,String sm4KeyString ) {
  String jsonString = "";
  if (data == null){
    jsonString = jsonEncode("");
  }else{
    jsonString = jsonEncode(data);
  }

  String sm4String = SM4.encrypt(jsonString, key: sm4KeyString);
  // String sm2String = SM2.encrypt(sm4String, G.sm2PublicKey, cipherMode: 1);
  return sm4String;
}

/// 加密sm4公钥
String encryptSM4Key(String sm4String){
  String sm4EncryptString = SM2.encrypt(sm4String, G.sm2PublicKey, cipherMode: 1);
  return "04$sm4EncryptString";
}

/// 获取sm4公钥
 String getPublicKey() {
  return generateRandomHex128();
}

/// sm2解密
dynamic wjDecrypt(dynamic data,) {
  String sm4String = SM2.decrypt(data, G.sm2PrivateKey);
  return jsonDecode(sm4String);
}

/// 获取当前项目的公钥还是私钥
void getProjectEncryptSetting(){
  if (Platform.isIOS){
    G.clientId = G.iosClientId;
    G.sm2PublicKey = G.iosRequestPublic;
    G.sm2PrivateKey = G.iosResponsePrivate;
    G.secret = G.iosSecret;
  }else if(Platform.isAndroid){
    G.clientId = G.androidClientId;
    G.secret = G.androidSecret;
    G.sm2PublicKey = G.androidRequestPublic;
    G.sm2PrivateKey = G.androidResponsePrivate;
  }
  wjPrint("G.clientId: ${G.clientId} \n");
  wjPrint("G.secret: ${G.secret} \n");
  wjPrint("G.sm2PublicKey: ${G.sm2PublicKey} \n");
  wjPrint("G.sm2PrivateKey: ${G.sm2PrivateKey} \n");
}


/// 生成随机 128 比特（16 字节）的十六进制字符串
String generateRandomHex128() {
  final random = Random();
  // 生成16个随机字节
  final bytes = List.generate(16, (index) => random.nextInt(256));
  // 将字节列表转换为十六进制字符串
  return bytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();
}

/// version1:远程版本
/// version2:本地版本
// 代码版本比较
int compareAppVersions(String version1, String version2) {
  List<int> version1Components = version1.split('.').map(int.parse).toList();
  List<int> version2Components = version2.split('.').map(int.parse).toList();

  int maxLength = version1Components.length > version2Components.length
      ? version1Components.length
      : version2Components.length;

  for (int i = 0; i < maxLength; i++) {
    int value1 = (i < version1Components.length) ? version1Components[i] : 0;
    int value2 = (i < version2Components.length) ? version2Components[i] : 0;

    if (value1 < value2) return -1;
    if (value1 > value2) return 1;
  }
  return 0;
}

/// 获取后台的当前版本
void getRemoteVersionData(BuildContext context) async {
  var params = {"editionType": 1};
  HomeApi.getSingleton().updateVersion(params).then((value) async {
    if (value == null) return;
    AppUpdate appInfo = AppUpdate.fromJson(value);
    bool hasUpdate = false;
    if (appInfo.code == 200) {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      if (appInfo.item != null && appInfo.item.appTitle != null) {
        int appVersion = compareAppVersions(appInfo.item.appTitle, packageInfo.version);
        hasUpdate = appVersion > 0 ? true : false;
      }
    }
    if (hasUpdate) {
      compareVersion(context, appInfo.item.appContent);
    }

    wjPrint('获取后台的当前版本-------$value');
  });
}

/// 判断当前版本大小
void compareVersion(BuildContext context, String content) {
  showCupertinoDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async {
            if (_lastPressedAt == null ||
                DateTime.now().difference(_lastPressedAt) >
                    Duration(seconds: 2)) {
              _lastPressedAt = DateTime.now();
              ToastUtil.showOtherToast("再按一次，退出");
              return Future.value(false);
            } else {
              exit(0);
            }
          },
          child: Material(
            color: Colors.transparent,
            child: Container(
              margin:
              const EdgeInsets.symmetric(vertical: 200, horizontal: 50),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    "lib/assets/images/bg_update_top.png",
                    fit: BoxFit.cover,
                  ),
                  Expanded(
                    child: Container(
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10.0),
                              bottomRight: Radius.circular(10.0))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                              child: Padding(
                                padding:
                                const EdgeInsets.symmetric(horizontal: 15),
                                child: Text(
                                  '$content',
                                  // "1、优化api接口。\n 2、添加使用demo演示。\n 3、新增自定义更新服务API接口。\n 4、优化更新提示界面。",
                                  style: TextStyle(
                                    fontSize: 16.0,
                                  ),
                                ),
                              )),
                          GestureDetector(
                            child: Center(
                              child: Container(
                                width: 120,
                                height: 40,
                                alignment: Alignment.center,
                                margin:
                                const EdgeInsets.symmetric(vertical: 15),
                                decoration: BoxDecoration(
                                    color: Colors.redAccent,
                                    borderRadius:
                                    BorderRadius.circular(10.0)),
                                child: Text(
                                  "更新",
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                            onTap: () async {
                              if (Platform.isIOS) {
                                String urlString =
                                    'https://apps.apple.com/cn/app/%E9%9D%92%E6%A1%90%E6%99%BA%E7%9B%92/id1540090264';
                                if (await canLaunch(urlString)) {
                                  await launch(urlString);
                                }
                              } else if (Platform.isAndroid) {
                                if (!await Permission
                                    .storage.status.isGranted) {
                                  G.showCustomToast(
                                      context: G.getCurrentContext(),
                                      titleText: "存储权限使用说明：",
                                      subTitleText: "文件存储等场景",
                                      time: 2);
                                }
                                final status =
                                await Permission.storage.request();
                                if (status == PermissionStatus.granted) {
                                  G.pop();
                                  showDownloadApkProgress(context);
                                  CheckUpdate checkUpdate = CheckUpdate();
                                  checkUpdate.check(context, false);
                                } else {
                                  G.showPermissionDialog(str: "访问存储权限");
                                }

                                // String urlString =
                                //     'https://sc.njguochu.com:46/index.html?${Random().nextDouble() * 300}';
                                // if (await canLaunch(urlString)) {
                                //   await launch(urlString);
                                // }
                              }
                            },
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      });
}

/// 计算KB
int caculateKBSize(int size) {
  int tempSize = 0;
  wjPrint("size--------$size");
  if (size == 0) {
    return tempSize;
  }
  tempSize = size ~/ 1024 + 1;
  wjPrint("tempSize-------$tempSize");
  return tempSize;
}

/// 判断输入的字符串是中文还是英文
List<String> judgeChineseOrEnglishName(String name) {
  List<String> tempList = [];
  if (name == null || name.isEmpty) {
    return ['null'];
  }
  if (name.isChinese()) {
    if (name.contains('·')) {
      name.replaceAll('·', '');
      tempList = name.split('');
      return tempList;
    }
    tempList = name.split("");
    return tempList;
  } else if (name.isEnglish()) {
    if (name.endsWith(" ")) {
      name = name.substring(0, name.length - 1);
    }
    if (name.startsWith(' ')) {
      name = name.substring(1, name.length);
    }
    if (name.contains(" ")) {
      tempList = name.split(" ");
      return tempList;
    } else if (name.contains(",")) {
      tempList = name.split(",");
      return tempList;
    } else if (name.contains("/")) {
      tempList = name.split("/");
      return tempList;
    } else if (name.length <= 5) {
      tempList.add(name);
      return tempList;
    } else if (name.length > 5) {
      int len = name.length ~/ 5;
      int segment = name.length % 5;
      segment > 0 ? len++ : len;
      for (int i = 0; i < len; i++) {
        if (i == len - 1) {
          tempList.add(name.substring(i * 5, name.length));
        } else {
          tempList.add(name.substring(i * 5, (i + 1) * 5));
        }
      }
      return tempList;
    }
    return ["null"];
  } else if (name.length <= 5) {
    tempList.add(name);
    return tempList;
  } else if (name.length > 5) {
    int len = name.length ~/ 5;
    int segment = name.length % 5;
    segment > 0 ? len++ : len;
    for (int i = 0; i < len; i++) {
      if (i == len - 1) {
        tempList.add(name.substring(i * 5, name.length));
      } else {
        tempList.add(name.substring(i * 5, (i + 1) * 5));
      }
    }
    return tempList;
  }
}

/// 隐私权限弹框
void requestPrivacy() {
  Future.delayed(Duration.zero, () async {
    var prefs = await SharedPreferences.getInstance();
    bool isOne = prefs.getBool("isOne");
    wjPrint("------------$isOne");
    if (isOne == null || isOne) {
      showDeleteConfirmDialog();
    } else {
      await AmapLocation.instance.init(
          iosKey:
              "02c307e37731dc02c57b91cc563b04bb"); // 3da2a762ec5f22e0933aec3e3f0956c1
      // AMapFlutterLocation.setApiKey("a4fb7c89b43e3bf648ceb45390467da9", "3da2a762ec5f22e0933aec3e3f0956c1");
      // await FluwxPay.initFluwx("wx01962cc4ae161f91");
      registerWxApi(
          appId: "wx01962cc4ae161f91",
          universalLink: "https://0oyh2i.xinstall.com.cn/tolink/");

      String channelString = "";
      if (Platform.isAndroid) {
        channelString = "青桐智盒/android";
      } else if (Platform.isIOS) {
        channelString = "青桐智盒/ios";
      }
      UmengCommonSdk.initCommon("667a7a43cac2a664de54b001",
          "667a7a7c940d5a4c4976eafd", channelString);
      UmengCommonSdk.setPageCollectionModeAuto();
      if (G.isGranted == 0) {
        G.requestForegroundService();
      }
    }
  });
}

// 弹出对话框
Future<bool> showDeleteConfirmDialog() {
  return showDialog<bool>(
    barrierDismissible: false,
    context: G.getCurrentContext(),
    builder: (context) {
      return WillPopScope(
        onWillPop: () async {
          return Future.value(false);
        },
        child: AlertDialog(
          title: const Text("隐私政策"),
          content: RichText(
            text: TextSpan(
              text: '欢迎你使用青桐智盒APP，请你仔细阅读并充分理解 ',
              style: TextStyle(color: Colors.black, fontSize: 18.0),
              children: <TextSpan>[
                TextSpan(
                  text: '《隐私政策》 ',
                  style: TextStyle(
                    color: AppTheme.themeBlue,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async {
                      G.pushNamed(RoutePaths.Privacy);
                    },
                ),
                TextSpan(text: '如你同意'),
                TextSpan(
                  text: '《隐私政策》 ',
                  style: TextStyle(
                    color: AppTheme.themeBlue,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async {
                      G.pushNamed(RoutePaths.Privacy);
                    },
                ),
                TextSpan(
                  text: '的全部内容，请点击“同意”开始使用我们的服务 ',
                ),
              ],
            ),
          ),
          actions: <Widget>[
            MaterialButton(
              child: Text("取消"),
              onPressed: () => G.pop(),
            ),
            MaterialButton(
              child: Text("同意"),
              onPressed: () async {
                //关闭对话框并返回true
                var prefs = await SharedPreferences.getInstance();
                prefs.setBool("isOne", false);
                Navigator.of(context).pop(true);
                await AmapLocation.instance.init(
                    iosKey:
                        "02c307e37731dc02c57b91cc563b04bb"); // 3da2a762ec5f22e0933aec3e3f0956c1
                // AMapFlutterLocation.setApiKey("a4fb7c89b43e3bf648ceb45390467da9", "3da2a762ec5f22e0933aec3e3f0956c1");
                // await FluwxPay.initFluwx("wx01962cc4ae161f91");
                registerWxApi(
                    appId: "wx01962cc4ae161f91",
                    universalLink: "https://0oyh2i.xinstall.com.cn/tolink/");
                G.requestForegroundService();
                String channelString = "";
                if (Platform.isAndroid) {
                  channelString = "青桐智盒/android";
                } else if (Platform.isIOS) {
                  channelString = "青桐智盒/ios";
                }
                UmengCommonSdk.initCommon("667a7a43cac2a664de54b001",
                    "667a7a7c940d5a4c4976eafd", channelString);
                UmengCommonSdk.setPageCollectionModeAuto();
              },
            ),
          ],
        ),
      );
    },
  );
}

// 检查是否同意隐私权限
void checkPrivacy() {
  Future.delayed(Duration.zero, () async {
    var prefs = await SharedPreferences.getInstance();
    bool isOne = prefs.getBool("isOne");
    wjPrint("------------$isOne");
    if (isOne == null || isOne) {
      showPrivacyConfirmDialog();
    } else {
      await AmapLocation.instance.init(
          iosKey:
              "02c307e37731dc02c57b91cc563b04bb"); // 3da2a762ec5f22e0933aec3e3f0956c1
      // AMapFlutterLocation.setApiKey("a4fb7c89b43e3bf648ceb45390467da9", "3da2a762ec5f22e0933aec3e3f0956c1");
      // await FluwxPay.initFluwx("wx01962cc4ae161f91");
      registerWxApi(
          appId: "wx01962cc4ae161f91",
          universalLink: "https://0oyh2i.xinstall.com.cn/tolink/");
      String channelString = "";
      if (Platform.isAndroid) {
        channelString = "青桐智盒/android";
      } else if (Platform.isIOS) {
        channelString = "青桐智盒/ios";
      }
      UmengCommonSdk.initCommon("667a7a43cac2a664de54b001",
          "667a7a7c940d5a4c4976eafd", channelString);
      UmengCommonSdk.setPageCollectionModeAuto();
      if (G.isGranted == 0) {
        G.requestForegroundService();
      }
    }
  });
}

// 弹出对话框
Future<bool> showPrivacyConfirmDialog() {
  return showDialog<bool>(
    barrierDismissible: false,
    context: G.getCurrentContext(),
    builder: (context) {
      return WillPopScope(
        onWillPop: () async {
          return Future.value(false);
        },
        child: AlertDialog(
          title: const Text("提示"),
          content: RichText(
            text: TextSpan(
              text: '使用该功能需要你仔细阅读并同意',
              style: TextStyle(color: Colors.black, fontSize: 18.0),
              children: <TextSpan>[
                TextSpan(
                  text: '《隐私政策》 ',
                  style: TextStyle(
                    color: AppTheme.themeBlue,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async {
                      G.pushNamed(RoutePaths.Privacy);
                    },
                ),
                TextSpan(text: '如你同意'),
                TextSpan(
                  text: '《隐私政策》 ',
                  style: TextStyle(
                    color: AppTheme.themeBlue,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async {
                      G.pushNamed(RoutePaths.Privacy);
                    },
                ),
                TextSpan(
                  text: '的全部内容，请点击“同意”后使用我们的服务，否则无法继续使用 ',
                ),
              ],
            ),
          ),
          actions: <Widget>[
            MaterialButton(
              child: Text("不同意"),
              onPressed: () => G.pop(),
            ),
            MaterialButton(
              child: Text("同意"),
              onPressed: () async {
                //关闭对话框并返回true
                var prefs = await SharedPreferences.getInstance();
                prefs.setBool("isOne", false);
                Navigator.of(context).pop(true);
                await AmapLocation.instance.init(
                    iosKey:
                        "02c307e37731dc02c57b91cc563b04bb"); // 3da2a762ec5f22e0933aec3e3f0956c1
                // AMapFlutterLocation.setApiKey("a4fb7c89b43e3bf648ceb45390467da9", "3da2a762ec5f22e0933aec3e3f0956c1");
                // await FluwxPay.initFluwx("wx01962cc4ae161f91");
                registerWxApi(
                    appId: "wx01962cc4ae161f91",
                    universalLink: "https://0oyh2i.xinstall.com.cn/tolink/");
                String channelString = "";
                if (Platform.isAndroid) {
                  channelString = "青桐智盒/android";
                } else if (Platform.isIOS) {
                  channelString = "青桐智盒/ios";
                }
                UmengCommonSdk.initCommon("667a7a43cac2a664de54b001",
                    "667a7a7c940d5a4c4976eafd", channelString);
                UmengCommonSdk.setPageCollectionModeAuto();
                G.requestForegroundService();
              },
            ),
          ],
        ),
      );
    },
  );
}
void wjPrint(Object data) {
  if (!kReleaseMode) {
    print(data);
  }
}
