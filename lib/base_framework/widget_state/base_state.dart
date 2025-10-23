import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notarization_station_app/appTheme.dart';
import 'package:notarization_station_app/base_framework/widget/behavior/over_scroll_behavior.dart';

abstract class BaseState<T extends StatefulWidget> extends State<T> {
  double marginLeft = 0.0;
  double dragPosition = 0.0;
  bool slideOutActive = false;

  ///所有页面请务必使用此方法作为根布局
  ///切换状态栏 模式：light or dark
  ///应在根位置调用此方法
  ///needSlideOut是否支持右滑返回、如果整个项目不需要，可以配置默认值为false
  Widget switchStatusBar2Dark(
      {bool isSetDark = true,
      @required Widget child,

      ///适配、
      EdgeInsets edgeInsets,
      bool needSlideOut = false}) {
    if (!needSlideOut) {
      //不含侧滑退出
      return getNormalPage(
          isSetDark: isSetDark,
          child: child,
          edgeInsets: edgeInsets,
          needSlideOut: needSlideOut);
    } else {
      //侧滑退出
      return getPageWithSlideOut(
          isSetDark: isSetDark,
          child: child,
          edgeInsets: edgeInsets,
          needSlideOut: needSlideOut);
    }
  }

  Widget getNormalPage(
      {bool isSetDark = true,
      @required Widget child,

      ///适配、
      EdgeInsets edgeInsets,
      bool needSlideOut = false}) {
    return AnnotatedRegion(
        value:
            isSetDark ? SystemUiOverlayStyle.dark : SystemUiOverlayStyle.light,
        child: Material(
          color: Colors.white,
          child: Padding(
            padding: edgeInsets ??
                EdgeInsets.only(
                    bottom: ScreenUtil.getInstance().bottomBarHeight),
            child: child,
          ),
        ));
  }

  Widget getPageWithSlideOut(
      {bool isSetDark = true,
      @required Widget child,

      ///适配、
      EdgeInsets edgeInsets,
      bool needSlideOut = false}) {
    return AnnotatedRegion(
        value:
            isSetDark ? SystemUiOverlayStyle.dark : SystemUiOverlayStyle.light,
        child: Material(
          color: Colors.transparent,
          child: Padding(
            padding: edgeInsets ??
                EdgeInsets.only(
                    bottom: ScreenUtil.getInstance().bottomBarHeight),
            child: GestureDetector(
              onHorizontalDragStart: (dragStart) {
                slideOutActive =
                    dragStart.globalPosition.dx < (getScreenWidth() / 10);
              },
              onHorizontalDragUpdate: (dragDetails) {
                if (!slideOutActive) return;
                marginLeft = dragDetails.globalPosition.dx;
                dragPosition = marginLeft;
                //if(marLeft > 250) return;
                if (marginLeft < getWidthPx(50)) marginLeft = 0;
                setState(() {});
              },
              onHorizontalDragEnd: (dragEnd) {
                if (dragPosition > getScreenWidth() / 5) {
                  Navigator.of(context).pop();
                } else {
                  marginLeft = 0.0;
                  setState(() {});
                }
              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                margin: EdgeInsets.only(left: marginLeft),
                child: SingleChildScrollView(
                  physics: NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  child: child,
                ),
              ),
            ),
          ),
        ));
  }

  ///去掉 scroll view的 水印  e.g : listView scrollView
  ///当滑动到顶部或者底部时，继续拖动出现的蓝色水印
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
      Color backGroundColor,
      bool isPop = true,
      List actions}) {
    return AppBar(
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: backGroundColor ?? AppTheme.App_bar,
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

  ///通用APP bar 统一后退键
  Widget buildAppBarLeft() {
    return GestureDetector(
      onTap: () {
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        } else {
          ///增加需要的提示信息
        }
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

  /// current widget is visible and focusable if is true;
  bool isResumed = true;

  ///
  bool isInactive = true;

  ///cant not interact with user
  bool isPause = false;

  ///生命周期变化时回调
//  resumed:应用可见并可响应用户操作
//  inactive:用户可见，但不可响应用户操作
//  paused:已经暂停了，用户不可见、不可操作
//  suspending：应用被挂起，此状态IOS永远不会回调

  /// just trigger at user is pressing home or back button;
//  @override
//  void didChangeAppLifecycleState(AppLifecycleState state) {
//    isResumed = state == AppLifecycleState.resumed;
//
//    isInactive = state == AppLifecycleState.inactive;
//    isPause = state == AppLifecycleState.paused;
//
//  }

  /*
  * size adapter with tool ScreenUtil
  *
  * */

  ///得到适配后的高度
  double getHeightPx(double height) =>
      ScreenUtil.getInstance().getHeightPx(height);

  ///得到适配后的宽度
  double getWidthPx(double width) => ScreenUtil.getInstance().getWidthPx(width);

  ///屏幕宽度
  double getScreenWidth() => ScreenUtil.getInstance().screenWidth;

  ///屏幕高度
  double getScreenHeight() => ScreenUtil.getInstance().screenHeight;

  //目前仅对于手机： 因为手机大多数情况下是长度变化较大，
  // 所以以高度来算出半径，保证异形屏的弧度不会缩小
  //有其他需求，还需要重改
  /// 得到适配后的圆角半径
  double getRadiusFromHeight(double radius) =>
      ScreenUtil.getInstance().getHeightPx(radius);

  ///得到适配后的字号
  double getSp(double fontSize) => ScreenUtil.getInstance().getSp(fontSize);

  ///目前webview插件主要有两种，就当前版本介绍一下：
  ///  1、webview_flutter ^0.3.21
  ///     不支持html富文本、网页加载导致滚动异常 (如果遇到，使用wrapWebView() 方法可以解决)
  ///  2、flutter_webview_plugin  ^0.3.11
  ///     支持html富文本、但是会有web浮层导致遮盖其他原生页面（滑动退出页面时即可发现）

  ///解决 webview_flutter 滚动问题 update:解决不了
//  Widget wrapWebView(Widget webView){
//    return ListView(
//      padding: EdgeInsets.all(0),
//      children: <Widget>[
//        SizedBox.fromSize(
//          size: Size(100, 1000),
//          child: webView,
//        )
//      ],
//    );
//  }
  Widget loadingWidget() {
    return Center(
      child: SizedBox(
          width: 50,
          height: 50,
          child: CircularProgressIndicator(
              valueColor:
                  new AlwaysStoppedAnimation<Color>(AppTheme.themeBlue))),
    );
  }

  Widget emptyWidget(String content) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Image.asset(
            'lib/assets/images/empty.png',
            width: 100,
            height: 100,
          ),
          Text(
            content,
            style: TextStyle(color: Colors.grey),
          )
        ],
      ),
    );
  }
}
