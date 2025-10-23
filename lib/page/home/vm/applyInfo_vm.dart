import 'package:amap_location_fluttify/amap_location_fluttify.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:notarization_station_app/base_framework/utils/toast_util.dart';
import 'package:notarization_station_app/base_framework/view_model/single_view_state_model.dart';
import 'package:notarization_station_app/page/login/vm/user_view_model.dart';
import 'package:notarization_station_app/routes/router.dart';
import 'package:notarization_station_app/service_api/home_api.dart';
import 'package:notarization_station_app/utils/global.dart';
import 'package:permission_handler/permission_handler.dart';

class ApplyInfoModel extends SingleViewStateModel {
  final arguments;
  UserViewModel userViewModel;
  String selectSex;

  ApplyInfoModel(this.userViewModel, this.arguments) {
    this.userViewModel = userViewModel;
    selectSex = userViewModel.gender == 1 ? "男" : "女";
//    textContentOne = TextEditingController();
    textContentApply.add(TextEditingController());
    textContentMobile.add(TextEditingController());
    textContentIdCard.add(TextEditingController());
    textContentAddress.add(TextEditingController());
  }

  String selectLanguage;
  String selectCity;
  List countryList = [];
  List<String> countryNameList = []; //国家名称
  List languageList = [];
  List<String> languageNameList = []; //语言名称
  List notarizationMattersList = [];
  Map notarialInfo;
  Map notarialInfoLan;
  String toDay;
  List notaryItems = [];
  String orderId;
//  String  selectSex = "男";
  List<TextEditingController> textContentApply = []; //申请人
  List<TextEditingController> textContentMobile = []; //手机号码
  List<TextEditingController> textContentIdCard = []; //身份证号码
  List<TextEditingController> textContentAddress = []; //家庭住址
  String selectGender = "男";
  List selectGenderList = ["男"];
  List applyList = []; //申请人列表
  String birthday = "";
  List birthdayList = [""];
  List applyAgentList = []; //代理人列表
  List applyAllList = []; //选择是提交的列表

  // 下一步按钮状态控制
  bool isEnable = true;
  Location location;
  /// 获取当前ip信息
  String ipAddress = '';

  String latLng = '';

  void setSelectLanguage(String value) {
    selectLanguage = value;
    notifyListeners();
  }

  void setSelectGender(String value) {
    selectGender = value;
    notifyListeners();
  }

  void setSelectCity(String value) {
    selectCity = value;
    notifyListeners();
  }

  void setSelectSex(String value) {
    selectSex = value;
    notifyListeners();
  }

  notarialUpdate(info) {
    notarialInfo = {"notarialName": info["zh"], "unitGuid": info['unitGuid']};
    notifyListeners();
  }

  notarialUpdateLan(info) {
    notarialInfoLan = {
      "notarialLanguage": info["name"],
      "unitGuid": info['unitGuid']
    };
    notifyListeners();
  }

  void notify() {
    notifyListeners();
  }

  void getCountryList() async {
    countryList.clear();
    countryNameList.clear();
    EasyLoading.show();
    HomeApi.getSingleton().getCountryArea({}, errorCallBack: (e) {
      EasyLoading.dismiss();
    }).then((value) {
      setBusy(false);
      EasyLoading.dismiss();
      if (value["code"] == 200) {
        this.countryList = value["items"];
        if (countryList != null && countryList.isNotEmpty) {
          countryList.forEach((element) {
            countryNameList.add(element['zh']);
          });
        }
        this.selectCity = this.countryList[0]["unitGuid"];
        notifyListeners();
      }
    });
  }

  void getLanguageList() async {
    EasyLoading.show();
    languageList.clear();
    languageNameList.clear();
    HomeApi.getSingleton().getCountryLanguage({}, errorCallBack: (e) {
      EasyLoading.dismiss();
    }).then((value) {
      setBusy(false);
      EasyLoading.dismiss();
      if (value["code"] == 200) {
        this.languageList = value["items"];
        if (languageList != null && languageList.isNotEmpty) {
          languageList.forEach((element) {
            languageNameList.add(element['name']);
          });
        }
        this.selectLanguage = this.languageList[0]["unitGuid"];
        notifyListeners();
      }
    });
  }

  getLocation() async {
    if(!await Permission.location.status.isGranted){
      G.showCustomToast(
          context: G.getCurrentContext(),
          titleText: "定位权限使用说明：",
          subTitleText: "用于获取当前位置信息",
          time: 2
      );
    }
    if (await Permission.location.request().isGranted) {
      location = await AmapLocation.instance.fetchLocation();
      print("高德的位置信息：-----$location");
      if (location.latLng.longitude != null && location.latLng.longitude != 0.0 &&
          location.latLng.latitude != null && location.latLng.latitude != 0.0) {
        latLng = "${location.latLng.longitude},${location.latLng.latitude}";
      } else {
        ipAddress = await G.getDeviceIPAddress();
      }
    } else {
      ipAddress = await G.getDeviceIPAddress();
      G.showPermissionDialog(str: "访问定位权限");
    }
  }

  void addAutoHelpList() async {
    //否
    List itemList = [];
    notaryItems.forEach((element) {
      itemList.add({
        "notaryItemId": element["unitGuid"],
        "price": element["price"],
        "notaryItemName": element["name"],
        "notaryNum": 1,
        "orderId": ""
      });
    });

    var map = {
      // "userId":userViewModel.unitGuid,
      "name": userViewModel.userName,
      "useArea": notarialInfo["notarialName"],
      "useLanguage": notarialInfoLan["notarialLanguage"],
      "purposeName": arguments["purposeName"],
      "notaryId": arguments["notarialName"]["unitGuid"],
      "isDaiBan": 0,
      "notaryForm": 1,
      "terminalType": 1,
      "description": "",
      "notaryitems": JsonUtil.encodeObj(itemList),
      "applyUsers": JsonUtil.encodeObj([
        {
          "name": userViewModel.userName,
          "relationShip": "",
          "mobile": userViewModel.mobile,
          "idCard": userViewModel.idCard,
          "birthday": userViewModel.birthday,
          "gender": userViewModel.gender,
          "address": userViewModel.address,
          "orderId": ""
        }
      ]),
      "videolog":
          JsonUtil.encodeObj({"planDate": this.toDay, "videoDate": this.toDay}),
    };
    print('dayinshangchuandecanshu-----$map');
    HomeApi.getSingleton().addAutoHelpList(map, errorCallBack: (e) {
      isEnable = true;
      notifyListeners();
    }).then((value) {
      isEnable = true;
      notifyListeners();
      if (value["code"] == 200) {
        this.orderId = value["unitGuid"];
        G.pushNamed(
          RoutePaths.ConfirmApplyInfo,
          arguments: {
            "orderId": orderId,
            "mobile": userViewModel.mobile,
            "address": userViewModel.address,
            "notarizationMatters": notarizationMattersList,
            "isAgent": arguments["isAgent"]
          },
        );
        G.uploadOrderLocation({
          'busiId':this.orderId,
          'busiType': 1,
          "idCard":userViewModel.idCard,
          'ip': ipAddress,
          "longitude":latLng.isEmpty?'':latLng.split(',')[0],
          "latitude":latLng.isEmpty?'':latLng.split(',')[1]
        });
      } else {
        ToastUtil.showErrorToast(value["msg"]);
      }
    });
  }

  void addAgentAutoHelpList() async {
    EasyLoading.show();
    //是
    List itemList = [];
    notaryItems.forEach((element) {
      itemList.add({
        "notaryItemId": element["unitGuid"],
        "price": element["price"],
        "notaryItemName": element["name"],
        "notaryNum": 1,
        "orderId": ""
      });
    });

    var map = {
      //"userId":userViewModel.unitGuid,
      "name": userViewModel.userName,
      "useArea": notarialInfo["notarialName"],
      "useLanguage": notarialInfoLan["notarialLanguage"],
      "purposeName": arguments["purposeName"],
      "notaryId": arguments["notarialName"]["unitGuid"],
      "isDaiBan": 1,
      "notaryForm": 1,
      "terminalType": 1,
      "description": "",
      "notaryitems": JsonUtil.encodeObj(itemList),
      "applyUsers": JsonUtil.encodeObj(applyAllList),
      "videolog":
          JsonUtil.encodeObj({"planDate": this.toDay, "videoDate": this.toDay}),
    };
    HomeApi.getSingleton().addAutoHelpList(map, errorCallBack: (e) {
      EasyLoading.dismiss();
      isEnable = true;
      notifyListeners();
    }).then((value) {
      EasyLoading.dismiss();
      isEnable = true;
      notifyListeners();
      if (value["code"] == 200) {
        this.orderId = value["unitGuid"];
        G.pushNamed(
          RoutePaths.ConfirmApplyInfo,
          arguments: {
            "orderId": orderId,
            // "mobile": userViewModel.mobile,
            // "address": userViewModel.address,
            // "notarizationMatters": notarizationMattersList,
            // "isAgent": arguments["isAgent"],
            // "applyList": applyList
          },
        );
        G.uploadOrderLocation({
          'busiId':this.orderId,
          'busiType': 1,
          "idCard":userViewModel.idCard,
          'ip':ipAddress,
          "longitude":latLng.isEmpty?'':latLng.split(',')[0],
          "latitude":latLng.isEmpty?'':latLng.split(',')[1]
        });
      } else {
        ToastUtil.showErrorToast(value["msg"]);
      }
    });
  }

  @override
  onCompleted(data) {}

  @override
  Future loadData() {
    this.notarizationMattersList = arguments["selectDuo"];
    DateTime now = new DateTime.now();
    this.toDay = "${now.year}-${now.month}-${now.day}";
    getLocation();
    this.notarizationMattersList.forEach((item) {
      this.notaryItems.add(item);
    });
    return null;
  }
}
