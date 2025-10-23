import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

// import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:notarization_station_app/base_framework/utils/toast_util.dart';
import 'package:notarization_station_app/base_framework/view_model/single_view_state_model.dart';
import 'package:notarization_station_app/config.dart';
import 'package:notarization_station_app/page/login/vm/user_view_model.dart';
import 'package:notarization_station_app/service_api/home_api.dart';
import 'package:notarization_station_app/service_api/infomation_api.dart';
import 'package:notarization_station_app/utils/common_tools.dart';
import 'package:notarization_station_app/utils/global.dart';
import 'package:permission_handler/permission_handler.dart';

class ChatModel extends SingleViewStateModel {
  final info;
  UserViewModel userViewModel;
  ChatModel(this.userViewModel, this.info);

  ScrollController msgController = ScrollController();
  TextEditingController textEditingController = TextEditingController();
  int remoteUid = 0;
  // RtcEngine engine;
  List chatList = [];

  // 滚动消息至聊天底部
  scrollMsgBottom() {
    Timer(Duration(milliseconds: 100),
        () => msgController.jumpTo(msgController.position.maxScrollExtent));
  }

  //发送消息
  sendMessage() {
    String str = textEditingController.text.trim();
    if (textEditingController.text.isNotEmpty && str.length != 0) {
      // SocketManage.instance.gl_sock.sink.add(json.encode({"code":"chat","msg": textEditingController.text,"userId":info['unitGuid']+"-3","sender": userViewModel.unitGuid,"recipient": info['unitGuid'],"senderName": userViewModel.userName,"headIcon":userViewModel.headIcon,"img": 0}));
      addChatList(userViewModel.userName, textEditingController.text, 1, 0);
      textEditingController.text = "";
      notifyListeners();
    }
  }

  addChatList(String name, text, int num, imgNum, {String time = ""}) {
    var info = {
      "name": name,
      "time": time == ""
          ? "${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}:${DateTime.now().second.toString().padLeft(2, '0')}"
          : time,
      "info": text,
      "me": num,
      "isImg": imgNum,
    };
    chatList.add(info);
    scrollMsgBottom();
    notifyListeners();
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
          await Permission.camera.request().isGranted){
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

  Future<void> selectAssets() async {
    try {
      List<Asset> resultList = await MultiImagePicker.pickImages(
        // 选择图片的最大数量
        maxImages: 1,
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
        Asset asset = resultList[0];
        if (asset.originalHeight <= 0 || asset.originalWidth <= 0) {
          EasyLoading.dismiss();
          ToastUtil.showErrorToast("文件已破损，请重新选择");
        } else {
          ByteData byteData = await asset.getByteData();
          List<int> newImage = byteData.buffer.asUint8List();
          Uint8List result = await FlutterImageCompress.compressWithList(
            newImage,
            minWidth: 2300, //压缩后的最小宽度
            minHeight: 1500, //压缩后的最小高度
            // quality: 20, //压缩质量
            rotate: 0, //旋转角度
          );
          List base64List = [];
          base64List.add("data:image/png;base64,${base64Encode(result)}");
          Map<String, Object> map1 = {"files": base64List, "idCard": '111'};
          HomeApi.getSingleton().uploadImg(map1).then((res) {
            if (res != null) {
              if (res['code'] == 200) {
                // SocketManage.instance.gl_sock.sink.add(json.encode({"code":"chat","msg": Config.splicingImageUrl(res['item'][0]['filePath']),"sender": userViewModel.unitGuid,"userId": info['unitGuid']+"-3","recipient": info['unitGuid'],"senderName": userViewModel.userName,"headIcon":userViewModel.headIcon,"img": 1}));
                addChatList(userViewModel.userName,
                    Config.splicingImageUrl(res['item'][0]['filePath']), 1, 1);
              }
            }
          });
        }
      }
    } on Exception catch (e) {
      e.toString();
    }
  }

  getHistory() async {
    Map<String, dynamic> map = {
      //"sender":userViewModel.unitGuid,
      "recipient": info['unitGuid'],
    };
    var res = await InformationApi.getSingleton().queryHistory(map);
    if (res["code"] == 200) {
      res["items"].forEach((e) {
        // if(e['sender']==userViewModel.unitGuid){
        //   addChatList(userViewModel.userName,e['message'],1,e['img'],time: e['createDate']);
        // }else{
        //   addChatList(info['name'],e['message'],0,e['img'],time: e['createDate']);
        // }
      });
      chatList = chatList.reversed.toList();
    } else {
      ToastUtil.showErrorToast("出现了问题，请稍后再试");
    }
  }

  @override
  void socketDataHandler(onData) {
    // TODO: implement socketDataHandler
    wjPrint('...1$onData');
    var data = json.decode(onData);
    if (data['code'] == "chat" && data['sender'] == info['unitGuid']) {
      addChatList(data['senderName'], data['msg'], 0, data['img']);
    }
  }

  @override
  Future loadData() {
    // SocketManage.instance.setCallback(this);
    getHistory();
    return null;
  }

  @override
  onCompleted(data) {}
}
