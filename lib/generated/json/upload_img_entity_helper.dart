import 'package:notarization_station_app/page/mine/entity/upload_img_entity.dart';

uploadImgEntityFromJson(UploadImgEntity data, Map<String, dynamic> json) {
  if (json['msg'] != null) {
    data.msg = json['msg'].toString();
  }
  if (json['item'] != null) {
    data.item = UploadImgItem().fromJson(json['item']);
  }
  if (json['code'] != null) {
    data.code = json['code'] is String
        ? int.tryParse(json['code'])
        : json['code'].toInt();
  }
  return data;
}

Map<String, dynamic> uploadImgEntityToJson(UploadImgEntity entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['msg'] = entity.msg;
  data['item'] = entity.item?.toJson();
  data['code'] = entity.code;
  return data;
}

uploadImgItemFromJson(UploadImgItem data, Map<String, dynamic> json) {
  if (json['unitGuid'] != null) {
    data.unitGuid = json['unitGuid'].toString();
  }
  if (json['userId'] != null) {
    data.userId = json['userId'];
  }
  if (json['createDate'] != null) {
    data.createDate = json['createDate'].toString();
  }
  if (json['fileName'] != null) {
    data.fileName = json['fileName'].toString();
  }
  if (json['fileSize'] != null) {
    data.fileSize = json['fileSize'] is String
        ? int.tryParse(json['fileSize'])
        : json['fileSize'].toInt();
  }
  if (json['fileType'] != null) {
    data.fileType = json['fileType'].toString();
  }
  if (json['groupId'] != null) {
    data.groupId = json['groupId'];
  }
  if (json['filePath'] != null) {
    data.filePath = json['filePath'].toString();
  }
  if (json['code'] != null) {
    data.code = json['code'];
  }
  if (json['statusInfo'] != null) {
    data.statusInfo = json['statusInfo'];
  }
  return data;
}

Map<String, dynamic> uploadImgItemToJson(UploadImgItem entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
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
