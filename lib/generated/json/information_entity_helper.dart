import 'package:notarization_station_app/page/infomation/entity/information_entity.dart';

informationEntityFromJson(InformationEntity data, Map<String, dynamic> json) {
  if (json['msg'] != null) {
    data.msg = json['msg'].toString();
  }
  if (json['code'] != null) {
    data.code = json['code'] is String
        ? int.tryParse(json['code'])
        : json['code'].toInt();
  }
  if (json['page'] != null) {
    data.page = InformationPage().fromJson(json['page']);
  }
  if (json['items'] != null) {
    data.items = (json['items'] as List)
        .map((v) => InformationItem().fromJson(v))
        .toList();
  }
  return data;
}

Map<String, dynamic> informationEntityToJson(InformationEntity entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['msg'] = entity.msg;
  data['code'] = entity.code;
  data['page'] = entity.page?.toJson();
  data['items'] = entity.items?.map((v) => v.toJson())?.toList();
  return data;
}

informationPageFromJson(InformationPage data, Map<String, dynamic> json) {
  if (json['currentPage'] != null) {
    data.currentPage = json['currentPage'] is String
        ? int.tryParse(json['currentPage'])
        : json['currentPage'].toInt();
  }
  if (json['pageSize'] != null) {
    data.pageSize = json['pageSize'] is String
        ? int.tryParse(json['pageSize'])
        : json['pageSize'].toInt();
  }
  if (json['total'] != null) {
    data.total = json['total'] is String
        ? int.tryParse(json['total'])
        : json['total'].toInt();
  }
  return data;
}

Map<String, dynamic> informationPageToJson(InformationPage entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['currentPage'] = entity.currentPage;
  data['pageSize'] = entity.pageSize;
  data['total'] = entity.total;
  return data;
}

informationItemFromJson(InformationItem data, Map<String, dynamic> json) {
  if (json['unitGuid'] != null) {
    data.unitGuid = json['unitGuid'].toString();
  }
  if (json['notaryId'] != null) {
    data.notaryId = json['notaryId'].toString();
  }
  if (json['userId'] != null) {
    data.userId = json['userId'];
  }
  if (json['title'] != null) {
    data.title = json['title'].toString();
  }
  if (json['content'] != null) {
    data.content = json['content'].toString();
  }
  if (json['pictureUrl'] != null) {
    data.pictureUrl = json['pictureUrl'].toString();
  }
  if (json['browseNum'] != null) {
    data.browseNum = json['browseNum'] is String
        ? int.tryParse(json['browseNum'])
        : json['browseNum'].toInt();
  }
  if (json['deleteMark'] != null) {
    data.deleteMark = json['deleteMark'] is String
        ? int.tryParse(json['deleteMark'])
        : json['deleteMark'].toInt();
  }
  if (json['ifTop'] != null) {
    data.ifTop = json['ifTop'] is String
        ? int.tryParse(json['ifTop'])
        : json['ifTop'].toInt();
  }
  if (json['state'] != null) {
    data.state = json['state'] is String
        ? int.tryParse(json['state'])
        : json['state'].toInt();
  }
  if (json['publishTime'] != null) {
    data.publishTime = json['publishTime'].toString();
  }
  if (json['createDate'] != null) {
    data.createDate = json['createDate'].toString();
  }
  if (json['notaryName'] != null) {
    data.notaryName = json['notaryName'].toString();
  }
  return data;
}

Map<String, dynamic> informationItemToJson(InformationItem entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['unitGuid'] = entity.unitGuid;
  data['notaryId'] = entity.notaryId;
  data['userId'] = entity.userId;
  data['title'] = entity.title;
  data['content'] = entity.content;
  data['pictureUrl'] = entity.pictureUrl;
  data['browseNum'] = entity.browseNum;
  data['deleteMark'] = entity.deleteMark;
  data['ifTop'] = entity.ifTop;
  data['state'] = entity.state;
  data['publishTime'] = entity.publishTime;
  data['createDate'] = entity.createDate;
  data['notaryName'] = entity.notaryName;
  return data;
}
