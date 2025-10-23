import 'package:flutter/cupertino.dart';
import 'package:notarization_station_app/base_framework/utils/toast_util.dart';
import 'package:notarization_station_app/base_framework/view_model/single_view_state_model.dart';
import 'package:notarization_station_app/page/login/vm/user_view_model.dart';
import 'package:notarization_station_app/service_api/infomation_api.dart';
import 'package:notarization_station_app/utils/event_bus_instance.dart';
import 'package:notarization_station_app/utils/global.dart';

import '../../../utils/common_tools.dart';

class NewsModel extends SingleViewStateModel {
  UserViewModel userModel;
  final arguments;
  TextEditingController textEditingController = TextEditingController();
  NewsModel(this.userModel, this.arguments);
  List commentList = [];
  int currentPage = 1;
  int pageSize = 10;
  List presentList = [];
  int presentCurrentPage = 1;
  int presentPageSize = 10;

  // 用来对敏感词时评论弹框的处理
  bool isDeal = false;

  getComment() async {
    currentPage = 1;
    Map<String, dynamic> map = {
      "currentPage": currentPage, //当前页
      "pageSize": pageSize, //每页多少条数据
      "questionId": arguments['unitGuid'],
      // "createUser":userModel.unitGuid
    };
    var res = await InformationApi.getSingleton().getComment(map);
    if (res['code'] == 200 && res['items'] != null) {
      commentList = res['items'];
      notifyListeners();
    }
  }

  getCommentTwo() async {
    currentPage++;
    Map<String, dynamic> map = {
      "currentPage": currentPage, //当前页
      "pageSize": 10, //每页多少条数据
      "questionId": arguments['unitGuid'],
      //"createUser":userModel.unitGuid
    };
    wjPrint('++++++++++++++$map');
    var res = await InformationApi.getSingleton().getComment(map);
    if (res['code'] == 200 && res['items'].length != 0) {
      res['items'].forEach((e) {
        commentList.add(e);
      });
      notifyListeners();
    } else {
      ToastUtil.showWarningToast("暂无更多了");
    }
  }

  addComment(commentContent,
      {String commentId = "",
      String parentId = "",
      String parentName = "",
      int type}) async {
    Map<String, dynamic> map = {
      //"createUser":userModel.unitGuid,//评论人Id 或回复人Id
      "createUserName": userModel.userName,
      "questionId": arguments['unitGuid'], //提问ID或文章ID
      "commentContent": commentContent, //评论内容
      "picture": "2", //图片
      "type": type, //类型 1是评论 2是回复
      "commentId": commentId, //评论Id
      "parentId": parentId, //上级ID 回复的记录的主键
      "parentName": parentName,
      "userType": 1,
      "category": 2,
      "likesNumber": 0
    };
    wjPrint("---------$map");
    var res = await InformationApi.getSingleton().addComment(map);
    if (res['code'] == 200) {
      G.pop();
      getComment();
    } else if (res['code'] == 4001) {
      eventBus.fire({"isDeal": true});
      ToastUtil.showErrorToast(res["msg"]);
    }
  }

  Future clickLike(item, {int category = 3}) async {
    Map<String, dynamic> map = {
      //"createUser":userModel.unitGuid,
      "questionId": item['unitGuid'],
      "'type'": "1",
      "category": category,
      "userType": "1"
    };
    final res = await InformationApi.getSingleton().getLike(map);
    return res;
  }

  Future getReply(item) async {
    presentCurrentPage = 1;
    Map<String, dynamic> map = {
      "currentPage": presentCurrentPage, //当前页
      "pageSize": presentPageSize, //每页多少条数据
      "questionId": arguments['unitGuid'], //提问ID
      "commentId": item['unitGuid'] //评论Id
    };
    final data = await InformationApi.getSingleton().getReply(map);
    return data;
  }

  Future getReplyTwo(item) async {
    presentCurrentPage++;
    Map<String, dynamic> map = {
      "currentPage": presentCurrentPage, //当前页
      "pageSize": presentPageSize, //每页多少条数据
      "questionId": arguments['unitGuid'], //提问ID
      "commentId": item['unitGuid'] //评论Id
    };
    wjPrint('++++++++++++++$map');
    final data = await InformationApi.getSingleton().getReply(map);
    return data;
  }

  @override
  onCompleted(data) {}

  @override
  Future loadData() {
    return null;
  }
}
