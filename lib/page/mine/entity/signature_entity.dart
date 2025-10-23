/// businessLicenseFile : ""  	营业执照文件
/// createDate : ""  创建时间
/// enterpriseName : ""    企业名称
/// enterpriseSealUrl : ""   企业章地址
/// idBackFile : ""  法人背面照片
/// idFrontFile : ""  法人正面照片
/// organizationCode : ""  组织机构代码
/// unitGuid : "" 企业主键
/// userType : 0  用户类型
/// status :  0  状态

class SignatureEntity {
  SignatureEntity({
    String businessLicenseFile,
    String createDate,
    String enterpriseName,
    String enterpriseSealUrl,
    String idBackFile,
    String idFrontFile,
    String organizationCode,
    String unitGuid,
    int status,
    num userType,}){
    _businessLicenseFile = businessLicenseFile;
    _createDate = createDate;
    _enterpriseName = enterpriseName;
    _enterpriseSealUrl = enterpriseSealUrl;
    _idBackFile = idBackFile;
    _idFrontFile = idFrontFile;
    _organizationCode = organizationCode;
    _unitGuid = unitGuid;
    _userType = userType;
    _status = status;
  }

  set businessLicenseFile(String value) {
    _businessLicenseFile = value;
  }

  SignatureEntity.fromJson(dynamic json) {
    _businessLicenseFile = json['businessLicenseFile'];
    _createDate = json['createDate'];
    _enterpriseName = json['enterpriseName'];
    _enterpriseSealUrl = json['enterpriseSealUrl'];
    _idBackFile = json['idBackFile'];
    _idFrontFile = json['idFrontFile'];
    _organizationCode = json['organizationCode'];
    _unitGuid = json['unitGuid'];
    _userType = json['userType'];
    _status = json['status'];
  }
  String _businessLicenseFile;
  String _createDate;
  String _enterpriseName;
  String _enterpriseSealUrl;
  String _idBackFile;
  String _idFrontFile;
  String _organizationCode;
  String _unitGuid;
  int _status;
  num _userType;
  SignatureEntity copyWith({  String businessLicenseFile,
    String createDate,
    String enterpriseName,
    String enterpriseSealUrl,
    String idBackFile,
    String idFrontFile,
    String organizationCode,
    String unitGuid,
    int status,
    num userType,
  }) => SignatureEntity(  businessLicenseFile: businessLicenseFile ?? _businessLicenseFile,
    createDate: createDate ?? _createDate,
    enterpriseName: enterpriseName ?? _enterpriseName,
    enterpriseSealUrl: enterpriseSealUrl ?? _enterpriseSealUrl,
    idBackFile: idBackFile ?? _idBackFile,
    idFrontFile: idFrontFile ?? _idFrontFile,
    organizationCode: organizationCode ?? _organizationCode,
    unitGuid: unitGuid ?? _unitGuid,
    userType: userType ?? _userType,
    status: status ?? _status,
  );
  String get businessLicenseFile => _businessLicenseFile;
  String get createDate => _createDate;
  String get enterpriseName => _enterpriseName;
  String get enterpriseSealUrl => _enterpriseSealUrl;
  String get idBackFile => _idBackFile;
  String get idFrontFile => _idFrontFile;
  String get organizationCode => _organizationCode;
  String get unitGuid => _unitGuid;
  num get userType => _userType;
  int get status => _status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['businessLicenseFile'] = _businessLicenseFile;
    map['createDate'] = _createDate;
    map['enterpriseName'] = _enterpriseName;
    map['enterpriseSealUrl'] = _enterpriseSealUrl;
    map['idBackFile'] = _idBackFile;
    map['idFrontFile'] = _idFrontFile;
    map['organizationCode'] = _organizationCode;
    map['unitGuid'] = _unitGuid;
    map['userType'] = _userType;
    map['status'] = _status;
    return map;
  }

  set createDate(String value) {
    _createDate = value;
  }

  set enterpriseName(String value) {
    _enterpriseName = value;
  }

  set enterpriseSealUrl(String value) {
    _enterpriseSealUrl = value;
  }

  set idBackFile(String value) {
    _idBackFile = value;
  }

  set idFrontFile(String value) {
    _idFrontFile = value;
  }

  set organizationCode(String value) {
    _organizationCode = value;
  }

  set unitGuid(String value) {
    _unitGuid = value;
  }

  set status(int value) {
    _status = value;
  }

  set userType(num value) {
    _userType = value;
  }
}