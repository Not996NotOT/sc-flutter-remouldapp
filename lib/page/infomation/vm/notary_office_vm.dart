import 'package:amap_location_fluttify/amap_location_fluttify.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:notarization_station_app/base_framework/view_model/single_view_state_model.dart';
import 'package:notarization_station_app/page/login/vm/user_view_model.dart';
import 'package:notarization_station_app/service_api/home_api.dart';
import 'package:notarization_station_app/service_api/infomation_api.dart';
import 'package:notarization_station_app/utils/global.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../utils/common_tools.dart';

class NotaryOfficeModel extends SingleViewStateModel {
  UserViewModel userModel;
  NotaryOfficeModel(this.userModel);
  RefreshController refreshController = RefreshController();
  int currentPage = 1;
  int pageSize = 10;
  List notaryList = [];
  List treeList = [];
  String isOnTap = "";
  bool isShow = false;

  getTree() async {
    var res = await HomeApi.getSingleton()
        .getNotarizationPurpose({}, errorCallBack: (e) {});
    if (res['code'] == 200) {
      treeList = res['items'];
      notifyListeners();
    }
  }

  getNotaryOffice() async {
    if(!await Permission.location.status.isGranted){
      G.showCustomToast(
        context: G.getCurrentState().overlay.context,
        titleText: "定位权限使用说明：",
        subTitleText: "用于获取当前位置信息",
        time: 2,);
    }
    final status = await Permission.location.request();
    if (status == PermissionStatus.granted) {
      Location location = await AmapLocation.instance.fetchLocation();
      wjPrint("位置信息：-----$location");
      Map<String, dynamic> map = {
        "institutionType": "1",
        "currentPage": currentPage,
        "pageSize": 10,
        "distance": "${location.latLng.longitude},${location.latLng.latitude}",
      };
      EasyLoading.show();
      var res = await InformationApi.getSingleton().getNotarial(map,
          errorCallBack: (e) {
        EasyLoading.dismiss();
      });
      EasyLoading.dismiss();
      if (res['code'] == 200) {
        if (res['items'] != null) {
          notaryList = res['items'];
          notifyListeners();
        }
      }
    } else {
      G.showPermissionDialog(str: '访问定位权限');
    }
  }

  refresh() async {
    currentPage = 1;
    refreshController.resetNoData();
    if(!await Permission.location.status.isGranted){
      G.showCustomToast(
        context: G.getCurrentState().overlay.context,
        titleText: "定位权限使用说明：",
        subTitleText: "用于获取当前位置信息",
        time: 2,);
    }
    final status = await Permission.location.request();
    if (status == PermissionStatus.granted) {
      Location location = await AmapLocation.instance.fetchLocation();
      wjPrint("位置信息：-----${location.latLng.latitude}");
      Map<String, dynamic> map = {
        "institutionType": "1",
        "currentPage": currentPage,
        "pageSize": 10,
        "distance": "${location.latLng.longitude},${location.latLng.latitude}",
      };
      EasyLoading.show();
      InformationApi.getSingleton().getNotarial(map, errorCallBack: (e) {
        EasyLoading.dismiss();
        refreshController.refreshFailed();
        setBusy(false);
      }).then((res) {
        EasyLoading.dismiss();
        notaryList.clear();
        isOnTap = "";
        if (res['code'] == 200) {
          if (res['items'] != null) {
            notaryList = res['items'];
            notifyListeners();
            refreshController.refreshCompleted();
          } else {
            notaryList = [];
            refreshController.refreshCompleted();
            notifyListeners();
          }
        } else {
          refreshController.refreshFailed();
        }
      }).whenComplete(() {
        refreshController.refreshCompleted();
        setBusy(false);
      });
    } else {
      G.showPermissionDialog(str: '访问定位权限');
    }
  }

  loadMore() async {
    currentPage += 1;
    if(!await Permission.location.status.isGranted){
      G.showCustomToast(
        context: G.getCurrentState().overlay.context,
        titleText: "定位权限使用说明：",
        subTitleText: "用于获取当前位置信息",
        time: 2,);
    }
    final status = await Permission.location.request();
    if (status == PermissionStatus.granted) {
      Location location = await AmapLocation.instance.fetchLocation();
      wjPrint("位置信息：-----${location.latLng.latitude}");
      Map<String, dynamic> map = {
        "institutionType": "1",
        "currentPage": currentPage,
        "pageSize": 10,
        "distance": "${location.latLng.longitude},${location.latLng.latitude}",
      };

      InformationApi.getSingleton().getNotarial(map, errorCallBack: (e) {
        currentPage--;
        refreshController.loadFailed();
      }).then((res) {
        if (res['code'] == 200) {
          if (res["items"].isEmpty) {
            refreshController.loadNoData();
          } else {
            notaryList.addAll(res['items']);
            refreshController.loadComplete();
            notifyListeners();
          }
        } else {
          currentPage--;
          refreshController.loadFailed();
        }
      });
    } else {
      G.showPermissionDialog(str: '访问定位权限');
    }
  }

  @override
  onCompleted(data) {}

  @override
  Future loadData() {
    return null;
  }
}
