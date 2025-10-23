class AppUpdate {
  String msg;
  Item item;
  int code;

  AppUpdate({this.msg, this.item, this.code});

  AppUpdate.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    item = json['item'] != null ? new Item.fromJson(json['item']) : null;
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    if (this.item != null) {
      data['item'] = this.item.toJson();
    }
    data['code'] = this.code;
    return data;
  }
}

class Item {
  String unitGuid;
  String filePath;
  int editionType;
  String appTitle;
  String annexGuid;
  String createDate;
  String appContent;

  Item(
      {this.unitGuid,
      this.filePath,
      this.editionType,
      this.appTitle,
      this.annexGuid,
      this.createDate,
      this.appContent});

  Item.fromJson(Map<String, dynamic> json) {
    unitGuid = json['unitGuid'];
    filePath = json['filePath'];
    editionType = json['editionType'];
    appTitle = json['appTitle'];
    annexGuid = json['annexGuid'];
    createDate = json['createDate'];
    appContent = json['appContent'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['unitGuid'] = this.unitGuid;
    data['filePath'] = this.filePath;
    data['editionType'] = this.editionType;
    data['appTitle'] = this.appTitle;
    data['annexGuid'] = this.annexGuid;
    data['createDate'] = this.createDate;
    data['appContent'] = this.appContent;
    return data;
  }
}
