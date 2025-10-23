import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:notarization_station_app/base_framework/utils/toast_util.dart';
import 'package:notarization_station_app/base_framework/view_model/single_view_state_model.dart';
import 'package:notarization_station_app/generated/json/base/json_convert_content.dart';
import 'package:notarization_station_app/page/login/entity/userInfo.dart';
import 'package:notarization_station_app/page/mine/entity/address_entity.dart';
import 'package:notarization_station_app/service_api/mine_api.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../utils/common_tools.dart';

class AddressViewModel extends SingleViewStateModel<AddressEntity> {
  int pageNum = 1;
  int pageSize = 10;
  RefreshController refreshController;
  List<AddressItem> infoList = [];
  UserInfoEntity userEntity;

  AddressViewModel(UserInfoEntity userEntity) {
    this.userEntity = userEntity;
    refreshController = RefreshController();
  }

  @override
  Future<AddressEntity> loadData() async {
    infoList.clear();
    var map = {
      "currentPage": pageNum,
      "pageSize": pageSize,
      //"userGuid": userEntity.items.user.unitGuid,
    };
    var data = await MineApi.getSingleton().getAddressList(map);
    AddressEntity entity = JsonConvert.fromJsonAsT(data);
    return Future.value(entity);
  }

  refresh() async {
    infoList.clear();
    pageNum = 1;
    refreshController.resetNoData();
    var map = {
      "currentPage": pageNum,
      "pageSize": pageSize,
      //"userGuid": userEntity.items.user.unitGuid,
    };
    MineApi.getSingleton().getAddressList(map, errorCallBack: (e) {
      refreshController.refreshFailed();
    }).then((value) {
      AddressEntity entity = JsonConvert.fromJsonAsT(value);
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
      //"userGuid": userEntity.items.user.unitGuid,
    };
    MineApi.getSingleton().getAddressList(map, errorCallBack: (e) {
      refreshController.loadFailed();
      pageNum -= 1;
    }).then((value) {
      AddressEntity entity = JsonConvert.fromJsonAsT(value);
      if (entity.items.isEmpty) {
        refreshController.loadNoData();
      } else {
        onCompleted(entity);
        refreshController.loadComplete();
        notifyListeners();
      }
    });
  }

  delAddress(String id, int index) {
    var map = {
      "unitGuid": id,
    };
    MineApi.getSingleton().delAddress(map, errorCallBack: (e) {}).then((value) {
      AddressEntity entity = JsonConvert.fromJsonAsT(value);
      if (entity.code == 200) {
        infoList.removeAt(index);
        notifyListeners();
      }
    });
  }

  void editAddress(AddressItem item) {
    var addData = {
      "unitGuid": item.unitGuid,
      //"userGuid": userEntity.unitGuid,
      "address": item.address,
      "receivingUsername": item.receivingUsername,
      "phone": item.phone,
      "noDefault": item.noDefault,
    };
    EasyLoading.show(status: "修改地址");
    wjPrint(addData);
    MineApi.getSingleton().updateAddress(addData, errorCallBack: (e) {
      EasyLoading.dismiss();
    }).then((value) {
      EasyLoading.dismiss();
      if (value['code'] == 200) {
        refresh();
      } else {
        ToastUtil.showErrorToast("修改失败！");
      }
    });
  }

  @override
  onCompleted(data) {
    if (data.items == null || data.items.length == 0) {
      setEmpty();
    } else {
      infoList.addAll(data.items);
    }
  }
}
