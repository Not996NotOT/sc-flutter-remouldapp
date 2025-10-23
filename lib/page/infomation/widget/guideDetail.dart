/*
 * @Author: 王士博 wangshibo@gc.com
 * @Date: 2023-03-29 14:58:16
 * @LastEditors: 王士博 wangshibo@gc.com
 * @LastEditTime: 2023-04-26 11:30:09
 * @FilePath: /sc-flutter-remouldapp/remouldApp/lib/page/infomation/widget/guideDetail.dart
 * @Description: 
 * 
 * Copyright (c) 2023 by ${git_name_email}, All Rights Reserved. 
 */
import 'package:flutter/material.dart';
import 'package:notarization_station_app/appTheme.dart';
import 'package:notarization_station_app/base_framework/widget_state/base_state.dart';
import 'package:notarization_station_app/utils/global.dart';

class GuideDetailPage extends StatefulWidget {
  int arguments;
  GuideDetailPage({Key key, this.arguments}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return GuidePageState();
  }
}

class GuidePageState extends BaseState<GuideDetailPage> {
  String img1 = 'lib/assets/images/video_guide.png';
  String img2 = 'lib/assets/images/zizhu_guide.png';
  int state = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          setState(() {
            state = 1;
          });
          G.pop();
          return false;
        },
        child: Scaffold(
          appBar: commonAppBar(title: "办证指南"),
          backgroundColor: AppTheme.chipBackground,
          body: SingleChildScrollView(
            child: Image.asset(
              widget.arguments == 1 ? img2 : img1,
              width: getWidthPx(750),
              fit: BoxFit.fill,
            ),
          ),
        ));
  }
}
