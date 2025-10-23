import 'package:notarization_station_app/page/home/entity/video_entity.dart';

videoEntityFromJson(VideoEntity data, Map<String, dynamic> json) {
  if (json['msg'] != null) {
    data.msg = json['msg'].toString();
  }
  if (json['code'] != null) {
    data.code = json['code'] is String
        ? int.tryParse(json['code'])
        : json['code'].toInt();
  }
  if (json['unitGuid'] != null) {
    data.unitGuid = VideoUnitGuid().fromJson(json['unitGuid']);
  }
  return data;
}

Map<String, dynamic> videoEntityToJson(VideoEntity entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['msg'] = entity.msg;
  data['code'] = entity.code;
  data['unitGuid'] = entity.unitGuid?.toJson();
  return data;
}

videoUnitGuidFromJson(VideoUnitGuid data, Map<String, dynamic> json) {
  if (json['unitGuid'] != null) {
    data.unitGuid = json['unitGuid'].toString();
  }
  if (json['createDate'] != null) {
    data.createDate = json['createDate'].toString();
  }
  if (json['orderNo'] != null) {
    data.orderNo = json['orderNo'].toString();
  }
  if (json['userId'] != null) {
    data.userId = json['userId'].toString();
  }
  if (json['name'] != null) {
    data.name = json['name'].toString();
  }
  if (json['useArea'] != null) {
    data.useArea = json['useArea'].toString();
  }
  if (json['useLanguage'] != null) {
    data.useLanguage = json['useLanguage'].toString();
  }
  if (json['purposeName'] != null) {
    data.purposeName = json['purposeName'].toString();
  }
  if (json['notaryId'] != null) {
    data.notaryId = json['notaryId'].toString();
  }
  if (json['notaryName'] != null) {
    data.notaryName = json['notaryName'].toString();
  }
  if (json['greffierId'] != null) {
    data.greffierId = json['greffierId'];
  }
  if (json['greffierName'] != null) {
    data.greffierName = json['greffierName'];
  }
  if (json['notaryState'] != null) {
    data.notaryState = json['notaryState'] is String
        ? int.tryParse(json['notaryState'])
        : json['notaryState'].toInt();
  }
  if (json['notaryOrderLogs'] != null) {
    data.notaryOrderLogs = json['notaryOrderLogs'];
  }
  if (json['lastDate'] != null) {
    data.lastDate = json['lastDate'].toString();
  }
  if (json['isDaiBan'] != null) {
    data.isDaiBan = json['isDaiBan'] is String
        ? int.tryParse(json['isDaiBan'])
        : json['isDaiBan'].toInt();
  }
  if (json['notaryForm'] != null) {
    data.notaryForm = json['notaryForm'] is String
        ? int.tryParse(json['notaryForm'])
        : json['notaryForm'].toInt();
  }
  if (json['description'] != null) {
    data.description = json['description'].toString();
  }
  if (json['fee'] != null) {
    data.fee = json['fee'];
  }
  if (json['supplementFee'] != null) {
    data.supplementFee = json['supplementFee'];
  }
  if (json['takeUser'] != null) {
    data.takeUser = json['takeUser'];
  }
  if (json['takeMobile'] != null) {
    data.takeMobile = json['takeMobile'];
  }
  if (json['takeAddress'] != null) {
    data.takeAddress = json['takeAddress'];
  }
  if (json['takeStyle'] != null) {
    data.takeStyle = json['takeStyle'];
  }
  if (json['pdfUrl'] != null) {
    data.pdfUrl = json['pdfUrl'];
  }
  if (json['signatureUrl'] != null) {
    data.signatureUrl = json['signatureUrl'];
  }
  if (json['signName'] != null) {
    data.signName = json['signName'];
  }
  if (json['deleteMark'] != null) {
    data.deleteMark = json['deleteMark'] is String
        ? int.tryParse(json['deleteMark'])
        : json['deleteMark'].toInt();
  }
  if (json['terminalType'] != null) {
    data.terminalType = json['terminalType'] is String
        ? int.tryParse(json['terminalType'])
        : json['terminalType'].toInt();
  }
  if (json['notaryItemNames'] != null) {
    data.notaryItemNames = json['notaryItemNames'];
  }
  if (json['notaryStateName'] != null) {
    data.notaryStateName = json['notaryStateName'];
  }
  if (json['enquire'] != null) {
    data.enquire = json['enquire'];
  }
  if (json['scanFiles'] != null) {
    data.scanFiles = json['scanFiles'];
  }
  if (json['userSaveVideo'] != null) {
    data.userSaveVideo = json['userSaveVideo'];
  }
  if (json['userTakeVideo'] != null) {
    data.userTakeVideo = json['userTakeVideo'];
  }
  if (json['notarySaveVideo'] != null) {
    data.notarySaveVideo = json['notarySaveVideo'];
  }
  if (json['notaryTakeVideo'] != null) {
    data.notaryTakeVideo = json['notaryTakeVideo'];
  }
  if (json['materialPdf'] != null) {
    data.materialPdf = json['materialPdf'];
  }
  if (json['certificationAdd'] != null) {
    data.certificationAdd = json['certificationAdd'];
  }
  if (json['statutoryPerson'] != null) {
    data.statutoryPerson = json['statutoryPerson'];
  }
  if (json['companyName'] != null) {
    data.companyName = json['companyName'];
  }
  if (json['companyAdd'] != null) {
    data.companyAdd = json['companyAdd'];
  }
  if (json['statutoryMobile'] != null) {
    data.statutoryMobile = json['statutoryMobile'];
  }
  if (json['wordId'] != null) {
    data.wordId = json['wordId'];
  }
  if (json['lattice'] != null) {
    data.lattice = json['lattice'];
  }
  if (json['materialName'] != null) {
    data.materialName = json['materialName'];
  }
  if (json['notaryItemName'] != null) {
    data.notaryItemName = json['notaryItemName'];
  }
  if (json['companyList'] != null) {
    data.companyList = json['companyList'];
  }
  if (json['roomId'] != null) {
    data.roomId = json['roomId'];
  }
  if (json['signatureUrlList'] != null) {
    data.signatureUrlList = json['signatureUrlList'];
  }
  if (json['pdfUrlList'] != null) {
    data.pdfUrlList = json['pdfUrlList'];
  }
  if (json['code'] != null) {
    data.code = json['code'] is String
        ? int.tryParse(json['code'])
        : json['code'].toInt();
  }
  if (json['payType'] != null) {
    data.payType = json['payType'];
  }
  if (json['pay'] != null) {
    data.pay = json['pay'];
  }
  if (json['thirdPartyIdCard'] != null) {
    data.thirdPartyIdCard = json['thirdPartyIdCard'];
  }
  if (json['thirdPartyMob'] != null) {
    data.thirdPartyMob = json['thirdPartyMob'];
  }
  if (json['thirdPartyName'] != null) {
    data.thirdPartyName = json['thirdPartyName'];
  }
  if (json['notaryNum'] != null) {
    data.notaryNum = json['notaryNum'];
  }
  if (json['certificate'] != null) {
    data.certificate = json['certificate'];
  }
  if (json['wordUrl'] != null) {
    data.wordUrl = json['wordUrl'];
  }
  if (json['certificatePathList'] != null) {
    data.certificatePathList = json['certificatePathList'];
  }
  if (json['secretKey'] != null) {
    data.secretKey = json['secretKey'];
  }
  if (json['encDataFilePath'] != null) {
    data.encDataFilePath = json['encDataFilePath'];
  }
  if (json['confirm'] != null) {
    data.confirm = json['confirm'] is String
        ? int.tryParse(json['confirm'])
        : json['confirm'].toInt();
  }
  if (json['materialList'] != null) {
    data.materialList = json['materialList'];
  }
  if (json['materUrlList'] != null) {
    data.materUrlList = json['materUrlList'];
  }
  if (json['remarks'] != null) {
    data.remarks = json['remarks'];
  }
  if (json['currentState'] != null) {
    data.currentState = json['currentState'];
  }
  return data;
}

Map<String, dynamic> videoUnitGuidToJson(VideoUnitGuid entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['unitGuid'] = entity.unitGuid;
  data['createDate'] = entity.createDate;
  data['orderNo'] = entity.orderNo;
  data['userId'] = entity.userId;
  data['name'] = entity.name;
  data['useArea'] = entity.useArea;
  data['useLanguage'] = entity.useLanguage;
  data['purposeName'] = entity.purposeName;
  data['notaryId'] = entity.notaryId;
  data['notaryName'] = entity.notaryName;
  data['greffierId'] = entity.greffierId;
  data['greffierName'] = entity.greffierName;
  data['notaryState'] = entity.notaryState;
  data['notaryOrderLogs'] = entity.notaryOrderLogs;
  data['lastDate'] = entity.lastDate;
  data['isDaiBan'] = entity.isDaiBan;
  data['notaryForm'] = entity.notaryForm;
  data['description'] = entity.description;
  data['fee'] = entity.fee;
  data['supplementFee'] = entity.supplementFee;
  data['takeUser'] = entity.takeUser;
  data['takeMobile'] = entity.takeMobile;
  data['takeAddress'] = entity.takeAddress;
  data['takeStyle'] = entity.takeStyle;
  data['pdfUrl'] = entity.pdfUrl;
  data['signatureUrl'] = entity.signatureUrl;
  data['signName'] = entity.signName;
  data['deleteMark'] = entity.deleteMark;
  data['terminalType'] = entity.terminalType;
  data['notaryItemNames'] = entity.notaryItemNames;
  data['notaryStateName'] = entity.notaryStateName;
  data['enquire'] = entity.enquire;
  data['scanFiles'] = entity.scanFiles;
  data['userSaveVideo'] = entity.userSaveVideo;
  data['userTakeVideo'] = entity.userTakeVideo;
  data['notarySaveVideo'] = entity.notarySaveVideo;
  data['notaryTakeVideo'] = entity.notaryTakeVideo;
  data['materialPdf'] = entity.materialPdf;
  data['certificationAdd'] = entity.certificationAdd;
  data['statutoryPerson'] = entity.statutoryPerson;
  data['companyName'] = entity.companyName;
  data['companyAdd'] = entity.companyAdd;
  data['statutoryMobile'] = entity.statutoryMobile;
  data['wordId'] = entity.wordId;
  data['lattice'] = entity.lattice;
  data['materialName'] = entity.materialName;
  data['notaryItemName'] = entity.notaryItemName;
  data['companyList'] = entity.companyList;
  data['roomId'] = entity.roomId;
  data['signatureUrlList'] = entity.signatureUrlList;
  data['pdfUrlList'] = entity.pdfUrlList;
  data['code'] = entity.code;
  data['payType'] = entity.payType;
  data['pay'] = entity.pay;
  data['thirdPartyIdCard'] = entity.thirdPartyIdCard;
  data['thirdPartyMob'] = entity.thirdPartyMob;
  data['thirdPartyName'] = entity.thirdPartyName;
  data['notaryNum'] = entity.notaryNum;
  data['certificate'] = entity.certificate;
  data['wordUrl'] = entity.wordUrl;
  data['certificatePathList'] = entity.certificatePathList;
  data['secretKey'] = entity.secretKey;
  data['encDataFilePath'] = entity.encDataFilePath;
  data['confirm'] = entity.confirm;
  data['materialList'] = entity.materialList;
  data['materUrlList'] = entity.materUrlList;
  data['remarks'] = entity.remarks;
  data['currentState'] = entity.currentState;
  return data;
}
