/*
 * @Author: 王士博 wangshibo@gc.com
 * @Date: 2023-04-25 20:18:40
 * @LastEditors: 王士博 wangshibo@gc.com
 * @LastEditTime: 2023-04-27 10:37:23
 * @FilePath: /sc-flutter-remouldapp/remouldApp/lib/page/infomation/vm/information_vm.dart
 * @Description: 
 * 
 * Copyright (c) 2023 by ${git_name_email}, All Rights Reserved. 
 */
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:notarization_station_app/base_framework/view_model/single_view_state_model.dart';
import 'package:notarization_station_app/generated/json/base/json_convert_content.dart';
import 'package:notarization_station_app/page/infomation/entity/information_entity.dart';
import 'package:notarization_station_app/service_api/home_api.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../utils/common_tools.dart';

class InformationViewModel extends SingleViewStateModel<InformationEntity> {
  List<InformationItem> infoList = [];
  RefreshController refreshController;
  int pageNum = 1;
  int pageSize = 10;

  InformationViewModel() {
    refreshController = RefreshController();
  }

  @override
  onCompleted(data) {
    wjPrint("${data.items.length}22222222222222");
    if (data.items == null || data.items.length == 0) {
      setEmpty();
    } else {
      infoList.addAll(data.items);
    }
  }

  refresh() async {
    wjPrint("刷新---------------------");
    EasyLoading.show();
    pageNum = 1;
    infoList.clear();
    var map = {
      "currentPage": pageNum,
      "pageSize": pageSize,
    };
    HomeApi.getSingleton().getAllInfoList(map, errorCallBack: (e) {
      EasyLoading.dismiss();
      refreshController.refreshFailed();
    }).then((value) {
      EasyLoading.dismiss();
      InformationEntity info = JsonConvert.fromJsonAsT(value);
      if (info.code == 200) {
        onCompleted(info);
        refreshController.refreshCompleted();
        notifyListeners();
      }
    }).whenComplete(() {
      refreshController.refreshCompleted();
      setBusy(false);
    });
  }

  loadMore() async {
    pageNum += 1;
    var map = {
      "currentPage": pageNum.toString(),
      "pageSize": pageSize,
    };
    HomeApi.getSingleton().getAllInfoList(map, errorCallBack: (e) {
      refreshController.loadFailed();
      pageNum -= 1;
    }).then((value) {
      InformationEntity info = JsonConvert.fromJsonAsT(value);
      if (info.code == 200) {
        if (info.items.isEmpty) {
          refreshController.loadNoData();
        } else {
          onCompleted(info);
          refreshController.loadComplete();
          notifyListeners();
        }
      }
    });
  }

  @override
  Future<InformationEntity> loadData() {
    infoList.clear();
    var map = {"currentPage": 1, "pageSize": 99999};
    HomeApi.getSingleton().getAllInfoList(map).then((value) {
      InformationEntity info = JsonConvert.fromJsonAsT(value);
      wjPrint("${info.page.total}111111");
      if (info.page.total == 0) {
        return null;
      } else {
        return Future.value(info);
      }
    });
  }
}
