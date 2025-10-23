import 'dart:async';
import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http_parser/http_parser.dart';
import 'package:notarization_station_app/base_framework/utils/toast_util.dart';
import 'package:notarization_station_app/base_framework/widget_state/base_state.dart';
import 'package:notarization_station_app/config.dart';
import 'package:notarization_station_app/page/home/widget/scan.dart';
import 'package:notarization_station_app/page/login/vm/user_view_model.dart';
import 'package:notarization_station_app/routes/router.dart';
import 'package:notarization_station_app/service_api/home_api.dart';
import 'package:notarization_station_app/utils/global.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../utils/common_tools.dart';

class FacePage extends StatefulWidget {
  int arguments;
  FacePage({Key key, this.arguments}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return FacePageState();
  }
}

class FacePageState extends BaseState<FacePage> {
  // Future<void> initializeControllerFuture;
  UserViewModel userViewModel;
  // String path = '';
  // Timer timer;
  // List images = [];
  int num = 0;
  // List<CameraDescription> camerasList = [];
  // CameraController controller;

  CameraController cameraController;
  Future<void> initializeControllerFuture;

  Timer timer;

  @override
  void initState() {
    super.initState();
    getCameras();
  }

  @override
  void dispose() {
    timer?.cancel();
    cameraController?.dispose();
    super.dispose();
  }

  getCameras() async {
    if(!await Permission.camera.status.isGranted){
      G.showCustomToast(
          context: G.getCurrentContext(),
          titleText: "相机权限使用说明：",
          subTitleText: "用于拍摄、录制视频等场景",
          time: 2
      );
    }
    if(!await Permission.camera.request().isGranted){
      List<CameraDescription> cameras = await availableCameras();
      cameraController = CameraController(cameras[1], ResolutionPreset.veryHigh,enableAudio: false);
      initializeControllerFuture = cameraController.initialize();
      initializeControllerFuture.then((value) {
        if (!mounted) {
          return;
        }
        setState(() {});
      });
      goTimer();
    }else{
      G.showPermissionDialog(str: '访问相机权限');
      return;
    }
  }

  goTimer() {
    wjPrint("11111......s");
    timer = Timer.periodic(Duration(seconds: 2), (Timer t) => getImg());
  }

  getImg() async {
    try {
      await initializeControllerFuture;
      XFile info = await cameraController.takePicture();
      final result = await FlutterImageCompress.compressWithFile(
        info.path,
        minWidth: 2300, //压缩后的最小宽度
        minHeight: 1500, //压缩后的最小高度
        quality: 20, //压缩质量
        rotate: 0, //旋转角度
      );
      String imgInfo = base64Encode(result);
      wjPrint("....11111$imgInfo");
      Map<String, Object> map = {"base64": imgInfo};
      HomeApi.getSingleton().getBiopsy(map).then((res) {
        if (res['code'] == 200) {
          EasyLoading.show(status: "正在人脸比对");
          timer?.cancel();
          MultipartFile multipartFile = MultipartFile.fromBytes(
            result,
            filename: "${DateTime.now().millisecondsSinceEpoch}.jpg",
            contentType: MediaType("image", "jpg"),
          );
          HomeApi.getSingleton().uploadPictures(multipartFile).then((data) {
            if (data['code'] == 200) {
              wjPrint("---+++-----$data");
              Map<String, Object> map1 = {
                "name": userViewModel.userName,
                "idCard": userViewModel.idCard,
                "image": Config.splicingImageUrl(data['item']["filePath"]),
                "image_type": 'url'
              };
              wjPrint("--------$map1");
              HomeApi.getSingleton().faceComparison(map1).then((value) {
                EasyLoading.dismiss();
                if (value != null) {
                  if (value['code'] == 200) {
                    G.getCurrentState().pushReplacementNamed(RoutePaths.Explain,
                        arguments: widget.arguments);
                  } else {
                    ToastUtil.showErrorToast("人脸比对不通过！");
                    Future.delayed(Duration.zero).then((value) => G.pop());
                  }
                }
              });
            }
          });
        } else if (res['code'] == 500) {
          num++;
          if (num > 10) {
            ToastUtil.showErrorToast("您超过10次，活体检测不通过！");
            Future.delayed(Duration.zero).then((value) => G.pop());
          }
        }
      });
    } catch (err) {
      wjPrint(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: commonAppBar(title: "人脸识别"),
        body: Consumer<UserViewModel>(
          builder: (ctx, userModel, child) {
            userViewModel = userModel;
            return Center(
              child: Padding(
                padding: EdgeInsets.only(bottom: 100),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("正在进行人脸识别"),
                        SizedBox(height: 10),
                        Text('请正视摄像头'),
                        SizedBox(height: 10),
                      ],
                    ),
                    BallClipRotateIndicator(
                      maxRadius: getWidthPx(300),
                      minRadius: getWidthPx(300),
                      child: ClipOval(
                        child: cameraController != null
                            ? FutureBuilder<void>(
                                future: initializeControllerFuture,
                                builder: (context, snapshot) {
                                  return Container(
                                    width: getWidthPx(600),
                                    height: getWidthPx(600),
                                    child: CameraPreview(cameraController),
                                  );
                                },
                              )
                            : Container(
                                width: getWidthPx(600),
                                height: getWidthPx(600),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ));
  }
}
