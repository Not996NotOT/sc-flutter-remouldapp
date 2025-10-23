import 'dart:async';

import 'package:notarization_station_app/base_framework/view_model/single_view_state_model.dart';
import 'package:notarization_station_app/generated/json/select_room_history_model.dart';
import 'package:notarization_station_app/page/login/vm/user_view_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SelectRoomHistoryViewModel extends SingleViewStateModel {
  UserViewModel userViewModel;

  SelectRoomHistoryViewModel({this.userViewModel});

  List<SelectRoomHistoryModel> dataList = [];

  RefreshController controller = RefreshController();

  @override
  Future loadData() {
    // TODO: implement loadData
    throw UnimplementedError();
  }

  @override
  onCompleted(data) {
    // TODO: implement onCompleted
    throw UnimplementedError();
  }

  // 立即确认
  confirmNow() {}

  // 刷新数据
  refreshData() {}

  // 加载更多
  loadMoreData() {}

  // 时间转化
  List<String> _durationTransform(int index) {
    SelectRoomHistoryModel model = dataList[index];
    Timer(Duration(seconds: 1), () {
      model.time--;
      var d = Duration(seconds: model.time);
      List<String> parts = d.toString().split(":");
      model.minute = parts[1];
      model.seconds = parts[0];
      notifyListeners();
    });
  }
}
