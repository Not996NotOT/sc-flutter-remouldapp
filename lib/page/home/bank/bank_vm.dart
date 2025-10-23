import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:notarization_station_app/base_framework/utils/toast_util.dart';
import 'package:notarization_station_app/base_framework/view_model/single_view_state_model.dart';
import 'package:notarization_station_app/config.dart';
import 'package:notarization_station_app/page/login/vm/user_view_model.dart';
import 'package:notarization_station_app/routes/router.dart';
import 'package:notarization_station_app/service_api/home_api.dart';
import 'package:notarization_station_app/service_api/mine_api.dart';
import 'package:notarization_station_app/socket/mqtt_client.dart';
import 'package:notarization_station_app/utils/global.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class BankModel extends SingleViewStateModel {
  final UserViewModel userViewModel;
  List searchList = [];
  TextEditingController searchController;
  int pageNum = 1;
  int pageSize = 10;
  RefreshController refreshController;

  BankModel(this.userViewModel) {
    refreshController = RefreshController();
  }

  @override
  Future loadData() async {
    searchList.clear();
    var map = {
      "currentPage": pageNum,
      "pageSize": pageSize,
      "idCard": userViewModel.idCard,
      "notaryState": 30
    };
    var data = await HomeApi().getBank(map);
    print(".........$data");
    if (data['items'].length != 0) {
      return Future.value(data);
    } else {
      return null;
    }
  }

  refresh() async {
    pageNum = 1;
    refreshController.resetNoData();
    var map = {
      "currentPage": pageNum,
      "pageSize": pageSize,
      "idCard": userViewModel.idCard,
      "notaryState": 30
    };
    HomeApi().getBank(map, errorCallBack: (e) {
      refreshController.refreshFailed();
      setBusy(false);
    }).then((value) {
      searchList.clear();
      onCompleted(value);
      refreshController.refreshCompleted();
      notifyListeners();
    }).whenComplete(() {
      refreshController.refreshCompleted();
      setBusy(false);
    });
  }

  loadMore() async {
    pageNum += 1;
    var map = {
      "currentPage": pageNum,
      "pageSize": pageSize,
      "idCard": userViewModel.idCard,
      "notaryState": 30
    };
    HomeApi().getBank(map, errorCallBack: (e) {
      refreshController.loadFailed();
      pageNum--;
    }).then((value) {
      if (value['items'].isEmpty) {
        refreshController.loadNoData();
      } else {
        onCompleted(value);
        refreshController.loadComplete();
        notifyListeners();
      }
    });
  }

  getData(info) async {
    var map = {
      "unitGuid": info['unitGuid'],
    };
    EasyLoading.show(status: "正在安排公证员，请耐心等待...");
    HomeApi.getSingleton().getSmallDetail(map).then((res) {
      if (res["code"] == 200 && res['item']['notaryState'] == 30) {
        Map<String, Object> map = {"channelName": info["roomId"]};
        MineApi.getSingleton().getToken(map).then((data) {
          EasyLoading.dismiss();
          if (res["code"] == 200) {
            Config.aPPId = data['appId'];
            Config.token = data['token'];
            print("...111...${res['item']}");
            MqttClientMsg.instance
                .subscribe("/topic/bankXW/${info['orderId']}");
            G.getCurrentState().pushReplacementNamed(RoutePaths.BankIng,
                arguments: {
                  "info": res['item'],
                  "roomId": info['roomId'],
                  "isBank": true
                });
          }
        });
      } else {
        ToastUtil.showWarningToast("公证员暂无空闲");
        EasyLoading.dismiss();
      }
    });
  }

  @override
  onCompleted(data) {
    if (data['items'] == null || data['items'].length == 0) {
      setEmpty();
    } else {
      searchList.addAll(data["items"]);
    }
  }
}
