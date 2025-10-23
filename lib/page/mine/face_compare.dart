import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:color_dart/RgbaColor.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:notarization_station_app/appTheme.dart';
import 'package:notarization_station_app/base_framework/utils/toast_util.dart';
import 'package:notarization_station_app/base_framework/widget_state/base_state.dart';
import 'package:notarization_station_app/page/login/vm/user_view_model.dart';
import 'package:notarization_station_app/routes/router.dart';
import 'package:notarization_station_app/service_api/account_api.dart';
import 'package:notarization_station_app/service_api/bedrock_http.dart';
import 'package:notarization_station_app/service_api/mine_api.dart';
import 'package:notarization_station_app/utils/ServiceLocator.dart';
import 'package:notarization_station_app/utils/TelAndSmsService.dart';
import 'package:notarization_station_app/utils/focus_detector.dart';
import 'package:notarization_station_app/utils/global.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../config.dart';
import '../../utils/common_tools.dart';

class FaceCompareWidget extends StatefulWidget {
  final Map<String, dynamic> data;
  const FaceCompareWidget({Key key, this.data}) : super(key: key);

  @override
  State<FaceCompareWidget> createState() => _FaceCompareWidgetState();
}

class _FaceCompareWidgetState extends BaseState<FaceCompareWidget>
    with SingleTickerProviderStateMixin {
  TelAndSmsService _service = locator<TelAndSmsService>();

  // 计数器
  Timer _timer;

  CameraController controller;

  String _time = '20s';

  List<CameraDescription> _cameras;

  bool _isInit = false;

  bool isAbroad = false;

  // 证件号码
  String _idCard = '';

  // 姓名
  String _name = '';

  // 国籍
  String _nation = '';

  // 性别
  int _sex = 1;

  // 证件类型
  int _cerType = 0;

  // 有效日期
  String _endTime = '';

  // 出生日期
  String _birth = '';

  // 标记从登录模块进入还是我的模块进入
  String comeFrom;

  // 用户信息
  UserViewModel _userViewModel;

  @override
  void initState() {
    super.initState();
    isAbroad = widget.data['isAbroad'];
    _idCard = widget.data['cardData']['idCard'];
    _name = widget.data['cardData']['name'];
    comeFrom = widget.data['comeFrom'];
    if (isAbroad) {
      _nation = widget.data['cardData']['nation'];
      _sex = widget.data['cardData']['sex'] == '男' ? 1 : 2;
      _cerType = widget.data['cardData']['certificateType'];
      _endTime = widget.data['cardData']['endTime'];
      _birth = widget.data['cardData']['birth'];
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }


// 初始化相机
  void _initCamera(int index) async {
    if (!await Permission.camera.status.isGranted &&
        !await Permission.camera.status.isPermanentlyDenied) {
      G.showCustomToast(
          context: G.getCurrentContext(),
          titleText: "相机权限使用说明：",
          subTitleText: "用于拍摄、录制视频等场景",
          time: 2
      );
    }
    if (await Permission.camera
        .request()
        .isGranted) {
      _cameras = await availableCameras();
      controller = CameraController(
          _cameras[index], ResolutionPreset.max, enableAudio: false);
      controller.initialize().then((_) {
        setState(() {
          _isInit = true;
        });
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
    }else{
      G.showPermissionDialog(str: "访问相机权限");
    }
  }

  // 切换相机
  void switchCamera() async {
    if(!await Permission.camera.status.isGranted){
      G.showCustomToast(
          context: G.getCurrentContext(),
          titleText: "相机权限使用说明：",
          subTitleText: "用于拍摄、录制视频等场景",
          time: 2
      );
    }
    if(!_isInit){
      _initCamera(1);
    }
    if (_cameras.length > 1) {
      int index = _cameras.indexOf(controller.description);
      if (index < _cameras.length - 1) {
        index += 1;
      } else {
        index = 0;
      }
      _initCamera(index);
    }


  }

  // 拍照
  void _takePicture() async {
   if(!await Permission.camera.status.isGranted){
     G.showCustomToast(
         context: G.getCurrentContext(),
         titleText: "相机权限使用说明：",
         subTitleText: "用于拍摄、录制视频等场景",
         time: 2
     );
   }
   if(await Permission.camera.request().isGranted){
     EasyLoading.show();
     if (controller.value.isInitialized) {
       XFile path = await controller.takePicture();
       final result = await FlutterImageCompress.compressWithFile(
         path.path,
         minWidth: 900, //压缩后的最小宽度
         minHeight: 600, //压缩后的最小高度
         quality: 20, //压缩质量
       );
       var name = path.path
           .substring(path.path.lastIndexOf("/") + 1, path.path.length) +
           ".png";
       var image = MultipartFile.fromBytes(
         result,
         filename: name,
       );
       FormData formData = FormData.fromMap({
         "file": image,
       });
       final response = await HttpManager.instance
           .post("${Config.annexModule}/sys/annex/fastDFSUpload", data: formData,
           errorCallBack: (e) {
             EasyLoading.dismiss();
           });
       if (response.data['code'] == 200) {
         if (!isAbroad) {
           compareFace(response.data['item']['filePath']);
         } else {
           abroadCompareFace(response.data['item']['filePath']);
         }
       } else {
         EasyLoading.dismiss();
         ToastUtil.showErrorToast("网络出错了，请稍后再试！");
       }
     }
   }else{
     G.showPermissionDialog(str: "访问相机权限");
   }
  }

  // // 上传图片
  // void uploadImageFile(String filePath) async {
  //    MineApi.getSingleton().uploadPictures(filePath).then((value){
  //      if(value['code']==200){
  //        compareFace(value['item']['filePath']);
  //      }else{
  //        ToastUtil.showErrorToast("网络出错了，请稍后再试！");
  //      }
  //    });
  // }

  // 人脸比对
  void compareFace(String path) async {
    Map<String, dynamic> params = {
      "idCard": _idCard,
      "image": path,
      "image_type": "url",
      "name": _name,
    };
    wjPrint("params-------$params");
    MineApi.getSingleton().getFaceCompare(params, errorCallBack: (e) {
      EasyLoading.dismiss();
    }).then((value) {
      EasyLoading.dismiss();
      if (value['code'] == 200) {
        ToastUtil.showSuccessToast('人脸识别通过！');
        G.pushNamed(RoutePaths.Attestation, arguments: {
          'isAbroad': isAbroad,
          'comeFrom': comeFrom,
          "cardData": widget.data['cardData'],
          "cardZheng": widget.data['filePath'],
          // "cardFan": filePathF,
        });
      } else {
        ToastUtil.showErrorToast(value['msg'], second: 2);
      }
    });
  }

  // 境外人脸比对
  void abroadCompareFace(String path) async {
    Map<String, dynamic> params = {
      "idNum": _idCard,
      "imgBase64": path,
      "imageType": "url",
      'birthDate': _birth.replaceAll('-', ''),
      "expiryDate": _endTime.replaceAll('-', ''),
      "fullName": _name,
      'idType': _cerType.toString(),
      'nation': _nation,
      'mobile': _userViewModel.mobile,
      'authentication': true,
      'modeType': "146",
      'sex': _sex.toString(),
    };
    wjPrint("params-------$params");
    MineApi.getSingleton().getAbroadFaceCompare(params, errorCallBack: (e) {
      EasyLoading.dismiss();
    }).then((value) {
      EasyLoading.dismiss();
      if (value['code'] == 200) {
        if (value['data']['code'] == "00000") {
          ToastUtil.showSuccessToast('人脸识别通过！');
          G.pushNamed(RoutePaths.Attestation, arguments: {
            'isAbroad': isAbroad,
            'comeFrom': comeFrom,
            "cardData": widget.data['cardData'],
            "cardZheng": widget.data['filePath'],
            // "cardFan": filePathF,
          });
        } else {
          ToastUtil.showWarningToast(value['data']['message'], second: 2);
        }
      } else if (value['code'] == 11050) {
        disabledUserAccount();
      } else if (value['code'] != 11050 && value['code'] != 200) {
        ToastUtil.showErrorToast(value['message']);
      } else {
        ToastUtil.showErrorToast(value['msg'] ?? value['message'], second: 2);
      }
    });
  }

  // 境外人脸认证次数超限
  aboradCheckTooMany() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Center(
            child: Container(
              padding: EdgeInsets.all(getWidthPx(40)),
              margin: EdgeInsets.symmetric(horizontal: 30),
              decoration: BoxDecoration(
                  color: AppTheme.white,
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                      '''
      因您提供的证件信息无法自动识别验证，需要通过人工审核才能完成实名认证。

      可联系公证员协助处理，或使用大陆手机号联系4008001820进行咨询。'''),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                          onPressed: () {
                            G.pop();
                            exit(0);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 30, vertical: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: AppTheme.themeBlue, width: 1),
                            ),
                            child: Text(
                              '  退出  ',
                              style: TextStyle(color: AppTheme.themeBlue),
                            ),
                          )),
                      TextButton(
                          onPressed: () {
                            G.pop();
                            Future.delayed(const Duration(milliseconds: 500),
                                () {
                              _service.call("4008001820");
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 30, vertical: 10),
                            decoration: BoxDecoration(
                              color: AppTheme.themeBlue,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '立即拨打',
                              style: TextStyle(color: AppTheme.white),
                            ),
                          )),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  upDataUserInformation() {
    var map = {
      //"unitGuid":userViewModel.unitGuid,
      "idCardImg": widget.data['cardData']["idCardImg"],
      "userName": _name,
      "idCard": _idCard,
      "registeAddress": widget.data['cardData']['registeAddress'],
      "gender": widget.data['cardData']["sex"] == '男' ? 1 : 0,
      "nation": widget.data['cardData']["nation"],
      "birthday": widget.data['cardData']['birth'],
      "address": widget.data['cardData']['address']
    };
    wjPrint(map);
    wjPrint("身份数据");
    AccountApi.getSingleton()
        .identityUser(map, errorCallBack: (e) {})
        .then((data) {
      wjPrint("返回数据：$data");
      if (data["code"] == 200) {
        // ToastUtil.showSuccessToast("身份认证成功！");
        // _userViewModel.setUserName(_name);
        // _userViewModel.setUserGender(widget.data['cardData']["sex"] ?? '');
        // _userViewModel.setUserAddress(widget.data['cardData']['birth'] ?? '');
        // _userViewModel
        //     .setUserBirthday(widget.data['cardData']['address'] ?? '');
        // // userViewModel.setUserIdImg(imgList.join(","));
        // _userViewModel.setUseridCard(_idCard ?? '');
      } else {
        ToastUtil.showErrorToast(data["data"]);
      }
    });
  }

  // 用户账号禁用
  disabledUserAccount() {
    MineApi.getSingleton().disableByLoginName(
        {'loginName': _userViewModel.mobile}, errorCallBack: (e) {
      wjPrint('账号禁用成功----$e');
    }).then((value) {
      if (value['code'] == 200) {
        wjPrint('账号禁用成功');
        upDataUserInformation();
        _userViewModel.userLogout(isShow: false);
        aboradCheckTooMany();
      } else {
        wjPrint("账号禁用失败！");
      }
    });
  }

  // 人脸识别失败弹框
  void showFaceFailDialog(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (ctx, setBottomSheet) {
              return Dialog(
                child: Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(4)),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 24, horizontal: 15),
                          child: Text(
                            "人脸识别失败或超时\n请根据提示完成人脸识别",
                            style: TextStyle(
                              color: rgba(153, 153, 153, 1),
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Container(
                          // padding: EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                              border: Border(
                                  top: BorderSide(
                                      color: rgba(242, 242, 242, 1)))),
                          child: Row(
                            children: <Widget>[
                              // 取消按钮
                              Expanded(
                                  child: Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                      right: BorderSide(
                                          color: rgba(242, 242, 242, 1))),
                                ),
                                child: TextButton(
                                  child: const Text(
                                    "退出",
                                    style: TextStyle(color: AppTheme.bg_f),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                  },
                                ),
                              )),
                              // 确认按钮
                              Expanded(
                                child: TextButton(
                                  child: const Text("重新识别"),
                                  onPressed: () {
                                    G.pop();
                                    // Future.delayed(const Duration(microseconds: 500), () {
                                    //   // _time = '20s';
                                    //   // _timer.cancel();
                                    //   // _startTimer1();
                                    //   // // _startTimer2();
                                    //   _takePicture();
                                    // });
                                  },
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    )),
              );
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return FocusDetector(
      onFocusGained: (){
        _initCamera(1);
      },
      child: Scaffold(
        appBar: AppBar(
            centerTitle: true,
            title: const Text(
              '人脸识别',
              style: TextStyle(color: Colors.white),
            )),
        body: Consumer<UserViewModel>(builder: (context, userModel, child) {
          _userViewModel = userModel;
          return ColoredBox(
            color: Colors.white,
            child: Center(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: getWidthPx(720),
                    child: Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        Padding(
                            padding: EdgeInsets.only(top: 40, bottom: 15),
                            child: _isInit
                                ? ClipOval(
                                    child: SizedBox(
                                      width: getWidthPx(596),
                                      height: getWidthPx(596),
                                      child: OverflowBox(
                                        maxWidth: double.infinity,
                                        maxHeight: double.infinity,
                                        child: FittedBox(
                                          fit: BoxFit.fitWidth,
                                          child: SizedBox(
                                            width:
                                                MediaQuery.of(context).size.width,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                controller
                                                    .value.previewSize.width /
                                                controller
                                                    .value.previewSize.height,
                                            child: CameraPreview(controller),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(
                                    width: getWidthPx(600),
                                    height: getWidthPx(600),
                                    decoration: BoxDecoration(
                                        color: Color(0xFFD7D7D7),
                                        borderRadius: BorderRadius.circular(300)),
                                  )),
                        Padding(
                          padding: const EdgeInsets.only(top: 50),
                          child: Text(
                            "请将人脸移入框内",
                            style:
                                TextStyle(fontSize: getSp(32), color: Colors.red),
                          ),
                        )
                      ],
                    ),
                  ),
                  Text(
                    '请平视屏幕，距离30~60厘米',
                    style: TextStyle(fontSize: getSp(32)),
                  ),
                  const Spacer(),
                  Container(
                    height: getHeightPx(200),
                    padding: EdgeInsets.only(bottom: 60),
                    child: Stack(
                      alignment: Alignment.centerRight,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: getWidthPx(160),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Spacer(),
                              GestureDetector(
                                onTap: () {
                                  _takePicture();
                                },
                                child: Image.asset(
                                  'lib/assets/images/拍照.png',
                                  width: getWidthPx(160),
                                  height: getWidthPx(160),
                                ),
                              ),
                              const Spacer()
                            ],
                          ),
                        ),
                        Positioned(
                          right: (MediaQuery.of(context).size.width / 2 -
                                  getWidthPx(80) -
                                  40) /
                              2,
                          child: IconButton(
                              onPressed: () => switchCamera(),
                              icon: const Icon(
                                Icons.flip_camera_ios_outlined,
                                color: Color(0xFF1296db),
                                size: 40,
                              )),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
