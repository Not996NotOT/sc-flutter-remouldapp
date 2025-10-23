/*
 * @Author: 王士博 wangshibo@gc.com
 * @Date: 2023-02-27 17:48:10
 * @LastEditors: 王士博 wangshibo@gc.com
 * @LastEditTime: 2023-04-27 10:42:08
 * @FilePath: /sc-flutter-remouldapp/remouldApp/lib/page/home/small/small_money_vm.dart
 * @Description: 
 * 
 * Copyright (c) 2023 by ${git_name_email}, All Rights Reserved. 
 */
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:notarization_station_app/base_framework/view_model/single_view_state_model.dart';
import 'package:notarization_station_app/generated/json/base/json_convert_content.dart';
import 'package:notarization_station_app/page/home/entity/small_list_entity.dart';
import 'package:notarization_station_app/page/login/vm/user_view_model.dart';
import 'package:notarization_station_app/service_api/home_api.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SmallMoneyModel extends SingleViewStateModel<SmallListEntity> {
  final UserViewModel userViewModel;
  List<SmallListItems> searchList = [];
  TextEditingController searchController;
  int pageNum = 1;
  int pageSize = 10;
  RefreshController refreshController;

  SmallMoneyModel(this.userViewModel) {
    searchController = new TextEditingController();
    refreshController = RefreshController();
  }

  @override
  Future<SmallListEntity> loadData() async {
    searchList.clear();
    var map = {
      "currentPage": pageNum,
      "pageSize": pageSize,
      "mobile": userViewModel.mobile,
      "verification": 1
    };
    print(".........$map");
    var data = await HomeApi.getSingleton().getContractRecord(map);
    print(".........$data");
    if (data['items'].length != 0) {
      SmallListEntity entity = JsonConvert.fromJsonAsT(data);
      return Future.value(entity);
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
      "mobile": userViewModel.mobile,
      "verification": 1
    };
    HomeApi.getSingleton().getContractRecord(map, errorCallBack: (e) {
      refreshController.refreshFailed();
      setBusy(false);
    }).then((value) {
      SmallListEntity entity = JsonConvert.fromJsonAsT(value);
      searchList.clear();
      onCompleted(entity);
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
      "mobile": userViewModel.mobile,
      "verification": 1
    };
    HomeApi.getSingleton().getContractRecord(map, errorCallBack: (e) {
      refreshController.loadFailed();
      pageNum -= 1;
    }).then((value) {
      SmallListEntity entity = JsonConvert.fromJsonAsT(value);
      if (entity.items.isEmpty) {
        refreshController.loadNoData();
      } else {
        onCompleted(entity);
        refreshController.loadComplete();
        notifyListeners();
      }
    });
  }

  @override
  onCompleted(data) {
    if (data.items == null || data.items.length == 0) {
      setEmpty();
    } else {
      searchList.addAll(data.items);
    }
  }
}
