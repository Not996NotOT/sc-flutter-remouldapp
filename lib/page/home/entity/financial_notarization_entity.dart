class FinancialNotarizationEntity {
  // 受理时间
  String acceptDate;

  //业务类型
  String businessType;

  // 申请时间
  String createDate;

  // 借款人身份证号
  String idCard;

  // 借款金额
  String loanPrice;

  // 订单编号
  String orderNumber;

  // 订单状态
  int orderStatus;

  //订单主键
  String unitGuid;

  // 借款人
  String userName;

  // 房间编号
  String roomId;

  // 是否是简易版
  bool isCommon;

  // 机构名称
  String notaryName;

  FinancialNotarizationEntity({
    this.orderNumber,
    this.userName,
    this.roomId,
    this.orderStatus,
    this.unitGuid,
    this.isCommon,
    this.notaryName,
  });

  FinancialNotarizationEntity.fromJson(dynamic json) {
    userName = json['userName'] ?? '';
    notaryName = json['notaryName'] ?? '';
    orderNumber = json["orderNumber"] ?? '';
    orderStatus = json['orderStatus'];
    unitGuid = json['unitGuid'] ?? '';
    roomId = json['roomId'] ?? '';
  }

  Map toJson() {
    Map json = new Map();
    json["orderNumber"] = orderNumber;
    json['userName'] = userName;
    json["notaryName"] = notaryName;
    json['orderStatus'] = orderStatus;
    json['unitGuid'] = unitGuid;
    json['roomId'] = roomId;
    return json;
  }
}
