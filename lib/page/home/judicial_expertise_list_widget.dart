/*
 * @Author: wangshibo1689@gmail.com WSBwsb123!@#
 * @Date: 2023-10-23 11:21:48
 * @LastEditors: wangshibo1689@gmail.com WSBwsb123!@#
 * @LastEditTime: 2023-12-05 09:41:43
 * @FilePath: /remouldApp/lib/page/home/judicial_expertise_list_widget.dart
 * @Description: 司法鉴定列表
 * 
 * Copyright (c) 2023 by ${git_name_email}, All Rights Reserved. 
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:notarization_station_app/appTheme.dart';
import 'package:notarization_station_app/base_framework/widget/provider_widget.dart';
import 'package:notarization_station_app/base_framework/widget_state/base_state.dart';
import 'package:notarization_station_app/components/throttleUtil.dart';
import 'package:notarization_station_app/model/judicial_expertise_list_data_model.dart';
import 'package:notarization_station_app/page/home/vm/judicial_expertise_list_view_model.dart';
import 'package:notarization_station_app/routes/router.dart';
import 'package:notarization_station_app/utils/debounce_button.dart';
import 'package:notarization_station_app/utils/global.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class JudicialExpertiseListWidget extends StatefulWidget {
  JudicialExpertiseListWidget({Key key}) : super(key: key);

  @override
  State<JudicialExpertiseListWidget> createState() =>
      _JudicialExpertiseListWidgetState();
}

class _JudicialExpertiseListWidgetState
    extends BaseState<JudicialExpertiseListWidget> {
  JudicialExpertiseListViewModel _listViewModel;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _listViewModel.searchController.dispose();
    _listViewModel.focusNode?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            title: Text("司法鉴定公证摇号", style: TextStyle(color: Colors.black)),
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
                    RoutePaths.HomeIndex, (route) => false);
              },
            ),
          ),
          body: ProviderWidget<JudicialExpertiseListViewModel>(
            builder: (context, viewModel, child) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  caseNumberAndSearchWidget,
                  Expanded(child: caseListWidget),
                ],
              );
            },
            model: JudicialExpertiseListViewModel(),
            onModelReady: (model) {
              _listViewModel = model;
              model.loadData();
            },
          ),
        ),
        onWillPop: () async {
          G
              .getCurrentState()
              .pushNamedAndRemoveUntil(RoutePaths.HomeIndex, (route) => false);
          return Future.value(true);
        });
  }

  // 顶部按键编号及搜索组件
  Widget get caseNumberAndSearchWidget => Container(
        margin: EdgeInsets.all(15),
        height: 40,
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 12, right: 10),
                  child: Text(
                    "车牌号",
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),
                // RotatedBox(
                //    quarterTurns: _listViewModel.turn ? -2 : 2,
                //   child: Icon(
                //    _listViewModel.turn ? Icons.arrow_drop_down : Icons.arrow_drop_up,
                //     color: _listViewModel.turn ? AppTheme.themeBlue : AppTheme.bg_f ,
                //     size: 20,
                //   ),
                // )
                // ,
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 5, bottom: 5, right: 5),
              child: VerticalDivider(),
            ),
            Expanded(
                child: TextField(
              textAlignVertical: TextAlignVertical.center,
              focusNode: _listViewModel.focusNode,
              style: TextStyle(
                fontSize: 14,
              ),
              controller: _listViewModel.searchController,
              inputFormatters: [
                LengthLimitingTextInputFormatter(20),
                FilteringTextInputFormatter.deny(RegExp("[ ]"))
              ],
              onChanged: (value) {
                if (_listViewModel.searchController.text.length > 0) {
                  setState(() {
                    _listViewModel.hasFocus = true;
                  });
                } else {
                  setState(() {
                    _listViewModel.hasFocus = false;
                  });
                }
              },
              decoration: InputDecoration(
                  hintText: _listViewModel.filterPlaceHolder,
                  hintStyle: TextStyle(
                    fontSize: 14,
                    color: Color(0xFFBFBFBF),
                  ),
                  isCollapsed: true,
                  suffixIcon: _listViewModel.hasFocus
                      ? GestureDetector(
                          onTap: () {
                            _listViewModel.searchController.text = '';
                            _listViewModel.searchText = '';
                            _listViewModel.focusNode.unfocus();
                            _listViewModel.getOrderData();
                          },
                          child: Icon(
                            Icons.clear,
                            size: 20,
                            color: AppTheme.dark_grey,
                          ),
                        )
                      : SizedBox(),
                  border: InputBorder.none),
            )),
            InkWell(
              onTap: ThrottleUtil().throttle(() {
                _listViewModel.focusNode.unfocus();
                _listViewModel.searchText =
                    _listViewModel.searchController.text;
                _listViewModel.refresh();
              }),
              child: Container(
                  width: 35,
                  height: 35,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: AppTheme.themeBlue,
                      borderRadius: BorderRadius.circular(10)),
                  child: Icon(
                    Icons.search_rounded,
                    color: Colors.white,
                    size: 20,
                  )),
            )
          ],
        ),
      );
  // 案件列表
  Widget get caseListWidget => Stack(
        children: [
          Offstage(
            offstage: _listViewModel.isInit,
            child: Container(
              alignment: Alignment.center,
              color: Colors.white,
              child: Column(
                children: [
                  const Spacer(),
                  Container(
                    alignment: Alignment.center,
                    child: Image.asset(
                      "lib/assets/images/shicheng_icon_grey.png",
                      width: 210,
                      height: 210,
                    ),
                  ),
                  const Spacer(),
                  Padding(
                      padding: EdgeInsets.only(bottom: 40),
                      child: Text(
                        "南京市涉保理赔司法鉴定公证摇号系统",
                        style: TextStyle(
                            color: Color(0xFFA1A4AD).withOpacity(0.8),
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ))
                ],
              ),
            ),
          ),
          MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: _listViewModel.isInit
                  ? SmartRefresher(
                      controller: _listViewModel.refreshController,
                      onRefresh: _listViewModel.refresh,
                      onLoading: _listViewModel.loadMore,
                      enablePullUp: true,
                      enablePullDown: true,
                      child: _listViewModel.dataSource.isNotEmpty
                          ? ListView.builder(
                              itemCount: _listViewModel.dataSource.length,
                              itemBuilder: (context, index) {
                                return itemContainerWidget(index);
                              },
                            )
                          : Container(
                              alignment: Alignment.center,
                              color: Colors.white,
                              child: Column(
                                children: [
                                  const Spacer(),
                                  Container(
                                    alignment: Alignment.center,
                                    child: Image.asset(
                                      "lib/assets/images/shicheng_icon_grey.png",
                                      width: 210,
                                      height: 210,
                                    ),
                                  ),
                                  const Spacer(),
                                  Padding(
                                      padding: EdgeInsets.only(bottom: 40),
                                      child: Text(
                                        "南京市涉保理赔司法鉴定公证摇号系统",
                                        style: TextStyle(
                                            color: Color(0xFFA1A4AD)
                                                .withOpacity(0.8),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ))
                                ],
                              ),
                            ),
                    )
                  : loadingWidget()),
        ],
      );

  // item Container widget
  Widget itemContainerWidget(int index) {
    Records records = _listViewModel.dataSource[index];
    return Container(
      margin: EdgeInsets.only(left: 15, right: 15, bottom: 15),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: AppTheme.white, borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          rowItemWidget("车牌号", records.caseNumber ?? ''),
          rowItemWidget("受理时间", dealTimeString(records.acceptanceDate)),
          rowItemWidget(
              "摇号人",
              records.whetherDelegate == 1
                  ? records.principalName
                  : records.name ?? ''),
          rowItemWidget('身份证号',
              "${records.whetherDelegate == 1 ? records.principalIdCard : records.idCard ?? ''}"),
          records.whetherDelegate == 1
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    rowItemWidget('被鉴定人', "${records.name ?? ''}"),
                    rowItemWidget('身份证号', "${records.idCard ?? ''}"),
                  ],
                )
              : const SizedBox(),
          rowItemWidget("摇号创建时间", dealTimeString(records.createDate)),
          Padding(
            padding: EdgeInsets.only(
              top: 15,
              bottom: 10,
            ),
            child: Divider(),
          ),
          Row(
            children: [
              Image.asset(
                records.status == "4" ||
                        records.status == "7" ||
                        records.status == "6"
                    ? "lib/assets/images/icon_has_finished.png"
                    : (records.status == '5'
                        ? 'lib/assets/images/icon_has_terminal.png'
                        : (records.status == '3'
                            ? "lib/assets/images/icon_waiting_lottery.png"
                            : "lib/assets/images/icon_waiting_lottery.png")),
                width: 25,
                height: 25,
                fit: BoxFit.fill,
              ),
              Padding(
                padding: EdgeInsets.only(left: 5),
                child: Text(
                  records.status == "4"
                      ? "已完成"
                      : (records.status == "5"
                          ? '已终止'
                          : records.status == "6"
                              ? "不予受理"
                              : (records.status == '7'
                                  ? "鉴定完成"
                                  : records.status == "3"
                                      ? '待摇号'
                                      : "待摇号")),
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFF333333),
                  ),
                ),
              ),
              const Spacer(),
              Offstage(
                offstage: records.status == "5",
                child: DebounceButton(
                  isEnable: true,
                  clickTap: () {
                    _listViewModel.jumpIntoOtherWidget(records);
                  },
                  padding: EdgeInsets.symmetric(vertical: 6, horizontal: 25),
                  backgroundColor: AppTheme.themeBlue,
                  borderRadius: BorderRadius.circular(16),
                  child: Text(
                    records.status == "4" ||
                            records.status == "7" ||
                            records.status == "6"
                        ? '查看'
                        : (records.status == "2"
                            ? "进入"
                            : (records.status == "3" ? '进入' : "")),
                    style: TextStyle(fontSize: 15, color: AppTheme.white),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  // row item widget
  Widget rowItemWidget(String title, String subTitle) => Padding(
      padding: EdgeInsets.only(top: 10),
      child: Row(
        children: [
          Text(
            title ?? '',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF666666),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
              child: Text(
            subTitle ?? '',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.right,
            style: TextStyle(fontSize: 14, color: Color(0xFF333333)),
          ))
        ],
      ));

  String dealTimeString(String time) {
    if (time == null) {
      return '';
    }
    if (time != null && time.length > 10) {
      return time.substring(0, 10);
    }
    return time;
  }
}
