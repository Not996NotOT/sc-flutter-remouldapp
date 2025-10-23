import 'package:notarization_station_app/generated/json/base/json_convert_content.dart';
import 'package:notarization_station_app/page/infomation/entity/information_entity.dart';

InformationEntity $InformationEntityFromJson(Map<String, dynamic> json) {
  final InformationEntity informationEntity = InformationEntity();
  final String? msg = jsonConvert.convert<String>(json['msg']);
  if (msg != null) {
    informationEntity.msg = msg;
  }
  final int? code = jsonConvert.convert<int>(json['code']);
  if (code != null) {
    informationEntity.code = code;
  }
  final InformationPage? page =
      jsonConvert.convert<InformationPage>(json['page']);
  if (page != null) {
    informationEntity.page = page;
  }
  final List<InformationItem>? items =
      jsonConvert.convertListNotNull<InformationItem>(json['items']);
  if (items != null) {
    informationEntity.items = items;
  }
  return informationEntity;
}

Map<String, dynamic> $InformationEntityToJson(InformationEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['msg'] = entity.msg;
  data['code'] = entity.code;
  data['page'] = entity.page.toJson();
  data['items'] = entity.items.map((v) => v.toJson()).toList();
  return data;
}

InformationPage $InformationPageFromJson(Map<String, dynamic> json) {
  final InformationPage informationPage = InformationPage();
  final int? currentPage = jsonConvert.convert<int>(json['currentPage']);
  if (currentPage != null) {
    informationPage.currentPage = currentPage;
  }
  final int? pageSize = jsonConvert.convert<int>(json['pageSize']);
  if (pageSize != null) {
    informationPage.pageSize = pageSize;
  }
  final int? total = jsonConvert.convert<int>(json['total']);
  if (total != null) {
    informationPage.total = total;
  }
  return informationPage;
}

Map<String, dynamic> $InformationPageToJson(InformationPage entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['currentPage'] = entity.currentPage;
  data['pageSize'] = entity.pageSize;
  data['total'] = entity.total;
  return data;
}

InformationItem $InformationItemFromJson(Map<String, dynamic> json) {
  final InformationItem informationItem = InformationItem();
  final String? unitGuid = jsonConvert.convert<String>(json['unitGuid']);
  if (unitGuid != null) {
    informationItem.unitGuid = unitGuid;
  }
  final String? notaryId = jsonConvert.convert<String>(json['notaryId']);
  if (notaryId != null) {
    informationItem.notaryId = notaryId;
  }
  final dynamic? userId = jsonConvert.convert<dynamic>(json['userId']);
  if (userId != null) {
    informationItem.userId = userId;
  }
  final String? title = jsonConvert.convert<String>(json['title']);
  if (title != null) {
    informationItem.title = title;
  }
  final String? content = jsonConvert.convert<String>(json['content']);
  if (content != null) {
    informationItem.content = content;
  }
  final String? pictureUrl = jsonConvert.convert<String>(json['pictureUrl']);
  if (pictureUrl != null) {
    informationItem.pictureUrl = pictureUrl;
  }
  final int? browseNum = jsonConvert.convert<int>(json['browseNum']);
  if (browseNum != null) {
    informationItem.browseNum = browseNum;
  }
  final int? deleteMark = jsonConvert.convert<int>(json['deleteMark']);
  if (deleteMark != null) {
    informationItem.deleteMark = deleteMark;
  }
  final int? ifTop = jsonConvert.convert<int>(json['ifTop']);
  if (ifTop != null) {
    informationItem.ifTop = ifTop;
  }
  final int? state = jsonConvert.convert<int>(json['state']);
  if (state != null) {
    informationItem.state = state;
  }
  final String? publishTime = jsonConvert.convert<String>(json['publishTime']);
  if (publishTime != null) {
    informationItem.publishTime = publishTime;
  }
  final String? createDate = jsonConvert.convert<String>(json['createDate']);
  if (createDate != null) {
    informationItem.createDate = createDate;
  }
  final String? notaryName = jsonConvert.convert<String>(json['notaryName']);
  if (notaryName != null) {
    informationItem.notaryName = notaryName;
  }
  return informationItem;
}

Map<String, dynamic> $InformationItemToJson(InformationItem entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
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
