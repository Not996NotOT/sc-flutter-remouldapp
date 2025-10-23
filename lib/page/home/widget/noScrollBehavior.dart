/*
 * @Author: 王士博 wangshibo@gc.com
 * @Date: 2023-02-27 17:48:10
 * @LastEditors: 王士博 wangshibo@gc.com
 * @LastEditTime: 2023-06-07 09:14:49
 * @FilePath: /remouldApp/lib/page/home/widget/noScrollBehavior.dart
 * @Description: 
 * 
 * Copyright (c) 2023 by ${git_name_email}, All Rights Reserved. 
 */
import 'package:flutter/material.dart';

class EUMNoScrollBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    switch (getPlatform(context)) {
      case TargetPlatform.iOS:
        return child;
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
        return GlowingOverscrollIndicator(
          child: child,
          // 不显示头部水波纹
          showLeading: false,
          // 不显示尾部水波纹
          showTrailing: false,
          axisDirection: axisDirection,
          color: Theme.of(context).accentColor,
        );
      case TargetPlatform.linux:
        break;
      case TargetPlatform.macOS:
        break;
      case TargetPlatform.windows:
        break;
    }
    return child;
  }
}
