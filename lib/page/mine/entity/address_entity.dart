import 'package:notarization_station_app/generated/json/base/json_convert_content.dart';

class AddressEntity with JsonConvert<AddressEntity> {
  String msg;
  int code;
  AddressPage page;
  List<AddressItem> items;
}

class AddressPage with JsonConvert<AddressPage> {
  int currentPage;
  int pageSize;
  int total;
}

class AddressItem with JsonConvert<AddressItem> {
  String unitGuid;
  String userGuid;
  String address;
  String phone;
  String receivingUsername;
  String noDefault;
}
