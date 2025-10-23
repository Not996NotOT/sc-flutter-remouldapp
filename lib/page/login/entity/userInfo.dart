class UserInfoEntity {
  String birthday;
  String headIcon;
  String address;
  int gender;
  String idCard;
  String registeAddress;
  String roleName;
  String userName;
  String token;
  String mobile;
  String appleId;
  String unionId;
  UserInfoEntity(
      {this.birthday,
      this.headIcon,
      this.address,
      this.gender,
      this.idCard,
      this.registeAddress,
      this.roleName,
      this.userName,
      this.token,
        this.unionId,
        this.appleId,
      this.mobile});

  UserInfoEntity.fromJson(Map<String, dynamic> json) {
    birthday = json['birthday'];
    headIcon = json['headIcon'];
    address = json['address'];
    gender = json['gender'];
    idCard = json['idCard'];
    registeAddress = json['registeAddress'];
    roleName = json['roleName'];
    userName = json['userName'];
    token = json['token'];
    mobile = json['mobile'];
    appleId = json['appleId'];
    unionId = json['unionId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['birthday'] = this.birthday;
    data['headIcon'] = this.headIcon;
    data['address'] = this.address;
    data['gender'] = this.gender;
    data['idCard'] = this.idCard;
    data['registeAddress'] = this.registeAddress;
    data['roleName'] = this.roleName;
    data['userName'] = this.userName;
    data['token'] = this.token;
    data['mobile'] = this.mobile;
    data['unionId'] = this.unionId;
    data['appleId'] = this.appleId;
    return data;
  }
}
