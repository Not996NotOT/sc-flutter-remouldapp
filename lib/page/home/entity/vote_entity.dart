import 'package:notarization_station_app/generated/json/base/json_convert_content.dart';

class VoteEntity with JsonConvert<VoteEntity> {
  String voteName;
  List<dynamic> voteImg;
  int choice;
  List<VoteVoteData> voteData;
}

class VoteVoteData with JsonConvert<VoteVoteData> {
  String optionName;
  String optionData;
}
