/// createDate : ""
/// greffierName : ""
/// linkStatus : 0
/// notarizationTypes : ""
/// orderNo : ""
/// unitGuid : ""

class OrderReenterStatusModel {
  OrderReenterStatusModel({
      String createDate, 
      String greffierName, 
      num linkStatus, 
      String notarizationTypes, 
      String orderNo, 
      String unitGuid,}){
    _createDate = createDate;
    _greffierName = greffierName;
    _linkStatus = linkStatus;
    _notarizationTypes = notarizationTypes;
    _orderNo = orderNo;
    _unitGuid = unitGuid;
}

  OrderReenterStatusModel.fromJson(dynamic json) {
    _createDate = json['createDate'];
    _greffierName = json['greffierName'];
    _linkStatus = json['linkStatus'];
    _notarizationTypes = json['notarizationTypes'];
    _orderNo = json['orderNo'];
    _unitGuid = json['unitGuid'];
  }
  String _createDate;
  String _greffierName;
  num _linkStatus;
  String _notarizationTypes;
  String _orderNo;
  String _unitGuid;
OrderReenterStatusModel copyWith({  String createDate,
  String greffierName,
  num linkStatus,
  String notarizationTypes,
  String orderNo,
  String unitGuid,
}) => OrderReenterStatusModel(  createDate: createDate ?? _createDate,
  greffierName: greffierName ?? _greffierName,
  linkStatus: linkStatus ?? _linkStatus,
  notarizationTypes: notarizationTypes ?? _notarizationTypes,
  orderNo: orderNo ?? _orderNo,
  unitGuid: unitGuid ?? _unitGuid,
);
  String get createDate => _createDate;
  String get greffierName => _greffierName;
  num get linkStatus => _linkStatus;
  String get notarizationTypes => _notarizationTypes;
  String get orderNo => _orderNo;
  String get unitGuid => _unitGuid;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['createDate'] = _createDate;
    map['greffierName'] = _greffierName;
    map['linkStatus'] = _linkStatus;
    map['notarizationTypes'] = _notarizationTypes;
    map['orderNo'] = _orderNo;
    map['unitGuid'] = _unitGuid;
    return map;
  }

}