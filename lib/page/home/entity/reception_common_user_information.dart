class ReceptionCommonUserInformation {
  String address;
  bool bankUser;
  String idCard;
  int sort;
  String userName;

  ReceptionCommonUserInformation({
    this.address,
    this.bankUser,
    this.idCard,
    this.sort,
    this.userName,
  });

  @override
  String toString() {
    return 'ReceptionCommonUserInformation(address: $address, bankUser: $bankUser, idCard: $idCard, sort: $sort, userName: $userName)';
  }

  factory ReceptionCommonUserInformation.fromJson(Map<String, dynamic> json) {
    return ReceptionCommonUserInformation(
      address: json['address'] ?? '',
      bankUser: json['bankUser'] ?? false,
      idCard: json['idCard'] ?? '',
      sort: json['sort'] ?? 0,
      userName: json['userName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'address': address,
        'bankUser': bankUser,
        'idCard': idCard,
        'sort': sort,
        'userName': userName,
      };

  @override
  int get hashCode =>
      address.hashCode ^
      bankUser.hashCode ^
      idCard.hashCode ^
      sort.hashCode ^
      userName.hashCode;
}
