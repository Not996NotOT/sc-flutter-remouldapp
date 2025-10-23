import 'package:notarization_station_app/generated/json/base/json_convert_content.dart';

class SmallMaterialEntity with JsonConvert<SmallMaterialEntity> {
  String name;
  List<SmallMaterialData> data;
}

class SmallMaterialData with JsonConvert<SmallMaterialData> {
  String annexId;
  String imgPath;
  String materialName;
}
