import 'package:notarization_station_app/base_framework/view_model/single_view_state_model.dart';

import '../../../utils/common_tools.dart';

class InfoDetailPageModel extends SingleViewStateModel {
  final arguments;
  InfoDetailPageModel(this.arguments);
  Map oneData = {};
  @override
  onCompleted(data) {}

  @override
  Future loadData() {
    wjPrint("5555555555555555555555------------------------");
    wjPrint(arguments);
    wjPrint("777777");
    return null;
  }
}
