/*
 * @Author: 王士博 wangshibo@gc.com
 * @Date: 2023-06-05 22:20:37
 * @LastEditors: 王士博 wangshibo@gc.com
 * @LastEditTime: 2023-06-07 09:19:03
 * @FilePath: /remouldApp/lib/service_api/room_api.dart
 * @Description: 
 * 
 * Copyright (c) 2023 by ${git_name_email}, All Rights Reserved. 
 */
import 'package:notarization_station_app/service_api/bedrock_http.dart';

import '../config.dart';

class RoomApi {
  static RoomApi _instance;

  RoomApi get instance => getSingleton();

  factory RoomApi() => getSingleton();

  static RoomApi getSingleton() {
    if (_instance == null) {
      _instance = RoomApi._internal();
    }
    return _instance;
  }

  RoomApi._internal();

  // 用户进入直播间验证
  static Future checkUserWhenEnterLiveRoom(map,
      {Function errorCallBack}) async {
    final response = await HttpManager.instance.post(
        '${Config.room}/yxroom/buyer-info/enterDirectSeeding',
        data: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  // 选房记录

  static Future roomSelectionRecord(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.post(
        '${Config.room}/yxroom/buyer-info/roomSelectionRecord',
        data: map,
        errorCallBack: errorCallBack);
    return response.data;
  }
}
