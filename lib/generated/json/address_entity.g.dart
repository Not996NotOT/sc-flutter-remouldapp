import 'package:notarization_station_app/generated/json/base/json_convert_content.dart';
import 'package:notarization_station_app/page/mine/entity/address_entity.dart';

AddressEntity $AddressEntityFromJson(Map<String, dynamic> json) {
  final AddressEntity addressEntity = AddressEntity();
  final String? msg = jsonConvert.convert<String>(json['msg']);
  if (msg != null) {
    addressEntity.msg = msg;
  }
  final int? code = jsonConvert.convert<int>(json['code']);
  if (code != null) {
    addressEntity.code = code;
  }
  final AddressPage? page = jsonConvert.convert<AddressPage>(json['page']);
  if (page != null) {
    addressEntity.page = page;
  }
  final List<AddressItem>? items =
      jsonConvert.convertListNotNull<AddressItem>(json['items']);
  if (items != null) {
    addressEntity.items = items;
  }
  return addressEntity;
}

Map<String, dynamic> $AddressEntityToJson(AddressEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['msg'] = entity.msg;
  data['code'] = entity.code;
  data['page'] = entity.page.toJson();
  data['items'] = entity.items.map((v) => v.toJson()).toList();
  return data;
}

AddressPage $AddressPageFromJson(Map<String, dynamic> json) {
  final AddressPage addressPage = AddressPage();
  final int? currentPage = jsonConvert.convert<int>(json['currentPage']);
  if (currentPage != null) {
    addressPage.currentPage = currentPage;
  }
  final int? pageSize = jsonConvert.convert<int>(json['pageSize']);
  if (pageSize != null) {
    addressPage.pageSize = pageSize;
  }
  final int? total = jsonConvert.convert<int>(json['total']);
  if (total != null) {
    addressPage.total = total;
  }
  return addressPage;
}

Map<String, dynamic> $AddressPageToJson(AddressPage entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['currentPage'] = entity.currentPage;
  data['pageSize'] = entity.pageSize;
  data['total'] = entity.total;
  return data;
}

AddressItem $AddressItemFromJson(Map<String, dynamic> json) {
  final AddressItem addressItem = AddressItem();
  final String? unitGuid = jsonConvert.convert<String>(json['unitGuid']);
  if (unitGuid != null) {
    addressItem.unitGuid = unitGuid;
  }
  final String? userGuid = jsonConvert.convert<String>(json['userGuid']);
  if (userGuid != null) {
    addressItem.userGuid = userGuid;
  }
  final String? address = jsonConvert.convert<String>(json['address']);
  if (address != null) {
    addressItem.address = address;
  }
  final String? phone = jsonConvert.convert<String>(json['phone']);
  if (phone != null) {
    addressItem.phone = phone;
  }
  final String? receivingUsername =
      jsonConvert.convert<String>(json['receivingUsername']);
  if (receivingUsername != null) {
    addressItem.receivingUsername = receivingUsername;
  }
  final String? noDefault = jsonConvert.convert<String>(json['noDefault']);
  if (noDefault != null) {
    addressItem.noDefault = noDefault;
  }
  return addressItem;
}

Map<String, dynamic> $AddressItemToJson(AddressItem entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['unitGuid'] = entity.unitGuid;
  data['userGuid'] = entity.userGuid;
  data['address'] = entity.address;
  data['phone'] = entity.phone;
  data['receivingUsername'] = entity.receivingUsername;
  data['noDefault'] = entity.noDefault;
  return data;
}
