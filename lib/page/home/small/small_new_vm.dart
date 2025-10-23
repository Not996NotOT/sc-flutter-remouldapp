import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http_parser/http_parser.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:notarization_station_app/base_framework/utils/toast_util.dart';
import 'package:notarization_station_app/base_framework/view_model/single_view_state_model.dart';
import 'package:notarization_station_app/config.dart';
import 'package:notarization_station_app/generated/json/base/json_convert_content.dart';
import 'package:notarization_station_app/page/home/entity/small_list_entity.dart';
import 'package:notarization_station_app/page/home/entity/small_material_entity.dart';
import 'package:notarization_station_app/page/home/entity/video_entity.dart';
import 'package:notarization_station_app/page/login/vm/user_view_model.dart';
import 'package:notarization_station_app/routes/router.dart';
import 'package:notarization_station_app/service_api/home_api.dart';
import 'package:notarization_station_app/service_api/mine_api.dart';
import 'package:notarization_station_app/socket/mqtt_client.dart';
import 'package:notarization_station_app/utils/common_tools.dart';
import 'package:notarization_station_app/utils/global.dart';
import 'package:permission_handler/permission_handler.dart';

class SmallNewModel extends SingleViewStateModel with ClientCallback {
  UserViewModel userViewModel;
  SmallListItems route;
  List<SmallListItemsImgPath> imgList = [];
  List<String> imgIdList = [];

  VideoEntity orderInfo;
  Timer timer2;
  List personnelList = [];
  String personnelId = "";

  bool isInform = true;

  //材料
  List<SmallMaterialEntity> materialList = [];

  //是否重新编辑过
  bool isUpdate = false;

  String latLng = '';

  SmallNewModel(this.userViewModel, this.route) {
    imgList = route.imgPath;
    route.material.split('、').forEach((e) {
      SmallMaterialEntity info = SmallMaterialEntity();
      info.name = e;
      info.data = <SmallMaterialData>[];
      materialList.add(info);
    });
    materialList.forEach((e) {
      imgList.forEach((el) {
        if (el.materialName.split("附件")[0] == e.name) {
          SmallMaterialData info = SmallMaterialData();
          info.materialName = el.materialName;
          info.annexId = el.path;
          info.imgPath = el.unitGuid;
          e.data.add(info);
        }
      });
    });
  }

  submitVideo() async {
    // TODO 添加ipDependency
    EasyLoading.show(status: "正在安排公证员，请耐心等待...");
    DateTime now = new DateTime.now();
    String phoneInfo = await G.phoneInfo(latLng);
    Map<String, String> map = {
      "nei": phoneInfo,
      "userId": route.loanOfficerId,
      "name": route.loanOfficerName,
      "useArea": "",
      "useLanguage": "",
      "purposeName": "",
      "notaryId": route.notaryId,
      "isDaiBan": "0",
      "terminalType": "3",
      "notaryForm": "5",
      "description": "",
      //合同id
      "bankOrderId": route.bankOrderId,
      "videolog": json.encode(
          {"planDate": now.toString().substring(0, 10), 'ipDependency': ""}),
      "applyUsers": json.encode([
        {
          "name": route.loanOfficerName,
          "idCard": route.loanOfficerIdCard,
          "mobile": route.loanOfficerMobile,
        }
      ])
    };
    wjPrint(map);
    wjPrint("公证信息----------------------------");
    HomeApi.getSingleton().addOrder(map).then((res) {
      if (res != null) {
        orderInfo = JsonConvert.fromJsonAsT(res);
        if (orderInfo.code != 200) {
          EasyLoading.dismiss();
          return ToastUtil.showWarningToast("服务器异常，稍后再试！");
        }
        MqttClientMsg.instance.setCallback(this);
        MqttClientMsg.instance
            .subscribe("/topic/bank/${route.loanOfficerIdCard}");
        timer2 = Timer(new Duration(seconds: 60), () {
          //如果60s内不接单
          try {
            MqttClientMsg.instance
                ?.unsubscribe("/topic/bank/${route.loanOfficerIdCard}");
          } catch (e) {
            print("结束报错了$e");
          }
          cancelOrder();
          EasyLoading.dismiss();
        });
      } else {
        EasyLoading.dismiss();
        ToastUtil.showWarningToast("请求失败，稍后再试！");
      }
    });
  }

  @override
  void clientDataHandler(onData, topic) {
    if (topic == "bank") {
      print('MQTT的消息...$onData');
      var orderData = json.decode(onData);
      if (orderData['code'] == 'dontWiting') {
        timer2.cancel();
        EasyLoading.dismiss();
        Map<String, Object> map = {"channelName": orderData["roomId"]};
        MineApi.getSingleton().getToken(map).then((res) {
          if (res["code"] == 200) {
            Config.aPPId = res['appId'];
            Config.token = res['token'];
            G.pushNamed(RoutePaths.SmallVideo, arguments: {
              "roomId": orderData["roomId"],
              "materialList": materialList,
              "detail": route
            });
          }
        });
      }
    }
  }

  cancelOrder() {
    Map<String, String> map2 = {"unitGuid": orderInfo.unitGuid.unitGuid};
    HomeApi.getSingleton().shutVideoOrder(map2).then((res2) {
      if (res2 != null) {
        if (res2['code'] != 200) {
          return ToastUtil.showWarningToast("服务器异常，稍后再试！");
        }
        ToastUtil.showNormalToast("公证员正在忙碌请稍后再试！");
      } else {
        ToastUtil.showWarningToast("请求失败，稍后再试！");
      }
    });
  }

  Future<void> requestCameraPermission(String name) async {
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
          await Permission.camera.request().isGranted){
        selectAssets(name);
      }else{
        G.showPermissionDialog(str: "访问内部相机、相册及文件权限");
      }
    }
    if(Platform.isIOS){
      if(await Permission.photos.request().isGranted && await Permission.camera.request().isGranted){
        selectAssets(name);
      }else{
        G.showPermissionDialog(str: "访问相机、相册权限");
      }
    }
  }

//选照片
  Future<void> selectAssets(String name) async {
    try {
      List<Asset> resultList = await MultiImagePicker.pickImages(
        // 选择图片的最大数量
        maxImages: 5,
        // 是否支持拍照
        enableCamera: true,
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
            ByteData oldBd = await asset.getByteData(quality: 30);
            List<int> imageData = oldBd.buffer.asUint8List();
            final dateTime = DateTime.now().millisecondsSinceEpoch;
            List<int> result = await FlutterImageCompress.compressWithList(
              imageData,
              minWidth: 2300, //压缩后的最小宽度
              minHeight: 1500, //压缩后的最小高度
              quality: 20, //压缩质量
              rotate: 0, //旋转角度
            );
            MultipartFile multipartFile = MultipartFile.fromBytes(
              result,
              filename: '$dateTime.png',
              contentType: MediaType("image", "jpg"),
            );
            HomeApi.getSingleton().uploadPictures(multipartFile).then((res) {
              if (res != null && res['code'] == 200) {
                List list = [];
                SmallMaterialData data = SmallMaterialData();
                data.imgPath = res['item']['unitGuid'];
                data.materialName = "$name附件${i + 1}";
                list.add(data);
                Map<String, dynamic> info = {
                  "image": json.encode(list),
                  "bankOrderId": route.bankOrderId,
                };
                HomeApi.getSingleton().updateSmall(info).then((data) {
                  if (data['code'] == 200) {
                    SmallMaterialData listInfo = SmallMaterialData();
                    listInfo.annexId =
                        Config.splicingImageUrl(res['item']['filePath']);
                    data["item"].forEach((e) {
                      listInfo.imgPath = e["unitGuid"];
                      materialList.forEach((i) {
                        if (i.name == name) {
                          i.data.add(listInfo);
                          notifyListeners();
                        }
                      });
                    });
                  }
                });
                notifyListeners();
              }
            });
            if (i + 1 == resultList.length) {
              EasyLoading.dismiss();
            }
          }
        }
      }
    } on Exception catch (e) {
      e.toString();
    }
  }

  delImg(String info, int num, String name) {
    EasyLoading.show(status: "删除图片中");
    wjPrint("+++++删除图片中+++++$info");
    HomeApi.getSingleton().delSmallImg({"unitGuid": info}).then((res) {
      EasyLoading.dismiss();
      if (res['code'] == 200) {
        // imgList.removeAt(num);
        materialList.forEach((e) {
          if (e.name == name) {
            e.data.removeAt(num);
          }
        });
        ToastUtil.showSuccessToast("删除成功！");
      } else {
        ToastUtil.showWarningToast("删除失败，稍后再试！");
      }
      notifyListeners();
    });
  }

  @override
  Future loadData() {
    // TODO: implement loadData
    return null;
  }

  @override
  onCompleted(data) {
    // TODO: implement onCompleted
    throw UnimplementedError();
  }
}
