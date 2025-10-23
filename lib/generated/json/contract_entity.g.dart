import 'package:notarization_station_app/generated/json/base/json_convert_content.dart';
import 'package:notarization_station_app/page/home/entity/contract_entity.dart';

ContractEntity $ContractEntityFromJson(Map<String, dynamic> json) {
  final ContractEntity contractEntity = ContractEntity();
  final String? unitGuid = jsonConvert.convert<String>(json['unitGuid']);
  if (unitGuid != null) {
    contractEntity.unitGuid = unitGuid;
  }
  final String? createDate = jsonConvert.convert<String>(json['createDate']);
  if (createDate != null) {
    contractEntity.createDate = createDate;
  }
  final String? orderNo = jsonConvert.convert<String>(json['orderNo']);
  if (orderNo != null) {
    contractEntity.orderNo = orderNo;
  }
  final String? userId = jsonConvert.convert<String>(json['userId']);
  if (userId != null) {
    contractEntity.userId = userId;
  }
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    contractEntity.name = name;
  }
  final String? useArea = jsonConvert.convert<String>(json['useArea']);
  if (useArea != null) {
    contractEntity.useArea = useArea;
  }
  final String? useLanguage = jsonConvert.convert<String>(json['useLanguage']);
  if (useLanguage != null) {
    contractEntity.useLanguage = useLanguage;
  }
  final String? purposeName = jsonConvert.convert<String>(json['purposeName']);
  if (purposeName != null) {
    contractEntity.purposeName = purposeName;
  }
  final String? notaryId = jsonConvert.convert<String>(json['notaryId']);
  if (notaryId != null) {
    contractEntity.notaryId = notaryId;
  }
  final String? notaryName = jsonConvert.convert<String>(json['notaryName']);
  if (notaryName != null) {
    contractEntity.notaryName = notaryName;
  }
  final dynamic? greffierId = jsonConvert.convert<dynamic>(json['greffierId']);
  if (greffierId != null) {
    contractEntity.greffierId = greffierId;
  }
  final dynamic? greffierName =
      jsonConvert.convert<dynamic>(json['greffierName']);
  if (greffierName != null) {
    contractEntity.greffierName = greffierName;
  }
  final int? notaryState = jsonConvert.convert<int>(json['notaryState']);
  if (notaryState != null) {
    contractEntity.notaryState = notaryState;
  }
  final dynamic? notaryOrderLogs =
      jsonConvert.convert<dynamic>(json['notaryOrderLogs']);
  if (notaryOrderLogs != null) {
    contractEntity.notaryOrderLogs = notaryOrderLogs;
  }
  final String? lastDate = jsonConvert.convert<String>(json['lastDate']);
  if (lastDate != null) {
    contractEntity.lastDate = lastDate;
  }
  final int? isDaiBan = jsonConvert.convert<int>(json['isDaiBan']);
  if (isDaiBan != null) {
    contractEntity.isDaiBan = isDaiBan;
  }
  final int? notaryForm = jsonConvert.convert<int>(json['notaryForm']);
  if (notaryForm != null) {
    contractEntity.notaryForm = notaryForm;
  }
  final String? description = jsonConvert.convert<String>(json['description']);
  if (description != null) {
    contractEntity.description = description;
  }
  final dynamic? fee = jsonConvert.convert<dynamic>(json['fee']);
  if (fee != null) {
    contractEntity.fee = fee;
  }
  final dynamic? supplementFee =
      jsonConvert.convert<dynamic>(json['supplementFee']);
  if (supplementFee != null) {
    contractEntity.supplementFee = supplementFee;
  }
  final dynamic? takeUser = jsonConvert.convert<dynamic>(json['takeUser']);
  if (takeUser != null) {
    contractEntity.takeUser = takeUser;
  }
  final dynamic? takeMobile = jsonConvert.convert<dynamic>(json['takeMobile']);
  if (takeMobile != null) {
    contractEntity.takeMobile = takeMobile;
  }
  final dynamic? takeAddress =
      jsonConvert.convert<dynamic>(json['takeAddress']);
  if (takeAddress != null) {
    contractEntity.takeAddress = takeAddress;
  }
  final dynamic? takeStyle = jsonConvert.convert<dynamic>(json['takeStyle']);
  if (takeStyle != null) {
    contractEntity.takeStyle = takeStyle;
  }
  final dynamic? pdfUrl = jsonConvert.convert<dynamic>(json['pdfUrl']);
  if (pdfUrl != null) {
    contractEntity.pdfUrl = pdfUrl;
  }
  final dynamic? signatureUrl =
      jsonConvert.convert<dynamic>(json['signatureUrl']);
  if (signatureUrl != null) {
    contractEntity.signatureUrl = signatureUrl;
  }
  final dynamic? signName = jsonConvert.convert<dynamic>(json['signName']);
  if (signName != null) {
    contractEntity.signName = signName;
  }
  final int? deleteMark = jsonConvert.convert<int>(json['deleteMark']);
  if (deleteMark != null) {
    contractEntity.deleteMark = deleteMark;
  }
  final int? terminalType = jsonConvert.convert<int>(json['terminalType']);
  if (terminalType != null) {
    contractEntity.terminalType = terminalType;
  }
  final dynamic? notaryItemNames =
      jsonConvert.convert<dynamic>(json['notaryItemNames']);
  if (notaryItemNames != null) {
    contractEntity.notaryItemNames = notaryItemNames;
  }
  final dynamic? notaryStateName =
      jsonConvert.convert<dynamic>(json['notaryStateName']);
  if (notaryStateName != null) {
    contractEntity.notaryStateName = notaryStateName;
  }
  final dynamic? enquire = jsonConvert.convert<dynamic>(json['enquire']);
  if (enquire != null) {
    contractEntity.enquire = enquire;
  }
  final dynamic? scanFiles = jsonConvert.convert<dynamic>(json['scanFiles']);
  if (scanFiles != null) {
    contractEntity.scanFiles = scanFiles;
  }
  final dynamic? userSaveVideo =
      jsonConvert.convert<dynamic>(json['userSaveVideo']);
  if (userSaveVideo != null) {
    contractEntity.userSaveVideo = userSaveVideo;
  }
  final dynamic? userTakeVideo =
      jsonConvert.convert<dynamic>(json['userTakeVideo']);
  if (userTakeVideo != null) {
    contractEntity.userTakeVideo = userTakeVideo;
  }
  final dynamic? notarySaveVideo =
      jsonConvert.convert<dynamic>(json['notarySaveVideo']);
  if (notarySaveVideo != null) {
    contractEntity.notarySaveVideo = notarySaveVideo;
  }
  final dynamic? notaryTakeVideo =
      jsonConvert.convert<dynamic>(json['notaryTakeVideo']);
  if (notaryTakeVideo != null) {
    contractEntity.notaryTakeVideo = notaryTakeVideo;
  }
  final dynamic? materialPdf =
      jsonConvert.convert<dynamic>(json['materialPdf']);
  if (materialPdf != null) {
    contractEntity.materialPdf = materialPdf;
  }
  final dynamic? certificationAdd =
      jsonConvert.convert<dynamic>(json['certificationAdd']);
  if (certificationAdd != null) {
    contractEntity.certificationAdd = certificationAdd;
  }
  final dynamic? statutoryPerson =
      jsonConvert.convert<dynamic>(json['statutoryPerson']);
  if (statutoryPerson != null) {
    contractEntity.statutoryPerson = statutoryPerson;
  }
  final dynamic? companyName =
      jsonConvert.convert<dynamic>(json['companyName']);
  if (companyName != null) {
    contractEntity.companyName = companyName;
  }
  final dynamic? companyAdd = jsonConvert.convert<dynamic>(json['companyAdd']);
  if (companyAdd != null) {
    contractEntity.companyAdd = companyAdd;
  }
  final dynamic? statutoryMobile =
      jsonConvert.convert<dynamic>(json['statutoryMobile']);
  if (statutoryMobile != null) {
    contractEntity.statutoryMobile = statutoryMobile;
  }
  final dynamic? wordId = jsonConvert.convert<dynamic>(json['wordId']);
  if (wordId != null) {
    contractEntity.wordId = wordId;
  }
  final dynamic? lattice = jsonConvert.convert<dynamic>(json['lattice']);
  if (lattice != null) {
    contractEntity.lattice = lattice;
  }
  final dynamic? materialName =
      jsonConvert.convert<dynamic>(json['materialName']);
  if (materialName != null) {
    contractEntity.materialName = materialName;
  }
  final dynamic? notaryItemName =
      jsonConvert.convert<dynamic>(json['notaryItemName']);
  if (notaryItemName != null) {
    contractEntity.notaryItemName = notaryItemName;
  }
  final dynamic? companyList =
      jsonConvert.convert<dynamic>(json['companyList']);
  if (companyList != null) {
    contractEntity.companyList = companyList;
  }
  final dynamic? roomId = jsonConvert.convert<dynamic>(json['roomId']);
  if (roomId != null) {
    contractEntity.roomId = roomId;
  }
  final dynamic? signatureUrlList =
      jsonConvert.convert<dynamic>(json['signatureUrlList']);
  if (signatureUrlList != null) {
    contractEntity.signatureUrlList = signatureUrlList;
  }
  final dynamic? pdfUrlList = jsonConvert.convert<dynamic>(json['pdfUrlList']);
  if (pdfUrlList != null) {
    contractEntity.pdfUrlList = pdfUrlList;
  }
  final int? code = jsonConvert.convert<int>(json['code']);
  if (code != null) {
    contractEntity.code = code;
  }
  final dynamic? payType = jsonConvert.convert<dynamic>(json['payType']);
  if (payType != null) {
    contractEntity.payType = payType;
  }
  final dynamic? pay = jsonConvert.convert<dynamic>(json['pay']);
  if (pay != null) {
    contractEntity.pay = pay;
  }
  final String? thirdPartyIdCard =
      jsonConvert.convert<String>(json['thirdPartyIdCard']);
  if (thirdPartyIdCard != null) {
    contractEntity.thirdPartyIdCard = thirdPartyIdCard;
  }
  final String? thirdPartyMob =
      jsonConvert.convert<String>(json['thirdPartyMob']);
  if (thirdPartyMob != null) {
    contractEntity.thirdPartyMob = thirdPartyMob;
  }
  final String? thirdPartyName =
      jsonConvert.convert<String>(json['thirdPartyName']);
  if (thirdPartyName != null) {
    contractEntity.thirdPartyName = thirdPartyName;
  }
  final dynamic? notaryNum = jsonConvert.convert<dynamic>(json['notaryNum']);
  if (notaryNum != null) {
    contractEntity.notaryNum = notaryNum;
  }
  final dynamic? certificate =
      jsonConvert.convert<dynamic>(json['certificate']);
  if (certificate != null) {
    contractEntity.certificate = certificate;
  }
  final dynamic? wordUrl = jsonConvert.convert<dynamic>(json['wordUrl']);
  if (wordUrl != null) {
    contractEntity.wordUrl = wordUrl;
  }
  final dynamic? certificatePathList =
      jsonConvert.convert<dynamic>(json['certificatePathList']);
  if (certificatePathList != null) {
    contractEntity.certificatePathList = certificatePathList;
  }
  final dynamic? secretKey = jsonConvert.convert<dynamic>(json['secretKey']);
  if (secretKey != null) {
    contractEntity.secretKey = secretKey;
  }
  final dynamic? encDataFilePath =
      jsonConvert.convert<dynamic>(json['encDataFilePath']);
  if (encDataFilePath != null) {
    contractEntity.encDataFilePath = encDataFilePath;
  }
  final int? confirm = jsonConvert.convert<int>(json['confirm']);
  if (confirm != null) {
    contractEntity.confirm = confirm;
  }
  final dynamic? materialList =
      jsonConvert.convert<dynamic>(json['materialList']);
  if (materialList != null) {
    contractEntity.materialList = materialList;
  }
  final dynamic? materUrlList =
      jsonConvert.convert<dynamic>(json['materUrlList']);
  if (materUrlList != null) {
    contractEntity.materUrlList = materUrlList;
  }
  final dynamic? remarks = jsonConvert.convert<dynamic>(json['remarks']);
  if (remarks != null) {
    contractEntity.remarks = remarks;
  }
  final dynamic? similarityPdf =
      jsonConvert.convert<dynamic>(json['similarityPdf']);
  if (similarityPdf != null) {
    contractEntity.similarityPdf = similarityPdf;
  }
  final dynamic? macAddress = jsonConvert.convert<dynamic>(json['macAddress']);
  if (macAddress != null) {
    contractEntity.macAddress = macAddress;
  }
  final dynamic? bankorder = jsonConvert.convert<dynamic>(json['bankorder']);
  if (bankorder != null) {
    contractEntity.bankorder = bankorder;
  }
  return contractEntity;
}

Map<String, dynamic> $ContractEntityToJson(ContractEntity entity) {
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
  data['similarityPdf'] = entity.similarityPdf;
  data['macAddress'] = entity.macAddress;
  data['bankorder'] = entity.bankorder;
  return data;
}
