import 'package:notarization_station_app/generated/json/base/json_convert_content.dart';

class SmallListEntity with JsonConvert<SmallListEntity> {
  String msg;
  int code;
  SmallListPage page;
  List<SmallListItems> items;
}

class SmallListPage with JsonConvert<SmallListPage> {
  int currentPage;
  int pageSize;
  int total;
}

class SmallListItems with JsonConvert<SmallListItems> {
  String interestRate;
  dynamic borrowerId;
  dynamic mortgagorType;
  String loanStartDate;
  String loanOfficerIdCard;
  String loanOfficerName;
  String loanOfficerId;
  String loanOfficerMobile;
  String purpose;
  String idCard;
  String bankOrderId;
  dynamic mortgagorId;
  String notaryId;
  dynamic wordId;
  String fee;
  String borrower;
  List<SmallListItemsUserList> userList;
  String repaymentType;
  dynamic keyWordList;
  List<SmallListItemsImgPath> imgPath;
  List<SmallListItemsHtml> html;
  String term;
  String loanEndDate;
  String material;
}

class SmallListItemsUserList with JsonConvert<SmallListItemsUserList> {
  String unitGuid;
  String userName;
  String idCard;
  String mobile;
  String filePath;
  dynamic filePathList;
  String bankOrderId;
  String createDate;
  dynamic contractPath;
  dynamic contractList;
  int userType;
  dynamic pdfList;
  dynamic pdfPathList;
  dynamic signPdf;
  dynamic sign;
  dynamic bankorder;
  dynamic keyWordList;
  dynamic content;
  dynamic wordId;
  dynamic wordTitle;
  dynamic contractPathBack;
  dynamic state;
  String address;
  String nationality;
  String identity;
  int natureType;
  dynamic propertyId;
  String enterpriseName;
  String organizationCode;
  int isDaiBan;
  int gender;
  dynamic resBankProperty;
  String contractName;
  String borrowerId;
  dynamic mortgagorId;
  dynamic rstSignPath;
}

class SmallListItemsImgPath with JsonConvert<SmallListItemsImgPath> {
  String path;
  String unitGuid;
  String materialName;
}

class SmallListItemsHtml with JsonConvert<SmallListItemsHtml> {
  String mortgageType;
  String name;
  String property;
}
