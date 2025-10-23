/*
 * @Author: wangshibo1689@gmail.com WSBwsb123!@#
 * @Date: 2023-10-21 15:10:55
 * @LastEditors: WeJeson wangshibo@gc.com
 * @LastEditTime: 2024-12-10 16:17:50
 * @FilePath: /remouldApp/lib/page/home/vm/case_handing_view_model.dart
 * @Description: 
 * 
 * Copyright (c) 2023 by ${git_name_email}, All Rights Reserved. 
 */

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:notarization_station_app/base_framework/utils/toast_util.dart';
import 'package:notarization_station_app/base_framework/view_model/single_view_state_model.dart';
import 'package:notarization_station_app/page/login/vm/user_view_model.dart';
import 'package:notarization_station_app/routes/router.dart';
import 'package:notarization_station_app/service_api/home_api.dart';
import 'package:notarization_station_app/utils/global.dart';
import 'package:permission_handler/permission_handler.dart';

class CaseHandingViewModel extends SingleViewStateModel {
  CameraController cameraController;
  Future<void> initializeControllerFuture;

  List<CameraDescription> _cameras;

  bool isInit = false;
  UserViewModel userViewModel;

  CaseHandingViewModel();

  @override
  Future loadData() {
    Future.delayed(const Duration(milliseconds: 200), () {
      Permission.camera.status.isGranted.then((tempValue){
        if(!tempValue){
          G.showCustomToast(
              context: G.getCurrentContext(),
              titleText: "相机权限使用说明：",
              subTitleText: "用于拍摄、录制视频等场景",
              time: 2
          );
        }
      });
      Permission.camera.request().isGranted.then((value) {
        if (value) {
          initCamera();
        } else {
          G.showPermissionDialog(
              str: "访问相机权限",
              cancelCallBack: () {
                Navigator.pop(G.getCurrentContext());
              });
        }
      });
    });
    // throw UnimplementedError();
  }

  @override
  onCompleted(data) {
    throw UnimplementedError();
  }

  // 初始化相机
  void initCamera({Function initCallBack}) async {
    _cameras = await availableCameras();
    cameraController =
        CameraController(_cameras[1], ResolutionPreset.max, enableAudio: false);
    cameraController.initialize().then((_) {
      isInit = true;
      notifyListeners();
      initCallBack();
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
      isInit = false;
      notifyListeners();

      cameraController = CameraController(_cameras[index], ResolutionPreset.max,
          enableAudio: false);
      await cameraController.initialize();
      isInit = true;
      notifyListeners();
    }
  }

  getImg() async {
    // G.getCurrentState().pushNamedAndRemoveUntil(
    //     RoutePaths.judicialExpertiseList, (Route route) => false);
    try {
      // await initializeControllerFuture;
      EasyLoading.show(status: '人脸校验中...');
      XFile info = await cameraController.takePicture();
      final result = await FlutterImageCompress.compressWithFile(
        info.path,
        minWidth: 300, //压缩后的最小宽度
        minHeight: 200, //压缩后的最小高度
        quality: 10, //压缩质量
        rotate: 0, //旋转角度
      );
      String imgInfo = base64Encode(result);
      String biopsyImgInfo = base64Encode(await info.readAsBytes());

      Map<String, Object> map = {
        "image":"data:image/png;base64,$imgInfo",
        "name": G.userName,
        // "userId": VideoConferenceData.userId,
        "idCard": G.userIdCard
      };
      if (Platform.isIOS) {
        map["device"] = "app-qtzh-ios";
      } else if (Platform.isAndroid) {
        map["device"] = "app-qtzh-android";
      }
      log("11111.......$map");
      HomeApi.getSingleton().userLogin(map, errorCallBack: (error) {
        EasyLoading.dismiss();
        ToastUtil.showToast("人脸认证失败，请稍后再试！");
      }).then((value) {
        print("value-------$value");
        if (value
            != null && value['code'] == 200) {
          G.userToken = value['data']['token'];
          G.indentyId = value['data']['annexId'];
          HomeApi.getSingleton().getNewBiopsy({"base64":biopsyImgInfo},errorCallBack: (e){
            EasyLoading.dismiss();
            ToastUtil.showToast("人脸认证失败，请稍后再试！");
          }).then((value1){
            if(value1 !=null && value1['code'] ==200){
               EasyLoading.dismiss();
              print("value1---======$value1");
              G.getCurrentState().pushNamedAndRemoveUntil(
                  RoutePaths.judicialExpertiseList, (Route route) => false);
            }else{
              EasyLoading.dismiss();
              ToastUtil.showToast(value1["data"]??value1["message"]??value1["msg"]??"人脸认证失败，请稍后再试！");
            }
          });
        } else {
          EasyLoading.dismiss();
          ToastUtil.showToast(value["data"]??value["message"]??value["msg"]??"人脸认证失败，请稍后再试！");
        }
      });


    } catch (err) {
      print(err);
    }
  }
}
