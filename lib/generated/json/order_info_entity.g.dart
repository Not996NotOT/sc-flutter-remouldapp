import 'package:notarization_station_app/generated/json/base/json_convert_content.dart';
import 'package:notarization_station_app/page/home/entity/order_info_entity.dart';

OrderInfoEntity $OrderInfoEntityFromJson(Map<String, dynamic> json) {
  final OrderInfoEntity orderInfoEntity = OrderInfoEntity();
  final String? msg = jsonConvert.convert<String>(json['msg']);
  if (msg != null) {
    orderInfoEntity.msg = msg;
  }
  final OrderInfoItem? item = jsonConvert.convert<OrderInfoItem>(json['item']);
  if (item != null) {
    orderInfoEntity.item = item;
  }
  final int? code = jsonConvert.convert<int>(json['code']);
  if (code != null) {
    orderInfoEntity.code = code;
  }
  return orderInfoEntity;
}

Map<String, dynamic> $OrderInfoEntityToJson(OrderInfoEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['msg'] = entity.msg;
  data['item'] = entity.item.toJson();
  data['code'] = entity.code;
  return data;
}

OrderInfoItem $OrderInfoItemFromJson(Map<String, dynamic> json) {
  final OrderInfoItem orderInfoItem = OrderInfoItem();
  final dynamic? costcompose =
      jsonConvert.convert<dynamic>(json['costcompose']);
  if (costcompose != null) {
    orderInfoItem.costcompose = costcompose;
  }
  final dynamic? materials = jsonConvert.convert<dynamic>(json['materials']);
  if (materials != null) {
    orderInfoItem.materials = materials;
  }
  final dynamic? orderSupplements =
      jsonConvert.convert<dynamic>(json['orderSupplements']);
  if (orderSupplements != null) {
    orderInfoItem.orderSupplements = orderSupplements;
  }
  final List<OrderInfoItemNotaryItem>? notaryItems = jsonConvert
      .convertListNotNull<OrderInfoItemNotaryItem>(json['notaryItems']);
  if (notaryItems != null) {
    orderInfoItem.notaryItems = notaryItems;
  }
  final dynamic? cabinetLogs =
      jsonConvert.convert<dynamic>(json['cabinetLogs']);
  if (cabinetLogs != null) {
    orderInfoItem.cabinetLogs = cabinetLogs;
  }
  final List<OrderInfoItemOrderLog>? orderLogs =
      jsonConvert.convertListNotNull<OrderInfoItemOrderLog>(json['orderLogs']);
  if (orderLogs != null) {
    orderInfoItem.orderLogs = orderLogs;
  }
  final dynamic? videoLog = jsonConvert.convert<dynamic>(json['videoLog']);
  if (videoLog != null) {
    orderInfoItem.videoLog = videoLog;
  }
  final OrderInfoItemUser? user =
      jsonConvert.convert<OrderInfoItemUser>(json['user']);
  if (user != null) {
    orderInfoItem.user = user;
  }
  final List<OrderInfoItemApplyuser>? applyuser =
      jsonConvert.convertListNotNull<OrderInfoItemApplyuser>(json['applyuser']);
  if (applyuser != null) {
    orderInfoItem.applyuser = applyuser;
  }
  final OrderInfoItemOrder? order =
      jsonConvert.convert<OrderInfoItemOrder>(json['order']);
  if (order != null) {
    orderInfoItem.order = order;
  }
  return orderInfoItem;
}

Map<String, dynamic> $OrderInfoItemToJson(OrderInfoItem entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['costcompose'] = entity.costcompose;
  data['materials'] = entity.materials;
  data['orderSupplements'] = entity.orderSupplements;
  data['notaryItems'] = entity.notaryItems.map((v) => v.toJson()).toList();
  data['cabinetLogs'] = entity.cabinetLogs;
  data['orderLogs'] = entity.orderLogs.map((v) => v.toJson()).toList();
  data['videoLog'] = entity.videoLog;
  data['user'] = entity.user.toJson();
  data['applyuser'] = entity.applyuser.map((v) => v.toJson()).toList();
  data['order'] = entity.order.toJson();
  return data;
}

OrderInfoItemNotaryItem $OrderInfoItemNotaryItemFromJson(
    Map<String, dynamic> json) {
  final OrderInfoItemNotaryItem orderInfoItemNotaryItem =
      OrderInfoItemNotaryItem();
  final String? unitGuid = jsonConvert.convert<String>(json['unitGuid']);
  if (unitGuid != null) {
    orderInfoItemNotaryItem.unitGuid = unitGuid;
  }
  final String? notaryItemName =
      jsonConvert.convert<String>(json['notaryItemName']);
  if (notaryItemName != null) {
    orderInfoItemNotaryItem.notaryItemName = notaryItemName;
  }
  final int? notaryNum = jsonConvert.convert<int>(json['notaryNum']);
  if (notaryNum != null) {
    orderInfoItemNotaryItem.notaryNum = notaryNum;
  }
  final String? orderId = jsonConvert.convert<String>(json['orderId']);
  if (orderId != null) {
    orderInfoItemNotaryItem.orderId = orderId;
  }
  final String? notaryItemId =
      jsonConvert.convert<String>(json['notaryItemId']);
  if (notaryItemId != null) {
    orderInfoItemNotaryItem.notaryItemId = notaryItemId;
  }
  final double? price = jsonConvert.convert<double>(json['price']);
  if (price != null) {
    orderInfoItemNotaryItem.price = price;
  }
  final dynamic? createDate = jsonConvert.convert<dynamic>(json['createDate']);
  if (createDate != null) {
    orderInfoItemNotaryItem.createDate = createDate;
  }
  return orderInfoItemNotaryItem;
}

Map<String, dynamic> $OrderInfoItemNotaryItemToJson(
    OrderInfoItemNotaryItem entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['unitGuid'] = entity.unitGuid;
  data['notaryItemName'] = entity.notaryItemName;
  data['notaryNum'] = entity.notaryNum;
  data['orderId'] = entity.orderId;
  data['notaryItemId'] = entity.notaryItemId;
  data['price'] = entity.price;
  data['createDate'] = entity.createDate;
  return data;
}

OrderInfoItemOrderLog $OrderInfoItemOrderLogFromJson(
    Map<String, dynamic> json) {
  final OrderInfoItemOrderLog orderInfoItemOrderLog = OrderInfoItemOrderLog();
  final String? unitGuid = jsonConvert.convert<String>(json['unitGuid']);
  if (unitGuid != null) {
    orderInfoItemOrderLog.unitGuid = unitGuid;
  }
  final String? orderId = jsonConvert.convert<String>(json['orderId']);
  if (orderId != null) {
    orderInfoItemOrderLog.orderId = orderId;
  }
  final int? notaryState = jsonConvert.convert<int>(json['notaryState']);
  if (notaryState != null) {
    orderInfoItemOrderLog.notaryState = notaryState;
  }
  final String? createDate = jsonConvert.convert<String>(json['createDate']);
  if (createDate != null) {
    orderInfoItemOrderLog.createDate = createDate;
  }
  final String? reason = jsonConvert.convert<String>(json['reason']);
  if (reason != null) {
    orderInfoItemOrderLog.reason = reason;
  }
  final String? notaryStateName =
      jsonConvert.convert<String>(json['notaryStateName']);
  if (notaryStateName != null) {
    orderInfoItemOrderLog.notaryStateName = notaryStateName;
  }
  return orderInfoItemOrderLog;
}

Map<String, dynamic> $OrderInfoItemOrderLogToJson(
    OrderInfoItemOrderLog entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['unitGuid'] = entity.unitGuid;
  data['orderId'] = entity.orderId;
  data['notaryState'] = entity.notaryState;
  data['createDate'] = entity.createDate;
  data['reason'] = entity.reason;
  data['notaryStateName'] = entity.notaryStateName;
  return data;
}

OrderInfoItemUser $OrderInfoItemUserFromJson(Map<String, dynamic> json) {
  final OrderInfoItemUser orderInfoItemUser = OrderInfoItemUser();
  final String? unitGuid = jsonConvert.convert<String>(json['unitGuid']);
  if (unitGuid != null) {
    orderInfoItemUser.unitGuid = unitGuid;
  }
  final String? userName = jsonConvert.convert<String>(json['userName']);
  if (userName != null) {
    orderInfoItemUser.userName = userName;
  }
  final String? headIcon = jsonConvert.convert<String>(json['headIcon']);
  if (headIcon != null) {
    orderInfoItemUser.headIcon = headIcon;
  }
  final String? idCard = jsonConvert.convert<String>(json['idCard']);
  if (idCard != null) {
    orderInfoItemUser.idCard = idCard;
  }
  final int? gender = jsonConvert.convert<int>(json['gender']);
  if (gender != null) {
    orderInfoItemUser.gender = gender;
  }
  final String? birthday = jsonConvert.convert<String>(json['birthday']);
  if (birthday != null) {
    orderInfoItemUser.birthday = birthday;
  }
  final String? mobile = jsonConvert.convert<String>(json['mobile']);
  if (mobile != null) {
    orderInfoItemUser.mobile = mobile;
  }
  final String? registeAddress =
      jsonConvert.convert<String>(json['registeAddress']);
  if (registeAddress != null) {
    orderInfoItemUser.registeAddress = registeAddress;
  }
  final String? address = jsonConvert.convert<String>(json['address']);
  if (address != null) {
    orderInfoItemUser.address = address;
  }
  final dynamic? faceImage = jsonConvert.convert<dynamic>(json['faceImage']);
  if (faceImage != null) {
    orderInfoItemUser.faceImage = faceImage;
  }
  final dynamic? cardPositive =
      jsonConvert.convert<dynamic>(json['cardPositive']);
  if (cardPositive != null) {
    orderInfoItemUser.cardPositive = cardPositive;
  }
  final dynamic? cardReverse =
      jsonConvert.convert<dynamic>(json['cardReverse']);
  if (cardReverse != null) {
    orderInfoItemUser.cardReverse = cardReverse;
  }
  final dynamic? fingerPrint =
      jsonConvert.convert<dynamic>(json['fingerPrint']);
  if (fingerPrint != null) {
    orderInfoItemUser.fingerPrint = fingerPrint;
  }
  final String? createDate = jsonConvert.convert<String>(json['createDate']);
  if (createDate != null) {
    orderInfoItemUser.createDate = createDate;
  }
  final int? enabledMark = jsonConvert.convert<int>(json['enabledMark']);
  if (enabledMark != null) {
    orderInfoItemUser.enabledMark = enabledMark;
  }
  final int? deleteMark = jsonConvert.convert<int>(json['deleteMark']);
  if (deleteMark != null) {
    orderInfoItemUser.deleteMark = deleteMark;
  }
  final dynamic? email = jsonConvert.convert<dynamic>(json['email']);
  if (email != null) {
    orderInfoItemUser.email = email;
  }
  final String? nation = jsonConvert.convert<String>(json['nation']);
  if (nation != null) {
    orderInfoItemUser.nation = nation;
  }
  final dynamic? orderId = jsonConvert.convert<dynamic>(json['orderId']);
  if (orderId != null) {
    orderInfoItemUser.orderId = orderId;
  }
  final dynamic? notaryForm = jsonConvert.convert<dynamic>(json['notaryForm']);
  if (notaryForm != null) {
    orderInfoItemUser.notaryForm = notaryForm;
  }
  final dynamic? orderCreateDate =
      jsonConvert.convert<dynamic>(json['orderCreateDate']);
  if (orderCreateDate != null) {
    orderInfoItemUser.orderCreateDate = orderCreateDate;
  }
  final dynamic? terminalType =
      jsonConvert.convert<dynamic>(json['terminalType']);
  if (terminalType != null) {
    orderInfoItemUser.terminalType = terminalType;
  }
  final String? idcardImg = jsonConvert.convert<String>(json['idcardImg']);
  if (idcardImg != null) {
    orderInfoItemUser.idcardImg = idcardImg;
  }
  return orderInfoItemUser;
}

Map<String, dynamic> $OrderInfoItemUserToJson(OrderInfoItemUser entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
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

OrderInfoItemApplyuser $OrderInfoItemApplyuserFromJson(
    Map<String, dynamic> json) {
  final OrderInfoItemApplyuser orderInfoItemApplyuser =
      OrderInfoItemApplyuser();
  final String? unitGuid = jsonConvert.convert<String>(json['unitGuid']);
  if (unitGuid != null) {
    orderInfoItemApplyuser.unitGuid = unitGuid;
  }
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    orderInfoItemApplyuser.name = name;
  }
  final String? relationShip =
      jsonConvert.convert<String>(json['relationShip']);
  if (relationShip != null) {
    orderInfoItemApplyuser.relationShip = relationShip;
  }
  final String? mobile = jsonConvert.convert<String>(json['mobile']);
  if (mobile != null) {
    orderInfoItemApplyuser.mobile = mobile;
  }
  final dynamic? certificateType =
      jsonConvert.convert<dynamic>(json['certificateType']);
  if (certificateType != null) {
    orderInfoItemApplyuser.certificateType = certificateType;
  }
  final String? idCard = jsonConvert.convert<String>(json['idCard']);
  if (idCard != null) {
    orderInfoItemApplyuser.idCard = idCard;
  }
  final String? birthday = jsonConvert.convert<String>(json['birthday']);
  if (birthday != null) {
    orderInfoItemApplyuser.birthday = birthday;
  }
  final String? gender = jsonConvert.convert<String>(json['gender']);
  if (gender != null) {
    orderInfoItemApplyuser.gender = gender;
  }
  final String? address = jsonConvert.convert<String>(json['address']);
  if (address != null) {
    orderInfoItemApplyuser.address = address;
  }
  final String? orderId = jsonConvert.convert<String>(json['orderId']);
  if (orderId != null) {
    orderInfoItemApplyuser.orderId = orderId;
  }
  final dynamic? createDate = jsonConvert.convert<dynamic>(json['createDate']);
  if (createDate != null) {
    orderInfoItemApplyuser.createDate = createDate;
  }
  final dynamic? principal = jsonConvert.convert<dynamic>(json['principal']);
  if (principal != null) {
    orderInfoItemApplyuser.principal = principal;
  }
  return orderInfoItemApplyuser;
}

Map<String, dynamic> $OrderInfoItemApplyuserToJson(
    OrderInfoItemApplyuser entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
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

OrderInfoItemOrder $OrderInfoItemOrderFromJson(Map<String, dynamic> json) {
  final OrderInfoItemOrder orderInfoItemOrder = OrderInfoItemOrder();
  final String? unitGuid = jsonConvert.convert<String>(json['unitGuid']);
  if (unitGuid != null) {
    orderInfoItemOrder.unitGuid = unitGuid;
  }
  final String? createDate = jsonConvert.convert<String>(json['createDate']);
  if (createDate != null) {
    orderInfoItemOrder.createDate = createDate;
  }
  final String? orderNo = jsonConvert.convert<String>(json['orderNo']);
  if (orderNo != null) {
    orderInfoItemOrder.orderNo = orderNo;
  }
  final String? userId = jsonConvert.convert<String>(json['userId']);
  if (userId != null) {
    orderInfoItemOrder.userId = userId;
  }
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    orderInfoItemOrder.name = name;
  }
  final String? useArea = jsonConvert.convert<String>(json['useArea']);
  if (useArea != null) {
    orderInfoItemOrder.useArea = useArea;
  }
  final String? useLanguage = jsonConvert.convert<String>(json['useLanguage']);
  if (useLanguage != null) {
    orderInfoItemOrder.useLanguage = useLanguage;
  }
  final String? purposeName = jsonConvert.convert<String>(json['purposeName']);
  if (purposeName != null) {
    orderInfoItemOrder.purposeName = purposeName;
  }
  final String? notaryId = jsonConvert.convert<String>(json['notaryId']);
  if (notaryId != null) {
    orderInfoItemOrder.notaryId = notaryId;
  }
  final String? notaryName = jsonConvert.convert<String>(json['notaryName']);
  if (notaryName != null) {
    orderInfoItemOrder.notaryName = notaryName;
  }
  final dynamic? greffierId = jsonConvert.convert<dynamic>(json['greffierId']);
  if (greffierId != null) {
    orderInfoItemOrder.greffierId = greffierId;
  }
  final dynamic? greffierName =
      jsonConvert.convert<dynamic>(json['greffierName']);
  if (greffierName != null) {
    orderInfoItemOrder.greffierName = greffierName;
  }
  final int? notaryState = jsonConvert.convert<int>(json['notaryState']);
  if (notaryState != null) {
    orderInfoItemOrder.notaryState = notaryState;
  }
  final dynamic? notaryOrderLogs =
      jsonConvert.convert<dynamic>(json['notaryOrderLogs']);
  if (notaryOrderLogs != null) {
    orderInfoItemOrder.notaryOrderLogs = notaryOrderLogs;
  }
  final String? lastDate = jsonConvert.convert<String>(json['lastDate']);
  if (lastDate != null) {
    orderInfoItemOrder.lastDate = lastDate;
  }
  final int? isDaiBan = jsonConvert.convert<int>(json['isDaiBan']);
  if (isDaiBan != null) {
    orderInfoItemOrder.isDaiBan = isDaiBan;
  }
  final int? notaryForm = jsonConvert.convert<int>(json['notaryForm']);
  if (notaryForm != null) {
    orderInfoItemOrder.notaryForm = notaryForm;
  }
  final String? description = jsonConvert.convert<String>(json['description']);
  if (description != null) {
    orderInfoItemOrder.description = description;
  }
  final double? fee = jsonConvert.convert<double>(json['fee']);
  if (fee != null) {
    orderInfoItemOrder.fee = fee;
  }
  final dynamic? supplementFee =
      jsonConvert.convert<dynamic>(json['supplementFee']);
  if (supplementFee != null) {
    orderInfoItemOrder.supplementFee = supplementFee;
  }
  final dynamic? takeUser = jsonConvert.convert<dynamic>(json['takeUser']);
  if (takeUser != null) {
    orderInfoItemOrder.takeUser = takeUser;
  }
  final dynamic? takeMobile = jsonConvert.convert<dynamic>(json['takeMobile']);
  if (takeMobile != null) {
    orderInfoItemOrder.takeMobile = takeMobile;
  }
  final dynamic? takeAddress =
      jsonConvert.convert<dynamic>(json['takeAddress']);
  if (takeAddress != null) {
    orderInfoItemOrder.takeAddress = takeAddress;
  }
  final dynamic? takeStyle = jsonConvert.convert<dynamic>(json['takeStyle']);
  if (takeStyle != null) {
    orderInfoItemOrder.takeStyle = takeStyle;
  }
  final dynamic? pdfUrl = jsonConvert.convert<dynamic>(json['pdfUrl']);
  if (pdfUrl != null) {
    orderInfoItemOrder.pdfUrl = pdfUrl;
  }
  final dynamic? signatureUrl =
      jsonConvert.convert<dynamic>(json['signatureUrl']);
  if (signatureUrl != null) {
    orderInfoItemOrder.signatureUrl = signatureUrl;
  }
  final dynamic? signName = jsonConvert.convert<dynamic>(json['signName']);
  if (signName != null) {
    orderInfoItemOrder.signName = signName;
  }
  final int? deleteMark = jsonConvert.convert<int>(json['deleteMark']);
  if (deleteMark != null) {
    orderInfoItemOrder.deleteMark = deleteMark;
  }
  final dynamic? terminalType =
      jsonConvert.convert<dynamic>(json['terminalType']);
  if (terminalType != null) {
    orderInfoItemOrder.terminalType = terminalType;
  }
  final String? notaryItemNames =
      jsonConvert.convert<String>(json['notaryItemNames']);
  if (notaryItemNames != null) {
    orderInfoItemOrder.notaryItemNames = notaryItemNames;
  }
  final String? notaryStateName =
      jsonConvert.convert<String>(json['notaryStateName']);
  if (notaryStateName != null) {
    orderInfoItemOrder.notaryStateName = notaryStateName;
  }
  final dynamic? enquire = jsonConvert.convert<dynamic>(json['enquire']);
  if (enquire != null) {
    orderInfoItemOrder.enquire = enquire;
  }
  final dynamic? scanFiles = jsonConvert.convert<dynamic>(json['scanFiles']);
  if (scanFiles != null) {
    orderInfoItemOrder.scanFiles = scanFiles;
  }
  final dynamic? userSaveVideo =
      jsonConvert.convert<dynamic>(json['userSaveVideo']);
  if (userSaveVideo != null) {
    orderInfoItemOrder.userSaveVideo = userSaveVideo;
  }
  final dynamic? userTakeVideo =
      jsonConvert.convert<dynamic>(json['userTakeVideo']);
  if (userTakeVideo != null) {
    orderInfoItemOrder.userTakeVideo = userTakeVideo;
  }
  final dynamic? notarySaveVideo =
      jsonConvert.convert<dynamic>(json['notarySaveVideo']);
  if (notarySaveVideo != null) {
    orderInfoItemOrder.notarySaveVideo = notarySaveVideo;
  }
  final dynamic? notaryTakeVideo =
      jsonConvert.convert<dynamic>(json['notaryTakeVideo']);
  if (notaryTakeVideo != null) {
    orderInfoItemOrder.notaryTakeVideo = notaryTakeVideo;
  }
  final dynamic? materialPdf =
      jsonConvert.convert<dynamic>(json['materialPdf']);
  if (materialPdf != null) {
    orderInfoItemOrder.materialPdf = materialPdf;
  }
  final dynamic? certificationAdd =
      jsonConvert.convert<dynamic>(json['certificationAdd']);
  if (certificationAdd != null) {
    orderInfoItemOrder.certificationAdd = certificationAdd;
  }
  final dynamic? statutoryPerson =
      jsonConvert.convert<dynamic>(json['statutoryPerson']);
  if (statutoryPerson != null) {
    orderInfoItemOrder.statutoryPerson = statutoryPerson;
  }
  final dynamic? companyName =
      jsonConvert.convert<dynamic>(json['companyName']);
  if (companyName != null) {
    orderInfoItemOrder.companyName = companyName;
  }
  final dynamic? companyAdd = jsonConvert.convert<dynamic>(json['companyAdd']);
  if (companyAdd != null) {
    orderInfoItemOrder.companyAdd = companyAdd;
  }
  final dynamic? statutoryMobile =
      jsonConvert.convert<dynamic>(json['statutoryMobile']);
  if (statutoryMobile != null) {
    orderInfoItemOrder.statutoryMobile = statutoryMobile;
  }
  final dynamic? wordId = jsonConvert.convert<dynamic>(json['wordId']);
  if (wordId != null) {
    orderInfoItemOrder.wordId = wordId;
  }
  final dynamic? lattice = jsonConvert.convert<dynamic>(json['lattice']);
  if (lattice != null) {
    orderInfoItemOrder.lattice = lattice;
  }
  final dynamic? materialName =
      jsonConvert.convert<dynamic>(json['materialName']);
  if (materialName != null) {
    orderInfoItemOrder.materialName = materialName;
  }
  final dynamic? notaryItemName =
      jsonConvert.convert<dynamic>(json['notaryItemName']);
  if (notaryItemName != null) {
    orderInfoItemOrder.notaryItemName = notaryItemName;
  }
  final dynamic? companyList =
      jsonConvert.convert<dynamic>(json['companyList']);
  if (companyList != null) {
    orderInfoItemOrder.companyList = companyList;
  }
  final dynamic? roomId = jsonConvert.convert<dynamic>(json['roomId']);
  if (roomId != null) {
    orderInfoItemOrder.roomId = roomId;
  }
  final List<dynamic>? signatureUrlList =
      jsonConvert.convertListNotNull<dynamic>(json['signatureUrlList']);
  if (signatureUrlList != null) {
    orderInfoItemOrder.signatureUrlList = signatureUrlList;
  }
  final List<dynamic>? pdfUrlList =
      jsonConvert.convertListNotNull<dynamic>(json['pdfUrlList']);
  if (pdfUrlList != null) {
    orderInfoItemOrder.pdfUrlList = pdfUrlList;
  }
  final dynamic? code = jsonConvert.convert<dynamic>(json['code']);
  if (code != null) {
    orderInfoItemOrder.code = code;
  }
  final dynamic? payType = jsonConvert.convert<dynamic>(json['payType']);
  if (payType != null) {
    orderInfoItemOrder.payType = payType;
  }
  final List<dynamic>? pay =
      jsonConvert.convertListNotNull<dynamic>(json['pay']);
  if (pay != null) {
    orderInfoItemOrder.pay = pay;
  }
  final dynamic? thirdPartyIdCard =
      jsonConvert.convert<dynamic>(json['thirdPartyIdCard']);
  if (thirdPartyIdCard != null) {
    orderInfoItemOrder.thirdPartyIdCard = thirdPartyIdCard;
  }
  final dynamic? thirdPartyMob =
      jsonConvert.convert<dynamic>(json['thirdPartyMob']);
  if (thirdPartyMob != null) {
    orderInfoItemOrder.thirdPartyMob = thirdPartyMob;
  }
  final dynamic? thirdPartyName =
      jsonConvert.convert<dynamic>(json['thirdPartyName']);
  if (thirdPartyName != null) {
    orderInfoItemOrder.thirdPartyName = thirdPartyName;
  }
  final dynamic? notaryNum = jsonConvert.convert<dynamic>(json['notaryNum']);
  if (notaryNum != null) {
    orderInfoItemOrder.notaryNum = notaryNum;
  }
  final dynamic? certificate =
      jsonConvert.convert<dynamic>(json['certificate']);
  if (certificate != null) {
    orderInfoItemOrder.certificate = certificate;
  }
  final dynamic? wordUrl = jsonConvert.convert<dynamic>(json['wordUrl']);
  if (wordUrl != null) {
    orderInfoItemOrder.wordUrl = wordUrl;
  }
  final List<dynamic>? certificatePathList =
      jsonConvert.convertListNotNull<dynamic>(json['certificatePathList']);
  if (certificatePathList != null) {
    orderInfoItemOrder.certificatePathList = certificatePathList;
  }
  final dynamic? secretKey = jsonConvert.convert<dynamic>(json['secretKey']);
  if (secretKey != null) {
    orderInfoItemOrder.secretKey = secretKey;
  }
  final dynamic? encDataFilePath =
      jsonConvert.convert<dynamic>(json['encDataFilePath']);
  if (encDataFilePath != null) {
    orderInfoItemOrder.encDataFilePath = encDataFilePath;
  }
  final dynamic? confirm = jsonConvert.convert<dynamic>(json['confirm']);
  if (confirm != null) {
    orderInfoItemOrder.confirm = confirm;
  }
  final dynamic? materialList =
      jsonConvert.convert<dynamic>(json['materialList']);
  if (materialList != null) {
    orderInfoItemOrder.materialList = materialList;
  }
  final dynamic? materUrlList =
      jsonConvert.convert<dynamic>(json['materUrlList']);
  if (materUrlList != null) {
    orderInfoItemOrder.materUrlList = materUrlList;
  }
  final dynamic? remarks = jsonConvert.convert<dynamic>(json['remarks']);
  if (remarks != null) {
    orderInfoItemOrder.remarks = remarks;
  }
  final dynamic? similarityPdf =
      jsonConvert.convert<dynamic>(json['similarityPdf']);
  if (similarityPdf != null) {
    orderInfoItemOrder.similarityPdf = similarityPdf;
  }
  return orderInfoItemOrder;
}

Map<String, dynamic> $OrderInfoItemOrderToJson(OrderInfoItemOrder entity) {
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
  return data;
}
