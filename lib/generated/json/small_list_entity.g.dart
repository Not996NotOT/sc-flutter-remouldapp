import 'package:notarization_station_app/generated/json/base/json_convert_content.dart';
import 'package:notarization_station_app/page/home/entity/small_list_entity.dart';

SmallListEntity $SmallListEntityFromJson(Map<String, dynamic> json) {
  final SmallListEntity smallListEntity = SmallListEntity();
  final String? msg = jsonConvert.convert<String>(json['msg']);
  if (msg != null) {
    smallListEntity.msg = msg;
  }
  final int? code = jsonConvert.convert<int>(json['code']);
  if (code != null) {
    smallListEntity.code = code;
  }
  final SmallListPage? page = jsonConvert.convert<SmallListPage>(json['page']);
  if (page != null) {
    smallListEntity.page = page;
  }
  final List<SmallListItems>? items =
      jsonConvert.convertListNotNull<SmallListItems>(json['items']);
  if (items != null) {
    smallListEntity.items = items;
  }
  return smallListEntity;
}

Map<String, dynamic> $SmallListEntityToJson(SmallListEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['msg'] = entity.msg;
  data['code'] = entity.code;
  data['page'] = entity.page.toJson();
  data['items'] = entity.items.map((v) => v.toJson()).toList();
  return data;
}

SmallListPage $SmallListPageFromJson(Map<String, dynamic> json) {
  final SmallListPage smallListPage = SmallListPage();
  final int? currentPage = jsonConvert.convert<int>(json['currentPage']);
  if (currentPage != null) {
    smallListPage.currentPage = currentPage;
  }
  final int? pageSize = jsonConvert.convert<int>(json['pageSize']);
  if (pageSize != null) {
    smallListPage.pageSize = pageSize;
  }
  final int? total = jsonConvert.convert<int>(json['total']);
  if (total != null) {
    smallListPage.total = total;
  }
  return smallListPage;
}

Map<String, dynamic> $SmallListPageToJson(SmallListPage entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['currentPage'] = entity.currentPage;
  data['pageSize'] = entity.pageSize;
  data['total'] = entity.total;
  return data;
}

SmallListItems $SmallListItemsFromJson(Map<String, dynamic> json) {
  final SmallListItems smallListItems = SmallListItems();
  final String? interestRate =
      jsonConvert.convert<String>(json['interestRate']);
  if (interestRate != null) {
    smallListItems.interestRate = interestRate;
  }
  final dynamic? borrowerId = jsonConvert.convert<dynamic>(json['borrowerId']);
  if (borrowerId != null) {
    smallListItems.borrowerId = borrowerId;
  }
  final dynamic? mortgagorType =
      jsonConvert.convert<dynamic>(json['mortgagorType']);
  if (mortgagorType != null) {
    smallListItems.mortgagorType = mortgagorType;
  }
  final String? loanStartDate =
      jsonConvert.convert<String>(json['loanStartDate']);
  if (loanStartDate != null) {
    smallListItems.loanStartDate = loanStartDate;
  }
  final String? loanOfficerIdCard =
      jsonConvert.convert<String>(json['loanOfficerIdCard']);
  if (loanOfficerIdCard != null) {
    smallListItems.loanOfficerIdCard = loanOfficerIdCard;
  }
  final String? loanOfficerName =
      jsonConvert.convert<String>(json['loanOfficerName']);
  if (loanOfficerName != null) {
    smallListItems.loanOfficerName = loanOfficerName;
  }
  final String? loanOfficerId =
      jsonConvert.convert<String>(json['loanOfficerId']);
  if (loanOfficerId != null) {
    smallListItems.loanOfficerId = loanOfficerId;
  }
  final String? loanOfficerMobile =
      jsonConvert.convert<String>(json['loanOfficerMobile']);
  if (loanOfficerMobile != null) {
    smallListItems.loanOfficerMobile = loanOfficerMobile;
  }
  final String? purpose = jsonConvert.convert<String>(json['purpose']);
  if (purpose != null) {
    smallListItems.purpose = purpose;
  }
  final String? idCard = jsonConvert.convert<String>(json['idCard']);
  if (idCard != null) {
    smallListItems.idCard = idCard;
  }
  final String? bankOrderId = jsonConvert.convert<String>(json['bankOrderId']);
  if (bankOrderId != null) {
    smallListItems.bankOrderId = bankOrderId;
  }
  final dynamic? mortgagorId =
      jsonConvert.convert<dynamic>(json['mortgagorId']);
  if (mortgagorId != null) {
    smallListItems.mortgagorId = mortgagorId;
  }
  final String? notaryId = jsonConvert.convert<String>(json['notaryId']);
  if (notaryId != null) {
    smallListItems.notaryId = notaryId;
  }
  final dynamic? wordId = jsonConvert.convert<dynamic>(json['wordId']);
  if (wordId != null) {
    smallListItems.wordId = wordId;
  }
  final String? fee = jsonConvert.convert<String>(json['fee']);
  if (fee != null) {
    smallListItems.fee = fee;
  }
  final String? borrower = jsonConvert.convert<String>(json['borrower']);
  if (borrower != null) {
    smallListItems.borrower = borrower;
  }
  final List<SmallListItemsUserList>? userList =
      jsonConvert.convertListNotNull<SmallListItemsUserList>(json['userList']);
  if (userList != null) {
    smallListItems.userList = userList;
  }
  final String? repaymentType =
      jsonConvert.convert<String>(json['repaymentType']);
  if (repaymentType != null) {
    smallListItems.repaymentType = repaymentType;
  }
  final dynamic? keyWordList =
      jsonConvert.convert<dynamic>(json['keyWordList']);
  if (keyWordList != null) {
    smallListItems.keyWordList = keyWordList;
  }
  final List<SmallListItemsImgPath>? imgPath =
      jsonConvert.convertListNotNull<SmallListItemsImgPath>(json['imgPath']);
  if (imgPath != null) {
    smallListItems.imgPath = imgPath;
  }
  final List<SmallListItemsHtml>? html =
      jsonConvert.convertListNotNull<SmallListItemsHtml>(json['html']);
  if (html != null) {
    smallListItems.html = html;
  }
  final String? term = jsonConvert.convert<String>(json['term']);
  if (term != null) {
    smallListItems.term = term;
  }
  final String? loanEndDate = jsonConvert.convert<String>(json['loanEndDate']);
  if (loanEndDate != null) {
    smallListItems.loanEndDate = loanEndDate;
  }
  final String? material = jsonConvert.convert<String>(json['material']);
  if (material != null) {
    smallListItems.material = material;
  }
  return smallListItems;
}

Map<String, dynamic> $SmallListItemsToJson(SmallListItems entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
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
  data['userList'] = entity.userList.map((v) => v.toJson()).toList();
  data['repaymentType'] = entity.repaymentType;
  data['keyWordList'] = entity.keyWordList;
  data['imgPath'] = entity.imgPath.map((v) => v.toJson()).toList();
  data['html'] = entity.html.map((v) => v.toJson()).toList();
  data['term'] = entity.term;
  data['loanEndDate'] = entity.loanEndDate;
  data['material'] = entity.material;
  return data;
}

SmallListItemsUserList $SmallListItemsUserListFromJson(
    Map<String, dynamic> json) {
  final SmallListItemsUserList smallListItemsUserList =
      SmallListItemsUserList();
  final String? unitGuid = jsonConvert.convert<String>(json['unitGuid']);
  if (unitGuid != null) {
    smallListItemsUserList.unitGuid = unitGuid;
  }
  final String? userName = jsonConvert.convert<String>(json['userName']);
  if (userName != null) {
    smallListItemsUserList.userName = userName;
  }
  final String? idCard = jsonConvert.convert<String>(json['idCard']);
  if (idCard != null) {
    smallListItemsUserList.idCard = idCard;
  }
  final String? mobile = jsonConvert.convert<String>(json['mobile']);
  if (mobile != null) {
    smallListItemsUserList.mobile = mobile;
  }
  final String? filePath = jsonConvert.convert<String>(json['filePath']);
  if (filePath != null) {
    smallListItemsUserList.filePath = filePath;
  }
  final dynamic? filePathList =
      jsonConvert.convert<dynamic>(json['filePathList']);
  if (filePathList != null) {
    smallListItemsUserList.filePathList = filePathList;
  }
  final String? bankOrderId = jsonConvert.convert<String>(json['bankOrderId']);
  if (bankOrderId != null) {
    smallListItemsUserList.bankOrderId = bankOrderId;
  }
  final String? createDate = jsonConvert.convert<String>(json['createDate']);
  if (createDate != null) {
    smallListItemsUserList.createDate = createDate;
  }
  final dynamic? contractPath =
      jsonConvert.convert<dynamic>(json['contractPath']);
  if (contractPath != null) {
    smallListItemsUserList.contractPath = contractPath;
  }
  final dynamic? contractList =
      jsonConvert.convert<dynamic>(json['contractList']);
  if (contractList != null) {
    smallListItemsUserList.contractList = contractList;
  }
  final int? userType = jsonConvert.convert<int>(json['userType']);
  if (userType != null) {
    smallListItemsUserList.userType = userType;
  }
  final dynamic? pdfList = jsonConvert.convert<dynamic>(json['pdfList']);
  if (pdfList != null) {
    smallListItemsUserList.pdfList = pdfList;
  }
  final dynamic? pdfPathList =
      jsonConvert.convert<dynamic>(json['pdfPathList']);
  if (pdfPathList != null) {
    smallListItemsUserList.pdfPathList = pdfPathList;
  }
  final dynamic? signPdf = jsonConvert.convert<dynamic>(json['signPdf']);
  if (signPdf != null) {
    smallListItemsUserList.signPdf = signPdf;
  }
  final dynamic? sign = jsonConvert.convert<dynamic>(json['sign']);
  if (sign != null) {
    smallListItemsUserList.sign = sign;
  }
  final dynamic? bankorder = jsonConvert.convert<dynamic>(json['bankorder']);
  if (bankorder != null) {
    smallListItemsUserList.bankorder = bankorder;
  }
  final dynamic? keyWordList =
      jsonConvert.convert<dynamic>(json['keyWordList']);
  if (keyWordList != null) {
    smallListItemsUserList.keyWordList = keyWordList;
  }
  final dynamic? content = jsonConvert.convert<dynamic>(json['content']);
  if (content != null) {
    smallListItemsUserList.content = content;
  }
  final dynamic? wordId = jsonConvert.convert<dynamic>(json['wordId']);
  if (wordId != null) {
    smallListItemsUserList.wordId = wordId;
  }
  final dynamic? wordTitle = jsonConvert.convert<dynamic>(json['wordTitle']);
  if (wordTitle != null) {
    smallListItemsUserList.wordTitle = wordTitle;
  }
  final dynamic? contractPathBack =
      jsonConvert.convert<dynamic>(json['contractPathBack']);
  if (contractPathBack != null) {
    smallListItemsUserList.contractPathBack = contractPathBack;
  }
  final dynamic? state = jsonConvert.convert<dynamic>(json['state']);
  if (state != null) {
    smallListItemsUserList.state = state;
  }
  final String? address = jsonConvert.convert<String>(json['address']);
  if (address != null) {
    smallListItemsUserList.address = address;
  }
  final String? nationality = jsonConvert.convert<String>(json['nationality']);
  if (nationality != null) {
    smallListItemsUserList.nationality = nationality;
  }
  final String? identity = jsonConvert.convert<String>(json['identity']);
  if (identity != null) {
    smallListItemsUserList.identity = identity;
  }
  final int? natureType = jsonConvert.convert<int>(json['natureType']);
  if (natureType != null) {
    smallListItemsUserList.natureType = natureType;
  }
  final dynamic? propertyId = jsonConvert.convert<dynamic>(json['propertyId']);
  if (propertyId != null) {
    smallListItemsUserList.propertyId = propertyId;
  }
  final String? enterpriseName =
      jsonConvert.convert<String>(json['enterpriseName']);
  if (enterpriseName != null) {
    smallListItemsUserList.enterpriseName = enterpriseName;
  }
  final String? organizationCode =
      jsonConvert.convert<String>(json['organizationCode']);
  if (organizationCode != null) {
    smallListItemsUserList.organizationCode = organizationCode;
  }
  final int? isDaiBan = jsonConvert.convert<int>(json['isDaiBan']);
  if (isDaiBan != null) {
    smallListItemsUserList.isDaiBan = isDaiBan;
  }
  final int? gender = jsonConvert.convert<int>(json['gender']);
  if (gender != null) {
    smallListItemsUserList.gender = gender;
  }
  final dynamic? resBankProperty =
      jsonConvert.convert<dynamic>(json['resBankProperty']);
  if (resBankProperty != null) {
    smallListItemsUserList.resBankProperty = resBankProperty;
  }
  final String? contractName =
      jsonConvert.convert<String>(json['contractName']);
  if (contractName != null) {
    smallListItemsUserList.contractName = contractName;
  }
  final String? borrowerId = jsonConvert.convert<String>(json['borrowerId']);
  if (borrowerId != null) {
    smallListItemsUserList.borrowerId = borrowerId;
  }
  final dynamic? mortgagorId =
      jsonConvert.convert<dynamic>(json['mortgagorId']);
  if (mortgagorId != null) {
    smallListItemsUserList.mortgagorId = mortgagorId;
  }
  final dynamic? rstSignPath =
      jsonConvert.convert<dynamic>(json['rstSignPath']);
  if (rstSignPath != null) {
    smallListItemsUserList.rstSignPath = rstSignPath;
  }
  return smallListItemsUserList;
}

Map<String, dynamic> $SmallListItemsUserListToJson(
    SmallListItemsUserList entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
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

SmallListItemsImgPath $SmallListItemsImgPathFromJson(
    Map<String, dynamic> json) {
  final SmallListItemsImgPath smallListItemsImgPath = SmallListItemsImgPath();
  final String? path = jsonConvert.convert<String>(json['path']);
  if (path != null) {
    smallListItemsImgPath.path = path;
  }
  final String? unitGuid = jsonConvert.convert<String>(json['unitGuid']);
  if (unitGuid != null) {
    smallListItemsImgPath.unitGuid = unitGuid;
  }
  final String? materialName =
      jsonConvert.convert<String>(json['materialName']);
  if (materialName != null) {
    smallListItemsImgPath.materialName = materialName;
  }
  return smallListItemsImgPath;
}

Map<String, dynamic> $SmallListItemsImgPathToJson(
    SmallListItemsImgPath entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['path'] = entity.path;
  data['unitGuid'] = entity.unitGuid;
  data['materialName'] = entity.materialName;
  return data;
}

SmallListItemsHtml $SmallListItemsHtmlFromJson(Map<String, dynamic> json) {
  final SmallListItemsHtml smallListItemsHtml = SmallListItemsHtml();
  final String? mortgageType =
      jsonConvert.convert<String>(json['mortgageType']);
  if (mortgageType != null) {
    smallListItemsHtml.mortgageType = mortgageType;
  }
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    smallListItemsHtml.name = name;
  }
  final String? property = jsonConvert.convert<String>(json['property']);
  if (property != null) {
    smallListItemsHtml.property = property;
  }
  return smallListItemsHtml;
}

Map<String, dynamic> $SmallListItemsHtmlToJson(SmallListItemsHtml entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['mortgageType'] = entity.mortgageType;
  data['name'] = entity.name;
  data['property'] = entity.property;
  return data;
}
