class NotarialStatusModel {
  NotarialStatusModel({
    this.currentState,
    this.idCard,
    this.unitGuid,
    this.userName,
    this.isVideo = true,
  });

  NotarialStatusModel.fromJson(dynamic json) {
    currentState = json['currentState'];
    idCard = json['idCard'];
    unitGuid = json['unitGuid'];
    userName = json['userName'];
    isVideo = true;
  }
  int currentState;
  String idCard;
  String unitGuid;
  String userName;
  bool isVideo = true;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['currentState'] = currentState;
    map['idCard'] = idCard;
    map['unitGuid'] = unitGuid;
    map['userName'] = userName;
    map["isVideo"] = isVideo;
    return map;
  }
}
