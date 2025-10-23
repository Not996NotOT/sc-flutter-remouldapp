import 'dart:async';
import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http_parser/http_parser.dart';
import 'package:notarization_station_app/base_framework/utils/toast_util.dart';
import 'package:notarization_station_app/base_framework/view_model/single_view_state_model.dart';
import 'package:notarization_station_app/page/login/vm/user_view_model.dart';
import 'package:notarization_station_app/routes/router.dart';
import 'package:notarization_station_app/service_api/home_api.dart';
import 'package:notarization_station_app/utils/global.dart';

import '../../../config.dart';

class FaceViewModel extends SingleViewStateModel {
  final UserViewModel userViewModel;
  List<CameraDescription> cameraList;

  FaceViewModel(this.userViewModel, this.cameraList,
      this.initializeControllerFuture, this.cameraController, this.numRouter);

  CameraController cameraController;
  Future<void> initializeControllerFuture;
  String path = '';
  Timer timer;
  List images = [];
  String hintInfo = '请正视摄像头';
  int num = 0;
  int numRouter;

  getImg() async {
    print("....11111");
    try {
      await initializeControllerFuture;
      XFile info = await cameraController?.takePicture();
      print("....11111${info.path}");
      final result = await FlutterImageCompress.compressWithFile(
        info.path,
        minWidth: 2300, //压缩后的最小宽度
        minHeight: 1500, //压缩后的最小高度
        quality: 20, //压缩质量
        rotate: 0, //旋转角度
      );
      String imgInfo = base64Encode(result);
      print("....11111$imgInfo");
      Map<String, Object> map = {"base64": imgInfo};
      HomeApi().getBiopsy(map).then((res) {
        if (res['code'] == 200) {
          EasyLoading.show(status: "正在人脸比对");
          timer?.cancel();
          MultipartFile multipartFile = MultipartFile.fromBytes(
            result,
            filename: "${DateTime.now().millisecondsSinceEpoch}.jpg",
            contentType: MediaType("image", "jpg"),
          );
          HomeApi().uploadPictures(multipartFile).then((data) {
            if (data['code'] == 200) {
              print("---+++-----$data");
              Map<String, Object> map1 = {
                "name": userViewModel.userName,
                "idCard": userViewModel.idCard,
                "image": Config.splicingImageUrl(data['item']["filePath"])
              };
              print("--------$map1");
              HomeApi().faceComparison(map1).then((value) {
                EasyLoading.dismiss();
                if (value != null) {
                  if (value['code'] == 200) {
                    G.getCurrentState().pushReplacementNamed(RoutePaths.Explain,
                        arguments: numRouter);
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
      print(".....错误$err");
    }
  }

  @override
  onCompleted(data) {}
  @override
  Future loadData() {
    goTimer();
    return null;
  }

  goTimer() {
    timer = Timer.periodic(Duration(seconds: 2), (Timer t) => getImg());
    // getImg();
  }
}
