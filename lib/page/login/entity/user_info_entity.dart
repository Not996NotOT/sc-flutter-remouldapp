import 'package:notarization_station_app/generated/json/base/json_convert_content.dart';

class UserInfoEntity with JsonConvert<UserInfoEntity> {
  String msg;
  int code;
  UserInfoItems items;
}

class UserInfoItems with JsonConvert<UserInfoItems> {
  UserInfoItemsUser user;
  String token;
}

class UserInfoItemsUser with JsonConvert<UserInfoItemsUser> {
  String headIcon;
  String birthday;
  String address;
  int gender;
  int enabledMark;
  int mobileType;
  String unitGuid;
  String nation;
  String idCard;
  String registeAddress;
  String mobile;
  String userName;
  int deleteMark;
  String idCardImg;
  String createDate;
}
