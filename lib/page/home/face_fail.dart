import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:notarization_station_app/base_framework/utils/toast_util.dart';
import 'package:notarization_station_app/base_framework/widget_state/base_state.dart';
import 'package:notarization_station_app/page/home/widget/scan.dart';
import 'package:notarization_station_app/routes/router.dart';
import 'package:notarization_station_app/service_api/home_api.dart';
import 'package:notarization_station_app/utils/global.dart';

import '../../utils/common_tools.dart';
import 'entity/data.dart';

class FaceFailPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FaceFailPageState();
  }
}

class FaceFailPageState extends BaseState<FaceFailPage> {
  CameraController cameraController;
  Future<void> initializeControllerFuture;

  Timer timer;
  int num = 1;
  int time = 60;

  List<CameraDescription> _cameras;

  bool _isInit = false;

  @override
  void initState() {
    super.initState();
    // G.getCurrentState().pushReplacementNamed(RoutePaths.ConferenceIng);
    _initCamera();
  }

  @override
  void dispose() {
    timer?.cancel();
    cameraController?.dispose();
    super.dispose();
  }

  // 初始化相机
  void _initCamera() async {
    _cameras = await availableCameras();
    cameraController = CameraController(_cameras[1], ResolutionPreset.max);
    cameraController.initialize().then((_) {
      setState(() {
        _isInit = true;
        getImg();
      });
      // _takePicture();
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            break;
          default:
            break;
        }
      }
    });
  }

  // 切换相机
  void switchCamera() async {
    if (_cameras.length > 1) {
      int index = _cameras.indexOf(cameraController.description);
      if (index < _cameras.length - 1) {
        index += 1;
      } else {
        index = 0;
      }
      await cameraController.dispose();
      setState(() {
        _isInit = false;
      });

      cameraController =
          CameraController(_cameras[index], ResolutionPreset.max);
      await cameraController.initialize();
      setState(() {
        _isInit = true;
      });
      await cameraController.startImageStream((CameraImage img) {});
    }
  }

  getCameras() async {
    cameraController = CameraController(
        VideoConferenceData.cameras[1], ResolutionPreset.veryHigh);
    initializeControllerFuture = cameraController.initialize();
    initializeControllerFuture.then((value) {
      if (!mounted) {
        return;
      }
    });
  }

  getImg() async {
    try {
      // await initializeControllerFuture;
      XFile info = await cameraController.takePicture();
      final result = await FlutterImageCompress.compressWithFile(
        info.path,
        minWidth: 900, //压缩后的最小宽度
        minHeight: 600, //压缩后的最小高度
        quality: 20, //压缩质量
        rotate: 0, //旋转角度
      );
      String imgInfo = base64Encode(result);
      Map<String, Object> map = {
        "image": "data:image/png;base64,$imgInfo",
        "name": VideoConferenceData.userName,
        "userId": VideoConferenceData.userId,
        "idCard": VideoConferenceData.userIdCard
      };
      log("11111.......$map");
      HomeApi.getSingleton().postFace(map, errorCallBack: (e) {}).then((res) {
        // wjPrint("11111.......$res");
        if (res['code'] == 200) {
          wjPrint('success-------num:$num');
          cameraController?.dispose();
          G.getCurrentState().pushReplacementNamed(RoutePaths.ConferenceIng);
        } else {
          num++;
          if (num > 10) {
            wjPrint('fail-------num:$num');
            ToastUtil.showErrorToast("您超过10次，人脸不通过！");
            Future.delayed(Duration.zero).then((value) => G.pop());
          } else {
            getImg();
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
        body: Center(
          child: Padding(
            padding: EdgeInsets.only(bottom: 100),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text("正在进行人脸识别"),
                    const SizedBox(height: 10),
                    const Text('请正视摄像头'),
                    const SizedBox(height: 10),
                  ],
                ),
                BallClipRotateIndicator(
                  maxRadius: getWidthPx(300),
                  minRadius: getWidthPx(300),
                  child: ClipOval(
                    child: _isInit
                        ? SizedBox(
                            width: getWidthPx(600),
                            height: getWidthPx(600),
                            child: CameraPreview(cameraController),
                          )
                        : SizedBox(
                            width: getWidthPx(600),
                            height: getWidthPx(600),
                          ),
                  ),
                ),
                // ElevatedButton(
                //   child: Text('跳转'),
                //   onPressed: (){
                //     G.getCurrentState().pushReplacementNamed(RoutePaths.ConferenceIng);
                //   })
              ],
            ),
          ),
        ));
  }
}
