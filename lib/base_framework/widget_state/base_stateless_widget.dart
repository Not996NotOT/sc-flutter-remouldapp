import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notarization_station_app/base_framework/widget/behavior/over_scroll_behavior.dart';

import '../../appTheme.dart';

abstract class BaseStatelessWidget extends StatelessWidget {
  BuildContext context;

  ///切换状态栏 模式：light or dark
  ///应在根位置调用此方法
  Widget switchStatusBar2Dark(
      {bool isSetDark = false, @required Widget child, EdgeInsets edgeInsets}) {
    return AnnotatedRegion(
      value: isSetDark ? SystemUiOverlayStyle.dark : SystemUiOverlayStyle.light,
      child: Material(
        child: Padding(
          padding: edgeInsets ??
              EdgeInsets.only(bottom: ScreenUtil.getInstance().bottomBarHeight),
          child: child,
        ),
      ),
    );
  }

  ///去掉 scroll view的 水印  e.g : listView scrollView
  ///
  Widget getNoInkWellListView({@required Widget scrollView}) {
    return ScrollConfiguration(
      behavior: OverScrollBehavior(),
      child: scrollView,
    );
  }

  /// 一般页面的通用APP BAR 具体根据项目需求调整
  AppBar commonAppBar(
      {String title = '',
      bool borderBottom = false,
      bool isPop = true,
      List actions}) {
    return AppBar(
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: AppTheme.App_bar,
          ),
        ),
      ),
      centerTitle: true,
      title: Text(
        title,
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
      elevation: 0,
      leading: !isPop
          ? null
          : InkWell(
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
                size: 22,
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
      bottom: borderBottom
          ? PreferredSize(
              child: Divider(
                height: 1,
                thickness: 1,
              ),
              preferredSize: Size.fromHeight(0),
            )
          : null,
      actions: actions,
    );
  }

  Widget buildAppBarLeft() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Container(
        color: Colors.white,
        width: getWidthPx(150),
        height: getHeightPx(90),
        alignment: Alignment.bottomLeft,
        child: Icon(Icons.arrow_back_ios, size: 18),
      ),
    );
  }

  ///占位widget
  Widget getSizeBox({double width = 1, double height = 1}) {
    return SizedBox(
      width: width,
      height: height,
    );
  }

  /*
  * size adapter with tool ScreenUtil
  *
  * */

  double getHeightPx(double height) =>
      ScreenUtil.getInstance().getHeightPx(height);

  double getWidthPx(double width) => ScreenUtil.getInstance().getWidthPx(width);

  ///屏幕宽度
  double getScreenWidth() => ScreenUtil.getInstance().screenWidth;

  ///屏幕高度
  double getScreenHeight() => ScreenUtil.getInstance().screenHeight;

  //目前仅对于手机： 因为手机大多数情况下是长度变化较大，
  // 所以以高度来算出半径，保证异形屏的弧度不会缩小
  ///有其他需求，还需要重改
  double getRadiusFromHeight(double raidus) =>
      ScreenUtil.getInstance().getHeightPx(raidus);

  double getSp(double fontSize) => ScreenUtil.getInstance().getSp(fontSize);
}
