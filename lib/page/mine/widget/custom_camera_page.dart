/*
 * @Author: 王士博 wangshibo@gc.com
 * @Date: 2023-06-08 10:16:53
 * @LastEditors: 王士博 wangshibo@gc.com
 * @LastEditTime: 2023-06-14 11:34:27
 * @FilePath: /remouldApp/lib/page/mine/widget/custom_camera_page.dart
 * @Description: 
 * 
 * Copyright (c) 2023 by ${git_name_email}, All Rights Reserved. 
 */
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notarization_station_app/base_framework/widget_state/base_state.dart';
import 'package:notarization_station_app/utils/global.dart';

import '../../../utils/common_tools.dart';

class CustomCameraPage extends StatefulWidget {
  bool isFront;
  CustomCameraPage({Key key, this.isFront}) : super(key: key);
  @override
  _CustomCameraPageState createState() => _CustomCameraPageState();
}

class _CustomCameraPageState extends BaseState<CustomCameraPage> {
  CameraController controller;
  List<CameraDescription> cameras;

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  void _camera() async {
    cameras = await availableCameras();
    if (cameras != null) {
      controller = CameraController(cameras[0], ResolutionPreset.medium,
          enableAudio: false);
      controller.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _camera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: cameras == null
          ? Container(
              child: Center(
                child: Text("加載中..."),
              ),
            )
          : ColoredBox(
              color: Colors.black,
              child: Column(
                children: <Widget>[
                  SizedBox(
                      width: double.infinity,
                      height:
                          MediaQuery.of(context).size.height - getHeightPx(200),
                      child: FittedBox(
                        fit: BoxFit.fitWidth,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width *
                              controller.value.previewSize.width /
                              controller.value.previewSize.height,
                          height: MediaQuery.of(context).size.height -
                              getHeightPx(200),
                          child: CameraPreview(controller),
                        ),
                      )),
                  Container(
                    height: getHeightPx(200),
                    color: Colors.black,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            wjPrint("33333");
                            G.pop();
                            // G.pushNamed(
                            //   RoutePaths.HomeIndex,
                            // );
                          },
                          child: Icon(Icons.chevron_left,
                              color: Colors.white, size: 40),
                        ),
                        Container(
                          /*alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(horizontal: 15),*/
                          child: Align(
                            alignment: Alignment.center,
                            child: GestureDetector(
                                onTap: onTakePictureButtonPressed,
                                child: Icon(Icons.camera_alt,
                                    color: Colors.white, size: 50)),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void onTakePictureButtonPressed() {
    takePicture().then((String filePath) {
      if (mounted) {
        if (filePath != null) {
          Navigator.of(context).pop(filePath);
        }
      }
    });
  }

  Future<String> takePicture() async {
    if (!controller.value.isInitialized) {
      wjPrint('Error: select a camera first.');
      return null;
    }
    // final Directory extDir = await getApplicationDocumentsDirectory();
    // final String dirPath = '${extDir.path}/Pictures/flutter_test';
    // await Directory(dirPath).create(recursive: true);
    // final String filePath = '$dirPath/${timestamp()}.jpg';

    if (controller.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }
    try {
      XFile info = await controller.takePicture();
      wjPrint(controller.value.previewSize.width);
      return info.path;
    } on CameraException catch (e) {
      wjPrint("出现异常$e");
      return null;
    }
  }
}
