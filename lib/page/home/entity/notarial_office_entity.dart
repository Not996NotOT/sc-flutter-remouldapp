import 'package:notarization_station_app/generated/json/base/json_convert_content.dart';

class NotarialOfficeEntity with JsonConvert<NotarialOfficeEntity> {
  String msg;
  int code;
  List<NotarialOfficeItem> items;
}

class NotarialOfficeItem with JsonConvert<NotarialOfficeItem> {
  String unitGuid;
  String notarialName;
  String contactNumber;
  String address;
  String leader;
  dynamic notaryNumber;
  dynamic workTime;
  dynamic cityCode;
  int enabledMark;
  int deleteMark;
  String createDate;
  String description;
  String watermark;
}
