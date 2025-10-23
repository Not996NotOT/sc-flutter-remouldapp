import 'package:notarization_station_app/generated/json/base/json_convert_content.dart';

class ContractEntity with JsonConvert<ContractEntity> {
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
  dynamic fee;
  dynamic supplementFee;
  dynamic takeUser;
  dynamic takeMobile;
  dynamic takeAddress;
  dynamic takeStyle;
  dynamic pdfUrl;
  dynamic signatureUrl;
  dynamic signName;
  int deleteMark;
  int terminalType;
  dynamic notaryItemNames;
  dynamic notaryStateName;
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
  dynamic signatureUrlList;
  dynamic pdfUrlList;
  int code;
  dynamic payType;
  dynamic pay;
  String thirdPartyIdCard;
  String thirdPartyMob;
  String thirdPartyName;
  dynamic notaryNum;
  dynamic certificate;
  dynamic wordUrl;
  dynamic certificatePathList;
  dynamic secretKey;
  dynamic encDataFilePath;
  int confirm;
  dynamic materialList;
  dynamic materUrlList;
  dynamic remarks;
  dynamic similarityPdf;
  dynamic macAddress;
  dynamic bankorder;

  @override
  String toString() {
    // TODO: implement toString
    print("roomId--------$roomId");
    return "$roomId";
  }
}
