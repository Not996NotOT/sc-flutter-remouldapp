import 'package:notarization_station_app/generated/json/base/json_convert_content.dart';
import 'package:notarization_station_app/page/login/entity/user_info_entity.dart';

UserInfoEntity $UserInfoEntityFromJson(Map<String, dynamic> json) {
  final UserInfoEntity userInfoEntity = UserInfoEntity();
  final String? msg = jsonConvert.convert<String>(json['msg']);
  if (msg != null) {
    userInfoEntity.msg = msg;
  }
  final int? code = jsonConvert.convert<int>(json['code']);
  if (code != null) {
    userInfoEntity.code = code;
  }
  final UserInfoItems? items =
      jsonConvert.convert<UserInfoItems>(json['items']);
  if (items != null) {
    userInfoEntity.items = items;
  }
  return userInfoEntity;
}

Map<String, dynamic> $UserInfoEntityToJson(UserInfoEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['msg'] = entity.msg;
  data['code'] = entity.code;
  data['items'] = entity.items.toJson();
  return data;
}

UserInfoItems $UserInfoItemsFromJson(Map<String, dynamic> json) {
  final UserInfoItems userInfoItems = UserInfoItems();
  final UserInfoItemsUser? user =
      jsonConvert.convert<UserInfoItemsUser>(json['user']);
  if (user != null) {
    userInfoItems.user = user;
  }
  final String? token = jsonConvert.convert<String>(json['token']);
  if (token != null) {
    userInfoItems.token = token;
  }
  return userInfoItems;
}

Map<String, dynamic> $UserInfoItemsToJson(UserInfoItems entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['user'] = entity.user.toJson();
  data['token'] = entity.token;
  return data;
}

UserInfoItemsUser $UserInfoItemsUserFromJson(Map<String, dynamic> json) {
  final UserInfoItemsUser userInfoItemsUser = UserInfoItemsUser();
  final String? headIcon = jsonConvert.convert<String>(json['headIcon']);
  if (headIcon != null) {
    userInfoItemsUser.headIcon = headIcon;
  }
  final String? birthday = jsonConvert.convert<String>(json['birthday']);
  if (birthday != null) {
    userInfoItemsUser.birthday = birthday;
  }
  final String? address = jsonConvert.convert<String>(json['address']);
  if (address != null) {
    userInfoItemsUser.address = address;
  }
  final int? gender = jsonConvert.convert<int>(json['gender']);
  if (gender != null) {
    userInfoItemsUser.gender = gender;
  }
  final int? enabledMark = jsonConvert.convert<int>(json['enabledMark']);
  if (enabledMark != null) {
    userInfoItemsUser.enabledMark = enabledMark;
  }
  final int? mobileType = jsonConvert.convert<int>(json['mobileType']);
  if (mobileType != null) {
    userInfoItemsUser.mobileType = mobileType;
  }
  final String? unitGuid = jsonConvert.convert<String>(json['unitGuid']);
  if (unitGuid != null) {
    userInfoItemsUser.unitGuid = unitGuid;
  }
  final String? nation = jsonConvert.convert<String>(json['nation']);
  if (nation != null) {
    userInfoItemsUser.nation = nation;
  }
  final String? idCard = jsonConvert.convert<String>(json['idCard']);
  if (idCard != null) {
    userInfoItemsUser.idCard = idCard;
  }
  final String? registeAddress =
      jsonConvert.convert<String>(json['registeAddress']);
  if (registeAddress != null) {
    userInfoItemsUser.registeAddress = registeAddress;
  }
  final String? mobile = jsonConvert.convert<String>(json['mobile']);
  if (mobile != null) {
    userInfoItemsUser.mobile = mobile;
  }
  final String? userName = jsonConvert.convert<String>(json['userName']);
  if (userName != null) {
    userInfoItemsUser.userName = userName;
  }
  final int? deleteMark = jsonConvert.convert<int>(json['deleteMark']);
  if (deleteMark != null) {
    userInfoItemsUser.deleteMark = deleteMark;
  }
  final String? idCardImg = jsonConvert.convert<String>(json['idCardImg']);
  if (idCardImg != null) {
    userInfoItemsUser.idCardImg = idCardImg;
  }
  final String? createDate = jsonConvert.convert<String>(json['createDate']);
  if (createDate != null) {
    userInfoItemsUser.createDate = createDate;
  }
  return userInfoItemsUser;
}

Map<String, dynamic> $UserInfoItemsUserToJson(UserInfoItemsUser entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
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
