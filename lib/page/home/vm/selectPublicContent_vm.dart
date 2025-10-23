import 'package:amap_location_fluttify/amap_location_fluttify.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:notarization_station_app/base_framework/utils/toast_util.dart';
import 'package:notarization_station_app/base_framework/view_model/single_view_state_model.dart';
import 'package:notarization_station_app/page/home/entity/notarialData.dart';
import 'package:notarization_station_app/page/login/vm/user_view_model.dart';
import 'package:notarization_station_app/service_api/home_api.dart';
import 'package:notarization_station_app/utils/global.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../utils/common_tools.dart';

class SelectPublicContentModel extends SingleViewStateModel {
  final UserViewModel userViewModel;
  final arguments;

  SelectPublicContentModel(this.userViewModel, this.arguments);
  List notarialOfficeList = []; //公证处列表
  List<String> notarialOfficeNameList = []; //公证处名称列表
  List selectDan = [];
  List selectDuo = [];
  String selectIndex = "";
  List selectIndexDuo = [];
  Map notarialInfo;
  String purposeName;
  String adCode = '';
  String city;
  String latLng = '';

  notarialUpdate(info) {
    notarialInfo = {
      "notarialName": info["notarialName"],
      "unitGuid": info["unitGuid"]
    };
    NotaryData.notaryId = info["unitGuid"];
    notifyListeners();
  }

  @override
  onCompleted(data) {}

  @override
  Future loadData() {
    return null;
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
      Location location = await AmapLocation.instance.fetchLocation();
      wjPrint("位置信息：-----$location");
      city = "${location.province} ${location.city}";
      adCode = "${location.adCode.substring(0, 4)}00";
      latLng = "${location.latLng.longitude},${location.latLng.latitude}";
      getNotarialOfficeList();
      // getHistoryNotarial();
      notifyListeners();
    } else {
      G.showPermissionDialog(str: "访问定位权限");
    }
  }

  // getHistoryNotarial() {
  //   // Map<String, String> map = {
  //   //   //"userId":userViewModel.unitGuid
  //   // };
  //   HomeApi.getSingleton().queryHistoryOffice({}).then((res) {
  //     if (res != null && res["code"] == 200) {
  //       notarialInfo = {
  //         "notarialName": res['items']['notarialName'],
  //         "unitGuid": res['items']['notaryId']
  //       };
  //       NotaryData.notaryId = res['items']['notaryId'];
  //       print(".......$notarialInfo");
  //       notifyListeners();
  //     }
  //   });
  // }
  //
  // addHistoryNotarial() {
  //   Map<String, String> map = {
  //     "notaryId": notarialInfo['unitGuid'],
  //     //"userId":userViewModel.unitGuid,
  //   };
  //   HomeApi.getSingleton().historyNotarial(map);
  // }

  void getNotarialOfficeList() async {
    //获取公证处列表
    notarialOfficeList.clear();
    notarialOfficeNameList.clear();
    EasyLoading.show();
    var map = {"institutionType": 1, "cityCode": adCode};
    HomeApi.getSingleton().getNotarialOffice(map, errorCallBack: (e) {
      EasyLoading.dismiss();
    }).then((value) {
      setBusy(false);
      if (value["code"] == 200) {
        EasyLoading.dismiss();
        notarialOfficeList = value["items"];
        if (notarialOfficeList != null && notarialOfficeList.isNotEmpty) {
          notarialOfficeList.forEach((element) {
            notarialOfficeNameList.add(element['notarialName']);
          });
        }

        if (notarialOfficeList.length == 0) {
          ToastUtil.showNormalToast("此地区暂无公证处");
          notarialInfo = null;
        }
        notifyListeners();
      }
    });
  }

  void getNotarizationPurpose() async {
    //获取公证用途列表
    EasyLoading.show();
    HomeApi.getSingleton().getNotarizationPurpose({}, errorCallBack: (e) {
      EasyLoading.dismiss();
    }).then((value) {
      if (value["code"] == 200) {
        EasyLoading.dismiss();
        selectDan = value["items"];
      }
    });
  }
}
