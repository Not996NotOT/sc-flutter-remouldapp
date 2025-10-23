/*
 * @Author: 王士博 wangshibo@gc.com
 * @Date: 2023-06-05 22:20:37
 * @LastEditors: 王士博 wangshibo@gc.com
 * @LastEditTime: 2023-06-25 14:28:30
 * @FilePath: /remouldApp/lib/service_api/mine_api.dart
 * @Description: 
 * 
 * Copyright (c) 2023 by ${git_name_email}, All Rights Reserved. 
 */
import 'package:dio/dio.dart';
import 'package:notarization_station_app/config.dart';

import 'bedrock_http.dart';

class MineApi {
  static MineApi _singleton;

  factory MineApi() => getSingleton();

  static MineApi getSingleton() {
    if (_singleton == null) {
      _singleton = MineApi._internal();
    }
    return _singleton;
  }

  MineApi._internal() {
    //do stuff
  }

  Future getAddressList(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.post(
        "${Config.notaryModule}/cgz/receivingaddress/selectPage",
        queryParameters: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  Future addAddress(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.post(
        "${Config.notaryModule}/cgz/receivingaddress/add",
        data: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  Future updateAddress(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.post(
        "${Config.notaryModule}/cgz/receivingaddress/update",
        data: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  Future delAddress(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.post(
        "${Config.notaryModule}/cgz/receivingaddress/delete",
        queryParameters: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  Future upLoadImg(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.post(
        "${Config.userModule}/cgz/user/appUserHeadUpdate",
        data: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  Future uploadPictures(String path, {Function errorCallBack}) async {
    var name = path.substring(path.lastIndexOf("/") + 1, path.length) + ".png";
    var image = await MultipartFile.fromFile(
      path,
      filename: name,
    );
    FormData formData = FormData.fromMap({
      "file": image,
    });
    final response = await HttpManager.instance.post(
        "${Config.annexModule}/sys/annex/fastDFSUpload",
        data: formData,
        errorCallBack: errorCallBack);
    return response.data;
  }

  Future upLoadVersion(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.post(
        "${Config.userModule}/cgz/appedition/selectNewBy",
        data: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  //获取声网ID
  Future getToken(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.post(
        "${Config.notaryModule}/agora/token",
        data: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  Future userToCancellation(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.post(
        "${Config.userModule}/cgz/user/userToCancellation",
        queryParameters: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  // 保存境外用户实名信息  /cgz/user/certification
  Future saveAbroadUserInformation(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.post(
        "${Config.userModule}/cgz/user/certification",
        data: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  // 人脸是被
  Future getFaceCompare(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.post(
        "${Config.identificationModule}/face/faceComparison",
        data: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  // 境外人脸校验
  Future getAbroadFaceCompare(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.post(
        "${Config.identificationModule}/overIdAuth/idAuth",
        data: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  // /cgz/user/disableByLoginName  app账号禁用账号
  Future disableByLoginName(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.post(
        "${Config.userModule}/cgz/user/disableByLoginName",
        data: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  /// 查询企业签章
  Future queryMyEnterprise(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.get(
        "${Config.notaryModule}/cgz/caenterprise/queryMyEnterprise",
        queryParameters: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  /// 修改企业签章状态
  Future updateEnterpriseStatus(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.post(
        "${Config.notaryModule}/cgz/caenterprise/updateStatus",
        data: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  /// 删除企业签章
  Future deleteEnterprise(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.post(
        "${Config.notaryModule}/cgz/caenterprise/deleteById",
        queryParameters: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  /// 添加企业签章
  Future addEnterprise(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.post(
        "${Config.notaryModule}/cgz/caenterprise/add",
        data: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  /// 更新企业签章信息
  Future updateEnterprise(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.post(
        "${Config.notaryModule}/cgz/caenterprise/update",
        data: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  /// 获取人脸公共平台连接
  Future getFacePlatformUrl({Function errorCallBack}) async {
    final response = await HttpManager.instance.get(
        "${Config.notaryModule}/cgz/caenterprise/faceVerify",
        errorCallBack: errorCallBack);
    return response.data;
  }

  /// 用户人脸识别判断是否通过 post请求 参数 String faceId（操作1返回）
  Future faceNotify({String faceId, Function errorCallBack}) async {
    final response = await HttpManager.instance.post(
        "${Config.notaryModule}/cgz/caenterprise/faceNotify",
        data: {"faceId": faceId},
        errorCallBack: errorCallBack);
    return response.data;
  }
}
