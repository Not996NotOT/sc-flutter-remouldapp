import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:notarization_station_app/base_framework/utils/toast_util.dart';
import 'package:notarization_station_app/base_framework/view_model/single_view_state_model.dart';
import 'package:notarization_station_app/page/login/entity/userInfo.dart';
import 'package:notarization_station_app/page/mine/entity/address_entity.dart';
import 'package:notarization_station_app/service_api/mine_api.dart';

class AddAddressViewModel extends SingleViewStateModel {
  UserInfoEntity userEntity;
  TextEditingController controllerAddress;
  TextEditingController controllerName;
  TextEditingController controllerPhone;
  TextEditingController controllerDetail;
  BuildContext context;
  AddressItem addressItem;
  bool isDefAddress = false;

  /// 按钮状态控制
  bool isEnable = true;

  void setDefAddress(value) {
    isDefAddress = value;
    notifyListeners();
  }

  AddAddressViewModel(BuildContext context, UserInfoEntity userEntity,
      AddressItem addressItem) {
    this.userEntity = userEntity;
    this.context = context;
    this.addressItem = addressItem;
    controllerName = new TextEditingController(
        text: addressItem != null ? addressItem.receivingUsername : "");
    controllerPhone = new TextEditingController(
        text: addressItem != null ? addressItem.phone : "");
    controllerDetail = new TextEditingController(
        text: addressItem != null ? addressItem.address : "");
    isDefAddress = addressItem != null && addressItem.noDefault == "0";
  }

  void addAddress() {
    if (controllerName.text.isEmpty) {
      ToastUtil.showWarningToast("联系人不能为空!");
      return;
    }
    if (controllerPhone.text.isEmpty) {
      ToastUtil.showWarningToast("手机号不能为空!");
      return;
    }
    if (controllerDetail.text.isEmpty) {
      ToastUtil.showWarningToast("地址不能为空!");
      return;
    }
    isEnable = false;
    notifyListeners();
    var addData = {
      //"userGuid": userEntity.items.user.unitGuid,
      "address": controllerDetail.text,
      "receivingUsername": controllerName.text,
      "phone": controllerPhone.text,
      "noDefault": isDefAddress ? "0" : "1",
    };
    EasyLoading.show(status: "新增地址");
    MineApi.getSingleton().addAddress(addData, errorCallBack: (e) {
      isEnable = true;
      EasyLoading.dismiss();
      notifyListeners();
    }).then((value) {
      isEnable = true;
      notifyListeners();
      EasyLoading.dismiss();
      Navigator.pop(context, "新增地址");
    });
  }

  void editAddress() {
    isEnable = false;
    notifyListeners();
    var addData = {
      "unitGuid": addressItem.unitGuid,
      //"userGuid": userEntity.unitGuid,
      "address": controllerDetail.text,
      "receivingUsername": controllerName.text,
      "phone": controllerPhone.text,
      "noDefault": isDefAddress ? "0" : "1",
    };
    EasyLoading.show(status: "修改地址");
    MineApi.getSingleton().updateAddress(addData, errorCallBack: (e) {
      isEnable = true;
      EasyLoading.dismiss();
      notifyListeners();
    }).then((value) {
      isEnable = true;
      EasyLoading.dismiss();
      notifyListeners();
      Navigator.pop(context, "修改地址");
    });
  }

  @override
  Future loadData() async {
    return null;
  }

  @override
  onCompleted(data) {}
}
