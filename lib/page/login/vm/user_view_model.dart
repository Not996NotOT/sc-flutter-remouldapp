import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:notarization_station_app/base_framework/utils/toast_util.dart';
// import 'package:notarization_station_app/generated/json/base/json_convert_content.dart';
import 'package:notarization_station_app/page/login/entity/userInfo.dart';
import 'package:notarization_station_app/service_api/account_api.dart';

class UserViewModel extends ChangeNotifier {
  //这是保存需要跳转到那个tabs
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;
  set currentIndex(int value) {
    _currentIndex = value;
    notifyListeners();
  }

  set token(String value) {
    _userEntity?.token = value;
    saveUser(_userEntity);
    notifyListeners();
  }

  //此字段保存上一个登录的用户ID，之后根据此ID去取用户缓存
  //默认自动登录上一个用户
  static const String last_user_id = "lastUserId";

  UserInfoEntity _userEntity;

  UserInfoEntity get user => _userEntity;

  bool get hasUser => _userEntity != null;

  /// 获取user
  String get token => _userEntity?.token;
  String get userName => _userEntity?.userName;
  int get gender => _userEntity?.gender;
  String get mobile => _userEntity?.mobile;
  String get idCard => _userEntity?.idCard;
  String get address => _userEntity?.address;
  String get birthday => _userEntity?.birthday;
  String get headIcon => _userEntity?.headIcon;
  String get unionId => _userEntity?.unionId;
  String get appleId => _userEntity?.appleId;

  void setUserHead(String path) {
    _userEntity.headIcon = path;
    saveUser(_userEntity);
    notifyListeners();
  }

  void setUserName(String name) {
    _userEntity.userName = name;
    saveUser(_userEntity);
    notifyListeners();
  }

  void setUserGender(int sex) {
    _userEntity.gender = sex;
    saveUser(_userEntity);
    notifyListeners();
  }

  void setUserAddress(String address) {
    _userEntity.address = address;
    saveUser(_userEntity);
    notifyListeners();
  }

  void setUserBirthday(String birth) {
    _userEntity.birthday = birth;
    saveUser(_userEntity);
    notifyListeners();
  }

  void setUnionId(String unionId) {
    _userEntity.unionId = unionId;
    saveUser(_userEntity);
    notifyListeners();
  }

  void setAppleId(String appleId) {
    _userEntity.appleId = appleId;
    saveUser(_userEntity);
    notifyListeners();
  }


  // void setUserIdImg(String idImg) {
  //   _userEntity.idCardImg = idImg;
  //   saveUser(_userEntity);
  //   notifyListeners();
  // }

  void setUseridCard(String idCard) {
    _userEntity.idCard = idCard;
    saveUser(_userEntity);
    notifyListeners();
  }

  UserViewModel() {
    ///用户登陆后会在本地缓存用户实体，可以根据自己的实际需求改变
    var entity = SpUtil.getObject(last_user_id);
    if (entity != null) {
      _userEntity = UserInfoEntity.fromJson(entity);
    } else {
      _userEntity = null;
    }
  }

  saveUser(UserInfoEntity userEntity) {
    if (userEntity == null) {
      return;
    }
    _userEntity = userEntity;
    SpUtil.putObject(last_user_id, userEntity);
    notifyListeners();
  }

  ///登出后，清除缓存
  userLogout({bool isShow = true}) {
    AccountApi.getSingleton()
        .getLoginOut({}, errorCallBack: (e) {}).then((value) {
      _userEntity = null;
      SpUtil.remove(last_user_id);
      if (isShow) {
        ToastUtil.showSuccessToast("退出成功！");
      }
      notifyListeners();
    });
  }

  modifyPassWord() {
    _userEntity = null;
    notifyListeners();
    SpUtil.remove(last_user_id);
    ToastUtil.showSuccessToast("修改成功！");
  }

  /// 清空本地用户数据
  clearUserInformation(){
    _userEntity = null;
    notifyListeners();
  }
}
