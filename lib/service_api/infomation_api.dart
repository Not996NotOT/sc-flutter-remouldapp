import 'package:notarization_station_app/config.dart';

import 'bedrock_http.dart';

class InformationApi {
  static InformationApi _singleton;

  factory InformationApi() => getSingleton();

  static InformationApi getSingleton() {
    if (_singleton == null) {
      _singleton = InformationApi._internal();
    }
    return _singleton;
  }

  InformationApi._internal() {
    //do stuff
  }

  //公证问答
  Future getQuestion(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.post(
        "${Config.parkModule}/sq/question/notarization",
        data: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  //行业动态
  Future getIndustry(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.post(
        "${Config.parkModule}/sq/question/industryNews",
        data: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  Future getQuiz(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.post(
        "${Config.parkModule}/sq/question/add",
        data: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  Future getLike(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.post(
        "${Config.parkModule}/sq/likerecord/add",
        data: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  Future getComment(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.post(
        "${Config.parkModule}/sq/comment/commentPage",
        data: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  Future addComment(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.post(
        "${Config.parkModule}/sq/comment/add",
        data: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  Future getReply(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.post(
        "${Config.parkModule}/sq/comment/replyPage",
        data: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  Future getNotarialOffice(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.post(
        "${Config.notaryModule}/cgz/notarialOffice/selectPage",
        queryParameters: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  Future getNotaryPublic(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.post(
        "${Config.userModule}/cgz/notaryPublic/queryAllByNotaryId",
        data: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  Future addFriend(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.post(
        "${Config.parkModule}/sq/approval/add",
        data: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  Future getFriend(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.post(
        "${Config.parkModule}/sq/friendlist/queryFriend",
        data: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  Future applyFriend(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.post(
        "${Config.parkModule}/sq/approval/queryApprovalList",
        data: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  Future approvalFriend(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.post(
        "${Config.parkModule}/sq/approval/approval",
        data: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  Future queryHistory(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.post(
        "${Config.parkModule}/cgz/talk/queryHistory",
        data: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  Future getUnread(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.post(
        "${Config.parkModule}/cgz/lastTalk/queryLast",
        data: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  Future getUnreadUpdate(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.post(
        "${Config.parkModule}/cgz/lastTalk/update",
        data: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  Future getLikeList(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.post(
        "${Config.parkModule}/sq/likerecord/queryLikeList",
        data: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  Future getOneQuestion(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.post(
        "${Config.parkModule}/sq/question/getOne",
        data: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  Future getOneArticle(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.post(
        "${Config.parkModule}/sq/article/getOne",
        data: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  Future getOneComment(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.post(
        "${Config.parkModule}/sq/comment/getOne",
        data: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  Future getCommentList(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.post(
        "${Config.parkModule}/sq/comment/queryCommentList",
        data: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  Future getNotarial(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.post(
        "${Config.userModule}/cgz/notarialOffice/addressSortselectPage",
        queryParameters: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  Future getRecordCount(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.get(
        "${Config.parkModule}/sq/comment/recordCount",
        queryParameters: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  Future getCommentUpdate(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.post(
        "${Config.parkModule}/sq/comment/update",
        data: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  Future getLikerecord(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.get(
        "${Config.parkModule}/sq/likerecord/likeRecordCount",
        queryParameters: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  Future getLikeUpdate(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.post(
        "${Config.parkModule}/sq/likerecord/update",
        data: map,
        errorCallBack: errorCallBack);
    return response.data;
  }

  Future getMaterialModel(map, {Function errorCallBack}) async {
    final response = await HttpManager.instance.post(
        "${Config.notaryModule}/cgz/materialmodel/selectAll",
        queryParameters: map,
        errorCallBack: errorCallBack);
    return response.data;
  }
}
