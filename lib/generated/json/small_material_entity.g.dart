import 'package:notarization_station_app/generated/json/base/json_convert_content.dart';
import 'package:notarization_station_app/page/home/entity/small_material_entity.dart';

SmallMaterialEntity $SmallMaterialEntityFromJson(Map<String, dynamic> json) {
  final SmallMaterialEntity smallMaterialEntity = SmallMaterialEntity();
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    smallMaterialEntity.name = name;
  }
  final List<SmallMaterialData>? data =
      jsonConvert.convertListNotNull<SmallMaterialData>(json['data']);
  if (data != null) {
    smallMaterialEntity.data = data;
  }
  return smallMaterialEntity;
}

Map<String, dynamic> $SmallMaterialEntityToJson(SmallMaterialEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['name'] = entity.name;
  data['data'] = entity.data.map((v) => v.toJson()).toList();
  return data;
}

SmallMaterialData $SmallMaterialDataFromJson(Map<String, dynamic> json) {
  final SmallMaterialData smallMaterialData = SmallMaterialData();
  final String? annexId = jsonConvert.convert<String>(json['annexId']);
  if (annexId != null) {
    smallMaterialData.annexId = annexId;
  }
  final String? imgPath = jsonConvert.convert<String>(json['imgPath']);
  if (imgPath != null) {
    smallMaterialData.imgPath = imgPath;
  }
  final String? materialName =
      jsonConvert.convert<String>(json['materialName']);
  if (materialName != null) {
    smallMaterialData.materialName = materialName;
  }
  return smallMaterialData;
}

Map<String, dynamic> $SmallMaterialDataToJson(SmallMaterialData entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['annexId'] = entity.annexId;
  data['imgPath'] = entity.imgPath;
  data['materialName'] = entity.materialName;
  return data;
}
