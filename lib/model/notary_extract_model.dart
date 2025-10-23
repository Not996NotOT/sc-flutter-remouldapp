/// success : true
/// data : {"total":2,"size":9999,"current":1,"records":[{"unitguid":"5989da1f-051f-4c7c-bffe-d884d669d9a8","enabledmark":1,"deletemark":0,"description":null,"createuserid":"a76062dd-670d-4470-9b51-8de02ec3633b","createdate":"2023-10-26 18:56:30","updateuserid":null,"updatedate":null,"status":null,"remark":null,"sort":null,"institutionname":"南京市第二鉴定机构","institutionaddress":"南京市高铁区","institutionphone":"18171205195","institutionperson":"汪肖","unionnotaritionid":"57e3196b-e5a9-4718-bfdf-549f826ecf11"},{"unitguid":"e7987576-296c-4e8d-a622-3038b6c15b0c","enabledmark":1,"deletemark":0,"description":null,"createuserid":"a76062dd-670d-4470-9b51-8de02ec3633b","createdate":"2023-11-01 21:14:19","updateuserid":null,"updatedate":null,"status":null,"remark":null,"sort":null,"institutionname":"武汉市第一鉴定机构","institutionaddress":"武汉市江汉区","institutionphone":"18171205195","institutionperson":"周建","unionnotaritionid":"3beb0bd8-8d7d-4994-a147-6cc7c401ba4b"}]}
/// code : 200
/// message : "成功"

class NotaryExtractModel {
  NotaryExtractModel({
      bool success, 
      Data data, 
      num code, 
      String message,}){
    _success = success;
    _data = data;
    _code = code;
    _message = message;
}

  NotaryExtractModel.fromJson(dynamic json) {
    _success = json['success'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
    _code = json['code'];
    _message = json['message'];
  }
  bool _success;
  Data _data;
  num _code;
  String _message;
  NotaryExtractModel copyWith({  bool success,
  Data data,
  num code,
  String message,
}) => NotaryExtractModel(  success: success ?? _success,
  data: data ?? _data,
  code: code ?? _code,
  message: message ?? _message,
);
  bool get success => _success;
  Data get data => _data;
  num get code => _code;
  String get message => _message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    if (_data != null) {
      map['data'] = _data.toJson();
    }
    map['code'] = _code;
    map['message'] = _message;
    return map;
  }

}

/// total : 2
/// size : 9999
/// current : 1
/// records : [{"unitguid":"5989da1f-051f-4c7c-bffe-d884d669d9a8","enabledmark":1,"deletemark":0,"description":null,"createuserid":"a76062dd-670d-4470-9b51-8de02ec3633b","createdate":"2023-10-26 18:56:30","updateuserid":null,"updatedate":null,"status":null,"remark":null,"sort":null,"institutionname":"南京市第二鉴定机构","institutionaddress":"南京市高铁区","institutionphone":"18171205195","institutionperson":"汪肖","unionnotaritionid":"57e3196b-e5a9-4718-bfdf-549f826ecf11"},{"unitguid":"e7987576-296c-4e8d-a622-3038b6c15b0c","enabledmark":1,"deletemark":0,"description":null,"createuserid":"a76062dd-670d-4470-9b51-8de02ec3633b","createdate":"2023-11-01 21:14:19","updateuserid":null,"updatedate":null,"status":null,"remark":null,"sort":null,"institutionname":"武汉市第一鉴定机构","institutionaddress":"武汉市江汉区","institutionphone":"18171205195","institutionperson":"周建","unionnotaritionid":"3beb0bd8-8d7d-4994-a147-6cc7c401ba4b"}]

class Data {
  Data({
      List<Records> records,}){
    _records = records;
}

  Data.fromJson(dynamic json) {
    if (json['records'] != null) {
      _records = [];
      json['records'].forEach((v) {
        _records.add(Records.fromJson(v));
      });
    }
  }
  List<Records> _records;
Data copyWith({
  List<Records> records,
}) => Data(
  records: records ?? _records,
);
  List<Records> get records => _records;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_records != null) {
      map['records'] = _records.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// unitguid : "5989da1f-051f-4c7c-bffe-d884d669d9a8"
/// enabledmark : 1
/// deletemark : 0
/// description : null
/// createuserid : "a76062dd-670d-4470-9b51-8de02ec3633b"
/// createdate : "2023-10-26 18:56:30"
/// updateuserid : null
/// updatedate : null
/// status : null
/// remark : null
/// sort : null
/// institutionname : "南京市第二鉴定机构"
/// institutionaddress : "南京市高铁区"
/// institutionphone : "18171205195"
/// institutionperson : "汪肖"
/// unionnotaritionid : "57e3196b-e5a9-4718-bfdf-549f826ecf11"

class Records {
  Records({
      String unitguid, 
      num enabledmark, 
      num deletemark, 
      dynamic description, 
      String createuserid, 
      String createdate, 
      dynamic updateuserid, 
      dynamic updatedate, 
      dynamic status, 
      dynamic remark, 
      dynamic sort, 
      String institutionname, 
      String institutionaddress, 
      String institutionphone, 
      String institutionperson, 
      String unionnotaritionid,}){
    _unitguid = unitguid;
    _enabledmark = enabledmark;
    _deletemark = deletemark;
    _description = description;
    _createuserid = createuserid;
    _createdate = createdate;
    _updateuserid = updateuserid;
    _updatedate = updatedate;
    _status = status;
    _remark = remark;
    _sort = sort;
    _institutionname = institutionname;
    _institutionaddress = institutionaddress;
    _institutionphone = institutionphone;
    _institutionperson = institutionperson;
    _unionnotaritionid = unionnotaritionid;
}

  Records.fromJson(dynamic json) {
    _unitguid = json['unitguid'];
    _enabledmark = json['enabledmark'];
    _deletemark = json['deletemark'];
    _description = json['description'];
    _createuserid = json['createuserid'];
    _createdate = json['createdate'];
    _updateuserid = json['updateuserid'];
    _updatedate = json['updatedate'];
    _status = json['status'];
    _remark = json['remark'];
    _sort = json['sort'];
    _institutionname = json['institutionname'];
    _institutionaddress = json['institutionaddress'];
    _institutionphone = json['institutionphone'];
    _institutionperson = json['institutionperson'];
    _unionnotaritionid = json['unionnotaritionid'];
  }
  String _unitguid;
  num _enabledmark;
  num _deletemark;
  dynamic _description;
  String _createuserid;
  String _createdate;
  dynamic _updateuserid;
  dynamic _updatedate;
  dynamic _status;
  dynamic _remark;
  dynamic _sort;
  String _institutionname;
  String _institutionaddress;
  String _institutionphone;
  String _institutionperson;
  String _unionnotaritionid;
Records copyWith({  String unitguid,
  num enabledmark,
  num deletemark,
  dynamic description,
  String createuserid,
  String createdate,
  dynamic updateuserid,
  dynamic updatedate,
  dynamic status,
  dynamic remark,
  dynamic sort,
  String institutionname,
  String institutionaddress,
  String institutionphone,
  String institutionperson,
  String unionnotaritionid,
}) => Records(  unitguid: unitguid ?? _unitguid,
  enabledmark: enabledmark ?? _enabledmark,
  deletemark: deletemark ?? _deletemark,
  description: description ?? _description,
  createuserid: createuserid ?? _createuserid,
  createdate: createdate ?? _createdate,
  updateuserid: updateuserid ?? _updateuserid,
  updatedate: updatedate ?? _updatedate,
  status: status ?? _status,
  remark: remark ?? _remark,
  sort: sort ?? _sort,
  institutionname: institutionname ?? _institutionname,
  institutionaddress: institutionaddress ?? _institutionaddress,
  institutionphone: institutionphone ?? _institutionphone,
  institutionperson: institutionperson ?? _institutionperson,
  unionnotaritionid: unionnotaritionid ?? _unionnotaritionid,
);
  String get unitguid => _unitguid;
  num get enabledmark => _enabledmark;
  num get deletemark => _deletemark;
  dynamic get description => _description;
  String get createuserid => _createuserid;
  String get createdate => _createdate;
  dynamic get updateuserid => _updateuserid;
  dynamic get updatedate => _updatedate;
  dynamic get status => _status;
  dynamic get remark => _remark;
  dynamic get sort => _sort;
  String get institutionname => _institutionname;
  String get institutionaddress => _institutionaddress;
  String get institutionphone => _institutionphone;
  String get institutionperson => _institutionperson;
  String get unionnotaritionid => _unionnotaritionid;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['unitguid'] = _unitguid;
    map['enabledmark'] = _enabledmark;
    map['deletemark'] = _deletemark;
    map['description'] = _description;
    map['createuserid'] = _createuserid;
    map['createdate'] = _createdate;
    map['updateuserid'] = _updateuserid;
    map['updatedate'] = _updatedate;
    map['status'] = _status;
    map['remark'] = _remark;
    map['sort'] = _sort;
    map['institutionname'] = _institutionname;
    map['institutionaddress'] = _institutionaddress;
    map['institutionphone'] = _institutionphone;
    map['institutionperson'] = _institutionperson;
    map['unionnotaritionid'] = _unionnotaritionid;
    return map;
  }

}