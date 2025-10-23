import 'package:notarization_station_app/generated/json/base/json_convert_content.dart';
import 'package:notarization_station_app/page/home/entity/widget_map_entity.dart';

WidgetMapEntity $WidgetMapEntityFromJson(Map<String, dynamic> json) {
  final WidgetMapEntity widgetMapEntity = WidgetMapEntity();
  final String? userId = jsonConvert.convert<String>(json['userId']);
  if (userId != null) {
    widgetMapEntity.userId = userId;
  }
  final dynamic? widget = jsonConvert.convert<dynamic>(json['widget']);
  if (widget != null) {
    widgetMapEntity.widget = widget;
  }
  return widgetMapEntity;
}

Map<String, dynamic> $WidgetMapEntityToJson(WidgetMapEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['userId'] = entity.userId;
  data['widget'] = entity.widget;
  return data;
}
