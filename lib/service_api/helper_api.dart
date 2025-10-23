import 'package:notarization_station_app/config.dart';

import '../utils/common_tools.dart';
import 'bedrock_http.dart';

class HelperApi {
  static HelperApi _singleton;

  factory HelperApi() => getSingleton();

  static HelperApi getSingleton() {
    if (_singleton == null) {
      _singleton = HelperApi._internal();
    }
    return _singleton;
  }

  HelperApi._internal() {
    //do stuff
  }

  Future getNotarizationList(map, {Function errorCallBack}) async {
    //获取公证查询分页接口
    final response = await HttpManager.instance.post(
        "${Config.notaryModule}/cgz/notaryorder/selectPage",
        queryParameters: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  Future getOneNotarizationData(map, {Function errorCallBack}) async {
    //获取单条公证订单详情
    final response = await HttpManager.instance.post(
        "${Config.notaryModule}/cgz/notaryorder/getByOrderId",
        data: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  Future getOneListNotarizationData(map, {Function errorCallBack}) async {
    //新获取公证查询分页接口
    final response = await HttpManager.instance.post(
        "${Config.notaryModule}/cgz/notaryorder/selectNewPage",
        queryParameters: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  //自助存证 查询列表
  Future getAutoOrderList(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.post(
        "${Config.notaryModule}/sys/smarthome/selectPage",
        queryParameters: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  // 视频文件解密
  Future generatePresignedUr(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.get(
        "${Config.annexModule}/sys/annex/generatePresignedUr",
        queryParameters: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

//对公公证 查询列表
  Future getDuiOrderList(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.post(
        "${Config.notaryModule}/cgz/signingsubject/selectPage",
        queryParameters: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  //对公公证 单个
  Future getDuiOrder(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.post(
        "${Config.notaryModule}/cgz/signingsubject/getById",
        queryParameters: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  //公证评分详情
  Future getById(map, {Function errorCallBack}) async {
    wjPrint(
        '=============================检查公证评分详情接口地址=============================');
    final response = await HttpManager.instance.get(
        "${Config.notaryModule}/cgz/videoscore/getById",
        queryParameters: map,
        errorCallBack: errorCallBack);
    wjPrint('#####################response.data: ' + response.toString());
    return response.data;
  }

  //公证评分添加
  Future getEvaluateAdd(map, {Function errorCallBack}) async {
    wjPrint(
        '=============================检查公证评分添加接口地址=============================');
    final response = await HttpManager.instance.post(
        "${Config.notaryModule}/cgz/videoscore/insert",
        data: map,
        errorCallBack: errorCallBack);
    wjPrint('#####################response.data: ' + response.toString());
    return response.data;
  }
}
