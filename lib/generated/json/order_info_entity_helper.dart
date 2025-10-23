import 'package:notarization_station_app/page/home/entity/order_info_entity.dart';

orderInfoEntityFromJson(OrderInfoEntity data, Map<String, dynamic> json) {
  if (json['msg'] != null) {
    data.msg = json['msg'].toString();
  }
  if (json['item'] != null) {
    data.item = OrderInfoItem().fromJson(json['item']);
  }
  if (json['code'] != null) {
    data.code = json['code'] is String
        ? int.tryParse(json['code'])
        : json['code'].toInt();
  }
  return data;
}

Map<String, dynamic> orderInfoEntityToJson(OrderInfoEntity entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['msg'] = entity.msg;
  data['item'] = entity.item?.toJson();
  data['code'] = entity.code;
  return data;
}

orderInfoItemFromJson(OrderInfoItem data, Map<String, dynamic> json) {
  if (json['costcompose'] != null) {
    data.costcompose = json['costcompose'];
  }
  if (json['materials'] != null) {
    data.materials = json['materials'];
  }
  if (json['orderSupplements'] != null) {
    data.orderSupplements = json['orderSupplements'];
  }
  if (json['notaryItems'] != null) {
    data.notaryItems = (json['notaryItems'] as List)
        .map((v) => OrderInfoItemNotaryItem().fromJson(v))
        .toList();
  }
  if (json['cabinetLogs'] != null) {
    data.cabinetLogs = json['cabinetLogs'];
  }
  if (json['orderLogs'] != null) {
    data.orderLogs = (json['orderLogs'] as List)
        .map((v) => OrderInfoItemOrderLog().fromJson(v))
        .toList();
  }
  if (json['videoLog'] != null) {
    data.videoLog = json['videoLog'];
  }
  if (json['user'] != null) {
    data.user = OrderInfoItemUser().fromJson(json['user']);
  }
  if (json['applyuser'] != null) {
    data.applyuser = (json['applyuser'] as List)
        .map((v) => OrderInfoItemApplyuser().fromJson(v))
        .toList();
  }
  if (json['order'] != null) {
    data.order = OrderInfoItemOrder().fromJson(json['order']);
  }
  return data;
}

Map<String, dynamic> orderInfoItemToJson(OrderInfoItem entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['costcompose'] = entity.costcompose;
  data['materials'] = entity.materials;
  data['orderSupplements'] = entity.orderSupplements;
  data['notaryItems'] = entity.notaryItems?.map((v) => v.toJson())?.toList();
  data['cabinetLogs'] = entity.cabinetLogs;
  data['orderLogs'] = entity.orderLogs?.map((v) => v.toJson())?.toList();
  data['videoLog'] = entity.videoLog;
  data['user'] = entity.user?.toJson();
  data['applyuser'] = entity.applyuser?.map((v) => v.toJson())?.toList();
  data['order'] = entity.order?.toJson();
  return data;
}

orderInfoItemNotaryItemFromJson(
    OrderInfoItemNotaryItem data, Map<String, dynamic> json) {
  if (json['unitGuid'] != null) {
    data.unitGuid = json['unitGuid'].toString();
  }
  if (json['notaryItemName'] != null) {
    data.notaryItemName = json['notaryItemName'].toString();
  }
  if (json['notaryNum'] != null) {
    data.notaryNum = json['notaryNum'] is String
        ? int.tryParse(json['notaryNum'])
        : json['notaryNum'].toInt();
  }
  if (json['orderId'] != null) {
    data.orderId = json['orderId'].toString();
  }
  if (json['notaryItemId'] != null) {
    data.notaryItemId = json['notaryItemId'].toString();
  }
  if (json['price'] != null) {
    data.price = json['price'] is String
        ? double.tryParse(json['price'])
        : json['price'].toDouble();
  }
  if (json['createDate'] != null) {
    data.createDate = json['createDate'];
  }
  return data;
}

Map<String, dynamic> orderInfoItemNotaryItemToJson(
    OrderInfoItemNotaryItem entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['unitGuid'] = entity.unitGuid;
  data['notaryItemName'] = entity.notaryItemName;
  data['notaryNum'] = entity.notaryNum;
  data['orderId'] = entity.orderId;
  data['notaryItemId'] = entity.notaryItemId;
  data['price'] = entity.price;
  data['createDate'] = entity.createDate;
  return data;
}

orderInfoItemOrderLogFromJson(
    OrderInfoItemOrderLog data, Map<String, dynamic> json) {
  if (json['unitGuid'] != null) {
    data.unitGuid = json['unitGuid'].toString();
  }
  if (json['orderId'] != null) {
    data.orderId = json['orderId'].toString();
  }
  if (json['notaryState'] != null) {
    data.notaryState = json['notaryState'] is String
        ? int.tryParse(json['notaryState'])
        : json['notaryState'].toInt();
  }
  if (json['createDate'] != null) {
    data.createDate = json['createDate'].toString();
  }
  if (json['reason'] != null) {
    data.reason = json['reason'].toString();
  }
  if (json['notaryStateName'] != null) {
    data.notaryStateName = json['notaryStateName'].toString();
  }
  return data;
}

Map<String, dynamic> orderInfoItemOrderLogToJson(OrderInfoItemOrderLog entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['unitGuid'] = entity.unitGuid;
  data['orderId'] = entity.orderId;
  data['notaryState'] = entity.notaryState;
  data['createDate'] = entity.createDate;
  data['reason'] = entity.reason;
  data['notaryStateName'] = entity.notaryStateName;
  return data;
}

orderInfoItemUserFromJson(OrderInfoItemUser data, Map<String, dynamic> json) {
  if (json['unitGuid'] != null) {
    data.unitGuid = json['unitGuid'].toString();
  }
  if (json['userName'] != null) {
    data.userName = json['userName'].toString();
  }
  if (json['headIcon'] != null) {
    data.headIcon = json['headIcon'].toString();
  }
  if (json['idCard'] != null) {
    data.idCard = json['idCard'].toString();
  }
  if (json['gender'] != null) {
    data.gender = json['gender'] is String
        ? int.tryParse(json['gender'])
        : json['gender'].toInt();
  }
  if (json['birthday'] != null) {
    data.birthday = json['birthday'].toString();
  }
  if (json['mobile'] != null) {
    data.mobile = json['mobile'].toString();
  }
  if (json['registeAddress'] != null) {
    data.registeAddress = json['registeAddress'].toString();
  }
  if (json['address'] != null) {
    data.address = json['address'].toString();
  }
  if (json['faceImage'] != null) {
    data.faceImage = json['faceImage'];
  }
  if (json['cardPositive'] != null) {
    data.cardPositive = json['cardPositive'];
  }
  if (json['cardReverse'] != null) {
    data.cardReverse = json['cardReverse'];
  }
  if (json['fingerPrint'] != null) {
    data.fingerPrint = json['fingerPrint'];
  }
  if (json['createDate'] != null) {
    data.createDate = json['createDate'].toString();
  }
  if (json['enabledMark'] != null) {
    data.enabledMark = json['enabledMark'] is String
        ? int.tryParse(json['enabledMark'])
        : json['enabledMark'].toInt();
  }
  if (json['deleteMark'] != null) {
    data.deleteMark = json['deleteMark'] is String
        ? int.tryParse(json['deleteMark'])
        : json['deleteMark'].toInt();
  }
  if (json['email'] != null) {
    data.email = json['email'];
  }
  if (json['nation'] != null) {
    data.nation = json['nation'].toString();
  }
  if (json['orderId'] != null) {
    data.orderId = json['orderId'];
  }
  if (json['notaryForm'] != null) {
    data.notaryForm = json['notaryForm'];
  }
  if (json['orderCreateDate'] != null) {
    data.orderCreateDate = json['orderCreateDate'];
  }
  if (json['terminalType'] != null) {
    data.terminalType = json['terminalType'];
  }
  if (json['idcardImg'] != null) {
    data.idcardImg = json['idcardImg'].toString();
  }
  return data;
}

Map<String, dynamic> orderInfoItemUserToJson(OrderInfoItemUser entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['unitGuid'] = entity.unitGuid;
  data['userName'] = entity.userName;
  data['headIcon'] = entity.headIcon;
  data['idCard'] = entity.idCard;
  data['gender'] = entity.gender;
  data['birthday'] = entity.birthday;
  data['mobile'] = entity.mobile;
  data['registeAddress'] = entity.registeAddress;
  data['address'] = entity.address;
  data['faceImage'] = entity.faceImage;
  data['cardPositive'] = entity.cardPositive;
  data['cardReverse'] = entity.cardReverse;
  data['fingerPrint'] = entity.fingerPrint;
  data['createDate'] = entity.createDate;
  data['enabledMark'] = entity.enabledMark;
  data['deleteMark'] = entity.deleteMark;
  data['email'] = entity.email;
  data['nation'] = entity.nation;
  data['orderId'] = entity.orderId;
  data['notaryForm'] = entity.notaryForm;
  data['orderCreateDate'] = entity.orderCreateDate;
  data['terminalType'] = entity.terminalType;
  data['idcardImg'] = entity.idcardImg;
  return data;
}

orderInfoItemApplyuserFromJson(
    OrderInfoItemApplyuser data, Map<String, dynamic> json) {
  if (json['unitGuid'] != null) {
    data.unitGuid = json['unitGuid'].toString();
  }
  if (json['name'] != null) {
    data.name = json['name'].toString();
  }
  if (json['relationShip'] != null) {
    data.relationShip = json['relationShip'].toString();
  }
  if (json['mobile'] != null) {
    data.mobile = json['mobile'].toString();
  }
  if (json['certificateType'] != null) {
    data.certificateType = json['certificateType'];
  }
  if (json['idCard'] != null) {
    data.idCard = json['idCard'].toString();
  }
  if (json['birthday'] != null) {
    data.birthday = json['birthday'].toString();
  }
  if (json['gender'] != null) {
    data.gender = json['gender'].toString();
  }
  if (json['address'] != null) {
    data.address = json['address'].toString();
  }
  if (json['orderId'] != null) {
    data.orderId = json['orderId'].toString();
  }
  if (json['createDate'] != null) {
    data.createDate = json['createDate'];
  }
  if (json['principal'] != null) {
    data.principal = json['principal'];
  }
  return data;
}

Map<String, dynamic> orderInfoItemApplyuserToJson(
    OrderInfoItemApplyuser entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['unitGuid'] = entity.unitGuid;
  data['name'] = entity.name;
  data['relationShip'] = entity.relationShip;
  data['mobile'] = entity.mobile;
  data['certificateType'] = entity.certificateType;
  data['idCard'] = entity.idCard;
  data['birthday'] = entity.birthday;
  data['gender'] = entity.gender;
  data['address'] = entity.address;
  data['orderId'] = entity.orderId;
  data['createDate'] = entity.createDate;
  data['principal'] = entity.principal;
  return data;
}

orderInfoItemOrderFromJson(OrderInfoItemOrder data, Map<String, dynamic> json) {
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
    data.fee = json['fee'] is String
        ? double.tryParse(json['fee'])
        : json['fee'].toDouble();
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
    data.terminalType = json['terminalType'];
  }
  if (json['notaryItemNames'] != null) {
    data.notaryItemNames = json['notaryItemNames'].toString();
  }
  if (json['notaryStateName'] != null) {
    data.notaryStateName = json['notaryStateName'].toString();
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
    data.signatureUrlList = (json['signatureUrlList'] as List)
        .map((v) => v)
        .toList()
        .cast<dynamic>();
  }
  if (json['pdfUrlList'] != null) {
    data.pdfUrlList =
        (json['pdfUrlList'] as List).map((v) => v).toList().cast<dynamic>();
  }
  if (json['code'] != null) {
    data.code = json['code'];
  }
  if (json['payType'] != null) {
    data.payType = json['payType'];
  }
  if (json['pay'] != null) {
    data.pay = (json['pay'] as List).map((v) => v).toList().cast<dynamic>();
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
    data.certificatePathList = (json['certificatePathList'] as List)
        .map((v) => v)
        .toList()
        .cast<dynamic>();
  }
  if (json['secretKey'] != null) {
    data.secretKey = json['secretKey'];
  }
  if (json['encDataFilePath'] != null) {
    data.encDataFilePath = json['encDataFilePath'];
  }
  if (json['confirm'] != null) {
    data.confirm = json['confirm'];
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
  if (json['similarityPdf'] != null) {
    data.similarityPdf = json['similarityPdf'];
  }
  return data;
}

Map<String, dynamic> orderInfoItemOrderToJson(OrderInfoItemOrder entity) {
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
  data['similarityPdf'] = entity.similarityPdf;
  return data;
}
