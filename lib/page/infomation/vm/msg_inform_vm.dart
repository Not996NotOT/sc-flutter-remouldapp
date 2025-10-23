import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:notarization_station_app/base_framework/utils/toast_util.dart';
import 'package:notarization_station_app/base_framework/view_model/single_view_state_model.dart';
import 'package:notarization_station_app/page/login/vm/user_view_model.dart';
import 'package:notarization_station_app/routes/router.dart';
import 'package:notarization_station_app/service_api/infomation_api.dart';
import 'package:notarization_station_app/utils/global.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../utils/common_tools.dart';

class MsgInformModel extends SingleViewStateModel {
  UserViewModel userModel;
  RefreshController refreshController = RefreshController();
  MsgInformModel(this.userModel, this.num);
  int num;
  int pageSize = 15;
  int currentPage = 1;
  List msgList = [];

  getLike() async {
    if (num == 1) {
      Map<String, dynamic> map = {
        //"createUser":userModel.unitGuid,//主键ID
        "currentPage": currentPage,
        "pageSize": pageSize,
      };
      var res = await InformationApi.getSingleton().getLikeList(map);
      if (res['code'] == 200) {
        msgList = res['item'];
        notifyListeners();
      }
    } else {
      Map<String, dynamic> map = {
        //"parentId":userModel.unitGuid,//主键ID
        "currentPage": currentPage,
        "pageSize": pageSize,
      };
      var res = await InformationApi.getSingleton().getCommentList(map);
      if (res['code'] == 200) {
        msgList = res['items'];
        notifyListeners();
      }
    }
  }

  goDetail(int num, String id, String unitGuid, bool isRead) async {
    wjPrint(
        "------------$num----------$id----------$unitGuid------------$isRead");
    EasyLoading.show();
    Map<String, dynamic> map = {
      "unitGuid": id, //主键ID
    };
    wjPrint("------------$map");
    if (isRead) {
      Map<String, dynamic> map1 = {
        "unitGuid": unitGuid, //主键ID
        "isRead": 1
      };
      await InformationApi.getSingleton().getLikeUpdate(map1,
          errorCallBack: (e) {
        EasyLoading.dismiss();
      });
    }
    if (num == 1) {
      var res = await InformationApi.getSingleton().getOneQuestion(map,
          errorCallBack: (e) {
        EasyLoading.dismiss();
      });
      if (res['code'] == 200 && res['item'] != null) {
        EasyLoading.dismiss();
        G.pushNamed(RoutePaths.QuestionDetail, arguments: res['item']);
      } else {
        EasyLoading.dismiss();
        ToastUtil.showWarningToast("该笔内容异常！");
      }
    } else {
      var res = await InformationApi.getSingleton().getOneComment(map,
          errorCallBack: (e) {
        EasyLoading.dismiss();
      });
      if (res['code'] == 200 && res['item'] != null) {
        Map<String, dynamic> map1 = {
          "unitGuid": res['item']['questionId'], //主键ID
        };
        if (res['item']['category'] == "1") {
          var data = await InformationApi.getSingleton().getOneQuestion(map1);
          if (data['code'] == 200 && data['item'] != null) {
            G.pushNamed(RoutePaths.QuestionDetail, arguments: data['item']);
          }
        } else {
          var data = await InformationApi.getSingleton().getOneArticle(map1);
          if (data['code'] == 200 && data['item'] != null) {
            G.pushNamed(RoutePaths.News, arguments: data['item']);
          }
        }
      }
      EasyLoading.dismiss();
    }
  }

  goDetailTwo(int num, String id, String unitGuid, bool isRead) async {
    EasyLoading.show();
    Map<String, dynamic> map = {
      "unitGuid": id, //主键ID
    };
    if (isRead) {
      Map<String, dynamic> map1 = {
        "unitGuid": unitGuid, //主键ID
        "isRead": 1
      };
      await InformationApi.getSingleton().getCommentUpdate(map1,
          errorCallBack: (e) {
        EasyLoading.dismiss();
      });
    }
    wjPrint("------------$data");
    if (num == 1) {
      var res = await InformationApi.getSingleton().getOneQuestion(map,
          errorCallBack: (e) {
        EasyLoading.dismiss();
      });
      EasyLoading.dismiss();
      if (res['code'] == 200) {
        G.pushNamed(RoutePaths.QuestionDetail, arguments: res['item']);
        // Navigator.pushNamed(context, RoutePaths.QuestionDetail,arguments:  res['item']).then((value){
        //   getLike();
        // });
      }
    } else {
      var data = await InformationApi.getSingleton().getOneArticle(map,
          errorCallBack: (e) {
        EasyLoading.dismiss();
      });
      EasyLoading.dismiss();
      if (data['code'] == 200) {
        G.pushNamed(RoutePaths.News, arguments: data['item']);
        // Navigator.pushNamed(context, RoutePaths.News,arguments:  data['item']).then((value){
        //   getLike();
        // });
      }
    }
  }

  refresh() async {
    currentPage = 1;
    if (num == 1) {
      Map<String, dynamic> map = {
        "currentPage": currentPage,
        "pageSize": pageSize,
        //"createUser":userModel.unitGuid,
      };
      InformationApi.getSingleton().getLikeList(map, errorCallBack: (e) {
        refreshController.refreshFailed();
      }).then((res) {
        msgList.clear();
        msgList = res["item"];
        refreshController.refreshCompleted();
        notifyListeners();
      }).whenComplete(() {
        refreshController.loadComplete();
        setBusy(false);
      });
    } else {
      Map<String, dynamic> map = {
        "currentPage": currentPage,
        "pageSize": pageSize,
        //"parentId":userModel.unitGuid,
      };
      InformationApi.getSingleton().getCommentList(map, errorCallBack: (e) {
        refreshController.refreshFailed();
      }).then((res) {
        msgList.clear();
        msgList = res["items"];
        refreshController.refreshCompleted();
        notifyListeners();
      }).whenComplete(() {
        refreshController.loadComplete();
        setBusy(false);
      });
    }
  }

  loadMore() async {
    currentPage += 1;
    if (num == 1) {
      Map<String, dynamic> map = {
        "currentPage": currentPage,
        "pageSize": pageSize,
        //"createUser":userModel.unitGuid,
      };
      InformationApi.getSingleton().getLikeList(map, errorCallBack: (e) {
        refreshController.loadFailed();
        currentPage -= 1;
      }).then((res) {
        if (res["item"].isEmpty) {
          refreshController.loadNoData();
        } else {
          res["item"].forEach((e) {
            msgList.add(e);
          });
          refreshController.loadComplete();
          notifyListeners();
        }
      });
    } else {
      Map<String, dynamic> map = {
        "currentPage": currentPage,
        "pageSize": pageSize,
        //"parentId":userModel.unitGuid,
      };
      InformationApi.getSingleton().getCommentList(map, errorCallBack: (e) {
        refreshController.loadFailed();
        currentPage -= 1;
      }).then((res) {
        if (res["items"].isEmpty) {
          refreshController.loadNoData();
        } else {
          res["items"].forEach((e) {
            msgList.add(e);
          });
          refreshController.loadComplete();
          notifyListeners();
        }
      });
    }
  }

  @override
  onCompleted(data) {}

  @override
  Future loadData() {
    getLike();
    return null;
  }
}
