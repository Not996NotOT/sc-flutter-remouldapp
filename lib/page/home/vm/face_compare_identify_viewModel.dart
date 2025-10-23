import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:notarization_station_app/base_framework/utils/toast_util.dart';
import 'package:notarization_station_app/base_framework/view_model/single_view_state_model.dart';
import 'package:notarization_station_app/page/login/vm/user_view_model.dart';
import 'package:notarization_station_app/service_api/home_api.dart';
import 'package:notarization_station_app/utils/global.dart';
import 'package:permission_handler/permission_handler.dart';

class FaceCompareIdentifyViewModel extends SingleViewStateModel{

  CameraController cameraController;
  Future<void> initializeControllerFuture;
  
  String orderId;

  List<CameraDescription> _cameras;

  // 相机是否初始化
  bool isInit = false;
  // 切换相机是否完成
  bool isSwitch = true;

  UserViewModel userViewModel;
  
  FaceCompareIdentifyViewModel(this.orderId);

  @override
  Future loadData() {
    Future.delayed(const Duration(milliseconds: 200), () async{
      if(!await Permission.camera.status.isGranted){
        G.showCustomToast(
            context: G.getCurrentContext(),
            titleText: "相机权限使用说明：",
            subTitleText: "用于拍摄、录制视频等场景",
            time: 2
        );
      }
      Permission.camera.request().isGranted.then((value) {
        if (value) {
          initCamera();
        } else {
          G.showPermissionDialog(
              str: "访问相机权限");
        }
      });
    });
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
    try{
      isSwitch = false;
      notifyListeners();
      if (_cameras.length > 1) {
        int index = _cameras.indexOf(cameraController.description);
        // if (index < _cameras.length - 1) {
        //   index += 1;
        // } else {
        //   index = 0;
        // }
        if(index==1){
          index = 0;
        }else{
          index = 1;
        }
        cameraController.dispose().then((value){
          cameraController = CameraController(_cameras[index], ResolutionPreset.high,
              enableAudio: false);
          cameraController.initialize().then((value){
            isSwitch = true;
            notifyListeners();
          });
        });

      }
    }catch(e){
      isSwitch = true;
      notifyListeners();
    }
  }

  getImg() async {
    // G.getCurrentState().pushNamedAndRemoveUntil(
    //     RoutePaths.judicialExpertiseList, (Route route) => false);
    try {
      // await initializeControllerFuture;
      EasyLoading.show(status: '活体检测中...');
      XFile info = await cameraController.takePicture();
      final result = await FlutterImageCompress.compressWithFile(
        info.path,
        minWidth: 300, //压缩后的最小宽度
        minHeight: 200, //压缩后的最小高度
        quality: 10, //压缩质量
        rotate: 0, //旋转角度
      );
      String imgInfo = base64Encode(result);
      Map<String, Object> map = {
        "image":"data:image/png;base64,$imgInfo",
        "name": userViewModel.userName,
        // "userId": VideoConferenceData.userId,
        "image_type":"base64",
        "idCard": userViewModel.idCard
      };
      HomeApi.getSingleton().similarityForSC(map, errorCallBack: (error) {
        EasyLoading.dismiss();
        ToastUtil.showToast("活体检测失败，请稍后再试！");
      }).then((value) {
        print("value-------$value");
        if (value
            != null && value['code'] == 200) {
          uploadFaceReport(value['annexId']);
        } else {
          EasyLoading.dismiss();
          ToastUtil.showToast(value['message']??value['msg']??"活体检测失败");
        }
      });
    } catch (err) {
      print(err);
    }
  }

  // 上传人脸识别报告
void  uploadFaceReport(String fileID){
    if(fileID ==null || fileID.isEmpty){
      EasyLoading.dismiss();
      ToastUtil.showToast("活体检测失败");
      return;
    }
    if(orderId==null || orderId.isEmpty){
      EasyLoading.dismiss();
      ToastUtil.showToast("订单编号为空");
      return;
    }
    HomeApi.getSingleton().saveFaveReport({"reportFileId":fileID,"notaryId":orderId},errorCallBack: (error){
      EasyLoading.dismiss();
      ToastUtil.showToast("活体检测报告上传失败，请稍后再试！");
    }).then((value){
      if (value
          != null && value['code'] == 200) {
        EasyLoading.dismiss();
        ToastUtil.showSuccessToast("活体检测成功");
        G.pop();
        cameraController.dispose();
      } else {
        EasyLoading.dismiss();
        ToastUtil.showToast(value["message"]??value['msg']??"活体检测报告上传失败，请稍后再试！");
      }
    });

}

}