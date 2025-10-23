import 'package:notarization_station_app/generated/json/base/json_convert_content.dart';
import 'package:notarization_station_app/page/mine/entity/upload_img_entity.dart';

UploadImgEntity $UploadImgEntityFromJson(Map<String, dynamic> json) {
  final UploadImgEntity uploadImgEntity = UploadImgEntity();
  final String? msg = jsonConvert.convert<String>(json['msg']);
  if (msg != null) {
    uploadImgEntity.msg = msg;
  }
  final UploadImgItem? item = jsonConvert.convert<UploadImgItem>(json['item']);
  if (item != null) {
    uploadImgEntity.item = item;
  }
  final int? code = jsonConvert.convert<int>(json['code']);
  if (code != null) {
    uploadImgEntity.code = code;
  }
  return uploadImgEntity;
}

Map<String, dynamic> $UploadImgEntityToJson(UploadImgEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['msg'] = entity.msg;
  data['item'] = entity.item.toJson();
  data['code'] = entity.code;
  return data;
}

UploadImgItem $UploadImgItemFromJson(Map<String, dynamic> json) {
  final UploadImgItem uploadImgItem = UploadImgItem();
  final String? unitGuid = jsonConvert.convert<String>(json['unitGuid']);
  if (unitGuid != null) {
    uploadImgItem.unitGuid = unitGuid;
  }
  final dynamic? userId = jsonConvert.convert<dynamic>(json['userId']);
  if (userId != null) {
    uploadImgItem.userId = userId;
  }
  final String? createDate = jsonConvert.convert<String>(json['createDate']);
  if (createDate != null) {
    uploadImgItem.createDate = createDate;
  }
  final String? fileName = jsonConvert.convert<String>(json['fileName']);
  if (fileName != null) {
    uploadImgItem.fileName = fileName;
  }
  final int? fileSize = jsonConvert.convert<int>(json['fileSize']);
  if (fileSize != null) {
    uploadImgItem.fileSize = fileSize;
  }
  final String? fileType = jsonConvert.convert<String>(json['fileType']);
  if (fileType != null) {
    uploadImgItem.fileType = fileType;
  }
  final dynamic? groupId = jsonConvert.convert<dynamic>(json['groupId']);
  if (groupId != null) {
    uploadImgItem.groupId = groupId;
  }
  final String? filePath = jsonConvert.convert<String>(json['filePath']);
  if (filePath != null) {
    uploadImgItem.filePath = filePath;
  }
  final dynamic? code = jsonConvert.convert<dynamic>(json['code']);
  if (code != null) {
    uploadImgItem.code = code;
  }
  final dynamic? statusInfo = jsonConvert.convert<dynamic>(json['statusInfo']);
  if (statusInfo != null) {
    uploadImgItem.statusInfo = statusInfo;
  }
  return uploadImgItem;
}

Map<String, dynamic> $UploadImgItemToJson(UploadImgItem entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['unitGuid'] = entity.unitGuid;
  data['userId'] = entity.userId;
  data['createDate'] = entity.createDate;
  data['fileName'] = entity.fileName;
  data['fileSize'] = entity.fileSize;
  data['fileType'] = entity.fileType;
  data['groupId'] = entity.groupId;
  data['filePath'] = entity.filePath;
  data['code'] = entity.code;
  data['statusInfo'] = entity.statusInfo;
  return data;
}
