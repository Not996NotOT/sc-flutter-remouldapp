import 'dart:async';

import 'package:camera/camera.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:notarization_station_app/base_framework/utils/toast_util.dart';
import 'package:notarization_station_app/base_framework/view_model/single_view_state_model.dart';
import 'package:notarization_station_app/page/home/entity/Launch_room_infor_model.dart';
import 'package:notarization_station_app/page/home/entity/financial_notarization_entity.dart';
import 'package:notarization_station_app/page/login/vm/user_view_model.dart';
import 'package:notarization_station_app/routes/router.dart';
import 'package:notarization_station_app/service_api/home_api.dart';
import 'package:notarization_station_app/socket/mqtt_client.dart';
import 'package:notarization_station_app/utils/global.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class FinancialNotarizationViewModel extends SingleViewStateModel
    with ClientCallback {
  UserViewModel userViewModel;

  FinancialNotarizationViewModel({
    this.userViewModel,
  }) {
    refreshController = RefreshController();
  }

  bool enablePullDown = true;

  bool enablePullUp = true;

  LaunchRoomInforModel orderInfor;

  RefreshController refreshController;
  List dataList = [];
  int pageNumber = 1;

  StreamSubscription<ConnectivityResult> subscription;
  Timer timer2;
  CameraController cameraController;

  /// 获取通用模版网络数据
  _loadRemoteData(bool isRefresh) {
    if (isRefresh) {
      dataList.clear();
      pageNumber = 1;
    }
    Map<String, dynamic> tempMap = new Map<String, dynamic>();
    tempMap['currentPage'] = pageNumber;
    tempMap['pageSize'] = 10;
    HomeApi.getSingleton().getTaskList(tempMap, errorCallBack: (e) {
      if (isRefresh) {
        refreshController.refreshFailed();
      } else {
        pageNumber--;
        refreshController.loadFailed();
      }
    }).then((value) {
      if (value != null) {
        if (value['code'] == 200 && value["data"] != null) {
          List tempList = value["data"];
          dataList.addAll(tempList.map((e) {
            print("e--------$e");
            FinancialNotarizationEntity entity =
                FinancialNotarizationEntity.fromJson(e);
            entity.isCommon = false;
            return entity;
          }).toList());
          dataList.isEmpty ? setEmpty() : setIdle();
          if (isRefresh) {
            refreshController.refreshCompleted();
            notifyListeners();
          } else {
            if (tempList.isEmpty) {
              refreshController.loadNoData();
            } else {
              refreshController.loadComplete();
              notifyListeners();
            }
          }
        }
      } else {
        ToastUtil.showErrorToast('${value["message"]}');
      }
    }).whenComplete(() {
      if (isRefresh) {
        refreshController.refreshCompleted();
        setBusy(false);
      } else {
        refreshController.loadComplete();
      }
    });
  }

  /// 获取简易模版的数据
  _loadCommonRemoteData(bool isRefresh) {
    if (isRefresh) {
      dataList.clear();
      pageNumber = 1;
    }
    Map<String, dynamic> tempMap = new Map<String, dynamic>();
    tempMap['currentPage'] = pageNumber;
    tempMap['pageSize'] = 10;
    HomeApi.getSingleton().getCommonTaskList(tempMap, errorCallBack: (e) {
      if (isRefresh) {
        setBusy(false);
        refreshController.refreshFailed();
      } else {
        refreshController.loadFailed();
        pageNumber--;
      }
    }).then((value) {
      if (value != null) {
        if (value['code'] == 200 && value["data"] != null) {
          List tempList = value["data"];
          dataList.addAll(tempList.map((e) {
            print("e--------$e");
            FinancialNotarizationEntity entity =
                FinancialNotarizationEntity.fromJson(e);
            entity.isCommon = true;
            return entity;
          }).toList());
          dataList.isEmpty ? setEmpty() : setIdle();
          if (isRefresh) {
            refreshController.refreshCompleted();
            notifyListeners();
          } else {
            if (tempList.isEmpty) {
              refreshController.loadNoData();
            } else {
              refreshController.loadComplete();
              notifyListeners();
            }
          }
        }
      } else {
        ToastUtil.showErrorToast('${value["message"]}');
      }
    }).whenComplete(() {
      if (isRefresh) {
        refreshController.refreshCompleted();
        setBusy(false);
      } else {
        refreshController.loadComplete();
      }
    });
  }

  /// 刷新数据
  refreshData() {
    pageNumber = 1;
    dataList.clear();
    refreshController.resetNoData();
    _loadCommonRemoteData(true);
    _loadRemoteData(true);
  }

  /// 加载更多
  loadMoreData() {
    pageNumber++;
    _loadRemoteData(false);
    _loadCommonRemoteData(false);
  }

  /// 开始认证
  startAuthentication(FinancialNotarizationEntity entity) async {
    if (entity == null) {
      return;
    }
    if(!await Permission.camera.status.isGranted || !await Permission.speech.status.isGranted || !await Permission.storage.status.isGranted){
      G.showCustomToast(
          context: G.getCurrentContext(),
          titleText: "相机、麦克风、存储权限说明：",
          subTitleText: "用于视频通话、语音录制、拍照、录像、文件存储等场景",
          time: 2
      );
    }
    if (await Permission.camera.request().isGranted &&
        await Permission.speech.request().isGranted &&
        await Permission.storage.request().isGranted) {
      if (entity.isCommon) {
        _launchCommonAuthentication(entity);
      } else {
        _launchAuthentication(entity);
      }
    } else {
      G.showPermissionDialog(str: "访问访问内部存储、语音麦克风、相机、相册权限");
    }
  }

  // 发起公证
  _launchAuthentication(FinancialNotarizationEntity entity) {
    Map temp = new Map();
    temp['unitGuid'] = entity.unitGuid;
    EasyLoading.show();
    HomeApi.getSingleton().launchNotarization(temp).then((value) async {
      EasyLoading.dismiss();
      if (value != null) {
        if (value['code'] != 200) {
          return ToastUtil.showErrorToast('${value['data']}');
        }
        if (value["code"] == 200 &&
            value['data'] != null &&
            value['data']['roomId'] != null) {
          orderInfor = LaunchRoomInforModel.fromJson(value['data']);
          orderInfor.unitGuid = entity.unitGuid;
          MqttClientMsg.instance
              .subscribe("/topic/commonBank/${userViewModel.idCard}");
          G.pushNamed(RoutePaths.receptionRoom, arguments: {
            'orderInfor': orderInfor,
            'isCommon': entity.isCommon
          });
        }
      } else {
        ToastUtil.showWarningToast("请求失败，稍后再试！");
      }
    });
  }

  // 简易模版发起公证
  _launchCommonAuthentication(FinancialNotarizationEntity entity) {
    Map temp = new Map();
    temp['unitGuid'] = entity.unitGuid;
    EasyLoading.show();
    HomeApi.getSingleton().launchCommonNotarization(temp).then((value) async {
      EasyLoading.dismiss();
      if (value != null) {
        if (value['code'] != 200) {
          return ToastUtil.showErrorToast('${value['data']}');
        }
        if (value["code"] == 200 &&
            value['data'] != null &&
            value['data']['notaryId'] != null) {
          orderInfor = LaunchRoomInforModel.fromJson(value['data']);
          orderInfor.unitGuid = entity.unitGuid;
          MqttClientMsg.instance
              .subscribe("/topic/commonBank/${userViewModel.idCard}");
          G.pushNamed(RoutePaths.receptionRoom, arguments: {
            'orderInfor': orderInfor,
            'isCommon': entity.isCommon
          });
        }
      } else {
        ToastUtil.showWarningToast("请求失败，稍后再试！");
      }
    });
  }

  @override
  onCompleted(data) {}

  @override
  Future loadData() {
    // TODO: implement loadData
    MqttClientMsg.instance.setCallback(this);
    setBusy(true);
    refreshData();
    return null;
  }

  @override
  void clientDataHandler(onData, topic) async {
    print('MQTT的消息...$onData....$topic');
  }
}
