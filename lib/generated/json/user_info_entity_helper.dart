import 'package:notarization_station_app/page/login/entity/user_info_entity.dart';

userInfoEntityFromJson(UserInfoEntity data, Map<String, dynamic> json) {
  if (json['msg'] != null) {
    data.msg = json['msg'].toString();
  }
  if (json['code'] != null) {
    data.code = json['code'] is String
        ? int.tryParse(json['code'])
        : json['code'].toInt();
  }
  if (json['items'] != null) {
    data.items = UserInfoItems().fromJson(json['items']);
  }
  return data;
}

Map<String, dynamic> userInfoEntityToJson(UserInfoEntity entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['msg'] = entity.msg;
  data['code'] = entity.code;
  data['items'] = entity.items?.toJson();
  return data;
}

userInfoItemsFromJson(UserInfoItems data, Map<String, dynamic> json) {
  if (json['user'] != null) {
    data.user = UserInfoItemsUser().fromJson(json['user']);
  }
  if (json['token'] != null) {
    data.token = json['token'].toString();
  }
  return data;
}

Map<String, dynamic> userInfoItemsToJson(UserInfoItems entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['user'] = entity.user?.toJson();
  data['token'] = entity.token;
  return data;
}

userInfoItemsUserFromJson(UserInfoItemsUser data, Map<String, dynamic> json) {
  if (json['headIcon'] != null) {
    data.headIcon = json['headIcon'].toString();
  }
  if (json['birthday'] != null) {
    data.birthday = json['birthday'].toString();
  }
  if (json['address'] != null) {
    data.address = json['address'].toString();
  }
  if (json['gender'] != null) {
    data.gender = json['gender'] is String
        ? int.tryParse(json['gender'])
        : json['gender'].toInt();
  }
  if (json['enabledMark'] != null) {
    data.enabledMark = json['enabledMark'] is String
        ? int.tryParse(json['enabledMark'])
        : json['enabledMark'].toInt();
  }
  if (json['mobileType'] != null) {
    data.mobileType = json['mobileType'] is String
        ? int.tryParse(json['mobileType'])
        : json['mobileType'].toInt();
  }
  if (json['unitGuid'] != null) {
    data.unitGuid = json['unitGuid'].toString();
  }
  if (json['nation'] != null) {
    data.nation = json['nation'].toString();
  }
  if (json['idCard'] != null) {
    data.idCard = json['idCard'].toString();
  }
  if (json['registeAddress'] != null) {
    data.registeAddress = json['registeAddress'].toString();
  }
  if (json['mobile'] != null) {
    data.mobile = json['mobile'].toString();
  }
  if (json['userName'] != null) {
    data.userName = json['userName'].toString();
  }
  if (json['deleteMark'] != null) {
    data.deleteMark = json['deleteMark'] is String
        ? int.tryParse(json['deleteMark'])
        : json['deleteMark'].toInt();
  }
  if (json['idCardImg'] != null) {
    data.idCardImg = json['idCardImg'].toString();
  }
  if (json['createDate'] != null) {
    data.createDate = json['createDate'].toString();
  }
  return data;
}

Map<String, dynamic> userInfoItemsUserToJson(UserInfoItemsUser entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['headIcon'] = entity.headIcon;
  data['birthday'] = entity.birthday;
  data['address'] = entity.address;
  data['gender'] = entity.gender;
  data['enabledMark'] = entity.enabledMark;
  data['mobileType'] = entity.mobileType;
  data['unitGuid'] = entity.unitGuid;
  data['nation'] = entity.nation;
  data['idCard'] = entity.idCard;
  data['registeAddress'] = entity.registeAddress;
  data['mobile'] = entity.mobile;
  data['userName'] = entity.userName;
  data['deleteMark'] = entity.deleteMark;
  data['idCardImg'] = entity.idCardImg;
  data['createDate'] = entity.createDate;
  return data;
}
