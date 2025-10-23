/// notaryId : ""
/// notaryIdCard : ""
/// notaryName : ""
/// roomId : 0
/// unitGuid : ""

class LaunchRoomInforModel {
  LaunchRoomInforModel({
    this.notaryId,
    this.notaryIdCard,
    this.notaryName,
    this.roomId,
    this.unitGuid,
  });

  LaunchRoomInforModel.fromJson(dynamic json) {
    notaryId = json['notaryId'];
    notaryIdCard = json['notaryIdCard'];
    notaryName = json['notaryName'];
    roomId = json['roomId'];
    unitGuid = json['unitGuid'];
  }
  String notaryId;
  String notaryIdCard;
  String notaryName;
  int roomId;
  String unitGuid;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['notaryId'] = notaryId;
    map['notaryIdCard'] = notaryIdCard;
    map['notaryName'] = notaryName;
    map['roomId'] = roomId;
    map['unitGuid'] = unitGuid;
    return map;
  }
}
