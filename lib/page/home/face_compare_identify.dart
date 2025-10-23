import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:notarization_station_app/base_framework/widget/provider_widget.dart';
import 'package:notarization_station_app/base_framework/widget_state/base_state.dart';
import 'package:notarization_station_app/page/home/vm/face_compare_identify_viewModel.dart';
import 'package:notarization_station_app/page/home/widget/scan.dart';
import 'package:notarization_station_app/page/login/vm/user_view_model.dart';
import 'package:notarization_station_app/routes/router.dart';
import 'package:notarization_station_app/utils/focus_detector.dart';
import 'package:notarization_station_app/utils/global.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../appTheme.dart';


class FaceCompareIdentifyWidget extends StatefulWidget {
  final String orderId;

  const FaceCompareIdentifyWidget({Key key,this.orderId}) : super(key: key);

  @override
  State<FaceCompareIdentifyWidget> createState() => _FaceCompareIdentifyWidgetState();
}

class _FaceCompareIdentifyWidgetState extends BaseState<FaceCompareIdentifyWidget> {

  FaceCompareIdentifyViewModel faceCompareIdentifyViewModel;

  @override
  void dispose() {
    faceCompareIdentifyViewModel.cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FocusDetector(
      onFocusGained: () {
        if (faceCompareIdentifyViewModel != null) {
          faceCompareIdentifyViewModel.loadData();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("人脸识别", style: TextStyle(color: Colors.black)),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_outlined,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, RoutePaths.HomeIndex, (route) => false);
            },
          ),
        ),
        body: Consumer<UserViewModel>(
          builder: (context, userViewModel, child) {
            return ProviderWidget<FaceCompareIdentifyViewModel>(
              builder: (context, viewModel, child) {
                return CustomScrollView(slivers: [
                  SliverFillRemaining(
                      hasScrollBody: false,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: getWidthPx(80)),
                            child: BallClipRotateIndicator(
                              maxRadius: getWidthPx(300),
                              minRadius: getWidthPx(300),
                              color: AppTheme.white,
                              child: ClipOval(
                                child: viewModel.isInit
                                    ? viewModel.isSwitch ?SizedBox(
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
                                            viewModel.cameraController.value
                                                .previewSize.width /
                                            viewModel.cameraController.value
                                                .previewSize.height,
                                        child: CameraPreview(
                                            viewModel.cameraController),
                                      ),
                                    ),
                                  ),
                                ) : SizedBox(
                                  width: getWidthPx(600),
                                  height: getWidthPx(600),
                                )
                                    : SizedBox(
                                  width: getWidthPx(600),
                                  height: getWidthPx(600),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: getWidthPx(60),bottom: getWidthPx(90)),
                            child: Text(
                              "请正对手机摄像头，确保光源充足 \n 确保面部清晰可见",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: AppTheme.darkerText,
                                  fontWeight: FontWeight.w500,
                                  height: 1.5,
                                  fontSize: getSp(28)),
                            ),
                          ),
                          const Spacer(),
                          Padding(
                            padding: EdgeInsets.only(bottom: getWidthPx(120)),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Future.delayed(
                                        const Duration(milliseconds: 200), () async{
                                      if(!await Permission.camera.status.isGranted){
                                        G.showCustomToast(
                                            context: G.getCurrentContext(),
                                            titleText: "相机权限使用说明：",
                                            subTitleText: "用于拍摄、录制视频等场景",
                                            time: 2
                                        );
                                      }
                                      Permission.camera
                                          .request()
                                          .isGranted
                                          .then((value) {
                                        if (value) {
                                          if (viewModel.isInit) {
                                            if(viewModel.isSwitch){
                                              viewModel.getImg();
                                            }
                                          } else {
                                            viewModel.initCamera(
                                                initCallBack: () {
                                                  viewModel.getImg();
                                                });
                                          }
                                        } else {
                                          G.showPermissionDialog(
                                              str: "访问相机权限");
                                        }
                                      });
                                    });
                                  },
                                  child: Image.asset(
                                    'lib/assets/images/拍照.png',
                                    width: getWidthPx(160),
                                    height: getWidthPx(160),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                Row(
                                  children: [
                                    const Spacer(),
                                    Padding(
                                      padding:
                                      EdgeInsets.only(right: getWidthPx(70)),
                                      child: IconButton(
                                          icon: const Icon(
                                            Icons.flip_camera_ios_outlined,
                                            color: Color(0xFF1296db),
                                            size: 40,
                                          ),
                                          onPressed: () async{
                                            if(!await Permission.camera.status.isGranted){
                                              G.showCustomToast(
                                                  context: G.getCurrentContext(),
                                                  titleText: "相机权限使用说明：",
                                                  subTitleText: "用于拍摄、录制视频等场景",
                                                  time: 2
                                              );
                                            }
                                            Permission.camera
                                                .request()
                                                .isGranted
                                                .then((value) {
                                              if (value) {
                                                if (viewModel.isInit) {
                                                  if(viewModel.isSwitch){
                                                    viewModel.switchCamera();
                                                  }
                                                } else {
                                                  viewModel.initCamera(
                                                      initCallBack: () {
                                                        viewModel.switchCamera();
                                                      });
                                                }
                                              } else {
                                                G.showPermissionDialog(
                                                    str: "访问相机权限");
                                              }
                                            });
                                          }),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ))
                ]);
              },
              model: FaceCompareIdentifyViewModel(widget.orderId),
              onModelReady: (model) {
                faceCompareIdentifyViewModel = model;
                faceCompareIdentifyViewModel.userViewModel = userViewModel;
              },
            );
          },
        ),
      ),
    );
  }
}
