import 'package:notarization_station_app/page/home/entity/vote_entity.dart';

voteEntityFromJson(VoteEntity data, Map<String, dynamic> json) {
  if (json['voteName'] != null) {
    data.voteName = json['voteName'].toString();
  }
  if (json['voteImg'] != null) {
    data.voteImg =
        (json['voteImg'] as List).map((v) => v).toList().cast<dynamic>();
  }
  if (json['choice'] != null) {
    data.choice = json['choice'] is String
        ? int.tryParse(json['choice'])
        : json['choice'].toInt();
  }
  if (json['voteData'] != null) {
    data.voteData = (json['voteData'] as List)
        .map((v) => VoteVoteData().fromJson(v))
        .toList();
  }
  return data;
}

Map<String, dynamic> voteEntityToJson(VoteEntity entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['voteName'] = entity.voteName;
  data['voteImg'] = entity.voteImg;
  data['choice'] = entity.choice;
  data['voteData'] = entity.voteData?.map((v) => v.toJson())?.toList();
  return data;
}

voteVoteDataFromJson(VoteVoteData data, Map<String, dynamic> json) {
  if (json['optionName'] != null) {
    data.optionName = json['optionName'].toString();
  }
  if (json['optionData'] != null) {
    data.optionData = json['optionData'].toString();
  }
  return data;
}

Map<String, dynamic> voteVoteDataToJson(VoteVoteData entity) {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['optionName'] = entity.optionName;
  data['optionData'] = entity.optionData;
  return data;
}
