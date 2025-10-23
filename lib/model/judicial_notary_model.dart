/// createdate : ""
/// createuserid : ""
/// deletemark : 0
/// description : ""
/// enabledmark : 0
/// institutionaddress : ""
/// institutionname : ""
/// institutionperson : ""
/// institutionphone : ""
/// remark : ""
/// sort : 0
/// status : ""
/// unionnotaritionid : ""
/// unitguid : ""
/// updatedate : ""
/// updateuserid : ""

class JudicialNotaryModel {
  JudicialNotaryModel({
      String createdate, 
      String createuserid, 
      num deletemark, 
      String description, 
      num enabledmark, 
      String institutionaddress, 
      String institutionname, 
      String institutionperson, 
      String institutionphone, 
      String remark, 
      num sort, 
      String status, 
      String unionnotaritionid, 
      String unitguid, 
      String updatedate, 
      String updateuserid,}){
    _createdate = createdate;
    _createuserid = createuserid;
    _deletemark = deletemark;
    _description = description;
    _enabledmark = enabledmark;
    _institutionaddress = institutionaddress;
    _institutionname = institutionname;
    _institutionperson = institutionperson;
    _institutionphone = institutionphone;
    _remark = remark;
    _sort = sort;
    _status = status;
    _unionnotaritionid = unionnotaritionid;
    _unitguid = unitguid;
    _updatedate = updatedate;
    _updateuserid = updateuserid;
}

  JudicialNotaryModel.fromJson(dynamic json) {
    _createdate = json['createdate'];
    _createuserid = json['createuserid'];
    _deletemark = json['deletemark'];
    _description = json['description'];
    _enabledmark = json['enabledmark'];
    _institutionaddress = json['institutionaddress'];
    _institutionname = json['institutionname'];
    _institutionperson = json['institutionperson'];
    _institutionphone = json['institutionphone'];
    _remark = json['remark'];
    _sort = json['sort'];
    _status = json['status'];
    _unionnotaritionid = json['unionnotaritionid'];
    _unitguid = json['unitguid'];
    _updatedate = json['updatedate'];
    _updateuserid = json['updateuserid'];
  }
  String _createdate;
  String _createuserid;
  num _deletemark;
  String _description;
  num _enabledmark;
  String _institutionaddress;
  String _institutionname;
  String _institutionperson;
  String _institutionphone;
  String _remark;
  num _sort;
  String _status;
  String _unionnotaritionid;
  String _unitguid;
  String _updatedate;
  String _updateuserid;
JudicialNotaryModel copyWith({  String createdate,
  String createuserid,
  num deletemark,
  String description,
  num enabledmark,
  String institutionaddress,
  String institutionname,
  String institutionperson,
  String institutionphone,
  String remark,
  num sort,
  String status,
  String unionnotaritionid,
  String unitguid,
  String updatedate,
  String updateuserid,
}) => JudicialNotaryModel(  createdate: createdate ?? _createdate,
  createuserid: createuserid ?? _createuserid,
  deletemark: deletemark ?? _deletemark,
  description: description ?? _description,
  enabledmark: enabledmark ?? _enabledmark,
  institutionaddress: institutionaddress ?? _institutionaddress,
  institutionname: institutionname ?? _institutionname,
  institutionperson: institutionperson ?? _institutionperson,
  institutionphone: institutionphone ?? _institutionphone,
  remark: remark ?? _remark,
  sort: sort ?? _sort,
  status: status ?? _status,
  unionnotaritionid: unionnotaritionid ?? _unionnotaritionid,
  unitguid: unitguid ?? _unitguid,
  updatedate: updatedate ?? _updatedate,
  updateuserid: updateuserid ?? _updateuserid,
);
  String get createdate => _createdate;
  String get createuserid => _createuserid;
  num get deletemark => _deletemark;
  String get description => _description;
  num get enabledmark => _enabledmark;
  String get institutionaddress => _institutionaddress;
  String get institutionname => _institutionname;
  String get institutionperson => _institutionperson;
  String get institutionphone => _institutionphone;
  String get remark => _remark;
  num get sort => _sort;
  String get status => _status;
  String get unionnotaritionid => _unionnotaritionid;
  String get unitguid => _unitguid;
  String get updatedate => _updatedate;
  String get updateuserid => _updateuserid;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['createdate'] = _createdate;
    map['createuserid'] = _createuserid;
    map['deletemark'] = _deletemark;
    map['description'] = _description;
    map['enabledmark'] = _enabledmark;
    map['institutionaddress'] = _institutionaddress;
    map['institutionname'] = _institutionname;
    map['institutionperson'] = _institutionperson;
    map['institutionphone'] = _institutionphone;
    map['remark'] = _remark;
    map['sort'] = _sort;
    map['status'] = _status;
    map['unionnotaritionid'] = _unionnotaritionid;
    map['unitguid'] = _unitguid;
    map['updatedate'] = _updatedate;
    map['updateuserid'] = _updateuserid;
    return map;
  }

}