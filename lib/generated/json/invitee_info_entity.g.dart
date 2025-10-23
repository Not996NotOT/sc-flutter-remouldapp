import 'package:notarization_station_app/generated/json/base/json_convert_content.dart';
import 'package:notarization_station_app/page/home/entity/invitee_info_entity.dart';

InviteeInfoEntity $InviteeInfoEntityFromJson(Map<String, dynamic> json) {
  final InviteeInfoEntity inviteeInfoEntity = InviteeInfoEntity();
  final String? userName = jsonConvert.convert<String>(json['userName']);
  if (userName != null) {
    inviteeInfoEntity.userName = userName;
  }
  final String? idCard = jsonConvert.convert<String>(json['idCard']);
  if (idCard != null) {
    inviteeInfoEntity.idCard = idCard;
  }
  final String? mobile = jsonConvert.convert<String>(json['mobile']);
  if (mobile != null) {
    inviteeInfoEntity.mobile = mobile;
  }
  return inviteeInfoEntity;
}

Map<String, dynamic> $InviteeInfoEntityToJson(InviteeInfoEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['userName'] = entity.userName;
  data['idCard'] = entity.idCard;
  data['mobile'] = entity.mobile;
  return data;
}
