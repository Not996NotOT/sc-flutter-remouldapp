/*
 * @Author: wangshibo1689@gmail.com WSBwsb123!@#
 * @Date: 2023-10-21 15:08:10
 * @LastEditors: wangshibo1689@gmail.com WSBwsb123!@#
 * @LastEditTime: 2023-10-23 16:11:42
 * @FilePath: /remouldApp/lib/page/home/case_handling_widget.dart
 * @Description: 案件办结人脸识别界面
 * 
 * Copyright (c) 2023 by ${git_name_email}, All Rights Reserved. 
 */

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:notarization_station_app/appTheme.dart';
import 'package:notarization_station_app/base_framework/widget/provider_widget.dart';
import 'package:notarization_station_app/base_framework/widget_state/base_state.dart';
import 'package:notarization_station_app/page/home/vm/case_handing_view_model.dart';
import 'package:notarization_station_app/page/home/widget/scan.dart';
import 'package:notarization_station_app/page/login/vm/user_view_model.dart';
import 'package:notarization_station_app/utils/alert_view.dart';
import 'package:notarization_station_app/utils/focus_detector.dart';
import 'package:notarization_station_app/utils/global.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class CaseHandingWidget extends StatefulWidget {
  final String name;
  final String idCard;
  const CaseHandingWidget({Key key, this.name, this.idCard}) : super(key: key);

  @override
  State<CaseHandingWidget> createState() => _CaseHandingWidgetState();
}

class _CaseHandingWidgetState extends BaseState<CaseHandingWidget> {
  CaseHandingViewModel caseHandingViewModel;

  @override
  void dispose() {
    caseHandingViewModel.cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        showLogoutCaseAlert(context, decideFunction: () {
          G.pop();
          G.pop();
        });
        return Future.value(true);
      },
      child: FocusDetector(
        onFocusGained: () {
          if (caseHandingViewModel != null) {
            caseHandingViewModel.loadData();
          }
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
                showLogoutCaseAlert(context, decideFunction: () {
                  G.pop();
                  G.pop();
                });
              },
            ),
          ),
          body: Consumer<UserViewModel>(
            builder: (context, userViewModel, child) {
              return ProviderWidget<CaseHandingViewModel>(
                builder: (context, viewModel, child) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [Color(0xFF86B0F4), Color(0xFF5886EA)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter)),
                    child: CustomScrollView(slivers: [
                      SliverFillRemaining(
                          hasScrollBody: false,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 20),
                                child: SizedBox(),
                              ),
                              BallClipRotateIndicator(
                                maxRadius: getWidthPx(300),
                                minRadius: getWidthPx(300),
                                color: AppTheme.white,
                                child: ClipOval(
                                  child: viewModel.isInit
                                      ? SizedBox(
                                          width: getWidthPx(596),
                                          height: getWidthPx(596),
                                          child: OverflowBox(
                                            maxWidth: double.infinity,
                                            maxHeight: double.infinity,
                                            child: FittedBox(
                                              fit: BoxFit.fitWidth,
                                              child: SizedBox(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    viewModel
                                                        .cameraController
                                                        .value
                                                        .previewSize
                                                        .width /
                                                    viewModel
                                                        .cameraController
                                                        .value
                                                        .previewSize
                                                        .height,
                                                child: CameraPreview(
                                                    viewModel.cameraController),
                                              ),
                                            ),
                                          ),
                                        )
                                      : SizedBox(
                                          width: getWidthPx(600),
                                          height: getWidthPx(600),
                                        ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: getWidthPx(60),
                                    bottom: getWidthPx(90)),
                                child: Text(
                                  "请正对手机摄像头，确保光源充足 \n 确保面部清晰可见",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: AppTheme.white,
                                      fontWeight: FontWeight.w500,
                                      height: 1.5,
                                      fontSize: getSp(28)),
                                ),
                              ),
                              const Spacer(),
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Future.delayed(
                                          const Duration(milliseconds: 200),
                                          () {
                                        Permission.camera.status.isGranted
                                            .then((value) {
                                          if (!value) {
                                            G.showCustomToast(
                                                context: G.getCurrentContext(),
                                                titleText: "相机权限使用说明：",
                                                subTitleText: "用于拍摄、录制视频等场景",
                                                time: 2);
                                          }
                                        });
                                        Permission.camera
                                            .request()
                                            .isGranted
                                            .then((value) {
                                          if (value) {
                                            if (viewModel.isInit) {
                                              viewModel.getImg();
                                            } else {
                                              viewModel.initCamera(
                                                  initCallBack: () {
                                                viewModel.getImg();
                                              });
                                            }
                                          } else {
                                            G.showPermissionDialog(
                                                str: "访问相机权限",
                                                cancelCallBack: () {
                                                  Navigator.pop(context);
                                                });
                                          }
                                        });
                                      });
                                    },
                                    child: Image.asset(
                                      'lib/assets/images/tap_camera.png',
                                      width: getWidthPx(160),
                                      height: getWidthPx(160),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      const Spacer(),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            right: getWidthPx(70)),
                                        child: IconButton(
                                            icon: Image.asset(
                                              "lib/assets/images/camera_switch.png",
                                              width: 40,
                                              height: 40,
                                              fit: BoxFit.fill,
                                            ),
                                            onPressed: () {
                                              Permission.camera.status.isGranted
                                                  .then((value) {
                                                if (!value) {
                                                  G.showCustomToast(
                                                      context:
                                                          G.getCurrentContext(),
                                                      titleText: "相机权限使用说明：",
                                                      subTitleText:
                                                          "用于拍摄、录制视频等场景",
                                                      time: 2);
                                                }
                                              });
                                              Permission.camera
                                                  .request()
                                                  .isGranted
                                                  .then((value) {
                                                if (value) {
                                                  if (viewModel.isInit) {
                                                    viewModel.switchCamera();
                                                  } else {
                                                    viewModel.initCamera(
                                                        initCallBack: () {
                                                      viewModel.switchCamera();
                                                    });
                                                  }
                                                } else {
                                                  G.showPermissionDialog(
                                                      str: "访问相机权限",
                                                      cancelCallBack: () {
                                                        Navigator.pop(context);
                                                      });
                                                }
                                              });
                                            }),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    bottom: getWidthPx(80),
                                    top: getWidthPx(90)),
                                child: Text(
                                  "南京市涉保理赔司法鉴定公证摇号系统",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: AppTheme.white.withOpacity(0.8),
                                      fontWeight: FontWeight.bold,
                                      fontSize: getSp(32)),
                                ),
                              ),
                            ],
                          ))
                    ]),
                  );
                },
                model: CaseHandingViewModel(),
                onModelReady: (model) {
                  caseHandingViewModel = model;
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
