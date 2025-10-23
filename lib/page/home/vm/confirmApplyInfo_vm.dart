import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:notarization_station_app/base_framework/utils/toast_util.dart';
import 'package:notarization_station_app/base_framework/view_model/single_view_state_model.dart';
import 'package:notarization_station_app/page/login/vm/user_view_model.dart';
import 'package:notarization_station_app/routes/router.dart';
import 'package:notarization_station_app/service_api/home_api.dart';
import 'package:notarization_station_app/service_api/mine_api.dart';
import 'package:notarization_station_app/utils/global.dart';

class ConfirmApplyInfoModel extends SingleViewStateModel {
  UserViewModel userViewModel;
  final arguments;

  String selectType = "自取";
  TextEditingController number;
  TextEditingController mobile;
  TextEditingController type;
  List addressList = [];
  Map orderAddress;
  int takeStyle = 1;
  String takeAddress = "";
  String defaultAddress = "";
  String unitId = "";
  String takePhone = "";
  String chooseAddress = "";
  Map showAddressInformation = new Map();

  bool isEnable = true;

  ConfirmApplyInfoModel(this.userViewModel, this.arguments) {
    this.userViewModel = userViewModel;
    number = TextEditingController();
    mobile = TextEditingController();
    type = TextEditingController();
  }

  orderAddressUpdate(info) {
    orderAddress = {
      "myAddress": info["address"],
      "unitGuid": info['unitGuid'],
      "phone": info["phone"]
    };
    notifyListeners();
  }

  void setSelectType(String value) {
    selectType = value;
    notifyListeners();
  }

  void getAddressList() async {
    EasyLoading.show();
    var map = {
      "currentPage": 1,
      "pageSize": 99,
      //"userGuid": userViewModel.unitGuid,
    };
    MineApi.getSingleton().getAddressList(map, errorCallBack: (e) {
      EasyLoading.dismiss();
    }).then((value) {
      EasyLoading.dismiss();
      if (value["code"] == 200) {
        this.addressList = value["items"];
        bool isHas = false;
        value["items"].forEach((data) {
          if (data["noDefault"] == "0") {
            isHas = true;
            defaultAddress = data["address"];
            showAddressInformation = data;
          }
        });
        if (!isHas) {
          defaultAddress = addressList.isNotEmpty ?  addressList[addressList.length - 1]['address'] : "";
          showAddressInformation =  addressList.isNotEmpty ? addressList[addressList.length - 1] : {};
        }
        notifyListeners();
      }
    });
  }

  changeNumber(value) {
    number.text = value;
    notifyListeners();
  }

  void setTakeType() async {
    var map = {
      'unitGuid': arguments["orderId"],
      "notaryState": 11,
      "takeMobile": mobile.text,
      "takeAddress": takeAddress,
      "takeStyle": takeStyle,
      "notaryNum": number.text
    };
    HomeApi.getSingleton().setTakeType(map, errorCallBack: (e) {
      isEnable = true;
      notifyListeners();
    }).then((value) {
      if (value["code"] == 200) {
        G.pushNamed(RoutePaths.UploadMaterial, arguments: {
          // "notarizationMatters": arguments["notarizationMatters"],
          "orderId": arguments["orderId"],
          // "notaryForm": number.text
        });
        isEnable = true;
        notifyListeners();
      } else {
        ToastUtil.showErrorToast(value["msg"]);
        isEnable = true;
        notifyListeners();
      }
    });
  }

  @override
  onCompleted(data) {}

  @override
  Future loadData() {
    return null;
  }
}
