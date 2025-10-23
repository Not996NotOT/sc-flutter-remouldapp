import 'package:notarization_station_app/base_framework/view_model/single_view_state_model.dart';
import 'package:notarization_station_app/page/login/vm/user_view_model.dart';
import 'package:notarization_station_app/service_api/infomation_api.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../utils/common_tools.dart';

class CommunityModel extends SingleViewStateModel {
  RefreshController refreshController = RefreshController();
  List questionList = [];
  List industryList = [];
  UserViewModel userViewModel;
  int pageSize = 10;
  int currentPage = 1;
  bool isShow = true;
  Map notarialInfo = {
    "unitGuid": "d4ff0b3b-2bea-4ae1-b269-e61cf1d20c23",
    "notarialName": "",
    "contactNumber": "",
    "address": "",
    "leader": "张海波",
    "deleteMark": 0,
    "createDate": "2020-12-08 11:05:09",
    "description":
        "江苏省东台市公证处始建于1979年，现有公证人员17名，其中执业公证员4名，文化程度本科以上17人，是一支整体素质高、团结进取、无私奉献的先进集体",
    "watermark": "江苏省东台市公证处",
    "institutionType": 1,
  };

  CommunityModel(this.userViewModel);

  getList(int num) {
    currentPage = 1;
    if (num == 0) {
      Map<String, dynamic> map = {
        "currentPage": currentPage,
        "pageSize": pageSize,
        //
      };
      wjPrint("111111$map");
      InformationApi.getSingleton().getQuestion(map, errorCallBack: (e) {
        wjPrint("e---------$e");
      }).then((res) {
        if (res != null && res["items"].length != 0) {
          questionList = res["items"];
          notifyListeners();
        }
      });
    } else {
      Map<String, dynamic> map = {
        "currentPage": currentPage,
        "pageSize": pageSize,
        //"userId":userViewModel.unitGuid,
      };
      wjPrint("111111$map");
      InformationApi.getSingleton().getIndustry(map, errorCallBack: (e) {
        wjPrint("e---------$e");
      }).then((res) {
        if (res["items"].length != 0) {
          industryList = res["items"];
          notifyListeners();
        }
      });
    }
  }

  clickLike(item, {category = 1}) {
    Map<String, dynamic> map = {
      //"createUser":userViewModel.unitGuid,
      "questionId": item['unitGuid'],
      "type": "1",
      "category": category,
      "userType": "1"
    };
    wjPrint("111111$map");
    InformationApi.getSingleton().getLike(map).then((res) {
      wjPrint("1233333333$res");
      if (res["code"] == 200) {
        item['likesNumber'] = item['isLike'] == 1
            ? item['likesNumber'] - 1
            : item['likesNumber'] + 1;
        item['isLike'] = item['isLike'] == 1 ? 0 : 1;
        notifyListeners();
      }
    });
  }

  refresh() async {
    currentPage = 1;
    refreshController.resetNoData();
    if (!isShow) {
      Map<String, dynamic> map = {
        "currentPage": currentPage,
        "pageSize": pageSize,
        //"userId":userViewModel.unitGuid,
      };
      InformationApi.getSingleton().getQuestion(map, errorCallBack: (e) {
        refreshController.refreshFailed();
      }).then((res) {
        if (res != null && res["items"].length != 0) {
          questionList.clear();
          questionList = res["items"];
          refreshController.refreshCompleted();
          notifyListeners();
        }
      }).whenComplete(() {
        refreshController.refreshCompleted();
      });
    } else {
      Map<String, dynamic> map = {
        "currentPage": currentPage,
        "pageSize": pageSize,
        //"userId":userViewModel.unitGuid,
      };
      InformationApi.getSingleton().getIndustry(map, errorCallBack: (e) {
        refreshController.refreshFailed();
      }).then((res) {
        industryList.clear();
        industryList = res["items"];
        refreshController.refreshCompleted();
        notifyListeners();
      }).whenComplete(() {
        refreshController.refreshCompleted();
      });
    }
  }

  loadMore() async {
    currentPage += 1;
    if (!isShow) {
      Map<String, dynamic> map = {
        "currentPage": currentPage,
        "pageSize": pageSize,
        //"userId":userViewModel.unitGuid,
      };
      InformationApi.getSingleton().getQuestion(map, errorCallBack: (e) {
        wjPrint("e----------$e");
        refreshController.loadFailed();
        currentPage -= 1;
      }).then((res) {
        if (res != null && res["items"].isEmpty) {
          refreshController.loadNoData();
        } else {
          res["items"].forEach((e) {
            questionList.add(e);
          });
          refreshController.loadComplete();
          notifyListeners();
        }
      });
    } else {
      Map<String, dynamic> map = {
        "currentPage": currentPage,
        "pageSize": pageSize,
        //"userId":userViewModel.unitGuid,
      };
      InformationApi.getSingleton().getIndustry(map, errorCallBack: (e) {
        refreshController.loadFailed();
        currentPage -= 1;
      }).then((res) {
        if (res["items"].isEmpty) {
          refreshController.loadNoData();
        } else {
          res["items"].forEach((e) {
            industryList.add(e);
          });
          refreshController.loadComplete();
          notifyListeners();
        }
      });
    }
  }

  // getNearbyNotary()async{
  //   final status = await Permission.location.request();
  //   if (status == PermissionStatus.granted) {
  //     Location location = await AmapLocation.instance.fetchLocation();
  //     wjPrint("位置信息：-----${location.latLng.latitude}");
  //     Map<String, dynamic> map = {
  //       "currentPage":1,
  //       "pageSize":1,
  //       "distance":"${location.latLng.longitude},${location.latLng.latitude}"
  //     };
  //     var res = await InformationApi.getSingleton().getNotarial(map);
  //     if(res['code']==200){
  //
  //       wjPrint(".....$res");
  //       notarialInfo = res['items'][0];
  //       notifyListeners();
  //     }
  //     getList(0);
  //   }else{
  //     ToastUtil.showErrorToast("请允许应用获得手机权限");
  //   }
  //
  // }

  @override
  onCompleted(data) {}

  @override
  Future loadData() {
    return null;
  }
}
