import 'package:notarization_station_app/generated/json/base/json_convert_content.dart';
import 'package:notarization_station_app/page/home/entity/video_entity.dart';

VideoEntity $VideoEntityFromJson(Map<String, dynamic> json) {
  final VideoEntity videoEntity = VideoEntity();
  final String? msg = jsonConvert.convert<String>(json['msg']);
  if (msg != null) {
    videoEntity.msg = msg;
  }
  final int? code = jsonConvert.convert<int>(json['code']);
  if (code != null) {
    videoEntity.code = code;
  }
  final VideoUnitGuid? unitGuid =
      jsonConvert.convert<VideoUnitGuid>(json['unitGuid']);
  if (unitGuid != null) {
    videoEntity.unitGuid = unitGuid;
  }
  return videoEntity;
}

Map<String, dynamic> $VideoEntityToJson(VideoEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['msg'] = entity.msg;
  data['code'] = entity.code;
  data['unitGuid'] = entity.unitGuid.toJson();
  return data;
}

VideoUnitGuid $VideoUnitGuidFromJson(Map<String, dynamic> json) {
  final VideoUnitGuid videoUnitGuid = VideoUnitGuid();
  final String? unitGuid = jsonConvert.convert<String>(json['unitGuid']);
  if (unitGuid != null) {
    videoUnitGuid.unitGuid = unitGuid;
  }
  final String? createDate = jsonConvert.convert<String>(json['createDate']);
  if (createDate != null) {
    videoUnitGuid.createDate = createDate;
  }
  final String? orderNo = jsonConvert.convert<String>(json['orderNo']);
  if (orderNo != null) {
    videoUnitGuid.orderNo = orderNo;
  }
  final String? userId = jsonConvert.convert<String>(json['userId']);
  if (userId != null) {
    videoUnitGuid.userId = userId;
  }
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    videoUnitGuid.name = name;
  }
  final String? useArea = jsonConvert.convert<String>(json['useArea']);
  if (useArea != null) {
    videoUnitGuid.useArea = useArea;
  }
  final String? useLanguage = jsonConvert.convert<String>(json['useLanguage']);
  if (useLanguage != null) {
    videoUnitGuid.useLanguage = useLanguage;
  }
  final String? purposeName = jsonConvert.convert<String>(json['purposeName']);
  if (purposeName != null) {
    videoUnitGuid.purposeName = purposeName;
  }
  final String? notaryId = jsonConvert.convert<String>(json['notaryId']);
  if (notaryId != null) {
    videoUnitGuid.notaryId = notaryId;
  }
  final String? notaryName = jsonConvert.convert<String>(json['notaryName']);
  if (notaryName != null) {
    videoUnitGuid.notaryName = notaryName;
  }
  final dynamic? greffierId = jsonConvert.convert<dynamic>(json['greffierId']);
  if (greffierId != null) {
    videoUnitGuid.greffierId = greffierId;
  }
  final dynamic? greffierName =
      jsonConvert.convert<dynamic>(json['greffierName']);
  if (greffierName != null) {
    videoUnitGuid.greffierName = greffierName;
  }
  final int? notaryState = jsonConvert.convert<int>(json['notaryState']);
  if (notaryState != null) {
    videoUnitGuid.notaryState = notaryState;
  }
  final dynamic? notaryOrderLogs =
      jsonConvert.convert<dynamic>(json['notaryOrderLogs']);
  if (notaryOrderLogs != null) {
    videoUnitGuid.notaryOrderLogs = notaryOrderLogs;
  }
  final String? lastDate = jsonConvert.convert<String>(json['lastDate']);
  if (lastDate != null) {
    videoUnitGuid.lastDate = lastDate;
  }
  final int? isDaiBan = jsonConvert.convert<int>(json['isDaiBan']);
  if (isDaiBan != null) {
    videoUnitGuid.isDaiBan = isDaiBan;
  }
  final int? notaryForm = jsonConvert.convert<int>(json['notaryForm']);
  if (notaryForm != null) {
    videoUnitGuid.notaryForm = notaryForm;
  }
  final String? description = jsonConvert.convert<String>(json['description']);
  if (description != null) {
    videoUnitGuid.description = description;
  }
  final dynamic? fee = jsonConvert.convert<dynamic>(json['fee']);
  if (fee != null) {
    videoUnitGuid.fee = fee;
  }
  final dynamic? supplementFee =
      jsonConvert.convert<dynamic>(json['supplementFee']);
  if (supplementFee != null) {
    videoUnitGuid.supplementFee = supplementFee;
  }
  final dynamic? takeUser = jsonConvert.convert<dynamic>(json['takeUser']);
  if (takeUser != null) {
    videoUnitGuid.takeUser = takeUser;
  }
  final dynamic? takeMobile = jsonConvert.convert<dynamic>(json['takeMobile']);
  if (takeMobile != null) {
    videoUnitGuid.takeMobile = takeMobile;
  }
  final dynamic? takeAddress =
      jsonConvert.convert<dynamic>(json['takeAddress']);
  if (takeAddress != null) {
    videoUnitGuid.takeAddress = takeAddress;
  }
  final dynamic? takeStyle = jsonConvert.convert<dynamic>(json['takeStyle']);
  if (takeStyle != null) {
    videoUnitGuid.takeStyle = takeStyle;
  }
  final dynamic? pdfUrl = jsonConvert.convert<dynamic>(json['pdfUrl']);
  if (pdfUrl != null) {
    videoUnitGuid.pdfUrl = pdfUrl;
  }
  final dynamic? signatureUrl =
      jsonConvert.convert<dynamic>(json['signatureUrl']);
  if (signatureUrl != null) {
    videoUnitGuid.signatureUrl = signatureUrl;
  }
  final dynamic? signName = jsonConvert.convert<dynamic>(json['signName']);
  if (signName != null) {
    videoUnitGuid.signName = signName;
  }
  final int? deleteMark = jsonConvert.convert<int>(json['deleteMark']);
  if (deleteMark != null) {
    videoUnitGuid.deleteMark = deleteMark;
  }
  final int? terminalType = jsonConvert.convert<int>(json['terminalType']);
  if (terminalType != null) {
    videoUnitGuid.terminalType = terminalType;
  }
  final dynamic? notaryItemNames =
      jsonConvert.convert<dynamic>(json['notaryItemNames']);
  if (notaryItemNames != null) {
    videoUnitGuid.notaryItemNames = notaryItemNames;
  }
  final dynamic? notaryStateName =
      jsonConvert.convert<dynamic>(json['notaryStateName']);
  if (notaryStateName != null) {
    videoUnitGuid.notaryStateName = notaryStateName;
  }
  final dynamic? enquire = jsonConvert.convert<dynamic>(json['enquire']);
  if (enquire != null) {
    videoUnitGuid.enquire = enquire;
  }
  final dynamic? scanFiles = jsonConvert.convert<dynamic>(json['scanFiles']);
  if (scanFiles != null) {
    videoUnitGuid.scanFiles = scanFiles;
  }
  final dynamic? userSaveVideo =
      jsonConvert.convert<dynamic>(json['userSaveVideo']);
  if (userSaveVideo != null) {
    videoUnitGuid.userSaveVideo = userSaveVideo;
  }
  final dynamic? userTakeVideo =
      jsonConvert.convert<dynamic>(json['userTakeVideo']);
  if (userTakeVideo != null) {
    videoUnitGuid.userTakeVideo = userTakeVideo;
  }
  final dynamic? notarySaveVideo =
      jsonConvert.convert<dynamic>(json['notarySaveVideo']);
  if (notarySaveVideo != null) {
    videoUnitGuid.notarySaveVideo = notarySaveVideo;
  }
  final dynamic? notaryTakeVideo =
      jsonConvert.convert<dynamic>(json['notaryTakeVideo']);
  if (notaryTakeVideo != null) {
    videoUnitGuid.notaryTakeVideo = notaryTakeVideo;
  }
  final dynamic? materialPdf =
      jsonConvert.convert<dynamic>(json['materialPdf']);
  if (materialPdf != null) {
    videoUnitGuid.materialPdf = materialPdf;
  }
  final dynamic? certificationAdd =
      jsonConvert.convert<dynamic>(json['certificationAdd']);
  if (certificationAdd != null) {
    videoUnitGuid.certificationAdd = certificationAdd;
  }
  final dynamic? statutoryPerson =
      jsonConvert.convert<dynamic>(json['statutoryPerson']);
  if (statutoryPerson != null) {
    videoUnitGuid.statutoryPerson = statutoryPerson;
  }
  final dynamic? companyName =
      jsonConvert.convert<dynamic>(json['companyName']);
  if (companyName != null) {
    videoUnitGuid.companyName = companyName;
  }
  final dynamic? companyAdd = jsonConvert.convert<dynamic>(json['companyAdd']);
  if (companyAdd != null) {
    videoUnitGuid.companyAdd = companyAdd;
  }
  final dynamic? statutoryMobile =
      jsonConvert.convert<dynamic>(json['statutoryMobile']);
  if (statutoryMobile != null) {
    videoUnitGuid.statutoryMobile = statutoryMobile;
  }
  final dynamic? wordId = jsonConvert.convert<dynamic>(json['wordId']);
  if (wordId != null) {
    videoUnitGuid.wordId = wordId;
  }
  final dynamic? lattice = jsonConvert.convert<dynamic>(json['lattice']);
  if (lattice != null) {
    videoUnitGuid.lattice = lattice;
  }
  final dynamic? materialName =
      jsonConvert.convert<dynamic>(json['materialName']);
  if (materialName != null) {
    videoUnitGuid.materialName = materialName;
  }
  final dynamic? notaryItemName =
      jsonConvert.convert<dynamic>(json['notaryItemName']);
  if (notaryItemName != null) {
    videoUnitGuid.notaryItemName = notaryItemName;
  }
  final dynamic? companyList =
      jsonConvert.convert<dynamic>(json['companyList']);
  if (companyList != null) {
    videoUnitGuid.companyList = companyList;
  }
  final dynamic? roomId = jsonConvert.convert<dynamic>(json['roomId']);
  if (roomId != null) {
    videoUnitGuid.roomId = roomId;
  }
  final dynamic? signatureUrlList =
      jsonConvert.convert<dynamic>(json['signatureUrlList']);
  if (signatureUrlList != null) {
    videoUnitGuid.signatureUrlList = signatureUrlList;
  }
  final dynamic? pdfUrlList = jsonConvert.convert<dynamic>(json['pdfUrlList']);
  if (pdfUrlList != null) {
    videoUnitGuid.pdfUrlList = pdfUrlList;
  }
  final int? code = jsonConvert.convert<int>(json['code']);
  if (code != null) {
    videoUnitGuid.code = code;
  }
  final dynamic? payType = jsonConvert.convert<dynamic>(json['payType']);
  if (payType != null) {
    videoUnitGuid.payType = payType;
  }
  final dynamic? pay = jsonConvert.convert<dynamic>(json['pay']);
  if (pay != null) {
    videoUnitGuid.pay = pay;
  }
  final dynamic? thirdPartyIdCard =
      jsonConvert.convert<dynamic>(json['thirdPartyIdCard']);
  if (thirdPartyIdCard != null) {
    videoUnitGuid.thirdPartyIdCard = thirdPartyIdCard;
  }
  final dynamic? thirdPartyMob =
      jsonConvert.convert<dynamic>(json['thirdPartyMob']);
  if (thirdPartyMob != null) {
    videoUnitGuid.thirdPartyMob = thirdPartyMob;
  }
  final dynamic? thirdPartyName =
      jsonConvert.convert<dynamic>(json['thirdPartyName']);
  if (thirdPartyName != null) {
    videoUnitGuid.thirdPartyName = thirdPartyName;
  }
  final dynamic? notaryNum = jsonConvert.convert<dynamic>(json['notaryNum']);
  if (notaryNum != null) {
    videoUnitGuid.notaryNum = notaryNum;
  }
  final dynamic? certificate =
      jsonConvert.convert<dynamic>(json['certificate']);
  if (certificate != null) {
    videoUnitGuid.certificate = certificate;
  }
  final dynamic? wordUrl = jsonConvert.convert<dynamic>(json['wordUrl']);
  if (wordUrl != null) {
    videoUnitGuid.wordUrl = wordUrl;
  }
  final dynamic? certificatePathList =
      jsonConvert.convert<dynamic>(json['certificatePathList']);
  if (certificatePathList != null) {
    videoUnitGuid.certificatePathList = certificatePathList;
  }
  final dynamic? secretKey = jsonConvert.convert<dynamic>(json['secretKey']);
  if (secretKey != null) {
    videoUnitGuid.secretKey = secretKey;
  }
  final dynamic? encDataFilePath =
      jsonConvert.convert<dynamic>(json['encDataFilePath']);
  if (encDataFilePath != null) {
    videoUnitGuid.encDataFilePath = encDataFilePath;
  }
  final int? confirm = jsonConvert.convert<int>(json['confirm']);
  if (confirm != null) {
    videoUnitGuid.confirm = confirm;
  }
  final dynamic? materialList =
      jsonConvert.convert<dynamic>(json['materialList']);
  if (materialList != null) {
    videoUnitGuid.materialList = materialList;
  }
  final dynamic? materUrlList =
      jsonConvert.convert<dynamic>(json['materUrlList']);
  if (materUrlList != null) {
    videoUnitGuid.materUrlList = materUrlList;
  }
  final dynamic? remarks = jsonConvert.convert<dynamic>(json['remarks']);
  if (remarks != null) {
    videoUnitGuid.remarks = remarks;
  }
  return videoUnitGuid;
}

Map<String, dynamic> $VideoUnitGuidToJson(VideoUnitGuid entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
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
  return data;
}
