import 'package:notarization_station_app/page/home/entity/widget_map_entity.dart';

widgetMapEntityFromJson(WidgetMapEntity data, Map<String, dynamic> json) {
  if (json['userId'] != null) {
    data.userId = json['userId'].toString();
  }
  if (json['widget'] != null) {
    data.widget = json['widget'];
  }
  return data;
}

Map<String, dynamic> widgetMapEntityToJson(WidgetMapEntity entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['userId'] = entity.userId;
  data['widget'] = entity.widget;
  return data;
}
