import 'package:notarization_station_app/generated/json/base/json_convert_content.dart';

class UploadImgEntity with JsonConvert<UploadImgEntity> {
  String msg;
  UploadImgItem item;
  int code;
}

class UploadImgItem with JsonConvert<UploadImgItem> {
  String unitGuid;
  dynamic userId;
  String createDate;
  String fileName;
  int fileSize;
  String fileType;
  dynamic groupId;
  String filePath;
  dynamic code;
  dynamic statusInfo;
}
