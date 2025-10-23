import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:notarization_station_app/config.dart';
import 'package:notarization_station_app/routes/router.dart' as Routers;
import 'package:notarization_station_app/utils/ServiceLocator.dart';
import 'package:notarization_station_app/utils/network_connectivity.dart';
import 'package:package_info/package_info.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:umeng_apm_sdk/umeng_apm_sdk.dart';

import 'base_framework/config/app_config.dart';
import 'global/global_provider_manager.dart';
import 'utils/common_tools.dart';
import 'utils/global.dart';
import 'utils/log_utils.dart';

// ignore: must_be_immutable
void main() async {
  final UmengApmSdk umengApmSdk = UmengApmSdk(
    name: '',

    bver: '',

    // 是否开启SDK运行时日志输出
    enableLog: true,

    // 您使用的flutter版本，默认为空，为方便定位访问，建议配置
    flutterVersion: '2.5.0',

    engineVersion: 'f0826da7ef',

    // 开启监测页面帧率（默认关闭) 版本 v2.1.3 可支持
    enableTrackingPageFps: true,

    // 开启监测页面性能（默认关闭）版本 v2.1.3 可支持
    enableTrackingPagePerf: true,

    // 带入继承ApmWidgetsFlutterBinding的覆写和初始化方法, 可用于自定义监听应用生命周期
    // 确保去掉原有的WidgetsFlutterBinding.ensureInitialized() ，以免出现重复初始化绑定的异常造成无法正常初始化，SDK内部已通过initFlutterBinding入参带入继承的WidgetsFlutterBinding实现初始化操作
    initFlutterBinding: MyApmWidgetsFlutterBinding.ensureInitialized,

//    抛出异常事件
    onError: (exception, stack) {
      print(
          "WeJeson/系统捕捉的details错误信息：\n ${exception.toString()}---${stack.toString()}");
      // LogUtils.writeDataToFilePath(
      //     'flutterApp/易存链/UmengFlutterErrorDetails: ${DateTime.now()} ==>${exception.toString()} ===>$stack');
      // LogUtils.writeDataToFilePath(
      //     'flutterApp/易存链/UmengFlutterErrorDetails: ${DateTime.now()} ==> exception: ${exception.toString()} ===> stack: ${stack.toString()}');
    },
  );

  umengApmSdk.init(appRunner: (observer) async {
    // 确保去掉原有的WidgetsFlutterBinding.ensureInitialized() ，以免出现重复初始化绑定的异常造成无法正常初始化，SDK内部已通过initFlutterBinding入参带入继承的WidgetsFlutterBinding实现初始化操作
    // 依赖ensureInitialized()初始化的代码可在此调用
    // 需要异步获取设置应用名称和版本号可在此回调中操作
    // SDK实例化的设置可先将name和bver 为 "",然后通过以下方式进行设置
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String packageName = packageInfo.packageName;
    String buildNumber = packageInfo.buildNumber;
    String version = packageInfo.version;
    umengApmSdk.name = packageName;
    umengApmSdk.bver = '$version+$buildNumber';
    // await NetWorkConnectivityTools().initConnectivity();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isOne = prefs.getBool("isOne");
    try {
      Response response = await Dio().get("${Config.hostUrl}apistatus/");
      debugPrint("response-----$response");
      if (response.data != null &&
          response.data["country_state"] != null &&
          response.data["country_state"]['code'] == 200001) {
        debugPrint('getData:success');
        G.isColorFiltered = true;
      }
    } catch (e) {
      ExceptionTrace.captureException(exception: Exception(e.toString()));
    }

    ///横竖屏
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    await AppConfig.init();
    setupLocator();
    // /// 动态申请定位权限
    // requestPermission();
    if (Platform.isAndroid) {
      await FlutterDownloader.initialize(debug: true);
    }
    EasyLoading.instance
      ..displayDuration = Duration(minutes: 3)
      ..maskType = EasyLoadingMaskType.black
      ..userInteractions = false;
    return MyApp(
      navigatorObserver: observer,
    );
  });
  FlutterError.onError = (FlutterErrorDetails details) async {
    debugPrint("进入FlutterError.onError");
    LogUtils.writeDataToFilePath("系统报错写入：$details");
    bool isDebugMode = false;
    assert(() {
      isDebugMode = true;
      return true;
    }());
    if (isDebugMode) {
      FlutterError.dumpErrorToConsole(details);
    } else {
      ExceptionTrace.captureException(exception: Exception(details.toString()));
    }
  };
}

/// 动态申请定位权限
void requestPermission() async {
  // 申请权限
  bool hasLocationPermission = await requestLocationPermission();
  if (hasLocationPermission) {
    debugPrint("定位权限申请通过");
  } else {
    debugPrint("定位权限申请不通过");
  }
}

/// 申请定位权限
/// 授予定位权限返回true， 否则返回false
Future<bool> requestLocationPermission() async {
  //获取当前的权限
  var status = await Permission.location.status;
  if (status == PermissionStatus.granted) {
    //已经授权
    return true;
  } else {
    //未授权则发起一次申请
    status = await Permission.location.request();
    if (status == PermissionStatus.granted) {
      return true;
    } else {
      return false;
    }
  }
}

class MyApmWidgetsFlutterBinding extends ApmWidgetsFlutterBinding {
  static WidgetsBinding ensureInitialized() {
    MyApmWidgetsFlutterBinding();
    return WidgetsBinding.instance;
  }
}

class MyApp extends StatefulWidget {
  final NavigatorObserver navigatorObserver;
  const MyApp({Key key, this.navigatorObserver}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    getProjectEncryptSetting();
  }

  @override
  Widget build(BuildContext context) {
    ///设计图尺寸
    setDesignWHD(750, 1334, density: 1.0);
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: MultiProvider(
          providers: providers,
          child: RefreshConfiguration(
            hideFooterWhenNotFull: false, //列表数据不满一页,不触发加载更多
            child: MaterialApp(
                navigatorKey: G.navigatorKey,
                navigatorObservers: <NavigatorObserver>[
                  widget.navigatorObserver ??
                      ApmNavigatorObserver.singleInstance
                ],
                debugShowCheckedModeBanner: false,
                locale: Locale("zh"),
                title: "青桐智盒",
                //国际化工厂代理
                localizationsDelegates: [
                  RefreshLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate
                ],
                supportedLocales: [
                  const Locale('en'),
                  const Locale('zh'),
                ],
                localeResolutionCallback:
                    (Locale locale, Iterable<Locale> supportedLocales) {
                  return locale;
                },
                onGenerateRoute: Routers.Router.getRoutes,
                builder: (BuildContext context, Widget child) {
                  return MediaQuery(
                    data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                    child: Material(
                      type: MaterialType.transparency,
                      child: FlutterEasyLoading(child: child),
                    ),
                  );
                },
                initialRoute: Routers.RoutePaths.HomeIndex
                // home: NavigationHomeScreen(),
                ),
          )),
    );
  }
}

// 重写HttpOverrides
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    var http = super.createHttpClient(context);
    http.findProxy = (uri) {
      return 'PROXY 172.16.100.27:8888';
    };
    http.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    return http;
  }
}
