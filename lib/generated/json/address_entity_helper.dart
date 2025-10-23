import 'package:notarization_station_app/page/mine/entity/address_entity.dart';

addressEntityFromJson(AddressEntity data, Map<String, dynamic> json) {
  if (json['msg'] != null) {
    data.msg = json['msg'].toString();
  }
  if (json['code'] != null) {
    data.code = json['code'] is String
        ? int.tryParse(json['code'])
        : json['code'].toInt();
  }
  if (json['page'] != null) {
    data.page = AddressPage().fromJson(json['page']);
  }
  if (json['items'] != null) {
    data.items =
        (json['items'] as List).map((v) => AddressItem().fromJson(v)).toList();
  }
  return data;
}

Map<String, dynamic> addressEntityToJson(AddressEntity entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['msg'] = entity.msg;
  data['code'] = entity.code;
  data['page'] = entity.page?.toJson();
  data['items'] = entity.items?.map((v) => v.toJson())?.toList();
  return data;
}

addressPageFromJson(AddressPage data, Map<String, dynamic> json) {
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

Map<String, dynamic> addressPageToJson(AddressPage entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['currentPage'] = entity.currentPage;
  data['pageSize'] = entity.pageSize;
  data['total'] = entity.total;
  return data;
}

addressItemFromJson(AddressItem data, Map<String, dynamic> json) {
  if (json['unitGuid'] != null) {
    data.unitGuid = json['unitGuid'].toString();
  }
  if (json['userGuid'] != null) {
    data.userGuid = json['userGuid'].toString();
  }
  if (json['address'] != null) {
    data.address = json['address'].toString();
  }
  if (json['phone'] != null) {
    data.phone = json['phone'].toString();
  }
  if (json['receivingUsername'] != null) {
    data.receivingUsername = json['receivingUsername'].toString();
  }
  if (json['noDefault'] != null) {
    data.noDefault = json['noDefault'].toString();
  }
  return data;
}

Map<String, dynamic> addressItemToJson(AddressItem entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['unitGuid'] = entity.unitGuid;
  data['userGuid'] = entity.userGuid;
  data['address'] = entity.address;
  data['phone'] = entity.phone;
  data['receivingUsername'] = entity.receivingUsername;
  data['noDefault'] = entity.noDefault;
  return data;
}
