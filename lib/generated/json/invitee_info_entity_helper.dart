import 'package:notarization_station_app/page/home/entity/invitee_info_entity.dart';

inviteeInfoEntityFromJson(InviteeInfoEntity data, Map<String, dynamic> json) {
  if (json['userName'] != null) {
    data.userName = json['userName'].toString();
  }
  if (json['idCard'] != null) {
    data.idCard = json['idCard'].toString();
  }
  if (json['mobile'] != null) {
    data.mobile = json['mobile'].toString();
  }
  return data;
}

Map<String, dynamic> inviteeInfoEntityToJson(InviteeInfoEntity entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['userName'] = entity.userName;
  data['idCard'] = entity.idCard;
  data['mobile'] = entity.mobile;
  return data;
}
