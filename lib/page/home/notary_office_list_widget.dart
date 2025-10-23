/*
 * @Author: wangshibo1689@gmail.com WSBwsb123!@#
 * @Date: 2023-10-24 10:37:35
 * @LastEditors: wangshibo1689@gmail.com WSBwsb123!@#
 * @LastEditTime: 2023-12-05 09:35:14
 * @FilePath: /remouldApp/lib/page/home/notary_office_list_widget.dart
 * @Description: 公证处列表
 * 
 * Copyright (c) 2023 by ${git_name_email}, All Rights Reserved. 
 */

import 'package:flutter/material.dart';
import 'package:notarization_station_app/appTheme.dart';
import 'package:notarization_station_app/base_framework/widget/provider_widget.dart';
import 'package:notarization_station_app/page/home/vm/notary_office_list_view_model.dart';
import 'package:notarization_station_app/routes/router.dart';
import 'package:notarization_station_app/utils/debounce_button.dart';
import 'package:notarization_station_app/utils/global.dart';

class NotaryOfficeListWidget extends StatefulWidget {
  String selectNotary;

  List dataList;

  String unitGuid;
  // 选中的鉴定机构
  String selectNotaryId;

  // 公证处名称
  String notaryName;

  NotaryOfficeListWidget(
      {Key key,
      this.selectNotary,
      this.dataList,
      this.unitGuid,
        this.notaryName,
      this.selectNotaryId})
      : super(key: key);

  @override
  State<NotaryOfficeListWidget> createState() => _NotaryOfficeListWidgetState();
}

class _NotaryOfficeListWidgetState extends State<NotaryOfficeListWidget> {
  String notary = '';
  List myData = [];
  String filePathString = '';
  // 录屏文件fileID
  String screenFileId = '';

  // 选中的鉴定机构
  String selectNotaryId = '';

  bool isEnable = true;

  @override
  void initState() {
    super.initState();
    notary = widget.selectNotary;
    selectNotaryId = widget.selectNotaryId;
    myData = widget.dataList;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("案件办理", style: TextStyle(color: Colors.black)),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_outlined,
              color: Colors.black,
            ),
            onPressed: () {
              G.getCurrentState().pushNamedAndRemoveUntil(
                  RoutePaths.judicialExpertiseList, (route) => false);
            },
          ),
        ),
        body: ProviderWidget<NotaryOfficeListViewModel>(
          model: NotaryOfficeListViewModel(),
          onModelReady: (model) {
            model.loadData();
          },
          builder: (context, viewModel, child) {
            return Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFF86B0F4), Color(0xFF5886EA)]),
                ),
                child: CustomScrollView(
                  slivers: [
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Column(
                        children: [
                          topTextWidget('${widget.notaryName ?? "南京市石城公证处"}'),
                          carWidget("$notary", myData),
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.only(top: 45,bottom: 40),
                            child: Text("南京市涉保理赔司法鉴定公证摇号系统",style: TextStyle(
                                color: AppTheme.white.withOpacity(0.8),
                                fontWeight: FontWeight.bold,
                                fontSize: 16
                            ),),
                          ),
                        ],
                      ),
                    )
                  ],
                ));
          },
        ),
      ),
    );
  }

  // 顶部文字显示
  Widget topTextWidget(String notaryName) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 30, bottom: 24, left: 30, right: 30),
            child: Text(
              '本案件由$notaryName进行公证',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 48),
            child: Text(
              '抽取结果',
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          )
        ],
      );

  // 中间car视图
  Widget carWidget(String notaryName, List dataSource) => Container(
        margin: EdgeInsets.symmetric(horizontal: 15),
        padding: EdgeInsets.all(30),
        height: 490,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(
              "本次随机抽取的司法鉴定机构为",
              style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF333333),
                  fontWeight: FontWeight.bold),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              height: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Color(0xFFedf4ff),
                  borderRadius: BorderRadius.circular(10)),
              child: Text(
                notaryName ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFF333333),
                    fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 50),
              child: Image.asset('lib/assets/images/shicheng_icon_grey.png',
                  width: 140, height: 140),
            ),
            DebounceButton(
              isEnable: isEnable,
              margin: EdgeInsets.only(top: 20),
              padding: EdgeInsets.symmetric(vertical: 15),
              borderRadius: BorderRadius.circular(10),
              backgroundColor: AppTheme.themeBlue,
              clickTap: () {
                G.getCurrentState().pushNamedAndRemoveUntil(
                    RoutePaths.judicialExpertiseList, (route) => false);
              },
              child: Text(
                '完成',
                style: TextStyle(
                    fontSize: 18,
                    color: AppTheme.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      );
}
