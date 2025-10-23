import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notarization_station_app/base_framework/utils/toast_util.dart';
import 'package:notarization_station_app/base_framework/widget_state/base_state.dart';
import 'package:notarization_station_app/generated/json/base/json_convert_content.dart';
import 'package:notarization_station_app/page/login/vm/user_view_model.dart';
import 'package:notarization_station_app/page/mine/entity/upload_img_entity.dart';
import 'package:notarization_station_app/service_api/mine_api.dart';
import 'package:notarization_station_app/utils/global.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../config.dart';
import '../../utils/common_tools.dart';

class EditPortraitPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _EditPortraitPageState();
  }
}

class _EditPortraitPageState extends BaseState<EditPortraitPage> {
  UserViewModel userModel;
  // final picker = ImagePicker.;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBar(title: "修改头像"),
      body: Consumer<UserViewModel>(
        builder: (ctx, userModel, child) {
          this.userModel = userModel;
          return buildWidget();
        },
      ),
    );
  }

  Widget buildWidget() {
    var height = getScreenWidth() / 1.3;
    var width = getScreenWidth();
    return Stack(
      children: <Widget>[
        Container(
          height: height,
          color: Color(0xFFDBDBDB),
        ),
        Container(
          height: height,
          alignment: Alignment.center,
          child: ClipOval(
              child: FadeInImage.assetNetwork(
            width: height - getWidthPx(10),
            height: height - getWidthPx(10),
            placeholder: 'lib/assets/images/on-boy.jpg',
            image: userModel.hasUser
                ? Config.splicingImageUrl(userModel.headIcon)
                : "",
            fit: BoxFit.cover,
          )), //userData!=null?userData.mobile:''
        ),
        Container(
          alignment: Alignment.center,
          height: height,
          child: Container(
            alignment: Alignment.center,
            width: height - 5,
            height: height - 5,
            decoration: BoxDecoration(
              border: new Border.all(color: Color(0xB3FFFFFF), width: 10),
              // 边色与边宽度
              color: Colors.transparent,
              // 底色
              borderRadius: new BorderRadius.circular((height - 10) / 2), // 圆角度
            ),
          ),
        ),
        Positioned(
          top: height - 35,
          left: (width / 4) * 3,
          child: InkWell(
              onTap: () {
                _showDialog();
              },
              child: Icon(Icons.camera_alt, color: Colors.black, size: 30)),
        )
      ],
    );
  }

  _showDialog() async {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              InkWell(
                onTap: () {
                  getGallery();
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: EdgeInsets.all(getWidthPx(20)),
                  child: Text(
                    "从相册选择图片",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: getSp(36)),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  getImage();
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: EdgeInsets.all(getWidthPx(20)),
                  child: Text(
                    "拍照",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: getSp(36)),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: EdgeInsets.all(getWidthPx(20)),
                  child: Text(
                    "取消",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: getSp(36)),
                  ),
                ),
              ),
            ],
          );
        });
  }

  Future getImage() async {
    if(Platform.isIOS){
      if (await Permission.camera.request().isGranted) {
        final pickedFile = await ImagePicker.pickImage(source: ImageSource.camera);
        wjPrint(pickedFile.path);
        if (pickedFile.path != null) {
          _cropperImage(pickedFile.path);
        }
      } else {
        G.showPermissionDialog(str: "访问相机权限");
      }
    }
    if(Platform.isAndroid){
      if(!await Permission.camera.status.isGranted || !await Permission.storage.status.isGranted){
        G.showCustomToast(
            context: G.getCurrentContext(),
            titleText: "相机、存储权限使用说明：",
            subTitleText: "用于拍摄、录制视频、文件存储等场景",
            time: 2
        );
      }
      if (await Permission.camera.request().isGranted &&
          await Permission.storage.request().isGranted) {
        final pickedFile = await ImagePicker.pickImage(source: ImageSource.camera);
        wjPrint(pickedFile.path);
        if (pickedFile.path != null) {
          _cropperImage(pickedFile.path);
        }
      } else {
        G.showPermissionDialog(str: "访问内部存储、相机权限");
      }
    }


  }

  Future getGallery() async {
    if(Platform.isIOS){
      if(await Permission.photos.request().isGranted){
        File pickedGallery =
        await ImagePicker.pickImage(source: ImageSource.gallery);
        wjPrint("11111$pickedGallery");
        if (pickedGallery.path != null) {
          wjPrint(pickedGallery.path);
          _cropperImage(pickedGallery.path);
        }
      }else{
        G.showPermissionDialog(str: "访问相册权限");
      }
    }
    if(Platform.isAndroid){
      if( !await Permission.storage.status.isGranted){
        G.showCustomToast(
            context: G.getCurrentContext(),
            titleText: "照片及文件权限使用说明：",
            subTitleText: "用于上传照片和文件、以及设置头像等场景",
            time: 2
        );
      }
      if(await Permission.storage.request().isGranted){
        File pickedGallery =
        await ImagePicker.pickImage(source: ImageSource.gallery);
        wjPrint("11111$pickedGallery");
        if (pickedGallery.path != null) {
          wjPrint(pickedGallery.path);
          _cropperImage(pickedGallery.path);
        }
      }else{
        G.showPermissionDialog(str: "访问内部照片及文件权限");
      }
    }

  }

  _cropperImage(String path) async {
    File croppedFile = await ImageCropper.cropImage(
        cropStyle: CropStyle.circle,
        sourcePath: path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: '编辑图片',
            toolbarColor: Colors.white,
            toolbarWidgetColor: Colors.black,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));
    uploadPictures(croppedFile.path);
  }

  uploadPictures(String path) {
    EasyLoading.show(status: "上传图片");
    MineApi.getSingleton().uploadPictures(path).then((value) {
      wjPrint("带着自理$value");
      UploadImgEntity entity = JsonConvert.fromJsonAsT(value);
      EasyLoading.dismiss();
      if (entity.code == 200) {
        Map<String, Object> map = {
          //"unitGuid":userModel.unitGuid,
          "headIcon": entity.item.filePath,
        };
        wjPrint('zhehsi $map');
        MineApi.getSingleton().upLoadImg(map).then((res) {
          if (res['code'] == 200) {
            ToastUtil.showSuccessToast("修改头像成功！");
            userModel.setUserHead(entity.item.filePath);
          } else {
            ToastUtil.showErrorToast("修改头像失败！");
          }
        });
      }
    });
  }
}
