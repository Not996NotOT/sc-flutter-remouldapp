/// acceptanceDate : ""
/// agents : [{"gender":0,"idCard":"","mobile":"","name":"","principal":"","unitGuid":""}]
/// applicants : [{"address":"","idCard":"","mobile":"","name":"","unitGuid":""}]
/// applyDate : ""
/// doorFee : ""
/// enterprises : [{"companyAdd":"","companyName":"","statutoryMobile":"","statutoryPerson":"","unitGuid":""}]
/// fanYiFee : ""
/// fuBenFee : ""
/// gongZhengFee : ""
/// greffierId : ""
/// greffierName : ""
/// gzFanYiFee : ""
/// itemCode : ""
/// itemName : ""
/// lawFee : ""
/// linkStatus : 0
/// materialName : ""
/// materials : [{"filePath":"","materialName":"","unitGuid":""}]
/// notarialFiles : [{"fileName":"","filePath":"","fileType":0,"unitGuid":""}]
/// notaryId : ""
/// notaryItems : [{"notarizationTypeCode":"","notarizationTypeName":""}]
/// notaryName : ""
/// orderNo : ""
/// otherFee : ""
/// purposeName : ""
/// remarks : ""
/// signInfo : []
/// status : 0
/// sydCode : ""
/// syly : ""
/// unitGuid : ""
/// useArea : ""
/// useLanguage : ""
/// videoFee : ""
/// wordId : ""
/// yt : ""
/// ywwzId : ""

class OrderReenterStatusInfoModel {
  OrderReenterStatusInfoModel({
      String acceptanceDate, 
      List<Agents> agents, 
      List<Applicants> applicants, 
      String applyDate, 
      String doorFee, 
      List<Enterprises> enterprises, 
      String fanYiFee, 
      String fuBenFee, 
      String gongZhengFee, 
      String greffierId, 
      String greffierName, 
      String gzFanYiFee, 
      String itemCode, 
      String itemName, 
      String lawFee, 
      num linkStatus, 
      String materialName, 
      List<Materials> materials, 
      List<NotarialFiles> notarialFiles, 
      String notaryId, 
      List<NotaryItems> notaryItems, 
      String notaryName, 
      String orderNo, 
      String otherFee, 
      String purposeName, 
      String remarks, 
      List signInfo,
      num status, 
      String sydCode, 
      String syly, 
      String unitGuid, 
      String useArea, 
      String useLanguage, 
      String videoFee, 
      String wordId, 
      String yt, 
      String ywwzId,}){
    _acceptanceDate = acceptanceDate;
    _agents = agents;
    _applicants = applicants;
    _applyDate = applyDate;
    _doorFee = doorFee;
    _enterprises = enterprises;
    _fanYiFee = fanYiFee;
    _fuBenFee = fuBenFee;
    _gongZhengFee = gongZhengFee;
    _greffierId = greffierId;
    _greffierName = greffierName;
    _gzFanYiFee = gzFanYiFee;
    _itemCode = itemCode;
    _itemName = itemName;
    _lawFee = lawFee;
    _linkStatus = linkStatus;
    _materialName = materialName;
    _materials = materials;
    _notarialFiles = notarialFiles;
    _notaryId = notaryId;
    _notaryItems = notaryItems;
    _notaryName = notaryName;
    _orderNo = orderNo;
    _otherFee = otherFee;
    _purposeName = purposeName;
    _remarks = remarks;
    _signInfo = signInfo;
    _status = status;
    _sydCode = sydCode;
    _syly = syly;
    _unitGuid = unitGuid;
    _useArea = useArea;
    _useLanguage = useLanguage;
    _videoFee = videoFee;
    _wordId = wordId;
    _yt = yt;
    _ywwzId = ywwzId;
}

  OrderReenterStatusInfoModel.fromJson(dynamic json) {
    _acceptanceDate = json['acceptanceDate'];
    if (json['agents'] != null) {
      _agents = [];
      json['agents'].forEach((v) {
        _agents.add(Agents.fromJson(v));
      });
    }
    if (json['applicants'] != null) {
      _applicants = [];
      json['applicants'].forEach((v) {
        _applicants.add(Applicants.fromJson(v));
      });
    }
    _applyDate = json['applyDate'];
    _doorFee = json['doorFee'];
    if (json['enterprises'] != null) {
      _enterprises = [];
      json['enterprises'].forEach((v) {
        _enterprises.add(Enterprises.fromJson(v));
      });
    }
    _fanYiFee = json['fanYiFee'];
    _fuBenFee = json['fuBenFee'];
    _gongZhengFee = json['gongZhengFee'];
    _greffierId = json['greffierId'];
    _greffierName = json['greffierName'];
    _gzFanYiFee = json['gzFanYiFee'];
    _itemCode = json['itemCode'];
    _itemName = json['itemName'];
    _lawFee = json['lawFee'];
    _linkStatus = json['linkStatus'];
    _materialName = json['materialName'];
    if (json['materials'] != null) {
      _materials = [];
      json['materials'].forEach((v) {
        _materials.add(Materials.fromJson(v));
      });
    }
    if (json['notarialFiles'] != null) {
      _notarialFiles = [];
      json['notarialFiles'].forEach((v) {
        _notarialFiles.add(NotarialFiles.fromJson(v));
      });
    }
    _notaryId = json['notaryId'];
    if (json['notaryItems'] != null) {
      _notaryItems = [];
      json['notaryItems'].forEach((v) {
        _notaryItems.add(NotaryItems.fromJson(v));
      });
    }
    _notaryName = json['notaryName'];
    _orderNo = json['orderNo'];
    _otherFee = json['otherFee'];
    _purposeName = json['purposeName'];
    _remarks = json['remarks'];
    if (json['signInfo'] != null) {
      _signInfo = json['signInfo'];
    }
    _status = json['status'];
    _sydCode = json['sydCode'];
    _syly = json['syly'];
    _unitGuid = json['unitGuid'];
    _useArea = json['useArea'];
    _useLanguage = json['useLanguage'];
    _videoFee = json['videoFee'];
    _wordId = json['wordId'];
    _yt = json['yt'];
    _ywwzId = json['ywwzId'];
  }
  String _acceptanceDate;
  List<Agents> _agents;
  List<Applicants> _applicants;
  String _applyDate;
  String _doorFee;
  List<Enterprises> _enterprises;
  String _fanYiFee;
  String _fuBenFee;
  String _gongZhengFee;
  String _greffierId;
  String _greffierName;
  String _gzFanYiFee;
  String _itemCode;
  String _itemName;
  String _lawFee;
  num _linkStatus;
  String _materialName;
  List<Materials> _materials;
  List<NotarialFiles> _notarialFiles;
  String _notaryId;
  List<NotaryItems> _notaryItems;
  String _notaryName;
  String _orderNo;
  String _otherFee;
  String _purposeName;
  String _remarks;
  List _signInfo;
  num _status;
  String _sydCode;
  String _syly;
  String _unitGuid;
  String _useArea;
  String _useLanguage;
  String _videoFee;
  String _wordId;
  String _yt;
  String _ywwzId;
OrderReenterStatusInfoModel copyWith({  String acceptanceDate,
  List<Agents> agents,
  List<Applicants> applicants,
  String applyDate,
  String doorFee,
  List<Enterprises> enterprises,
  String fanYiFee,
  String fuBenFee,
  String gongZhengFee,
  String greffierId,
  String greffierName,
  String gzFanYiFee,
  String itemCode,
  String itemName,
  String lawFee,
  num linkStatus,
  String materialName,
  List<Materials> materials,
  List<NotarialFiles> notarialFiles,
  String notaryId,
  List<NotaryItems> notaryItems,
  String notaryName,
  String orderNo,
  String otherFee,
  String purposeName,
  String remarks,
  List signInfo,
  num status,
  String sydCode,
  String syly,
  String unitGuid,
  String useArea,
  String useLanguage,
  String videoFee,
  String wordId,
  String yt,
  String ywwzId,
}) => OrderReenterStatusInfoModel(  acceptanceDate: acceptanceDate ?? _acceptanceDate,
  agents: agents ?? _agents,
  applicants: applicants ?? _applicants,
  applyDate: applyDate ?? _applyDate,
  doorFee: doorFee ?? _doorFee,
  enterprises: enterprises ?? _enterprises,
  fanYiFee: fanYiFee ?? _fanYiFee,
  fuBenFee: fuBenFee ?? _fuBenFee,
  gongZhengFee: gongZhengFee ?? _gongZhengFee,
  greffierId: greffierId ?? _greffierId,
  greffierName: greffierName ?? _greffierName,
  gzFanYiFee: gzFanYiFee ?? _gzFanYiFee,
  itemCode: itemCode ?? _itemCode,
  itemName: itemName ?? _itemName,
  lawFee: lawFee ?? _lawFee,
  linkStatus: linkStatus ?? _linkStatus,
  materialName: materialName ?? _materialName,
  materials: materials ?? _materials,
  notarialFiles: notarialFiles ?? _notarialFiles,
  notaryId: notaryId ?? _notaryId,
  notaryItems: notaryItems ?? _notaryItems,
  notaryName: notaryName ?? _notaryName,
  orderNo: orderNo ?? _orderNo,
  otherFee: otherFee ?? _otherFee,
  purposeName: purposeName ?? _purposeName,
  remarks: remarks ?? _remarks,
  signInfo: signInfo ?? _signInfo,
  status: status ?? _status,
  sydCode: sydCode ?? _sydCode,
  syly: syly ?? _syly,
  unitGuid: unitGuid ?? _unitGuid,
  useArea: useArea ?? _useArea,
  useLanguage: useLanguage ?? _useLanguage,
  videoFee: videoFee ?? _videoFee,
  wordId: wordId ?? _wordId,
  yt: yt ?? _yt,
  ywwzId: ywwzId ?? _ywwzId,
);
  String get acceptanceDate => _acceptanceDate;
  List<Agents> get agents => _agents;
  List<Applicants> get applicants => _applicants;
  String get applyDate => _applyDate;
  String get doorFee => _doorFee;
  List<Enterprises> get enterprises => _enterprises;
  String get fanYiFee => _fanYiFee;
  String get fuBenFee => _fuBenFee;
  String get gongZhengFee => _gongZhengFee;
  String get greffierId => _greffierId;
  String get greffierName => _greffierName;
  String get gzFanYiFee => _gzFanYiFee;
  String get itemCode => _itemCode;
  String get itemName => _itemName;
  String get lawFee => _lawFee;
  num get linkStatus => _linkStatus;
  String get materialName => _materialName;
  List<Materials> get materials => _materials;
  List<NotarialFiles> get notarialFiles => _notarialFiles;
  String get notaryId => _notaryId;
  List<NotaryItems> get notaryItems => _notaryItems;
  String get notaryName => _notaryName;
  String get orderNo => _orderNo;
  String get otherFee => _otherFee;
  String get purposeName => _purposeName;
  String get remarks => _remarks;
  List get signInfo => _signInfo;
  num get status => _status;
  String get sydCode => _sydCode;
  String get syly => _syly;
  String get unitGuid => _unitGuid;
  String get useArea => _useArea;
  String get useLanguage => _useLanguage;
  String get videoFee => _videoFee;
  String get wordId => _wordId;
  String get yt => _yt;
  String get ywwzId => _ywwzId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['acceptanceDate'] = _acceptanceDate;
    if (_agents != null) {
      map['agents'] = _agents.map((v) => v.toJson()).toList();
    }
    if (_applicants != null) {
      map['applicants'] = _applicants.map((v) => v.toJson()).toList();
    }
    map['applyDate'] = _applyDate;
    map['doorFee'] = _doorFee;
    if (_enterprises != null) {
      map['enterprises'] = _enterprises.map((v) => v.toJson()).toList();
    }
    map['fanYiFee'] = _fanYiFee;
    map['fuBenFee'] = _fuBenFee;
    map['gongZhengFee'] = _gongZhengFee;
    map['greffierId'] = _greffierId;
    map['greffierName'] = _greffierName;
    map['gzFanYiFee'] = _gzFanYiFee;
    map['itemCode'] = _itemCode;
    map['itemName'] = _itemName;
    map['lawFee'] = _lawFee;
    map['linkStatus'] = _linkStatus;
    map['materialName'] = _materialName;
    if (_materials != null) {
      map['materials'] = _materials.map((v) => v.toJson()).toList();
    }
    if (_notarialFiles != null) {
      map['notarialFiles'] = _notarialFiles.map((v) => v.toJson()).toList();
    }
    map['notaryId'] = _notaryId;
    if (_notaryItems != null) {
      map['notaryItems'] = _notaryItems.map((v) => v.toJson()).toList();
    }
    map['notaryName'] = _notaryName;
    map['orderNo'] = _orderNo;
    map['otherFee'] = _otherFee;
    map['purposeName'] = _purposeName;
    map['remarks'] = _remarks;
    if (_signInfo != null) {
      map['signInfo'] = _signInfo;
    }
    map['status'] = _status;
    map['sydCode'] = _sydCode;
    map['syly'] = _syly;
    map['unitGuid'] = _unitGuid;
    map['useArea'] = _useArea;
    map['useLanguage'] = _useLanguage;
    map['videoFee'] = _videoFee;
    map['wordId'] = _wordId;
    map['yt'] = _yt;
    map['ywwzId'] = _ywwzId;
    return map;
  }

}

/// notarizationTypeCode : ""
/// notarizationTypeName : ""

class NotaryItems {
  NotaryItems({
      String notarizationTypeCode, 
      String notarizationTypeName,}){
    _notarizationTypeCode = notarizationTypeCode;
    _notarizationTypeName = notarizationTypeName;
}

  NotaryItems.fromJson(dynamic json) {
    _notarizationTypeCode = json['notarizationTypeCode'];
    _notarizationTypeName = json['notarizationTypeName'];
  }
  String _notarizationTypeCode;
  String _notarizationTypeName;
NotaryItems copyWith({  String notarizationTypeCode,
  String notarizationTypeName,
}) => NotaryItems(  notarizationTypeCode: notarizationTypeCode ?? _notarizationTypeCode,
  notarizationTypeName: notarizationTypeName ?? _notarizationTypeName,
);
  String get notarizationTypeCode => _notarizationTypeCode;
  String get notarizationTypeName => _notarizationTypeName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['notarizationTypeCode'] = _notarizationTypeCode;
    map['notarizationTypeName'] = _notarizationTypeName;
    return map;
  }

}

/// fileName : ""
/// filePath : ""
/// fileType : 0
/// unitGuid : ""

class NotarialFiles {
  NotarialFiles({
      String fileName, 
      String filePath, 
      num fileType, 
      String unitGuid,}){
    _fileName = fileName;
    _filePath = filePath;
    _fileType = fileType;
    _unitGuid = unitGuid;
}

  NotarialFiles.fromJson(dynamic json) {
    _fileName = json['fileName'];
    _filePath = json['filePath'];
    _fileType = json['fileType'];
    _unitGuid = json['unitGuid'];
  }
  String _fileName;
  String _filePath;
  num _fileType;
  String _unitGuid;
NotarialFiles copyWith({  String fileName,
  String filePath,
  num fileType,
  String unitGuid,
}) => NotarialFiles(  fileName: fileName ?? _fileName,
  filePath: filePath ?? _filePath,
  fileType: fileType ?? _fileType,
  unitGuid: unitGuid ?? _unitGuid,
);
  String get fileName => _fileName;
  String get filePath => _filePath;
  num get fileType => _fileType;
  String get unitGuid => _unitGuid;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['fileName'] = _fileName;
    map['filePath'] = _filePath;
    map['fileType'] = _fileType;
    map['unitGuid'] = _unitGuid;
    return map;
  }

}

/// filePath : ""
/// materialName : ""
/// unitGuid : ""

class Materials {
  Materials({
      String filePath, 
      String materialName, 
      String unitGuid,}){
    _filePath = filePath;
    _materialName = materialName;
    _unitGuid = unitGuid;
}

  Materials.fromJson(dynamic json) {
    _filePath = json['filePath'];
    _materialName = json['materialName'];
    _unitGuid = json['unitGuid'];
  }
  String _filePath;
  String _materialName;
  String _unitGuid;
Materials copyWith({  String filePath,
  String materialName,
  String unitGuid,
}) => Materials(  filePath: filePath ?? _filePath,
  materialName: materialName ?? _materialName,
  unitGuid: unitGuid ?? _unitGuid,
);
  String get filePath => _filePath;
  String get materialName => _materialName;
  String get unitGuid => _unitGuid;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['filePath'] = _filePath;
    map['materialName'] = _materialName;
    map['unitGuid'] = _unitGuid;
    return map;
  }

}

/// companyAdd : ""
/// companyName : ""
/// statutoryMobile : ""
/// statutoryPerson : ""
/// unitGuid : ""

class Enterprises {
  Enterprises({
      String companyAdd, 
      String companyName, 
      String statutoryMobile, 
      String statutoryPerson, 
      String unitGuid,}){
    _companyAdd = companyAdd;
    _companyName = companyName;
    _statutoryMobile = statutoryMobile;
    _statutoryPerson = statutoryPerson;
    _unitGuid = unitGuid;
}

  Enterprises.fromJson(dynamic json) {
    _companyAdd = json['companyAdd'];
    _companyName = json['companyName'];
    _statutoryMobile = json['statutoryMobile'];
    _statutoryPerson = json['statutoryPerson'];
    _unitGuid = json['unitGuid'];
  }
  String _companyAdd;
  String _companyName;
  String _statutoryMobile;
  String _statutoryPerson;
  String _unitGuid;
Enterprises copyWith({  String companyAdd,
  String companyName,
  String statutoryMobile,
  String statutoryPerson,
  String unitGuid,
}) => Enterprises(  companyAdd: companyAdd ?? _companyAdd,
  companyName: companyName ?? _companyName,
  statutoryMobile: statutoryMobile ?? _statutoryMobile,
  statutoryPerson: statutoryPerson ?? _statutoryPerson,
  unitGuid: unitGuid ?? _unitGuid,
);
  String get companyAdd => _companyAdd;
  String get companyName => _companyName;
  String get statutoryMobile => _statutoryMobile;
  String get statutoryPerson => _statutoryPerson;
  String get unitGuid => _unitGuid;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['companyAdd'] = _companyAdd;
    map['companyName'] = _companyName;
    map['statutoryMobile'] = _statutoryMobile;
    map['statutoryPerson'] = _statutoryPerson;
    map['unitGuid'] = _unitGuid;
    return map;
  }

}

/// address : ""
/// idCard : ""
/// mobile : ""
/// name : ""
/// unitGuid : ""

class Applicants {
  Applicants({
      String address, 
      String idCard, 
      String mobile, 
      String name, 
      String unitGuid,}){
    _address = address;
    _idCard = idCard;
    _mobile = mobile;
    _name = name;
    _unitGuid = unitGuid;
}

  Applicants.fromJson(dynamic json) {
    _address = json['address'];
    _idCard = json['idCard'];
    _mobile = json['mobile'];
    _name = json['name'];
    _unitGuid = json['unitGuid'];
  }
  String _address;
  String _idCard;
  String _mobile;
  String _name;
  String _unitGuid;
Applicants copyWith({  String address,
  String idCard,
  String mobile,
  String name,
  String unitGuid,
}) => Applicants(  address: address ?? _address,
  idCard: idCard ?? _idCard,
  mobile: mobile ?? _mobile,
  name: name ?? _name,
  unitGuid: unitGuid ?? _unitGuid,
);
  String get address => _address;
  String get idCard => _idCard;
  String get mobile => _mobile;
  String get name => _name;
  String get unitGuid => _unitGuid;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['address'] = _address;
    map['idCard'] = _idCard;
    map['mobile'] = _mobile;
    map['name'] = _name;
    map['unitGuid'] = _unitGuid;
    return map;
  }

}

/// gender : 0
/// idCard : ""
/// mobile : ""
/// name : ""
/// principal : ""
/// unitGuid : ""

class Agents {
  Agents({
      num gender, 
      String idCard, 
      String mobile, 
      String name, 
      String principal, 
      String unitGuid,}){
    _gender = gender;
    _idCard = idCard;
    _mobile = mobile;
    _name = name;
    _principal = principal;
    _unitGuid = unitGuid;
}

  Agents.fromJson(dynamic json) {
    _gender = json['gender'];
    _idCard = json['idCard'];
    _mobile = json['mobile'];
    _name = json['name'];
    _principal = json['principal'];
    _unitGuid = json['unitGuid'];
  }
  num _gender;
  String _idCard;
  String _mobile;
  String _name;
  String _principal;
  String _unitGuid;
Agents copyWith({  num gender,
  String idCard,
  String mobile,
  String name,
  String principal,
  String unitGuid,
}) => Agents(  gender: gender ?? _gender,
  idCard: idCard ?? _idCard,
  mobile: mobile ?? _mobile,
  name: name ?? _name,
  principal: principal ?? _principal,
  unitGuid: unitGuid ?? _unitGuid,
);
  num get gender => _gender;
  String get idCard => _idCard;
  String get mobile => _mobile;
  String get name => _name;
  String get principal => _principal;
  String get unitGuid => _unitGuid;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['gender'] = _gender;
    map['idCard'] = _idCard;
    map['mobile'] = _mobile;
    map['name'] = _name;
    map['principal'] = _principal;
    map['unitGuid'] = _unitGuid;
    return map;
  }

}