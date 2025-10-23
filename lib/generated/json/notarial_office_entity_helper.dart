import 'package:notarization_station_app/page/home/entity/notarial_office_entity.dart';

notarialOfficeEntityFromJson(
    NotarialOfficeEntity data, Map<String, dynamic> json) {
  if (json['msg'] != null) {
    data.msg = json['msg'].toString();
  }
  if (json['code'] != null) {
    data.code = json['code'] is String
        ? int.tryParse(json['code'])
        : json['code'].toInt();
  }
  if (json['items'] != null) {
    data.items = (json['items'] as List)
        .map((v) => NotarialOfficeItem().fromJson(v))
        .toList();
  }
  return data;
}

Map<String, dynamic> notarialOfficeEntityToJson(NotarialOfficeEntity entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['msg'] = entity.msg;
  data['code'] = entity.code;
  data['items'] = entity.items?.map((v) => v.toJson())?.toList();
  return data;
}

notarialOfficeItemFromJson(NotarialOfficeItem data, Map<String, dynamic> json) {
  if (json['unitGuid'] != null) {
    data.unitGuid = json['unitGuid'].toString();
  }
  if (json['notarialName'] != null) {
    data.notarialName = json['notarialName'].toString();
  }
  if (json['contactNumber'] != null) {
    data.contactNumber = json['contactNumber'].toString();
  }
  if (json['address'] != null) {
    data.address = json['address'].toString();
  }
  if (json['leader'] != null) {
    data.leader = json['leader'].toString();
  }
  if (json['notaryNumber'] != null) {
    data.notaryNumber = json['notaryNumber'];
  }
  if (json['workTime'] != null) {
    data.workTime = json['workTime'];
  }
  if (json['cityCode'] != null) {
    data.cityCode = json['cityCode'];
  }
  if (json['enabledMark'] != null) {
    data.enabledMark = json['enabledMark'] is String
        ? int.tryParse(json['enabledMark'])
        : json['enabledMark'].toInt();
  }
  if (json['deleteMark'] != null) {
    data.deleteMark = json['deleteMark'] is String
        ? int.tryParse(json['deleteMark'])
        : json['deleteMark'].toInt();
  }
  if (json['createDate'] != null) {
    data.createDate = json['createDate'].toString();
  }
  if (json['description'] != null) {
    data.description = json['description'].toString();
  }
  if (json['watermark'] != null) {
    data.watermark = json['watermark'].toString();
  }
  return data;
}

Map<String, dynamic> notarialOfficeItemToJson(NotarialOfficeItem entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
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
