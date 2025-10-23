import 'package:notarization_station_app/generated/json/base/json_convert_content.dart';

class InformationEntity with JsonConvert<InformationEntity> {
  String msg;
  int code;
  InformationPage page;
  List<InformationItem> items;
}

class InformationPage with JsonConvert<InformationPage> {
  int currentPage;
  int pageSize;
  int total;
}

class InformationItem with JsonConvert<InformationItem> {
  String unitGuid;
  String notaryId;
  dynamic userId;
  String title;
  String content;
  String pictureUrl;
  int browseNum;
  int deleteMark;
  int ifTop;
  int state;
  String publishTime;
  String createDate;
  String notaryName;
}
