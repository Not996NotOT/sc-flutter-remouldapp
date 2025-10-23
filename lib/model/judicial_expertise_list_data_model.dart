/// code : 0
/// data : {"current":0,"records":[{"accepanceFileId":"","acceptanceDate":"","applicationFileId":"","appraisalNotaritionId":"","appraisalNotaritionName":"","caseNumber":"","createDate":"","createUserId":"","damageType":0,"deleteMark":0,"enabledMark":0,"idCard":"","instructionsId":"","insureNotaritionId":"","inusureNotaritionName":"","isChangeInfo":0,"isOnlinePay":0,"lotteryStatus":0,"money":0,"name":"","notAcceptedReason":"","notificationFileId":"","payOrderNum":"","payStatus":0,"payType":0,"phone":"","principalIdCard":"","principalName":"","principalPhone":"","remark":"","screenFileId":"","signId":"","sort":"","status":"","unionNotaritionId":"","unionNotaritionName":"","unitGuid":"","updateDate":"","updateUserId":"","whetherDelegate":0}],"size":0,"total":0}
/// message : ""
/// success : true

class JudicialExpertiseListDataModel {
  JudicialExpertiseListDataModel({
      num code,
      Data data,
      String message,
      bool success,}){
    _code = code;
    _data = data;
    _message = message;
    _success = success;
}

  JudicialExpertiseListDataModel.fromJson(dynamic json) {
    _code = json['code'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
    _message = json['message'];
    _success = json['success'];
  }
  num _code;
  Data _data;
  String _message;
  bool _success;
JudicialExpertiseListDataModel copyWith({  num code,
  Data data,
  String message,
  bool success,
}) => JudicialExpertiseListDataModel(  code: code ?? _code,
  data: data ?? _data,
  message: message ?? _message,
  success: success ?? _success,
);
  num get code => _code;
  Data get data => _data;
  String get message => _message;
  bool get success => _success;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['code'] = _code;
    if (_data != null) {
      map['data'] = _data.toJson();
    }
    map['message'] = _message;
    map['success'] = _success;
    return map;
  }

}

/// current : 0
/// records : [{"accepanceFileId":"","acceptanceDate":"","applicationFileId":"","appraisalNotaritionId":"","appraisalNotaritionName":"","caseNumber":"","createDate":"","createUserId":"","damageType":0,"deleteMark":0,"enabledMark":0,"idCard":"","instructionsId":"","insureNotaritionId":"","inusureNotaritionName":"","isChangeInfo":0,"isOnlinePay":0,"lotteryStatus":0,"money":0,"name":"","notAcceptedReason":"","notificationFileId":"","payOrderNum":"","payStatus":0,"payType":0,"phone":"","principalIdCard":"","principalName":"","principalPhone":"","remark":"","screenFileId":"","signId":"","sort":"","status":"","unionNotaritionId":"","unionNotaritionName":"","unitGuid":"","updateDate":"","updateUserId":"","whetherDelegate":0}]
/// size : 0
/// total : 0

class Data {
  Data({
      num current,
      List<Records> records,
      num size,
      num total,}){
    _current = current;
    _records = records;
    _size = size;
    _total = total;
}

  Data.fromJson(dynamic json) {
    _current = json['current'];
    if (json['records'] != null) {
      _records = [];
      json['records'].forEach((v) {
        _records.add(Records.fromJson(v));
      });
    }
    _size = json['size'];
    _total = json['total'];
  }
  num _current;
  List<Records> _records;
  num _size;
  num _total;
Data copyWith({  num current,
  List<Records> records,
  num size,
  num total,
}) => Data(  current: current ?? _current,
  records: records ?? _records,
  size: size ?? _size,
  total: total ?? _total,
);
  num get current => _current;
  List<Records> get records => _records;
  num get size => _size;
  num get total => _total;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['current'] = _current;
    if (_records != null) {
      map['records'] = _records.map((v) => v.toJson()).toList();
    }
    map['size'] = _size;
    map['total'] = _total;
    return map;
  }

}

/// accepanceFileId : ""
/// acceptanceDate : ""
/// applicationFileId : ""
/// appraisalNotaritionId : ""
/// appraisalNotaritionName : ""
/// caseNumber : ""
/// createDate : ""
/// createUserId : ""
/// damageType : 0
/// deleteMark : 0
/// enabledMark : 0
/// idCard : ""
/// instructionsId : ""
/// insureNotaritionId : ""
/// inusureNotaritionName : ""
/// isChangeInfo : 0
/// isOnlinePay : 0
/// lotteryStatus : 0
/// money : 0
/// name : ""
/// notAcceptedReason : ""
/// notificationFileId : ""
/// payOrderNum : ""
/// payStatus : 0
/// payType : 0
/// phone : ""
/// principalIdCard : ""
/// principalName : ""
/// principalPhone : ""
/// remark : ""
/// screenFileId : ""
/// signId : ""
/// sort : ""
/// status : ""
/// unionNotaritionId : ""
/// unionNotaritionName : ""
/// unitGuid : ""
/// updateDate : ""
/// updateUserId : ""
/// whetherDelegate : 0

class Records {
  Records({
      String accepanceFileId,
      String acceptanceDate,
      String applicationFileId,
      String appraisalNotaritionId,
      String appraisalNotaritionName,
      String caseNumber,
      String createDate,
      String createUserId,
      num damageType,
      num deleteMark,
      num enabledMark,
      String idCard,
      String instructionsId,
      String insureNotaritionId,
      String inusureNotaritionName,
      num isChangeInfo,
      num isOnlinePay,
      num lotteryStatus,
      num money,
      String name,
      String notAcceptedReason,
      String notificationFileId,
      String payOrderNum,
      num payStatus,
      num payType,
      String phone,
      String principalIdCard,
      String principalName,
      String principalPhone,
      String remark,
      String screenFileId,
      String signId,
      String sort,
      String status,
      String unionNotaritionId,
      String unionNotaritionName,
      String unitGuid,
      String updateDate,
      String updateUserId,
      String notaryName,
      String invoiceFileUrl,
      num whetherDelegate,}){
    _accepanceFileId = accepanceFileId;
    _acceptanceDate = acceptanceDate;
    _applicationFileId = applicationFileId;
    _appraisalNotaritionId = appraisalNotaritionId;
    _appraisalNotaritionName = appraisalNotaritionName;
    _caseNumber = caseNumber;
    _createDate = createDate;
    _createUserId = createUserId;
    _damageType = damageType;
    _deleteMark = deleteMark;
    _enabledMark = enabledMark;
    _idCard = idCard;
    _instructionsId = instructionsId;
    _insureNotaritionId = insureNotaritionId;
    _inusureNotaritionName = inusureNotaritionName;
    _isChangeInfo = isChangeInfo;
    _isOnlinePay = isOnlinePay;
    _lotteryStatus = lotteryStatus;
    _money = money;
    _name = name;
    _notAcceptedReason = notAcceptedReason;
    _notificationFileId = notificationFileId;
    _payOrderNum = payOrderNum;
    _payStatus = payStatus;
    _payType = payType;
    _phone = phone;
    _principalIdCard = principalIdCard;
    _principalName = principalName;
    _principalPhone = principalPhone;
    _remark = remark;
    _screenFileId = screenFileId;
    _signId = signId;
    _sort = sort;
    _status = status;
    _unionNotaritionId = unionNotaritionId;
    _unionNotaritionName = unionNotaritionName;
    _unitGuid = unitGuid;
    _updateDate = updateDate;
    _updateUserId = updateUserId;
    _whetherDelegate = whetherDelegate;
    _notaryName = notaryName;
    _invoiceFileUrl = invoiceFileUrl;
}

  Records.fromJson(dynamic json) {
    _accepanceFileId = json['accepanceFileId'];
    _acceptanceDate = json['acceptanceDate'];
    _applicationFileId = json['applicationFileId'];
    _appraisalNotaritionId = json['appraisalNotaritionId'];
    _appraisalNotaritionName = json['appraisalNotaritionName'];
    _caseNumber = json['caseNumber'];
    _createDate = json['createDate'];
    _createUserId = json['createUserId'];
    _damageType = json['damageType'];
    _deleteMark = json['deleteMark'];
    _enabledMark = json['enabledMark'];
    _idCard = json['idCard'];
    _instructionsId = json['instructionsId'];
    _insureNotaritionId = json['insureNotaritionId'];
    _inusureNotaritionName = json['inusureNotaritionName'];
    _isChangeInfo = json['isChangeInfo'];
    _isOnlinePay = json['isOnlinePay'];
    _lotteryStatus = json['lotteryStatus'];
    _money = json['money'];
    _name = json['name'];
    _notAcceptedReason = json['notAcceptedReason'];
    _notificationFileId = json['notificationFileId'];
    _payOrderNum = json['payOrderNum'];
    _payStatus = json['payStatus'];
    _payType = json['payType'];
    _phone = json['phone'];
    _principalIdCard = json['principalIdCard'];
    _principalName = json['principalName'];
    _principalPhone = json['principalPhone'];
    _remark = json['remark'];
    _screenFileId = json['screenFileId'];
    _signId = json['signId'];
    _sort = json['sort'];
    _status = json['status'];
    _unionNotaritionId = json['unionNotaritionId'];
    _unionNotaritionName = json['unionNotaritionName'];
    _unitGuid = json['unitGuid'];
    _updateDate = json['updateDate'];
    _updateUserId = json['updateUserId'];
    _whetherDelegate = json['whetherDelegate'];
    _notaryName = json["notaryName"];
    _invoiceFileUrl = json["invoiceFileUrl"];
  }
  String _accepanceFileId;
  String _acceptanceDate;
  String _applicationFileId;
  String _appraisalNotaritionId;
  String _appraisalNotaritionName;
  String _caseNumber;
  String _createDate;
  String _createUserId;
  num _damageType;
  num _deleteMark;
  num _enabledMark;
  String _idCard;
  String _instructionsId;
  String _insureNotaritionId;
  String _inusureNotaritionName;
  num _isChangeInfo;
  num _isOnlinePay;
  num _lotteryStatus;
  num _money;
  String _name;
  String _notAcceptedReason;
  String _notificationFileId;
  String _payOrderNum;
  num _payStatus;
  num _payType;
  String _phone;
  String _principalIdCard;
  String _principalName;
  String _principalPhone;
  String _remark;
  String _screenFileId;
  String _signId;
  String _sort;
  String _status;
  String _unionNotaritionId;
  String _unionNotaritionName;
  String _unitGuid;
  String _updateDate;
  String _updateUserId;
  String _notaryName;
  String _invoiceFileUrl;
  num _whetherDelegate;
Records copyWith({  String accepanceFileId,
  String acceptanceDate,
  String applicationFileId,
  String appraisalNotaritionId,
  String appraisalNotaritionName,
  String caseNumber,
  String createDate,
  String createUserId,
  num damageType,
  num deleteMark,
  num enabledMark,
  String idCard,
  String instructionsId,
  String insureNotaritionId,
  String inusureNotaritionName,
  num isChangeInfo,
  num isOnlinePay,
  num lotteryStatus,
  num money,
  String name,
  String notAcceptedReason,
  String notificationFileId,
  String payOrderNum,
  num payStatus,
  num payType,
  String phone,
  String principalIdCard,
  String principalName,
  String principalPhone,
  String remark,
  String screenFileId,
  String signId,
  String sort,
  String status,
  String unionNotaritionId,
  String unionNotaritionName,
  String unitGuid,
  String updateDate,
  String updateUserId,
  String notaryName,
  String invoiceFileUrl,
  num whetherDelegate,
}) => Records(  accepanceFileId: accepanceFileId ?? _accepanceFileId,
  acceptanceDate: acceptanceDate ?? _acceptanceDate,
  applicationFileId: applicationFileId ?? _applicationFileId,
  appraisalNotaritionId: appraisalNotaritionId ?? _appraisalNotaritionId,
  appraisalNotaritionName: appraisalNotaritionName ?? _appraisalNotaritionName,
  caseNumber: caseNumber ?? _caseNumber,
  createDate: createDate ?? _createDate,
  createUserId: createUserId ?? _createUserId,
  damageType: damageType ?? _damageType,
  deleteMark: deleteMark ?? _deleteMark,
  enabledMark: enabledMark ?? _enabledMark,
  idCard: idCard ?? _idCard,
  instructionsId: instructionsId ?? _instructionsId,
  insureNotaritionId: insureNotaritionId ?? _insureNotaritionId,
  inusureNotaritionName: inusureNotaritionName ?? _inusureNotaritionName,
  isChangeInfo: isChangeInfo ?? _isChangeInfo,
  isOnlinePay: isOnlinePay ?? _isOnlinePay,
  lotteryStatus: lotteryStatus ?? _lotteryStatus,
  money: money ?? _money,
  name: name ?? _name,
  notAcceptedReason: notAcceptedReason ?? _notAcceptedReason,
  notificationFileId: notificationFileId ?? _notificationFileId,
  payOrderNum: payOrderNum ?? _payOrderNum,
  payStatus: payStatus ?? _payStatus,
  payType: payType ?? _payType,
  phone: phone ?? _phone,
  principalIdCard: principalIdCard ?? _principalIdCard,
  principalName: principalName ?? _principalName,
  principalPhone: principalPhone ?? _principalPhone,
  remark: remark ?? _remark,
  screenFileId: screenFileId ?? _screenFileId,
  signId: signId ?? _signId,
  sort: sort ?? _sort,
  status: status ?? _status,
  unionNotaritionId: unionNotaritionId ?? _unionNotaritionId,
  unionNotaritionName: unionNotaritionName ?? _unionNotaritionName,
  unitGuid: unitGuid ?? _unitGuid,
  updateDate: updateDate ?? _updateDate,
  updateUserId: updateUserId ?? _updateUserId,
  notaryName: notaryName ?? _notaryName,
  invoiceFileUrl: invoiceFileUrl ?? _invoiceFileUrl,
  whetherDelegate: whetherDelegate ?? _whetherDelegate,
);
  String get accepanceFileId => _accepanceFileId;
  String get acceptanceDate => _acceptanceDate;
  String get applicationFileId => _applicationFileId;
  String get appraisalNotaritionId => _appraisalNotaritionId;
  String get appraisalNotaritionName => _appraisalNotaritionName;
  String get caseNumber => _caseNumber;
  String get createDate => _createDate;
  String get createUserId => _createUserId;
  num get damageType => _damageType;
  num get deleteMark => _deleteMark;
  num get enabledMark => _enabledMark;
  String get idCard => _idCard;
  String get instructionsId => _instructionsId;
  String get insureNotaritionId => _insureNotaritionId;
  String get inusureNotaritionName => _inusureNotaritionName;
  num get isChangeInfo => _isChangeInfo;
  num get isOnlinePay => _isOnlinePay;
  num get lotteryStatus => _lotteryStatus;
  num get money => _money;
  String get name => _name;
  String get notAcceptedReason => _notAcceptedReason;
  String get notificationFileId => _notificationFileId;
  String get payOrderNum => _payOrderNum;
  num get payStatus => _payStatus;
  num get payType => _payType;
  String get phone => _phone;
  String get principalIdCard => _principalIdCard;
  String get principalName => _principalName;
  String get principalPhone => _principalPhone;
  String get remark => _remark;
  String get screenFileId => _screenFileId;
  String get signId => _signId;
  String get sort => _sort;
  String get status => _status;
  String get unionNotaritionId => _unionNotaritionId;
  String get unionNotaritionName => _unionNotaritionName;
  String get unitGuid => _unitGuid;
  String get updateDate => _updateDate;
  String get updateUserId => _updateUserId;
  String get notaryName => _notaryName;
  String get invoiceFileUrl => _invoiceFileUrl;
  num get whetherDelegate => _whetherDelegate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['accepanceFileId'] = _accepanceFileId;
    map['acceptanceDate'] = _acceptanceDate;
    map['applicationFileId'] = _applicationFileId;
    map['appraisalNotaritionId'] = _appraisalNotaritionId;
    map['appraisalNotaritionName'] = _appraisalNotaritionName;
    map['caseNumber'] = _caseNumber;
    map['createDate'] = _createDate;
    map['createUserId'] = _createUserId;
    map['damageType'] = _damageType;
    map['deleteMark'] = _deleteMark;
    map['enabledMark'] = _enabledMark;
    map['idCard'] = _idCard;
    map['instructionsId'] = _instructionsId;
    map['insureNotaritionId'] = _insureNotaritionId;
    map['inusureNotaritionName'] = _inusureNotaritionName;
    map['isChangeInfo'] = _isChangeInfo;
    map['isOnlinePay'] = _isOnlinePay;
    map['lotteryStatus'] = _lotteryStatus;
    map['money'] = _money;
    map['name'] = _name;
    map['notAcceptedReason'] = _notAcceptedReason;
    map['notificationFileId'] = _notificationFileId;
    map['payOrderNum'] = _payOrderNum;
    map['payStatus'] = _payStatus;
    map['payType'] = _payType;
    map['phone'] = _phone;
    map['principalIdCard'] = _principalIdCard;
    map['principalName'] = _principalName;
    map['principalPhone'] = _principalPhone;
    map['remark'] = _remark;
    map['screenFileId'] = _screenFileId;
    map['signId'] = _signId;
    map['sort'] = _sort;
    map['status'] = _status;
    map['unionNotaritionId'] = _unionNotaritionId;
    map['unionNotaritionName'] = _unionNotaritionName;
    map['unitGuid'] = _unitGuid;
    map['updateDate'] = _updateDate;
    map['updateUserId'] = _updateUserId;
    map["notaryName"] = _notaryName;
    map["invoiceFileUrl"] = _invoiceFileUrl;
    map['whetherDelegate'] = _whetherDelegate;
    return map;
  }

}