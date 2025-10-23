import 'package:notarization_station_app/page/home/entity/small_material_entity.dart';

smallMaterialEntityFromJson(
    SmallMaterialEntity data, Map<String, dynamic> json) {
  if (json['name'] != null) {
    data.name = json['name'].toString();
  }
  if (json['data'] != null) {
    data.data = (json['data'] as List)
        .map((v) => SmallMaterialData().fromJson(v))
        .toList();
  }
  return data;
}

Map<String, dynamic> smallMaterialEntityToJson(SmallMaterialEntity entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['name'] = entity.name;
  data['data'] = entity.data?.map((v) => v.toJson())?.toList();
  return data;
}

smallMaterialDataFromJson(SmallMaterialData data, Map<String, dynamic> json) {
  if (json['annexId'] != null) {
    data.annexId = json['annexId'].toString();
  }
  if (json['imgPath'] != null) {
    data.imgPath = json['imgPath'].toString();
  }
  if (json['materialName'] != null) {
    data.materialName = json['materialName'].toString();
  }
  return data;
}

Map<String, dynamic> smallMaterialDataToJson(SmallMaterialData entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['annexId'] = entity.annexId;
  data['imgPath'] = entity.imgPath;
  data['materialName'] = entity.materialName;
  return data;
}
