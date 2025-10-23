import 'package:dio/dio.dart';
import 'package:notarization_station_app/config.dart';
import 'package:notarization_station_app/service_api/judicial_network.dart';


import '../base_framework/utils/toast_util.dart';
import '../utils/common_tools.dart';
import '../utils/global.dart';
import 'bedrock_http.dart';

class HomeApi {
  static HomeApi _singleton;

  factory HomeApi() => getSingleton();

  static HomeApi getSingleton() {
    if (_singleton == null) {
      _singleton = HomeApi._internal();
    }
    return _singleton;
  }

  HomeApi._internal() {
    //do stuff
  }

//获取公证处列表的
  Future getNotarialOffice(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.post(
        "${Config.notaryModule}/cgz/notarialOffice/selectAll",
        queryParameters: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  //获取公证处列表的
  Future getNotarialOfficeTwo(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.post(
        "${Config.notaryModule}/cgz/notarialOffice/selectAllUp",
        queryParameters: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  //创建订单
  Future addOrder(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.post(
        "${Config.notaryModule}/cgz/notaryorder/machineAdd",
        data: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  //取消订单
  Future shutVideoOrder(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.post(
        "${Config.notaryModule}/cgz/notaryorder/doUserStop",
        data: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  // 视频公证待处理、已取消提醒 /sys/ordervideo/app/videoNotarizationWaitHandleRemind
  /*
   greffierIdCard	公证员身份证号		true	 string
   notaryId	公证处Id		false	 string
   type	提醒类型 1-待受理 2-待受理取消		true	
integer(int32)
  */
  Future getVideoNotarizationWaitHandleRemind(map,
      {Function errorCallBack}) async {
    wjPrint("获取金融公证列表页---参数-------$map");
    final response = await HttpManager.instance.post(
        "${Config.notaryModule}/sys/ordervideo/app/videoNotarizationWaitHandleRemind",
        data: map,
        errorCallBack: errorCallBack);
    wjPrint("获取金融公证列表页---返回结果-------$response");
    return response.data;
  }

  // 获取金融公证列表页
  Future getTaskList(map, {Function errorCallBack}) async {
    wjPrint("获取金融公证列表页---参数-------$map");
    final response = await HttpManager.instance.post(
        "${Config.enforcement}/block-order/taskList",
        queryParameters: map,
        errorCallBack: errorCallBack);
    wjPrint("获取金融公证列表页---返回结果-------$response");
    return response.data;
  }

  // 获取金融公证简易列表页
  Future getCommonTaskList(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.post(
        "${Config.easyEnforcement}/easy-block-order/taskList",
        queryParameters: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  // 获取受理室简易模版自然人
  Future getCommonUser(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.post(
        "${Config.easyEnforcement}/easy-block-order/getPartyDetails",
        data: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  // 受理室简易模版上传材料
  Future uploadCommonFile(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.get(
        "${Config.easyEnforcement}/easy-block-order/addMaterial",
        queryParameters: map);
    return response.data;
  }

  // 金融公证发起公证
  Future launchNotarization(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.post(
        "${Config.enforcement}/block-order/launchNotarization",
        data: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  // 简易模版金融公证发起公证
  Future launchCommonNotarization(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.post(
        "${Config.easyEnforcement}/easy-block-order/launchNotarization",
        data: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  // 金融公证-受理室获取顶部列表
  Future selectPage(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.post(
        "${Config.userModule}/sys/dict/selectPage",
        data: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  // // 摇号获取配置字典项
  // Future selectPageWithHeaderToken(map,token ,{Function errorCallBack}) async {
  //   final response = await HttpManager.instance.post(
  //       "${Config.userModule}/sys/dict/selectPage",
  //       data: map,
  //       options: Options(
  //         headers: {
  //           "token":token
  //         }
  //       ),
  //       errorCallBack: errorCallBack);
  //   return response.data;
  // }
  //
  // // 摇号获取主键
  // Future getSelectAllTopWithHeaderToken(map,token ,{Function errorCallBack}) async {
  //   final response = await HttpManager.instance.post(
  //       "${Config.userModule}/sys/dict/selectAllTop",
  //       queryParameters: map,
  //       options: Options(
  //         headers: {
  //           "token":token
  //         }
  //       ),
  //       errorCallBack: errorCallBack);
  //   return response.data;
  // }

  // 获取主键
  Future getSelectAllTop(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.post(
        "${Config.userModule}/sys/dict/selectAllTop",
        queryParameters: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  // 根据主键ID获取数据
  Future getByParentId(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.post(
        "${Config.userModule}/sys/dict/getByParentId",
        queryParameters: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  // 查询公证员状态列表
  Future getListNotaryStatus(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.get(
        "${Config.notaryModule}/cgz/notaryPublic/listNotaryStatus",
        queryParameters: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  // 受理室订单详情
  Future blockOrderGetPartyDetails(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.post(
        "${Config.enforcement}/block-order/getPartyDetails",
        data: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  //上传图片
  Future uploadImg(Map map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.post(
        "${Config.annexModule}/sys/annex/uploadfiles",
        data: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  Future uploadPictures(MultipartFile file, {Function errorCallBack}) async {
    FormData formData = FormData.fromMap({
      "file": file,
    });
    Options options = Options(
        receiveTimeout: 5000,
        sendTimeout: 5000,
        contentType: "multipart/form-data");
    final response = await HttpManager.instance.post(
        "${Config.annexModule}/sys/annex/fastDFSUpload",
        data: formData,
        options: options,
        errorCallBack: errorCallBack);
    wjPrint("uploadPictures---------$response");
    return response.data;
  }

  // 获取onlyOffice配置信息
  Future getOnlyOfficeConfig(map,
      {Function errorCallBack}) async {
    final response = await HttpManager.instance.get('/office/config/info',
        queryParameters: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  //活体检测
  Future getBiopsy(Map map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.post(
        "${Config.identificationModule}/biopsyController/bioassay",
        data: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  //人脸比对
  Future faceComparison(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.post(
        "${Config.identificationModule}/face/faceComparison",
        data: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  // 境外人脸识别 /ocr/ocrDiscern
  Future ocrDiscern(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.post(
        "${Config.userModule}/ocr/ocrDiscern",
        data: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  //支付宝新接口支付
  Future aliPay(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.post(
        "${Config.notaryModule}/alipay/doNewSign",
        data: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  //摇号支付宝新接口支付
  Future aliPayWithHeaderToken(map,{Function errorCallBack}) async {
    final response = await JudicialNetwork.instance.post(
        "${Config.appraise}/cert/alipay/aliPay",
        data: map,
        options: Options(
            contentType: "application/x-www-form-urlencoded"
        ),
        errorCallBack: errorCallBack);
    return response.data;
  }

  //支付宝新接口支付
  Future aliOldPay(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.post(
        "${Config.notaryModule}/alipay/doSign",
        data: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  //自助存证   支付宝支付
  Future autoAliPay(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.post(
        "${Config.notaryModule}/alipay/selfHelpDoSign",
        data: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  //微信支付 selfHelpMWEBParamFixedAppId     MWEBParamFixedAppId
  // Future wxPay(map) async {
  //   final response = await HttpManager.instance.post("${Config.notaryModule}/cgz/wxpay/MWEBParamFixedAppId", queryParameters: map);
  //   return response.data;
  // }
  //
  // //自助存证  微信支付
  // Future autoWxPay(map) async {
  //   final response = await HttpManager.instance.post("${Config.notaryModule}/cgz/wxpay/selfHelpMWEBParamFixedAppId", queryParameters: map);
  //   return response.data;
  // }
// 微信新的支付接口
  Future wxPay(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.post(
        "${Config.notaryModule}/cgz/wxpay/AppMWEBParam",
        queryParameters: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  // 摇号微信支付接口
  Future wxPayWithHeaderToken(map,{Function errorCallBack}) async {
    final response = await JudicialNetwork.instance.post(
        "${Config.appraise}/cert/wechat/wxPay",
        queryParameters: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  //  微信支付旧接口
  Future MWEBParam(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.post(
        "${Config.notaryModule}/cgz/wxpay/MWEBParam",
        queryParameters: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  //自助存证  微信支付
  Future autoWxPay(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.post(
        "${Config.notaryModule}/cgz/wxpay/selfHelpWXParam",
        queryParameters: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  //公证用途分类
  Future getNotarizationPurpose(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.post(
        "${Config.notaryModule}/cgz/notarypurpose/selectTree",
        data: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  //公证使用地列表
  Future getCountryArea(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.post(
        "${Config.notaryModule}/sys/countryArea/selectAll",
        data: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  //公证语言列表
  Future getCountryLanguage(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.post(
        "${Config.notaryModule}/sys/countryLanguage/selectAll",
        data: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  //自助公证提交订单
  Future addAutoHelpList(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.post(
        "${Config.notaryModule}/cgz/notaryorder/add",
        data: map,
        errorCallBack: errorCallBack);
    return response.data;
  }
  /// 提交定位信息
  ///  "busiId": "busiId_a2b5ff776766",
  ///   "busiType": 0,
  ///   "idCard": "idCard_e83c95f4b5ce",
  ///   "ip": "ip_9a2c4287acc2",
  ///   "longitude": "longitude_90a2d99056fe",
  ///   "latitude": "latitude_20cde4883185"
  /// busiType： 1自助、2视频、3合同
  Future uploadLocationInformation(map, {Function errorCallBack})async{
    final response = await HttpManager.instance.post("${Config.notaryModule}/cgz/geo/updBusiGeoInfo",data:map,errorCallBack: errorCallBack);
    return response.data;
  }

  //设置邮寄
  Future setTakeType(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.post(
        "${Config.notaryModule}/cgz/notaryorder/doSetState",
        data: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  //自助公证 上传材料保存接口
  Future upLoadMaterial(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.post(
        "${Config.notaryModule}/cgz/material/add",
        data: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  //自助公证  获取公证事项材料
  Future getUpLoadMaterialName(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.post(
        "${Config.notaryModule}/cgz/notaryitemmodel/selectNotaryItem",
        queryParameters: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  //自助公证  预览
  Future previewFile(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.post(
        "${Config.notaryModule}/cgz/material/addApp",
        data: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  //签名
  Future doSetSignNameJSCA(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.post(
        "${Config.notaryModule}/cgz/notaryorder/doSetSignNameJSCA",
        data: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  //自助公证  签字
  Future doSetSignName(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.post(
        "${Config.notaryModule}/cgz/notaryorder/doSetSignName",
        data: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  //在线咨询  留言
  Future askMessage(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.post(
        "${Config.voteModule}/cgz/consultation/add",
        data: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  //在线咨询 人工服务
  Future askPeople(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.post(
        "${Config.notaryModule}/cgz/roomnumber/getArtificial",
        queryParameters: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  //在线咨询 消息记录
  Future getChattingList(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.post(
        "${Config.voteModule}/cgz/consultation/selectPage",
        queryParameters: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  //查询是否有合同公证
  Future getContract(map, {Function errorCallBack}) async {
    wjPrint(map);
    final response = await HttpManager.instance.post(
        "${Config.notaryModule}/cgz/notaryorder/queryContract",
        data: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  //查询支付结果
  Future getPay(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.post(
        "${Config.notaryModule}/cgz/wxpay/orderQuery",
        queryParameters: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  //查询支付结果
  Future getAliPayState(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.post(
        "${Config.notaryModule}/alipay/aipayQuery",
        data: map,
        errorCallBack: errorCallBack);
    return response.data;
  }
  //摇号微信支付查询支付结果
  Future getPayWithHeadersToken(map,{Function errorCallBack}) async {
    final response = await JudicialNetwork.instance.post(
        "${Config.appraise}/cert/wechat/queryOrder",
        queryParameters: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  //摇号支付宝支付查询支付结果
  Future getAliPayStateWithHeadersToken(map,{Function errorCallBack}) async {
    final response = await JudicialNetwork.instance.get(
        "${Config.appraise}/cert/alipay/payOrder",
        queryParameters: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  //消息通知 获取所有消息
  Future getAllInfoList(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.post(
        "${Config.notaryModule}/cgz/articleupload/selectPage",
        queryParameters: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  //自助存证 新增
  Future addAutoOrder(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.post(
        "${Config.notaryModule}/sys/smarthome/add",
        data: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

//新增预约
  Future addAppointment(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.post(
        "${Config.notaryModule}/cgz/makeappointment/add",
        data: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  //预约列表
  Future appointmentList(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.post(
        "${Config.notaryModule}/cgz/makeappointment/selectPage",
        queryParameters: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

//预约发起
  Future appointmentOrder(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.post(
        "${Config.notaryModule}/cgz/notaryorder/orderAdd",
        data: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  ///进入会议
  Future postConference(Map<String, dynamic> params,
      {Function errorCallBack}) async {
    final response = await HttpManager.instance.post(
        '${Config.notaryModule}/cgz/netmeeting/enterRoom',
        queryParameters: params,
        errorCallBack: errorCallBack);
    return response.data;
  }

  ///提交表决
  Future postVote(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.post(
        "${Config.notaryModule}/cgz/netmeeting/voteToPdf",
        data: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  ///签字包
  Future postSignature(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.post(
        "${Config.notaryModule}/cgz/meetinguser/userSign",
        data: map,
        errorCallBack: errorCallBack);
    // final response = await HttpManager.instance.post("${Config.notaryModule}/cgz/videolog/txYunGetSign", data: map);
    // wjPrint("===================="+response.data);
    return response.data;
  }

  //对公列表
  Future protocolList(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.post(
        "${Config.notaryModule}/cgz/publicnotaryuser/queryPublicNotary",
        data: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  ///
  /// 对公及合同列表   /cgz/notaryorder/multipartyNotaryList
  Future multipartyNotaryList(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.get(
        "${Config.notaryModule}/cgz/notaryorder/contractReenterOrders",
        queryParameters: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  //对公列表
  Future getProtocol(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.post(
        "${Config.notaryModule}/cgz/signingsubject/queryNotaryTime",
        data: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  Future getProtocolInfo(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.post(
        "${Config.notaryModule}/cgz/signingsubject/querySignUser",
        data: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  Future historyNotarial(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.post(
        "${Config.notaryModule}/cgz/historynotarialoffice/add",
        data: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  Future queryHistoryOffice(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.post(
        "${Config.notaryModule}/cgz/historynotarialoffice/queryHistoryOffice",
        data: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  Future getContractRecord(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.post(
        "${Config.bankModule}/cgz/bankorder/selectPage",
        queryParameters: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  //更新小额NEW
  Future updateSmall(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.post(
        "${Config.bankModule}/cgz/bankmaterialrelation/addList",
        queryParameters: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  //删除小额NEW
  Future delSmallImg(map, {Function errorCallBack}) async {
    // final response = await bedRock.post("/cgz/bankmaterial/delete", queryParameters: map);
    final response = await HttpManager.instance.post(
        "${Config.bankModule}/cgz/bankmaterialrelation/delete",
        queryParameters: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  ///人脸
  Future postFace(Map<String, dynamic> params, {Function errorCallBack}) async {
    final response = await HttpManager.instance.post(
        '${Config.notaryModule}/cgz/meetinguser/userIdentification',
        data: params,
        errorCallBack: errorCallBack);
    return response.data;
  }

  Future getBank(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.post(
        "${Config.bankModule}/cgz/creditbankorder/selectPage",
        queryParameters: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  Future getSmallDetail(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.post(
        "${Config.bankModule}/cgz/creditbankorder/getByUnitGuid",
        data: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  Future updateBank(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.post(
        "${Config.bankModule}/cgz/creditbankorder/materialAdd",
        data: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  Future delBankImg(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.post(
        "${Config.bankModule}/cgz/creditbankorder/materialDelete",
        data: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  Future uploadPart(map, {Function errorCallBack}) async {
    Options options = Options(contentType: "multipart/form-data");
    final response = await HttpManager.instance.post(
        "${Config.annexModule}/sys/annex/uploadPart",
        data: map,
        options: options,
        errorCallBack: errorCallBack);
    return response.data;
  }

  Future uploadPageId(Map<String, dynamic> data,
      {Function errorCallBack,Options options}) async {
    final response = await HttpManager.instance.get(
        "${Config.annexModule}/sys/annex/initiateMultipartUpload",
        queryParameters: data,
        options: options,
        errorCallBack: errorCallBack);
    return response.data;
  }

  Future openLog(Map<String, dynamic> data, {Function errorCallBack}) async {
    final response = await HttpManager.instance.post(
        "${Config.userModule}/operLog/add",
        data: data,
        errorCallBack: errorCallBack);
    return response.data;
  }

  /// 版本更新
  Future updateVersion(map, {Function errorCallBack}) async {
    try {
      BaseOptions _options = BaseOptions(
        baseUrl: Config.hostUrl,
        //连接时间为5秒
        connectTimeout: 60000,
        //响应时间为3秒
        receiveTimeout: 60000,
        //设置请求头
        headers: {},
        //默认值是"application/json; charset=utf-8",Headers.formUrlEncodedContentType会自动编码请求体.
        contentType: Headers.jsonContentType,
        //共有三种方式json,bytes(响应字节),stream（响应流）,plain
        responseType: ResponseType.json,
      );
      wjPrint("版本更新接口传参打印：$map");
      final response = await Dio(_options).post("${Config.userModule}/cgz/appedition/selectNewBy",data: map);
      wjPrint("版本更新接口返回数据打印：${response.toString()}");
      return response.data;
    } catch (e) {
      errorCallBack(e);
      return null;
    }
  }

  // 获取区号
  Future getPhoneAreaCode(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.get(
        "${Config.userModule}/sys/dict/getAreaCode",
        queryParameters: map,
        options: Options(contentType: 'application/x-www-form-urlencoded'),
        errorCallBack: errorCallBack);
    return response.data;
  }

  //境外用户注册时发送邮箱验证码  /cgz/userApp/sendEmailCode

  Future getSendEmailCode(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.post(
        '${Config.userModule}/cgz/userApp/sendEmailCode',
        data: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

// 境外发送短信
  Future getAbordMsgSend(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.get(
        '${Config.userModule}/sys/Sms/abroadSend',
        queryParameters: map,
        options: Options(contentType: 'application/x-www-form-urlencoded'),
        errorCallBack: errorCallBack);
    return response.data;
  }

// 联系公证员 /cgz/userApp/appContactAdmin
  Future appContactAdmin(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.post(
        '${Config.userModule}/cgz/userApp/appContactAdmin',
        data: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  // 获取省市区信息接口
  Future getProvinceAndCiteMessage(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.get(
        '${Config.userModule}/sysregion/get/$map',
        options: Options(
          contentType: "application/x-www-form-urlencoded"
        ),
        errorCallBack: errorCallBack);
    return response.data;
  }

  // 查询公证书是否生成完成
  Future selectByOrderGuid(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.get(
        '${Config.notaryModule}/notarizationAnnex/selectIsFinish',
        queryParameters: map,
        options: Options(
          contentType: "application/x-www-form-urlencoded"
        ),
        errorCallBack: errorCallBack);
    return response.data;
  }
  // 人脸识别报告生成人脸识别报告
  Future similarityForSC(map,
      {Function errorCallBack, bool checkNet = false}) async {
    final response = await HttpManager.instance.post(
        '/identification/face/similarityForSC',
        data: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  // 人脸识别报告生成人脸识别报告
  Future saveFaveReport(map,
      {Function errorCallBack, bool checkNet = false}) async {
    final response = await HttpManager.instance.post(
        '${Config.notaryModule}/cgz/notaryorder/saveFaceReport',
        data: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  // 获取文件列表
  Future generatePdfToImg(map,
      {Function errorCallBack, bool checkNet = false})async{
    final response = await HttpManager.instance.post(
        '${Config.notaryModule}/notarizationAnnex/generatePdfToImg',
        data: map,
        options: Options(
            contentType: "application/x-www-form-urlencoded"
        ),
        errorCallBack: errorCallBack);
    return response.data;
  }

  // 获取验证证书
  Future getCertificateUrl(map,
      {Function errorCallBack, bool checkNet = false})async{
    final response = await HttpManager.instance.post(
        '${Config.notaryModule}/notarization-annex-main/getCertificateUrl',
        data: map,
        options: Options(
            contentType: "application/x-www-form-urlencoded"
        ),
        errorCallBack: errorCallBack);
    return response.data;
  }
  // 电子公证书文件及验证证书下载
  Future downloadCertificateAnnex(map,
      {Function errorCallBack, bool checkNet = false})async{
    final response = await HttpManager.instance.get(
        '${Config.notaryModule}/notarizationAnnex/downloadCertificateAnnex',
        queryParameters: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

/**
 * 摇号部分接口
 */


  // /sys/login/userLogin
  // 用户姓名和身份证号码登录
  Future userLogin(map, {Function errorCallBack}) async {
    final response = await JudicialNetwork.instance.post(
        '${Config.userModule}/sys/login/userFaceLoginNoPersonInfo',
        data: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  // 用户姓名和身份证号码登录
  Future appraiseOrderSelectOrder(map, {Function errorCallBack,Options options}) async {
    final response = await JudicialNetwork.instance.post(
        '${Config.appraise}/cgz/AppraiseOrder/selectOrder',
        data: map,
        options: options,
        errorCallBack: errorCallBack);
    return response.data;
  }

  // 用户姓名和身份证号码登录
  Future queryFileById(unitGuid, {Function errorCallBack,Options options}) async {
    final response = await JudicialNetwork.instance.get(
        '${Config.annexModule}/sys/annex/queryById?unitGuid=$unitGuid',
        options: options,
        errorCallBack: errorCallBack);
    return response.data;
  }

  // 用户姓名和身份证号码登录
  Future selectNotarizationForm(unitGuid, {Function errorCallBack,Options options}) async {
    final response = await JudicialNetwork.instance.post(
        '${Config.appraise}/cgz/AppraiseOrder/selectNotarizationForm',
        data: {"unitGuid":unitGuid},
        options: options,
        errorCallBack: errorCallBack);
    return response.data;
  }

  // 签字调用接口
  Future signTellFile(data, {Function errorCallBack,Options options}) async {
    final response = await JudicialNetwork.instance.post(
        '${Config.appraise}/cgz/AppraiseOrder/signTellFile',
        data: data,
        options: options,
        errorCallBack: errorCallBack);
    return response.data;
  }

  // 更新订单状态
  Future updateOrder(data, {Function errorCallBack,Options options,CancelToken cancelToken}) async {
    final response = await JudicialNetwork.instance.post(
        '${Config.appraise}/cgz/AppraiseOrder/updateOrder',
        data: data,
        options: options,
        cancelToken: cancelToken,
        errorCallBack: errorCallBack);
    return response.data;
  }

  //获取鉴定机构 /cgz/AppraiseInstitution
  Future selectAllInstitution(data, {Function errorCallBack,Options options}) async {
    final response = await JudicialNetwork.instance.post(
        '${Config.appraise}/cgz/AppraiseInstitution/selectAllInstitution',
        data: data,
        options: options,
        errorCallBack: errorCallBack);
    return response.data;
  }

  //抽取鉴定机构
  Future appraiseInstitution(data, {Function errorCallBack,Options options}) async {
    final response = await JudicialNetwork.instance.post(
        '${Config.appraise}/cgz/AppraiseInstitution/appraiseInstitution',
        data: data,
        options: options,
        errorCallBack: errorCallBack);
    return response.data;
  }

  //  sys/annex/insert
  // 插入文件信息生成UnitGuid
  Future fileInsert(data, {Function errorCallBack,Options options,CancelToken cancelToken}) async {
    final response = await JudicialNetwork.instance.post(
        '${Config.annexModule}/sys/annex/insert',
        data: data,
        options: options,
        cancelToken: cancelToken,
        errorCallBack: errorCallBack);
    return response.data;
  }

  // 查询当前用户是否有代办订单 /selectHaveOrder
  Future selectHaveOrder(data, {Function errorCallBack}) async {
    final response = await JudicialNetwork.instance.post(
        '${Config.appraise}/cgz/AppraiseOrder/selectHaveOrder',
        data: data,
        errorCallBack: errorCallBack);
    return response.data;
  }

  // cgz/AppraiseOrder/PdfToImg pdf转图片
  Future pdfToImg(data, {Function errorCallBack}) async {
    final response = await JudicialNetwork.instance.get(
        '${Config.appraise}/cgz/AppraiseOrder/PdfToImg',
        queryParameters: data,
        errorCallBack: errorCallBack);
    return response.data;
  }

  // 更新用户身份报告
  Future updateOrderWithUserIndenty(data, {Function errorCallBack}) async {
    final response = await JudicialNetwork.instance.post(
        '${Config.appraise}/cgz/AppraiseOrder/updateOrder',
        data: data,
        errorCallBack: errorCallBack);
    return response.data;
  }


  //活体检1111
  Future getNewBiopsy(Map map, {Function errorCallBack}) async {
    final response = await JudicialNetwork.instance.post(
        "${Config.identificationModule}/biopsyController/bioassay",
        data: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  //统一下单接口
  // payType	支付类型 1、 支付宝 2、 微信
  // integer(int32)
  // unitGuid	订单主键		false
  // string
  Future addOrderManagerPay(Map map, {Function errorCallBack}) async {
    final response = await JudicialNetwork.instance.post(
        "${Config.appraise}/cgz/unifiedOrderManage/unifiedOrder",
        data: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  // 查询统一下单
  Future queryUnifiedOrder(map, {Function errorCallBack}) async {
    final response = await JudicialNetwork.instance.get(
        "${Config.appraise}/cgz/unifiedOrderManage/queryUnifiedOrder",
        queryParameters: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  // 查询摇号订单是否支付 /cgz/AppraiseOrder/getPayStatus
  Future getPayStatus(map,{Function errorCallBack})async{
    final response = await JudicialNetwork.instance.get(
        "${Config.appraise}/cgz/AppraiseOrder/getPayStatus",
        queryParameters: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  //重新进入列表（视频）
 Future reenterVideoOrdersList(map,{Function errorCallBack}) async {
   final response = await HttpManager.instance.post(
       "${Config.notaryModule}/cgz/notaryorder/reenterOrders",
       data: map,
       errorCallBack: errorCallBack);
   return response.data;
 }

  //重新进入列表（视频）
  Future contractReenterOrdersList(map,{Function errorCallBack}) async {
    final response = await HttpManager.instance.post(
        "${Config.notaryModule}/cgz/notaryorder/contractReenterOrders",
        data: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  // 重新进入（视频）
  Future videoReenter(map,{Function errorCallBack}) async {
    final response = await HttpManager.instance.get(
        "${Config.notaryModule}/cgz/notaryorder/reenter?unitGuid=${map}",
        options: new Options(
            contentType: "application/x-www-form-urlencoded"
        ),
        errorCallBack: errorCallBack);
    return response.data;
  }

  // 重新进入（合同）
  Future contractReenter(map,{Function errorCallBack}) async {
    final response = await HttpManager.instance.get(
        "${Config.notaryModule}/cgz/notaryorder/contractReenterOrders",
        queryParameters: map,
        options: new Options(
          contentType: "application/x-www-form-urlencoded"
        ),
        errorCallBack: errorCallBack);
    return response.data;
  }

}
