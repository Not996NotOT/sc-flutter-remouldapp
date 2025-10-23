import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:notarization_station_app/base_framework/utils/toast_util.dart';
import 'package:notarization_station_app/base_framework/view_model/single_view_state_model.dart';
import 'package:notarization_station_app/service_api/mine_api.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../entity/signature_entity.dart';

class SignatureViewModel extends SingleViewStateModel {
  List<SignatureEntity>  signatures = [] ;

  RefreshController refreshController = RefreshController();

  void toggleEnabled(int index) {
    // _signatures[index] = SignatureEntity(
    //   name: _signatures[index].name,
    //   applicant: _signatures[index].applicant,
    //   applyDate: _signatures[index].applyDate,
    //   enabled: !_signatures[index].enabled,
    // );
    notifyListeners();
  }

  void onRefresh()async{
    signatures.clear();
    getSignatureList();
    refreshController.refreshCompleted();
  }

  void onLoading()async{
    getSignatureList();
    refreshController.loadComplete();
  }

  /// 获取签章列表
  void getSignatureList() async {
    EasyLoading.show();
    signatures.clear();
    notifyListeners();
    MineApi.getSingleton().queryMyEnterprise({},errorCallBack: (){
      EasyLoading.dismiss();
      ToastUtil.showErrorToast('网络请求失败');
    }).then((result){
      EasyLoading.dismiss();
      if(result["code"] == 200){
        if(result["data"] != null && result["data"].length > 0){
         result["data"].forEach((item){
           SignatureEntity entity = SignatureEntity.fromJson(item);
           signatures.add(entity);
         });
        }
        notifyListeners();
      } else {
        ToastUtil.showErrorToast(result["message"]??result["msg"]??result["data"]);
      }
    });

  }

  /// 删除签章
  void deleteSignature(int index) {
    EasyLoading.showToast("签章删除中");
    var  params = {"unitGuid": signatures[index].unitGuid};
    MineApi.getSingleton().deleteEnterprise(params,errorCallBack: (){
      EasyLoading.dismiss();
      ToastUtil.showErrorToast('网络请求失败');
    }).then((result){
      EasyLoading.dismiss();
      if(result["code"] == 200){
        signatures.removeAt(index);
        ToastUtil.showSuccessToast("删除成功！");
        notifyListeners();
      } else {
        ToastUtil.showErrorToast(result["message"]??result["msg"]??result["data"]);
      }
    });
  }
  
  /// 修改签章状态
  void updateSignatureStatus(int index) {
    if(signatures[index].status == 2 || signatures[index].status == 4){
      EasyLoading.show();
      MineApi.getSingleton().updateEnterpriseStatus({
        "unitGuid": signatures[index].unitGuid,
        "oriStatus": signatures[index].status,
        "status": signatures[index].status == 2 ? 4 : 2,
      },errorCallBack: (){
        EasyLoading.dismiss();
        ToastUtil.showErrorToast("网络请求失败");
      }).then((result){
        EasyLoading.dismiss();
        if(result["code"] == 200) {
          signatures[index].status = signatures[index].status == 2 ? 4 : 2;
          notifyListeners();
        } else {
          ToastUtil.showErrorToast(result["message"]??result['msg']??result['data']);
        }
      });
    } else {
      ToastUtil.showWarningToast("签章未审核通过，无法进行此项操作！");
    }
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
} 