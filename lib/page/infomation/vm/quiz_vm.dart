import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http_parser/http_parser.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:notarization_station_app/base_framework/utils/toast_util.dart';
import 'package:notarization_station_app/base_framework/view_model/single_view_state_model.dart';
import 'package:notarization_station_app/page/login/vm/user_view_model.dart';
import 'package:notarization_station_app/service_api/home_api.dart';
import 'package:notarization_station_app/service_api/infomation_api.dart';
import 'package:notarization_station_app/utils/global.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../utils/common_tools.dart';

class QuizModel extends SingleViewStateModel {
  UserViewModel userModel;
  TextEditingController textEditingController = TextEditingController();
  QuizModel(this.userModel);

  List<Asset> imgList = [];
  List imgListUrl = [];
  // 提交按钮防抖操作
  bool isEnable = true;

  addQuiz() {
    if (textEditingController.text.isNotEmpty) {
      Map<String, dynamic> map = {
        "question": textEditingController.text, //提问内容
        "type": "1", //提问类型
        "isShow": "1",
        "picture": imgListUrl.join(","),
        //"createUser":userModel.unitGuid
      };
      EasyLoading.show(status: "问题反馈中...");
      isEnable = false;
      notifyListeners();
      InformationApi.getSingleton().getQuiz(map, errorCallBack: (e) {
        EasyLoading.dismiss();
        isEnable = true;
        notifyListeners();
      }).then((res) {
        EasyLoading.dismiss();
        if (res["code"] == 200) {
          G.getCurrentState().pop("refresh");
        } else if (res["code"] == 4001) {
          isEnable = true;
          notifyListeners();
          ToastUtil.showErrorToast(res["msg"]);
        } else {
          isEnable = true;
          notifyListeners();
        }
      });
    } else {
      ToastUtil.showWarningToast("请填写咨询内容");
    }
  }

  Future<void> requestCameraPermission() async {
    if(Platform.isAndroid){
      if(!await Permission.storage.status.isGranted || !await Permission.camera.status.isGranted){
        G.showCustomToast(
            context: G.getCurrentContext(),
            titleText: "相机、存储权限使用说明：",
            subTitleText: "用于拍摄、录制视频、文件存储等场景",
            time: 2
        );
      }
      if (await Permission.storage.request().isGranted &&
          await Permission.camera.request().isGranted) {
        selectAssets();
      }else{
        G.showPermissionDialog(str: "访问内部相机、相册及文件权限");
      }
    }
    if(Platform.isIOS){
      if(await Permission.photos.request().isGranted && await Permission.camera.request().isGranted){
        selectAssets();
      }else{
        G.showPermissionDialog(str: "访问相机、相册权限");
      }
    }
  }

  //选照片
  Future<void> selectAssets() async {
    try {
      List<Asset> resultList = await MultiImagePicker.pickImages(
        // 选择图片的最大数量
        maxImages: 3 - imgList.length,
        // 是否支持拍照
        enableCamera: false,
        materialOptions: MaterialOptions(
          actionBarTitle: "相册图片",
          allViewTitle: "所有图片",
          actionBarColor: "#1E90FF",
          actionBarTitleColor: "#FFFFFF",
          statusBarColor: '#1E90FF',
          startInAllView: true,
          useDetailsView: true,
          selectCircleStrokeColor: "#FFFFFF",
          selectionLimitReachedText: "您最多只能选择这些",
          textOnNothingSelected: "没有选择照片",
        ),
      );
      if (resultList != null && resultList.length != 0) {
        EasyLoading.show(status: "上传图片中");
        for (int i = 0; i < resultList.length; i++) {
          Asset asset = resultList[i];
          if (asset.originalHeight <= 0 || asset.originalWidth <= 0) {
            EasyLoading.dismiss();
            ToastUtil.showErrorToast("文件已破损，请重新选择");
          } else {
            imgList.add(asset);
            ByteData oldBd = await asset.getByteData();
            List<int> newImage = oldBd.buffer.asUint8List();
            final result = await FlutterImageCompress.compressWithList(
              newImage,
              minWidth: 2300, //压缩后的最小宽度
              minHeight: 1500, //压缩后的最小高度
              quality: 20, //压缩质量
              rotate: 0, //旋转角度
            );
            MultipartFile multipartFile = MultipartFile.fromBytes(
              result,
              filename: "${DateTime.now().millisecondsSinceEpoch}.jpg",
              contentType: MediaType("image", "jpg"),
            );
            HomeApi.getSingleton().uploadPictures(multipartFile,
                errorCallBack: (value) {
              EasyLoading.dismiss();
            }).then((res) {
              if (res != null && res['code'] == 200) {
                imgListUrl.add(res['item']['filePath']);
                if (i == resultList.length - 1) {
                  EasyLoading.dismiss();
                }
              } else {
                EasyLoading.dismiss();
              }
            });
          }
        }
        wjPrint("当前图片的个数为：${imgList.length}");
        notifyListeners();
      }
    } on Exception catch (e) {
      wjPrint("+++++++++++++$e");
    }
  }

  @override
  onCompleted(data) {}

  @override
  Future loadData() {
    return null;
  }
}
