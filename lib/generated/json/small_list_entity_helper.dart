import 'package:notarization_station_app/page/home/entity/small_list_entity.dart';

smallListEntityFromJson(SmallListEntity data, Map<String, dynamic> json) {
  if (json['msg'] != null) {
    data.msg = json['msg'].toString();
  }
  if (json['code'] != null) {
    data.code = json['code'] is String
        ? int.tryParse(json['code'])
        : json['code'].toInt();
  }
  if (json['page'] != null) {
    data.page = SmallListPage().fromJson(json['page']);
  }
  if (json['items'] != null) {
    data.items = (json['items'] as List)
        .map((v) => SmallListItems().fromJson(v))
        .toList();
  }
  return data;
}

Map<String, dynamic> smallListEntityToJson(SmallListEntity entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['msg'] = entity.msg;
  data['code'] = entity.code;
  data['page'] = entity.page?.toJson();
  data['items'] = entity.items?.map((v) => v.toJson())?.toList();
  return data;
}

smallListPageFromJson(SmallListPage data, Map<String, dynamic> json) {
  if (json['currentPage'] != null) {
    data.currentPage = json['currentPage'] is String
        ? int.tryParse(json['currentPage'])
        : json['currentPage'].toInt();
  }
  if (json['pageSize'] != null) {
    data.pageSize = json['pageSize'] is String
        ? int.tryParse(json['pageSize'])
        : json['pageSize'].toInt();
  }
  if (json['total'] != null) {
    data.total = json['total'] is String
        ? int.tryParse(json['total'])
        : json['total'].toInt();
  }
  return data;
}

Map<String, dynamic> smallListPageToJson(SmallListPage entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['currentPage'] = entity.currentPage;
  data['pageSize'] = entity.pageSize;
  data['total'] = entity.total;
  return data;
}

smallListItemsFromJson(SmallListItems data, Map<String, dynamic> json) {
  if (json['interestRate'] != null) {
    data.interestRate = json['interestRate'].toString();
  }
  if (json['borrowerId'] != null) {
    data.borrowerId = json['borrowerId'];
  }
  if (json['mortgagorType'] != null) {
    data.mortgagorType = json['mortgagorType'];
  }
  if (json['loanStartDate'] != null) {
    data.loanStartDate = json['loanStartDate'].toString();
  }
  if (json['loanOfficerIdCard'] != null) {
    data.loanOfficerIdCard = json['loanOfficerIdCard'].toString();
  }
  if (json['loanOfficerName'] != null) {
    data.loanOfficerName = json['loanOfficerName'].toString();
  }
  if (json['loanOfficerId'] != null) {
    data.loanOfficerId = json['loanOfficerId'].toString();
  }
  if (json['loanOfficerMobile'] != null) {
    data.loanOfficerMobile = json['loanOfficerMobile'].toString();
  }
  if (json['purpose'] != null) {
    data.purpose = json['purpose'].toString();
  }
  if (json['idCard'] != null) {
    data.idCard = json['idCard'].toString();
  }
  if (json['bankOrderId'] != null) {
    data.bankOrderId = json['bankOrderId'].toString();
  }
  if (json['mortgagorId'] != null) {
    data.mortgagorId = json['mortgagorId'];
  }
  if (json['notaryId'] != null) {
    data.notaryId = json['notaryId'].toString();
  }
  if (json['wordId'] != null) {
    data.wordId = json['wordId'];
  }
  if (json['fee'] != null) {
    data.fee = json['fee'].toString();
  }
  if (json['borrower'] != null) {
    data.borrower = json['borrower'].toString();
  }
  if (json['userList'] != null) {
    data.userList = (json['userList'] as List)
        .map((v) => SmallListItemsUserList().fromJson(v))
        .toList();
  }
  if (json['repaymentType'] != null) {
    data.repaymentType = json['repaymentType'].toString();
  }
  if (json['keyWordList'] != null) {
    data.keyWordList = json['keyWordList'];
  }
  if (json['imgPath'] != null) {
    data.imgPath = (json['imgPath'] as List)
        .map((v) => SmallListItemsImgPath().fromJson(v))
        .toList();
  }
  if (json['html'] != null) {
    data.html = (json['html'] as List)
        .map((v) => SmallListItemsHtml().fromJson(v))
        .toList();
  }
  if (json['term'] != null) {
    data.term = json['term'].toString();
  }
  if (json['loanEndDate'] != null) {
    data.loanEndDate = json['loanEndDate'].toString();
  }
  if (json['material'] != null) {
    data.material = json['material'].toString();
  }
  return data;
}

Map<String, dynamic> smallListItemsToJson(SmallListItems entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['interestRate'] = entity.interestRate;
  data['borrowerId'] = entity.borrowerId;
  data['mortgagorType'] = entity.mortgagorType;
  data['loanStartDate'] = entity.loanStartDate;
  data['loanOfficerIdCard'] = entity.loanOfficerIdCard;
  data['loanOfficerName'] = entity.loanOfficerName;
  data['loanOfficerId'] = entity.loanOfficerId;
  data['loanOfficerMobile'] = entity.loanOfficerMobile;
  data['purpose'] = entity.purpose;
  data['idCard'] = entity.idCard;
  data['bankOrderId'] = entity.bankOrderId;
  data['mortgagorId'] = entity.mortgagorId;
  data['notaryId'] = entity.notaryId;
  data['wordId'] = entity.wordId;
  data['fee'] = entity.fee;
  data['borrower'] = entity.borrower;
  data['userList'] = entity.userList?.map((v) => v.toJson())?.toList();
  data['repaymentType'] = entity.repaymentType;
  data['keyWordList'] = entity.keyWordList;
  data['imgPath'] = entity.imgPath?.map((v) => v.toJson())?.toList();
  data['html'] = entity.html?.map((v) => v.toJson())?.toList();
  data['term'] = entity.term;
  data['loanEndDate'] = entity.loanEndDate;
  data['material'] = entity.material;
  return data;
}

smallListItemsUserListFromJson(
    SmallListItemsUserList data, Map<String, dynamic> json) {
  if (json['unitGuid'] != null) {
    data.unitGuid = json['unitGuid'].toString();
  }
  if (json['userName'] != null) {
    data.userName = json['userName'].toString();
  }
  if (json['idCard'] != null) {
    data.idCard = json['idCard'].toString();
  }
  if (json['mobile'] != null) {
    data.mobile = json['mobile'].toString();
  }
  if (json['filePath'] != null) {
    data.filePath = json['filePath'].toString();
  }
  if (json['filePathList'] != null) {
    data.filePathList = json['filePathList'];
  }
  if (json['bankOrderId'] != null) {
    data.bankOrderId = json['bankOrderId'].toString();
  }
  if (json['createDate'] != null) {
    data.createDate = json['createDate'].toString();
  }
  if (json['contractPath'] != null) {
    data.contractPath = json['contractPath'];
  }
  if (json['contractList'] != null) {
    data.contractList = json['contractList'];
  }
  if (json['userType'] != null) {
    data.userType = json['userType'] is String
        ? int.tryParse(json['userType'])
        : json['userType'].toInt();
  }
  if (json['pdfList'] != null) {
    data.pdfList = json['pdfList'];
  }
  if (json['pdfPathList'] != null) {
    data.pdfPathList = json['pdfPathList'];
  }
  if (json['signPdf'] != null) {
    data.signPdf = json['signPdf'];
  }
  if (json['sign'] != null) {
    data.sign = json['sign'];
  }
  if (json['bankorder'] != null) {
    data.bankorder = json['bankorder'];
  }
  if (json['keyWordList'] != null) {
    data.keyWordList = json['keyWordList'];
  }
  if (json['content'] != null) {
    data.content = json['content'];
  }
  if (json['wordId'] != null) {
    data.wordId = json['wordId'];
  }
  if (json['wordTitle'] != null) {
    data.wordTitle = json['wordTitle'];
  }
  if (json['contractPathBack'] != null) {
    data.contractPathBack = json['contractPathBack'];
  }
  if (json['state'] != null) {
    data.state = json['state'];
  }
  if (json['address'] != null) {
    data.address = json['address'].toString();
  }
  if (json['nationality'] != null) {
    data.nationality = json['nationality'].toString();
  }
  if (json['identity'] != null) {
    data.identity = json['identity'].toString();
  }
  if (json['natureType'] != null) {
    data.natureType = json['natureType'] is String
        ? int.tryParse(json['natureType'])
        : json['natureType'].toInt();
  }
  if (json['propertyId'] != null) {
    data.propertyId = json['propertyId'];
  }
  if (json['enterpriseName'] != null) {
    data.enterpriseName = json['enterpriseName'].toString();
  }
  if (json['organizationCode'] != null) {
    data.organizationCode = json['organizationCode'].toString();
  }
  if (json['isDaiBan'] != null) {
    data.isDaiBan = json['isDaiBan'] is String
        ? int.tryParse(json['isDaiBan'])
        : json['isDaiBan'].toInt();
  }
  if (json['gender'] != null) {
    data.gender = json['gender'] is String
        ? int.tryParse(json['gender'])
        : json['gender'].toInt();
  }
  if (json['resBankProperty'] != null) {
    data.resBankProperty = json['resBankProperty'];
  }
  if (json['contractName'] != null) {
    data.contractName = json['contractName'].toString();
  }
  if (json['borrowerId'] != null) {
    data.borrowerId = json['borrowerId'].toString();
  }
  if (json['mortgagorId'] != null) {
    data.mortgagorId = json['mortgagorId'];
  }
  if (json['rstSignPath'] != null) {
    data.rstSignPath = json['rstSignPath'];
  }
  return data;
}

Map<String, dynamic> smallListItemsUserListToJson(
    SmallListItemsUserList entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['unitGuid'] = entity.unitGuid;
  data['userName'] = entity.userName;
  data['idCard'] = entity.idCard;
  data['mobile'] = entity.mobile;
  data['filePath'] = entity.filePath;
  data['filePathList'] = entity.filePathList;
  data['bankOrderId'] = entity.bankOrderId;
  data['createDate'] = entity.createDate;
  data['contractPath'] = entity.contractPath;
  data['contractList'] = entity.contractList;
  data['userType'] = entity.userType;
  data['pdfList'] = entity.pdfList;
  data['pdfPathList'] = entity.pdfPathList;
  data['signPdf'] = entity.signPdf;
  data['sign'] = entity.sign;
  data['bankorder'] = entity.bankorder;
  data['keyWordList'] = entity.keyWordList;
  data['content'] = entity.content;
  data['wordId'] = entity.wordId;
  data['wordTitle'] = entity.wordTitle;
  data['contractPathBack'] = entity.contractPathBack;
  data['state'] = entity.state;
  data['address'] = entity.address;
  data['nationality'] = entity.nationality;
  data['identity'] = entity.identity;
  data['natureType'] = entity.natureType;
  data['propertyId'] = entity.propertyId;
  data['enterpriseName'] = entity.enterpriseName;
  data['organizationCode'] = entity.organizationCode;
  data['isDaiBan'] = entity.isDaiBan;
  data['gender'] = entity.gender;
  data['resBankProperty'] = entity.resBankProperty;
  data['contractName'] = entity.contractName;
  data['borrowerId'] = entity.borrowerId;
  data['mortgagorId'] = entity.mortgagorId;
  data['rstSignPath'] = entity.rstSignPath;
  return data;
}

smallListItemsImgPathFromJson(
    SmallListItemsImgPath data, Map<String, dynamic> json) {
  if (json['path'] != null) {
    data.path = json['path'].toString();
  }
  if (json['unitGuid'] != null) {
    data.unitGuid = json['unitGuid'].toString();
  }
  if (json['materialName'] != null) {
    data.materialName = json['materialName'].toString();
  }
  return data;
}

Map<String, dynamic> smallListItemsImgPathToJson(SmallListItemsImgPath entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['path'] = entity.path;
  data['unitGuid'] = entity.unitGuid;
  data['materialName'] = entity.materialName;
  return data;
}

smallListItemsHtmlFromJson(SmallListItemsHtml data, Map<String, dynamic> json) {
  if (json['mortgageType'] != null) {
    data.mortgageType = json['mortgageType'].toString();
  }
  if (json['name'] != null) {
    data.name = json['name'].toString();
  }
  if (json['property'] != null) {
    data.property = json['property'].toString();
  }
  return data;
}

Map<String, dynamic> smallListItemsHtmlToJson(SmallListItemsHtml entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['mortgageType'] = entity.mortgageType;
  data['name'] = entity.name;
  data['property'] = entity.property;
  return data;
}
