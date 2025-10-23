import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluwx/fluwx.dart';
import 'package:notarization_station_app/appTheme.dart';
import 'package:notarization_station_app/base_framework/utils/toast_util.dart';
import 'package:notarization_station_app/base_framework/widget_state/base_state.dart';
import 'package:notarization_station_app/components/awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:notarization_station_app/iconfont/Icon.dart';
import 'package:notarization_station_app/page/helper/index.dart';
import 'package:notarization_station_app/page/home/index.dart';
import 'package:notarization_station_app/page/home/index_new.dart';
import 'package:notarization_station_app/routes/router.dart';
import 'package:notarization_station_app/service_api/home_api.dart';
import 'package:notarization_station_app/socket/mqtt_client.dart';
import 'package:notarization_station_app/utils/alert_view.dart';
import 'package:notarization_station_app/utils/check_update.dart';
import 'package:notarization_station_app/utils/common_tools.dart';
import 'package:notarization_station_app/utils/global.dart';
import 'package:notarization_station_app/utils/updateEntity.dart';
import 'package:package_info/package_info.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../service_api/home_api.dart';
import 'home/scan_widget1.dart';
import 'infomation/message.dart';
import 'login/vm/user_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'mine/mine_page.dart';

typedef TransportScrollController = Function(ScrollController controller);

class MainIndexPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MainIndexPageState();
  }
}

class MainIndexPageState extends BaseState<MainIndexPage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  TabController _tabController;
  DateTime lastPress;
  DateTime _lastPressedAt;

  final List<Widget> pages = [
    // HomeIndexWdiget(),
    IndexNew(),
    HelperPage(),
    ScanWidget1(),
    // InformationIndexPage(),
    // CommunityPage(),
    MessagePage(),
    MinePage()
  ];
  SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    requestPrivacy();
    Future.delayed(Duration(microseconds: 200), () async {
      prefs = await SharedPreferences.getInstance();
      bool isOne = prefs.getBool("isOne");
      if (!isOne) {
        getRemoteVersionData(context);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return switchStatusBar2Dark(
        isSetDark: true,
        edgeInsets: EdgeInsets.all(0),
        child: Container(
            color: AppTheme.white,
            width: getWidthPx(750),
            height: getHeightPx(1334),
            child: Consumer<UserViewModel>(builder: (ctx, vm, child) {
              if (vm.idCard != null && vm.hasUser) {
                MqttClientMsg.instance.connect(vm.idCard);
              }
              _tabController.animateTo(vm.currentIndex);
              return Scaffold(
                body: WillPopScope(
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
                  child: TabBarView(
                      controller: _tabController,
                      physics: NeverScrollableScrollPhysics(),
                      children: pages),
                ),
                bottomNavigationBar: Theme(
                    data: ThemeData(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent),
                    child: BottomBarCreative(
                      items: [
                        TabItemImage(
                          icon: "lib/assets/images/home_new.png",
                          selectIcon: "lib/assets/images/home_new_select.png",
                          // ignore: deprecated_member_use
                          title: '首页',
                        ),
                        TabItemImage(
                          icon: "lib/assets/images/search_new.png",
                          selectIcon: 'lib/assets/images/search_new_select.png',
                          // ignore: deprecated_member_use
                          title: '查询',
                        ),
                        TabItemImage(
                          icon: 'lib/assets/images/bottom_scan.png',
                          selectIcon: "lib/assets/images/bottom_scan.png",
                          // ignore: deprecated_member_use
                          title: "",
                        ),
                        TabItemImage(
                          icon: "lib/assets/images/message_new.png",
                          selectIcon:
                              "lib/assets/images/message_new_select.png",
                          // ignore: deprecated_member_use
                          title: '消息',
                        ),
                        TabItemImage(
                          icon: "lib/assets/images/person_new.png",
                          selectIcon: "lib/assets/images/person_new_select.png",
                          title: '我的',
                        ),
                      ],
                      backgroundColor: Colors.white,
                      color: Colors.black,
                      colorSelected: AppTheme.themeBlue,
                      visitHighlight: 2,
                      indexSelected: vm.currentIndex,
                      highlightStyle: const HighlightStyle(
                          sizeLarge: false, isHexagon: false, elevation: 2),
                      onTap: (int index) async {
                        prefs = await SharedPreferences.getInstance();
                        bool isOne = prefs.getBool("isOne");
                        if (index == 2) {
                          if (isOne != null && !isOne) {
                            vm.currentIndex = index;
                            _tabController.animateTo(index);
                          } else {
                            requestPrivacy();
                          }
                        } else {
                          vm.currentIndex = index;
                          _tabController.animateTo(index);
                        }
                      },
                    )),
              );
            })));
  }

  @override
  bool get wantKeepAlive => true;
}
