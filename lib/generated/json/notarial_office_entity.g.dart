import 'package:notarization_station_app/generated/json/base/json_convert_content.dart';
import 'package:notarization_station_app/page/home/entity/notarial_office_entity.dart';

NotarialOfficeEntity $NotarialOfficeEntityFromJson(Map<String, dynamic> json) {
  final NotarialOfficeEntity notarialOfficeEntity = NotarialOfficeEntity();
  final String? msg = jsonConvert.convert<String>(json['msg']);
  if (msg != null) {
    notarialOfficeEntity.msg = msg;
  }
  final int? code = jsonConvert.convert<int>(json['code']);
  if (code != null) {
    notarialOfficeEntity.code = code;
  }
  final List<NotarialOfficeItem>? items =
      jsonConvert.convertListNotNull<NotarialOfficeItem>(json['items']);
  if (items != null) {
    notarialOfficeEntity.items = items;
  }
  return notarialOfficeEntity;
}

Map<String, dynamic> $NotarialOfficeEntityToJson(NotarialOfficeEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['msg'] = entity.msg;
  data['code'] = entity.code;
  data['items'] = entity.items.map((v) => v.toJson()).toList();
  return data;
}

NotarialOfficeItem $NotarialOfficeItemFromJson(Map<String, dynamic> json) {
  final NotarialOfficeItem notarialOfficeItem = NotarialOfficeItem();
  final String? unitGuid = jsonConvert.convert<String>(json['unitGuid']);
  if (unitGuid != null) {
    notarialOfficeItem.unitGuid = unitGuid;
  }
  final String? notarialName =
      jsonConvert.convert<String>(json['notarialName']);
  if (notarialName != null) {
    notarialOfficeItem.notarialName = notarialName;
  }
  final String? contactNumber =
      jsonConvert.convert<String>(json['contactNumber']);
  if (contactNumber != null) {
    notarialOfficeItem.contactNumber = contactNumber;
  }
  final String? address = jsonConvert.convert<String>(json['address']);
  if (address != null) {
    notarialOfficeItem.address = address;
  }
  final String? leader = jsonConvert.convert<String>(json['leader']);
  if (leader != null) {
    notarialOfficeItem.leader = leader;
  }
  final dynamic? notaryNumber =
      jsonConvert.convert<dynamic>(json['notaryNumber']);
  if (notaryNumber != null) {
    notarialOfficeItem.notaryNumber = notaryNumber;
  }
  final dynamic? workTime = jsonConvert.convert<dynamic>(json['workTime']);
  if (workTime != null) {
    notarialOfficeItem.workTime = workTime;
  }
  final dynamic? cityCode = jsonConvert.convert<dynamic>(json['cityCode']);
  if (cityCode != null) {
    notarialOfficeItem.cityCode = cityCode;
  }
  final int? enabledMark = jsonConvert.convert<int>(json['enabledMark']);
  if (enabledMark != null) {
    notarialOfficeItem.enabledMark = enabledMark;
  }
  final int? deleteMark = jsonConvert.convert<int>(json['deleteMark']);
  if (deleteMark != null) {
    notarialOfficeItem.deleteMark = deleteMark;
  }
  final String? createDate = jsonConvert.convert<String>(json['createDate']);
  if (createDate != null) {
    notarialOfficeItem.createDate = createDate;
  }
  final String? description = jsonConvert.convert<String>(json['description']);
  if (description != null) {
    notarialOfficeItem.description = description;
  }
  final String? watermark = jsonConvert.convert<String>(json['watermark']);
  if (watermark != null) {
    notarialOfficeItem.watermark = watermark;
  }
  return notarialOfficeItem;
}

Map<String, dynamic> $NotarialOfficeItemToJson(NotarialOfficeItem entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['unitGuid'] = entity.unitGuid;
  data['notarialName'] = entity.notarialName;
  data['contactNumber'] = entity.contactNumber;
  data['address'] = entity.address;
  data['leader'] = entity.leader;
  data['notaryNumber'] = entity.notaryNumber;
  data['workTime'] = entity.workTime;
  data['cityCode'] = entity.cityCode;
  data['enabledMark'] = entity.enabledMark;
  data['deleteMark'] = entity.deleteMark;
  data['createDate'] = entity.createDate;
  data['description'] = entity.description;
  data['watermark'] = entity.watermark;
  return data;
}
