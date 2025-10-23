import 'package:notarization_station_app/generated/json/base/json_convert_content.dart';

class OrderInfoEntity with JsonConvert<OrderInfoEntity> {
  String msg;
  OrderInfoItem item;
  int code;
}

class OrderInfoItem with JsonConvert<OrderInfoItem> {
  dynamic costcompose;
  dynamic materials;
  dynamic orderSupplements;
  List<OrderInfoItemNotaryItem> notaryItems;
  dynamic cabinetLogs;
  List<OrderInfoItemOrderLog> orderLogs;
  dynamic videoLog;
  OrderInfoItemUser user;
  List<OrderInfoItemApplyuser> applyuser;
  OrderInfoItemOrder order;
}

class OrderInfoItemNotaryItem with JsonConvert<OrderInfoItemNotaryItem> {
  String unitGuid;
  String notaryItemName;
  int notaryNum;
  String orderId;
  String notaryItemId;
  double price;
  dynamic createDate;
}

class OrderInfoItemOrderLog with JsonConvert<OrderInfoItemOrderLog> {
  String unitGuid;
  String orderId;
  int notaryState;
  String createDate;
  String reason;
  String notaryStateName;
}

class OrderInfoItemUser with JsonConvert<OrderInfoItemUser> {
  String unitGuid;
  String userName;
  String headIcon;
  String idCard;
  int gender;
  String birthday;
  String mobile;
  String registeAddress;
  String address;
  dynamic faceImage;
  dynamic cardPositive;
  dynamic cardReverse;
  dynamic fingerPrint;
  String createDate;
  int enabledMark;
  int deleteMark;
  dynamic email;
  String nation;
  dynamic orderId;
  dynamic notaryForm;
  dynamic orderCreateDate;
  dynamic terminalType;
  String idcardImg;
}

class OrderInfoItemApplyuser with JsonConvert<OrderInfoItemApplyuser> {
  String unitGuid;
  String name;
  String relationShip;
  String mobile;
  dynamic certificateType;
  String idCard;
  String birthday;
  String gender;
  String address;
  String orderId;
  dynamic createDate;
  dynamic principal;
}

class OrderInfoItemOrder with JsonConvert<OrderInfoItemOrder> {
  String unitGuid;
  String createDate;
  String orderNo;
  String userId;
  String name;
  String useArea;
  String useLanguage;
  String purposeName;
  String notaryId;
  String notaryName;
  dynamic greffierId;
  dynamic greffierName;
  int notaryState;
  dynamic notaryOrderLogs;
  String lastDate;
  int isDaiBan;
  int notaryForm;
  String description;
  double fee;
  dynamic supplementFee;
  dynamic takeUser;
  dynamic takeMobile;
  dynamic takeAddress;
  dynamic takeStyle;
  dynamic pdfUrl;
  dynamic signatureUrl;
  dynamic signName;
  int deleteMark;
  dynamic terminalType;
  String notaryItemNames;
  String notaryStateName;
  dynamic enquire;
  dynamic scanFiles;
  dynamic userSaveVideo;
  dynamic userTakeVideo;
  dynamic notarySaveVideo;
  dynamic notaryTakeVideo;
  dynamic materialPdf;
  dynamic certificationAdd;
  dynamic statutoryPerson;
  dynamic companyName;
  dynamic companyAdd;
  dynamic statutoryMobile;
  dynamic wordId;
  dynamic lattice;
  dynamic materialName;
  dynamic notaryItemName;
  dynamic companyList;
  dynamic roomId;
  List<dynamic> signatureUrlList;
  List<dynamic> pdfUrlList;
  dynamic code;
  dynamic payType;
  List<dynamic> pay;
  dynamic thirdPartyIdCard;
  dynamic thirdPartyMob;
  dynamic thirdPartyName;
  dynamic notaryNum;
  dynamic certificate;
  dynamic wordUrl;
  List<dynamic> certificatePathList;
  dynamic secretKey;
  dynamic encDataFilePath;
  dynamic confirm;
  dynamic materialList;
  dynamic materUrlList;
  dynamic remarks;
  dynamic similarityPdf;
}
