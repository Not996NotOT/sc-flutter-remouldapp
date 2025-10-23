/*
 * @Author: wangshibo1689@gmail.com WSBwsb123!@#
 * @Date: 2023-10-21 13:17:27
 * @LastEditors: wangshibo1689@gmail.com WSBwsb123!@#
 * @LastEditTime: 2023-10-23 16:24:09
 * @FilePath: /remouldApp/lib/page/home/judicial_expertise_login.dart
 * @Description:  司法鉴定登录部分
 * 
 * Copyright (c) 2023 by ${git_name_email}, All Rights Reserved. 
 */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notarization_station_app/appTheme.dart';
import 'package:notarization_station_app/base_framework/widget/provider_widget.dart';
import 'package:notarization_station_app/base_framework/widget_state/base_state.dart';
import 'package:notarization_station_app/page/home/vm/judicail_view_model.dart';
import 'package:notarization_station_app/page/login/vm/user_view_model.dart';
import 'package:notarization_station_app/utils/debounce_button.dart';
import 'package:notarization_station_app/utils/global.dart';
import 'package:provider/provider.dart';

class JudicialExpertiseLoginPage extends StatefulWidget {
  const JudicialExpertiseLoginPage({Key key}) : super(key: key);

  @override
  State<JudicialExpertiseLoginPage> createState() =>
      _JudicialExpertiseLoginPageState();
}

class _JudicialExpertiseLoginPageState
    extends BaseState<JudicialExpertiseLoginPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserViewModel>(builder: (context, userViewModel, child) {
      return ProviderWidget<JudicialViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            // resizeToAvoidBottomInset: false,
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
                  G.pop();
                },
              ),
            ),
            body: Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Color(0xFF86B0F4), Color(0xFF5886EA)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter)),
              child: CustomScrollView(
                slivers:[
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Column(
                      children: [
                        Padding(
                          padding:
                          EdgeInsets.only(top: 40,left: 40,right: 40,bottom: 30),
                          child: Image.asset("lib/assets/images/judicial_login_topImage.png"),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 15),
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 90,
                                        child: Text(
                                          "姓名",
                                          style: TextStyle(
                                              fontSize: 17,
                                              color: AppTheme.dark_grey),
                                        ),
                                      ),
                                      Expanded(
                                          child: TextField(
                                            controller: viewModel
                                                .nameTextEditingController,
                                            inputFormatters: [
                                              LengthLimitingTextInputFormatter(
                                                  30),
                                              FilteringTextInputFormatter.deny(
                                                  RegExp("[ ]"))
                                            ],
                                            decoration: InputDecoration(
                                                hintText: "请填写姓名",
                                                hintStyle: TextStyle(
                                                    fontSize: 15,
                                                    color: Color(0xFFBFBFBF)),
                                                border: InputBorder.none),
                                          ))
                                    ],
                                  ),
                                  Divider(),
                                ],
                              ),
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 90,
                                        child: Text(
                                          "身份证号",
                                          style: TextStyle(
                                              fontSize: 17,
                                              color: AppTheme.dark_grey),
                                        ),
                                      ),
                                      Expanded(
                                          child: TextField(
                                            controller: viewModel
                                                .idCardTextEditingController,
                                            inputFormatters: [
                                              LengthLimitingTextInputFormatter(
                                                  18),
                                              FilteringTextInputFormatter.allow(
                                                  RegExp("[a-zA-Z||0-9]")),
                                            ],
                                            decoration: InputDecoration(
                                                hintText: "请填写身份证号码",
                                                hintStyle: TextStyle(
                                                    fontSize: 15,
                                                    color: Color(0xFFBFBFBF)),
                                                border: InputBorder.none),
                                          ))
                                    ],
                                  ),
                                  Divider(),
                                ],
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              DebounceButton(
                                isEnable: viewModel.isEndable,
                                clickTap: () {
                                  viewModel.login();
                                },
                                backgroundColor: AppTheme.themeBlue,
                                disableColor: Colors.grey,
                                borderRadius: BorderRadius.circular(10),
                                padding: EdgeInsets.symmetric(vertical: 15),
                                child: Text(
                                  '进入',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500),
                                ),
                              )
                            ],
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                  )
                ] ,
              ),
            ),
          );
        },
        model: JudicialViewModel(userViewModel),
        onModelReady: (viewModel) {
          viewModel.loadData();
        },
      );
    });
  }
}
