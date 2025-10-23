import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:notarization_station_app/base_framework/utils/toast_util.dart';
import 'package:notarization_station_app/base_framework/view_model/single_view_state_model.dart';
import 'package:notarization_station_app/routes/router.dart';
import 'package:notarization_station_app/service_api/mine_api.dart';
import 'package:notarization_station_app/utils/global.dart';

class MySignatureApplyViewModel extends SingleViewStateModel {

  bool isUpdate;

  // 查询的次数
  int count = 0;

  MySignatureApplyViewModel({this.isUpdate = false});

  bool role = true; // true: 法人, false: 代理人
  changeValue(bool value){
    role = value;
    notifyListeners();
  }

  @override
  Future loadData() {
    // TODO: implement loadData
    throw UnimplementedError();
  }

  @override
  onCompleted(data) {
    // TODO: implement onCompleted
    throw UnimplementedError();
  }

  /// 添加企业签章
/// businessLicenseFile	营业执照文件		false
// createUserId	创建用户Id		false
// enterpriseName	企业名称		true
// enterpriseSealUrl	企业章地址		true
// idBackFile	法人背面照片		false
// idFrontFile	法人正面照片		false
// organizationCode	组织机构代码		true
// status	状态		false
// updateUserId	修改用户Id		false
// userType	用户类型		false
  Future addEnterprise(map) async {
    EasyLoading.showToast("提交中...");
    MineApi.getSingleton().addEnterprise(map,errorCallBack: (){
      EasyLoading.dismiss();
      ToastUtil.showErrorToast("网络出错了，请稍后再试！");
    }).then((value){
      EasyLoading.dismiss();
      if(value['code'] ==200){
        ToastUtil.showSuccessToast("添加成功！");
        G.pop();
      } else {
        ToastUtil.showErrorToast(value['message']??value['msg']??value['data']??"提交失败！");
      }
    });
  }

  /// 更新订单信息
  Future updateOrderInfo(map) async {
    EasyLoading.showToast("提交中...");
    MineApi.getSingleton().updateEnterprise(map,errorCallBack: (){
      EasyLoading.dismiss();
      ToastUtil.showErrorToast("网络出错了，请稍后再试！");
    }).then((value){
      EasyLoading.dismiss();
      if(value['code'] ==200){
        ToastUtil.showSuccessToast("添加成功！");
        G.pop();
      } else {
        ToastUtil.showErrorToast(value['message']??value['msg']??value['data']??"提交失败！");
      }
    });
  }

  /// 调用人脸公共服务
  void faceCompare(Function callBack) async {
    count = 0;
    EasyLoading.show();
    MineApi.getSingleton().getFacePlatformUrl(errorCallBack: (){
      ToastUtil.showErrorToast("获取人脸公共服务失败！");
    }).then((value){
      EasyLoading.dismiss();
      if(value['code'] ==200 && value['data'] != null){
        Navigator.pushNamed(G.getCurrentContext(), RoutePaths.flutterInappwebview,arguments: {"title":'人脸识别',"url":value['data']['verifyUrl']}).then((result){
          if(result != null && result){
            queryFaceStatus(value['data']['faceId'], () {
              callBack(value['data']['faceId']);
            });
          }
        });
      } else {
        ToastUtil.showErrorToast(value['message']??value['msg']??value['data']??"获取人脸公共服务失败！");
      }
    });
  }

  /// 查询人脸是否通过
  Future queryFaceStatus(String faceId,Function callBack) async {
    MineApi.getSingleton().faceNotify(faceId:faceId,errorCallBack: (){
      EasyLoading.dismiss();
      ToastUtil.showErrorToast("网络出错了，请稍后再试！");
    }).then((value){
      if(value['code'] ==200){
        EasyLoading.dismiss();
        callBack();
      } else {
        if(count < 5){
          count++;
          Future.delayed(Duration(seconds: 1), () {
            queryFaceStatus(faceId, callBack);
          });
        } else {
          EasyLoading.dismiss();
          ToastUtil.showErrorToast(value['message']??value['msg']??value['data']??"人脸查询结果失败！");
        }
      }
    });
  }
}