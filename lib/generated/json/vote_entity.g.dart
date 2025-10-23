import 'package:notarization_station_app/generated/json/base/json_convert_content.dart';
import 'package:notarization_station_app/page/home/entity/vote_entity.dart';

VoteEntity $VoteEntityFromJson(Map<String, dynamic> json) {
  final VoteEntity voteEntity = VoteEntity();
  final String? voteName = jsonConvert.convert<String>(json['voteName']);
  if (voteName != null) {
    voteEntity.voteName = voteName;
  }
  final List<dynamic>? voteImg =
      jsonConvert.convertListNotNull<dynamic>(json['voteImg']);
  if (voteImg != null) {
    voteEntity.voteImg = voteImg;
  }
  final int? choice = jsonConvert.convert<int>(json['choice']);
  if (choice != null) {
    voteEntity.choice = choice;
  }
  final List<VoteVoteData>? voteData =
      jsonConvert.convertListNotNull<VoteVoteData>(json['voteData']);
  if (voteData != null) {
    voteEntity.voteData = voteData;
  }
  return voteEntity;
}

Map<String, dynamic> $VoteEntityToJson(VoteEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['voteName'] = entity.voteName;
  data['voteImg'] = entity.voteImg;
  data['choice'] = entity.choice;
  data['voteData'] = entity.voteData.map((v) => v.toJson()).toList();
  return data;
}

VoteVoteData $VoteVoteDataFromJson(Map<String, dynamic> json) {
  final VoteVoteData voteVoteData = VoteVoteData();
  final String? optionName = jsonConvert.convert<String>(json['optionName']);
  if (optionName != null) {
    voteVoteData.optionName = optionName;
  }
  final String? optionData = jsonConvert.convert<String>(json['optionData']);
  if (optionData != null) {
    voteVoteData.optionData = optionData;
  }
  return voteVoteData;
}

Map<String, dynamic> $VoteVoteDataToJson(VoteVoteData entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['optionName'] = entity.optionName;
  data['optionData'] = entity.optionData;
  return data;
}
