import 'package:notarization_station_app/base_framework/view_model/single_view_state_model.dart';
import 'package:notarization_station_app/page/home/scale_widget.dart';
import 'package:notarization_station_app/utils/event_bus_instance.dart';

class SelectRoomModuleViewModel extends SingleViewStateModel {
  // 已选择的
  List hasSelectedList = [];

  // 房间数及楼栋数
  List buildingList = [];

  // 已经选择的房间名称
  List selectedRoomNameList = [];

  // 栋
  List<ScaleModel> buildings = [];

  bool isForbidden = false;

  @override
  Future loadData() {
    print("dataList.length: ${dataList.length}");
    Future.delayed(Duration(microseconds: 200), () {
      buildingList.addAll(dataList.map((e) {
        print("e=================$e");
        int index = dataList.indexOf(e);
        buildings.add(ScaleModel(
            title: e['houseName'], id: e['houseId'], isSelected: index == 0));
        return BuildingModel.fromJson(e);
      }).toList());
      notifyListeners();
    });
    return null;
  }

  @override
  onCompleted(data) {}

  // 处理选中的房间
  void dealSelectedHouse(EventBusInstanceEvent event) {
    if (!event.source['model'].isSelected) {
      hasSelectedList.forEach((e) {
        if (e["model"] == event.source['model']) {
          hasSelectedList.remove(e);
        }
      });
    } else {
      String tempName =
          "${buildingList[event.source['index'][0]].buildingName}${buildingList[event.source['index'][0]].unitList[event.source['index'][1]].unitName} ${buildingList[event.source['index'][0]].unitList[event.source['index'][1]].roomList[event.source['index'][2]].floorName} ${buildingList[event.source['index'][0]].unitList[event.source['index'][1]].roomList[event.source['index'][2]].roomList[event.source['index'][3]].houseName}";
      hasSelectedList
          .insert(0, {'model': event.source['model'], 'name': tempName});
      if (hasSelectedList.length >= 6) {
        isForbidden = true;
      } else {
        isForbidden = false;
      }
    }
    notifyListeners();
  }
}

class BuildingModel {
  String buildingName;
  List<UnitModel> unitList;
  String houseId;
  BuildingModel({this.buildingName, this.unitList, this.houseId});
  BuildingModel.fromJson(Map<String, dynamic> json) {
    this.buildingName = json['houseName'];
    this.houseId = json['houseId'];
    print("BuildingModel----building: ${json['building']}");
    // this
    // .unitList
    // .addAll(json['building'].map((e) => UnitModel.fromJson(e)).toList());
    unitList = <UnitModel>[];
    json['building'].forEach((e) {
      UnitModel model = UnitModel.fromJson(e);
      unitList.add(model);
    });
  }

  Map<String, dynamic> toJson() {
    return {
      'buildingName': this.buildingName,
      'building': this.unitList,
      'houseId': this.houseId
    };
  }
}

class UnitModel {
  String unitName;
  List<FloorModel> roomList;

  UnitModel({this.unitName, this.roomList});
  UnitModel.fromJson(Map<String, dynamic> json) {
    this.unitName = json['unit'];
    // this
    //     .roomList
    //     .addAll(json['units'].map((e) => FloorModel.fromJson(e)).toList());

    roomList = <FloorModel>[];
    json['units'].forEach((e) {
      FloorModel model = FloorModel.fromJson(e);
      roomList.add(model);
    });
  }

  Map<String, dynamic> toJson() {
    return {
      'unit': this.unitName,
      'units': this.roomList,
    };
  }
}

class FloorModel {
  String floorName;
  List<HouseModel> roomList;
  FloorModel({this.floorName, this.roomList});
  FloorModel.fromJson(Map<String, dynamic> json) {
    this.floorName = json['floor'];
    roomList = <HouseModel>[];
    json['floors'].forEach((e) {
      HouseModel model = HouseModel.fromJson(e);
      roomList.add(model);
    });
  }

  Map<String, dynamic> toJson() {
    return {'floor': this.floorName, 'floors': this.roomList};
  }
}

// 房间数据model
class HouseModel {
  String houseName;
  String houseId;
  bool isSelected = false;
  HouseModel.fromJson(Map json) {
    houseName = json['room'] ?? '';
    houseId = json['room'];
  }

  Map toJson() {
    return {
      'room': houseName,
      'roomId': houseId,
    };
  }
}

List dataList = [
  {
    'houseName': '1栋',
    'houseId': '1',
    'building': [
      {
        'unit': '一单元',
        'units': [
          {
            'floor': "1F",
            "floors": [
              {'room': '101'},
              {'room': '102'},
              {'room': '103'},
              {'room': '104'},
              {'room': '105'},
              {'room': '106'}
            ]
          },
          {
            'floor': "2F",
            "floors": [
              {'room': '201'},
              {'room': '202'},
              {'room': '203'},
              {'room': '204'},
              {'room': '205'},
              {'room': '206'},
              {'room': '207'},
              {'room': '208'},
              {'room': '209'},
              {'room': '210'},
              {'room': '211'},
              {'room': '212'}
            ]
          },
          {
            'floor': "3F",
            "floors": [
              {'room': '301'},
              {'room': '302'},
              {'room': '303'},
              {'room': '304'},
              {'room': '305'},
              {'room': '306'}
            ]
          },
          {
            'floor': "4F",
            "floors": [
              {'room': '401'},
              {'room': '402'},
              {'room': '403'},
              {'room': '404'},
              {'room': '405'},
              {'room': '406'},
              {'room': '407'},
              {'room': '408'},
              {'room': '409'},
              {'room': '410'},
              {'room': '411'},
              {'room': '412'}
            ]
          },
          {
            'floor': "5F",
            "floors": [
              {'room': '501'},
              {'room': '502'},
              {'room': '503'},
              {'room': '504'},
              {'room': '505'},
              {'room': '506'}
            ]
          },
          {
            'floor': "6F",
            "floors": [
              {'room': '601'},
              {'room': '602'},
              {'room': '603'},
              {'room': '604'},
              {'room': '605'},
              {'room': '606'},
              {'room': '607'},
              {'room': '608'},
              {'room': '609'},
              {'room': '610'},
              {'room': '611'},
              {'room': '612'}
            ]
          },
          {
            'floor': "7F",
            "floors": [
              {'room': '701'},
              {'room': '702'},
              {'room': '703'},
              {'room': '704'},
              {'room': '705'},
              {'room': '706'}
            ]
          },
          {
            'floor': "8F",
            "floors": [
              {'room': '801'},
              {'room': '802'},
              {'room': '803'},
              {'room': '804'},
              {'room': '805'},
              {'room': '806'},
              {'room': '807'},
              {'room': '808'},
              {'room': '809'},
              {'room': '810'},
              {'room': '811'},
              {'room': '812'}
            ]
          },
        ]
      },
      {
        'unit': '二单元',
        'units': [
          {
            'floor': "1F",
            "floors": [
              {'room': '101'},
              {'room': '102'},
              {'room': '103'},
              {'room': '104'},
              {'room': '105'},
              {'room': '106'}
            ]
          },
          {
            'floor': "2F",
            "floors": [
              {'room': '201'},
              {'room': '202'},
              {'room': '203'},
              {'room': '204'},
              {'room': '205'},
              {'room': '206'},
              {'room': '207'},
              {'room': '208'},
              {'room': '209'},
              {'room': '210'},
              {'room': '211'},
              {'room': '212'}
            ]
          },
          {
            'floor': "3F",
            "floors": [
              {'room': '301'},
              {'room': '302'},
              {'room': '303'},
              {'room': '304'},
              {'room': '305'},
              {'room': '306'}
            ]
          },
          {
            'floor': "4F",
            "floors": [
              {'room': '401'},
              {'room': '402'},
              {'room': '403'},
              {'room': '404'},
              {'room': '405'},
              {'room': '406'},
              {'room': '407'},
              {'room': '408'},
              {'room': '409'},
              {'room': '410'},
              {'room': '411'},
              {'room': '412'}
            ]
          },
          {
            'floor': "5F",
            "floors": [
              {'room': '501'},
              {'room': '502'},
              {'room': '503'},
              {'room': '504'},
              {'room': '505'},
              {'room': '506'}
            ]
          },
          {
            'floor': "6F",
            "floors": [
              {'room': '601'},
              {'room': '602'},
              {'room': '603'},
              {'room': '604'},
              {'room': '605'},
              {'room': '606'},
              {'room': '607'},
              {'room': '608'},
              {'room': '609'},
              {'room': '610'},
              {'room': '611'},
              {'room': '612'}
            ]
          },
          {
            'floor': "7F",
            "floors": [
              {'room': '701'},
              {'room': '702'},
              {'room': '703'},
              {'room': '704'},
              {'room': '705'},
              {'room': '706'}
            ]
          },
          {
            'floor': "8F",
            "floors": [
              {'room': '801'},
              {'room': '802'},
              {'room': '803'},
              {'room': '804'},
              {'room': '805'},
              {'room': '806'},
              {'room': '807'},
              {'room': '808'},
              {'room': '809'},
              {'room': '810'},
              {'room': '811'},
              {'room': '812'}
            ]
          },
        ]
      },
      {
        'unit': '三单元',
        'units': [
          {
            'floor': "1F",
            "floors": [
              {'room': '101'},
              {'room': '102'},
              {'room': '103'},
              {'room': '104'},
              {'room': '105'},
              {'room': '106'}
            ]
          },
          {
            'floor': "2F",
            "floors": [
              {'room': '201'},
              {'room': '202'},
              {'room': '203'},
              {'room': '204'},
              {'room': '205'},
              {'room': '206'},
              {'room': '207'},
              {'room': '208'},
              {'room': '209'},
              {'room': '210'},
              {'room': '211'},
              {'room': '212'}
            ]
          },
          {
            'floor': "3F",
            "floors": [
              {'room': '301'},
              {'room': '302'},
              {'room': '303'},
              {'room': '304'},
              {'room': '305'},
              {'room': '306'}
            ]
          },
          {
            'floor': "4F",
            "floors": [
              {'room': '401'},
              {'room': '402'},
              {'room': '403'},
              {'room': '404'},
              {'room': '405'},
              {'room': '406'},
              {'room': '407'},
              {'room': '408'},
              {'room': '409'},
              {'room': '410'},
              {'room': '411'},
              {'room': '412'}
            ]
          },
          {
            'floor': "5F",
            "floors": [
              {'room': '501'},
              {'room': '502'},
              {'room': '503'},
              {'room': '504'},
              {'room': '505'},
              {'room': '506'}
            ]
          },
          {
            'floor': "6F",
            "floors": [
              {'room': '601'},
              {'room': '602'},
              {'room': '603'},
              {'room': '604'},
              {'room': '605'},
              {'room': '606'},
              {'room': '607'},
              {'room': '608'},
              {'room': '609'},
              {'room': '610'},
              {'room': '611'},
              {'room': '612'}
            ]
          },
          {
            'floor': "7F",
            "floors": [
              {'room': '701'},
              {'room': '702'},
              {'room': '703'},
              {'room': '704'},
              {'room': '705'},
              {'room': '706'}
            ]
          },
          {
            'floor': "8F",
            "floors": [
              {'room': '801'},
              {'room': '802'},
              {'room': '803'},
              {'room': '804'},
              {'room': '805'},
              {'room': '806'},
              {'room': '807'},
              {'room': '808'},
              {'room': '809'},
              {'room': '810'},
              {'room': '811'},
              {'room': '812'}
            ]
          },
        ]
      },
      {
        'unit': '四单元',
        'units': [
          {
            'floor': "1F",
            "floors": [
              {'room': '101'},
              {'room': '102'},
              {'room': '103'},
              {'room': '104'},
              {'room': '105'},
              {'room': '106'}
            ]
          },
          {
            'floor': "2F",
            "floors": [
              {'room': '201'},
              {'room': '202'},
              {'room': '203'},
              {'room': '204'},
              {'room': '205'},
              {'room': '206'},
              {'room': '207'},
              {'room': '208'},
              {'room': '209'},
              {'room': '210'},
              {'room': '211'},
              {'room': '212'}
            ]
          },
          {
            'floor': "3F",
            "floors": [
              {'room': '301'},
              {'room': '302'},
              {'room': '303'},
              {'room': '304'},
              {'room': '305'},
              {'room': '306'}
            ]
          },
          {
            'floor': "4F",
            "floors": [
              {'room': '401'},
              {'room': '402'},
              {'room': '403'},
              {'room': '404'},
              {'room': '405'},
              {'room': '406'},
              {'room': '407'},
              {'room': '408'},
              {'room': '409'},
              {'room': '410'},
              {'room': '411'},
              {'room': '412'}
            ]
          },
          {
            'floor': "5F",
            "floors": [
              {'room': '501'},
              {'room': '502'},
              {'room': '503'},
              {'room': '504'},
              {'room': '505'},
              {'room': '506'}
            ]
          },
          {
            'floor': "6F",
            "floors": [
              {'room': '601'},
              {'room': '602'},
              {'room': '603'},
              {'room': '604'},
              {'room': '605'},
              {'room': '606'},
              {'room': '607'},
              {'room': '608'},
              {'room': '609'},
              {'room': '610'},
              {'room': '611'},
              {'room': '612'}
            ]
          },
          {
            'floor': "7F",
            "floors": [
              {'room': '701'},
              {'room': '702'},
              {'room': '703'},
              {'room': '704'},
              {'room': '705'},
              {'room': '706'}
            ]
          },
          {
            'floor': "8F",
            "floors": [
              {'room': '801'},
              {'room': '802'},
              {'room': '803'},
              {'room': '804'},
              {'room': '805'},
              {'room': '806'},
              {'room': '807'},
              {'room': '808'},
              {'room': '809'},
              {'room': '810'},
              {'room': '811'},
              {'room': '812'}
            ]
          },
        ]
      }
    ],
  },
  {
    'houseName': '2栋',
    'houseId': '2',
    'building': [
      {
        'unit': '一单元',
        'units': [
          {
            'floor': "1F",
            "floors": [
              {'room': '101'},
              {'room': '102'},
              {'room': '103'},
              {'room': '104'},
              {'room': '105'},
              {'room': '106'}
            ]
          },
          {
            'floor': "2F",
            "floors": [
              {'room': '201'},
              {'room': '202'},
              {'room': '203'},
              {'room': '204'},
              {'room': '205'},
              {'room': '206'},
              {'room': '207'},
              {'room': '208'},
              {'room': '209'},
              {'room': '210'},
              {'room': '211'},
              {'room': '212'}
            ]
          },
          {
            'floor': "3F",
            "floors": [
              {'room': '301'},
              {'room': '302'},
              {'room': '303'},
              {'room': '304'},
              {'room': '305'},
              {'room': '306'}
            ]
          },
          {
            'floor': "4F",
            "floors": [
              {'room': '401'},
              {'room': '402'},
              {'room': '403'},
              {'room': '404'},
              {'room': '405'},
              {'room': '406'},
              {'room': '407'},
              {'room': '408'},
              {'room': '409'},
              {'room': '410'},
              {'room': '411'},
              {'room': '412'}
            ]
          },
          {
            'floor': "5F",
            "floors": [
              {'room': '501'},
              {'room': '502'},
              {'room': '503'},
              {'room': '504'},
              {'room': '505'},
              {'room': '506'}
            ]
          },
          {
            'floor': "6F",
            "floors": [
              {'room': '601'},
              {'room': '602'},
              {'room': '603'},
              {'room': '604'},
              {'room': '605'},
              {'room': '606'},
              {'room': '607'},
              {'room': '608'},
              {'room': '609'},
              {'room': '610'},
              {'room': '611'},
              {'room': '612'}
            ]
          },
          {
            'floor': "7F",
            "floors": [
              {'room': '701'},
              {'room': '702'},
              {'room': '703'},
              {'room': '704'},
              {'room': '705'},
              {'room': '706'}
            ]
          },
          {
            'floor': "8F",
            "floors": [
              {'room': '801'},
              {'room': '802'},
              {'room': '803'},
              {'room': '804'},
              {'room': '805'},
              {'room': '806'},
              {'room': '807'},
              {'room': '808'},
              {'room': '809'},
              {'room': '810'},
              {'room': '811'},
              {'room': '812'}
            ]
          },
        ]
      },
      {
        'unit': '二单元',
        'units': [
          {
            'floor': "1F",
            "floors": [
              {'room': '101'},
              {'room': '102'},
              {'room': '103'},
              {'room': '104'},
              {'room': '105'},
              {'room': '106'}
            ]
          },
          {
            'floor': "2F",
            "floors": [
              {'room': '201'},
              {'room': '202'},
              {'room': '203'},
              {'room': '204'},
              {'room': '205'},
              {'room': '206'},
              {'room': '207'},
              {'room': '208'},
              {'room': '209'},
              {'room': '210'},
              {'room': '211'},
              {'room': '212'}
            ]
          },
          {
            'floor': "3F",
            "floors": [
              {'room': '301'},
              {'room': '302'},
              {'room': '303'},
              {'room': '304'},
              {'room': '305'},
              {'room': '306'}
            ]
          },
          {
            'floor': "4F",
            "floors": [
              {'room': '401'},
              {'room': '402'},
              {'room': '403'},
              {'room': '404'},
              {'room': '405'},
              {'room': '406'},
              {'room': '407'},
              {'room': '408'},
              {'room': '409'},
              {'room': '410'},
              {'room': '411'},
              {'room': '412'}
            ]
          },
          {
            'floor': "5F",
            "floors": [
              {'room': '501'},
              {'room': '502'},
              {'room': '503'},
              {'room': '504'},
              {'room': '505'},
              {'room': '506'}
            ]
          },
          {
            'floor': "6F",
            "floors": [
              {'room': '601'},
              {'room': '602'},
              {'room': '603'},
              {'room': '604'},
              {'room': '605'},
              {'room': '606'},
              {'room': '607'},
              {'room': '608'},
              {'room': '609'},
              {'room': '610'},
              {'room': '611'},
              {'room': '612'}
            ]
          },
          {
            'floor': "7F",
            "floors": [
              {'room': '701'},
              {'room': '702'},
              {'room': '703'},
              {'room': '704'},
              {'room': '705'},
              {'room': '706'}
            ]
          },
          {
            'floor': "8F",
            "floors": [
              {'room': '801'},
              {'room': '802'},
              {'room': '803'},
              {'room': '804'},
              {'room': '805'},
              {'room': '806'},
              {'room': '807'},
              {'room': '808'},
              {'room': '809'},
              {'room': '810'},
              {'room': '811'},
              {'room': '812'}
            ]
          },
        ]
      },
      {
        'unit': '三单元',
        'units': [
          {
            'floor': "1F",
            "floors": [
              {'room': '101'},
              {'room': '102'},
              {'room': '103'},
              {'room': '104'},
              {'room': '105'},
              {'room': '106'}
            ]
          },
          {
            'floor': "2F",
            "floors": [
              {'room': '201'},
              {'room': '202'},
              {'room': '203'},
              {'room': '204'},
              {'room': '205'},
              {'room': '206'},
              {'room': '207'},
              {'room': '208'},
              {'room': '209'},
              {'room': '210'},
              {'room': '211'},
              {'room': '212'}
            ]
          },
          {
            'floor': "3F",
            "floors": [
              {'room': '301'},
              {'room': '302'},
              {'room': '303'},
              {'room': '304'},
              {'room': '305'},
              {'room': '306'}
            ]
          },
          {
            'floor': "4F",
            "floors": [
              {'room': '401'},
              {'room': '402'},
              {'room': '403'},
              {'room': '404'},
              {'room': '405'},
              {'room': '406'},
              {'room': '407'},
              {'room': '408'},
              {'room': '409'},
              {'room': '410'},
              {'room': '411'},
              {'room': '412'}
            ]
          },
          {
            'floor': "5F",
            "floors": [
              {'room': '501'},
              {'room': '502'},
              {'room': '503'},
              {'room': '504'},
              {'room': '505'},
              {'room': '506'}
            ]
          },
          {
            'floor': "6F",
            "floors": [
              {'room': '601'},
              {'room': '602'},
              {'room': '603'},
              {'room': '604'},
              {'room': '605'},
              {'room': '606'},
              {'room': '607'},
              {'room': '608'},
              {'room': '609'},
              {'room': '610'},
              {'room': '611'},
              {'room': '612'}
            ]
          },
          {
            'floor': "7F",
            "floors": [
              {'room': '701'},
              {'room': '702'},
              {'room': '703'},
              {'room': '704'},
              {'room': '705'},
              {'room': '706'}
            ]
          },
          {
            'floor': "8F",
            "floors": [
              {'room': '801'},
              {'room': '802'},
              {'room': '803'},
              {'room': '804'},
              {'room': '805'},
              {'room': '806'},
              {'room': '807'},
              {'room': '808'},
              {'room': '809'},
              {'room': '810'},
              {'room': '811'},
              {'room': '812'}
            ]
          },
        ]
      },
      {
        'unit': '四单元',
        'units': [
          {
            'floor': "1F",
            "floors": [
              {'room': '101'},
              {'room': '102'},
              {'room': '103'},
              {'room': '104'},
              {'room': '105'},
              {'room': '106'}
            ]
          },
          {
            'floor': "2F",
            "floors": [
              {'room': '201'},
              {'room': '202'},
              {'room': '203'},
              {'room': '204'},
              {'room': '205'},
              {'room': '206'},
              {'room': '207'},
              {'room': '208'},
              {'room': '209'},
              {'room': '210'},
              {'room': '211'},
              {'room': '212'}
            ]
          },
          {
            'floor': "3F",
            "floors": [
              {'room': '301'},
              {'room': '302'},
              {'room': '303'},
              {'room': '304'},
              {'room': '305'},
              {'room': '306'}
            ]
          },
          {
            'floor': "4F",
            "floors": [
              {'room': '401'},
              {'room': '402'},
              {'room': '403'},
              {'room': '404'},
              {'room': '405'},
              {'room': '406'},
              {'room': '407'},
              {'room': '408'},
              {'room': '409'},
              {'room': '410'},
              {'room': '411'},
              {'room': '412'}
            ]
          },
          {
            'floor': "5F",
            "floors": [
              {'room': '501'},
              {'room': '502'},
              {'room': '503'},
              {'room': '504'},
              {'room': '505'},
              {'room': '506'}
            ]
          },
          {
            'floor': "6F",
            "floors": [
              {'room': '601'},
              {'room': '602'},
              {'room': '603'},
              {'room': '604'},
              {'room': '605'},
              {'room': '606'},
              {'room': '607'},
              {'room': '608'},
              {'room': '609'},
              {'room': '610'},
              {'room': '611'},
              {'room': '612'}
            ]
          },
          {
            'floor': "7F",
            "floors": [
              {'room': '701'},
              {'room': '702'},
              {'room': '703'},
              {'room': '704'},
              {'room': '705'},
              {'room': '706'}
            ]
          },
          {
            'floor': "8F",
            "floors": [
              {'room': '801'},
              {'room': '802'},
              {'room': '803'},
              {'room': '804'},
              {'room': '805'},
              {'room': '806'},
              {'room': '807'},
              {'room': '808'},
              {'room': '809'},
              {'room': '810'},
              {'room': '811'},
              {'room': '812'}
            ]
          },
        ]
      }
    ],
  },
  {
    'houseName': '3栋',
    'houseId': '3',
    'building': [
      {
        'unit': '一单元',
        'units': [
          {
            'floor': "1F",
            "floors": [
              {'room': '101'},
              {'room': '102'},
              {'room': '103'},
              {'room': '104'},
              {'room': '105'},
              {'room': '106'}
            ]
          },
          {
            'floor': "2F",
            "floors": [
              {'room': '201'},
              {'room': '202'},
              {'room': '203'},
              {'room': '204'},
              {'room': '205'},
              {'room': '206'},
              {'room': '207'},
              {'room': '208'},
              {'room': '209'},
              {'room': '210'},
              {'room': '211'},
              {'room': '212'}
            ]
          },
          {
            'floor': "3F",
            "floors": [
              {'room': '301'},
              {'room': '302'},
              {'room': '303'},
              {'room': '304'},
              {'room': '305'},
              {'room': '306'}
            ]
          },
          {
            'floor': "4F",
            "floors": [
              {'room': '401'},
              {'room': '402'},
              {'room': '403'},
              {'room': '404'},
              {'room': '405'},
              {'room': '406'},
              {'room': '407'},
              {'room': '408'},
              {'room': '409'},
              {'room': '410'},
              {'room': '411'},
              {'room': '412'}
            ]
          },
          {
            'floor': "5F",
            "floors": [
              {'room': '501'},
              {'room': '502'},
              {'room': '503'},
              {'room': '504'},
              {'room': '505'},
              {'room': '506'}
            ]
          },
          {
            'floor': "6F",
            "floors": [
              {'room': '601'},
              {'room': '602'},
              {'room': '603'},
              {'room': '604'},
              {'room': '605'},
              {'room': '606'},
              {'room': '607'},
              {'room': '608'},
              {'room': '609'},
              {'room': '610'},
              {'room': '611'},
              {'room': '612'}
            ]
          },
          {
            'floor': "7F",
            "floors": [
              {'room': '701'},
              {'room': '702'},
              {'room': '703'},
              {'room': '704'},
              {'room': '705'},
              {'room': '706'}
            ]
          },
          {
            'floor': "8F",
            "floors": [
              {'room': '801'},
              {'room': '802'},
              {'room': '803'},
              {'room': '804'},
              {'room': '805'},
              {'room': '806'},
              {'room': '807'},
              {'room': '808'},
              {'room': '809'},
              {'room': '810'},
              {'room': '811'},
              {'room': '812'}
            ]
          },
        ]
      },
      {
        'unit': '二单元',
        'units': [
          {
            'floor': "1F",
            "floors": [
              {'room': '101'},
              {'room': '102'},
              {'room': '103'},
              {'room': '104'},
              {'room': '105'},
              {'room': '106'}
            ]
          },
          {
            'floor': "2F",
            "floors": [
              {'room': '201'},
              {'room': '202'},
              {'room': '203'},
              {'room': '204'},
              {'room': '205'},
              {'room': '206'},
              {'room': '207'},
              {'room': '208'},
              {'room': '209'},
              {'room': '210'},
              {'room': '211'},
              {'room': '212'}
            ]
          },
          {
            'floor': "3F",
            "floors": [
              {'room': '301'},
              {'room': '302'},
              {'room': '303'},
              {'room': '304'},
              {'room': '305'},
              {'room': '306'}
            ]
          },
          {
            'floor': "4F",
            "floors": [
              {'room': '401'},
              {'room': '402'},
              {'room': '403'},
              {'room': '404'},
              {'room': '405'},
              {'room': '406'},
              {'room': '407'},
              {'room': '408'},
              {'room': '409'},
              {'room': '410'},
              {'room': '411'},
              {'room': '412'}
            ]
          },
          {
            'floor': "5F",
            "floors": [
              {'room': '501'},
              {'room': '502'},
              {'room': '503'},
              {'room': '504'},
              {'room': '505'},
              {'room': '506'}
            ]
          },
          {
            'floor': "6F",
            "floors": [
              {'room': '601'},
              {'room': '602'},
              {'room': '603'},
              {'room': '604'},
              {'room': '605'},
              {'room': '606'},
              {'room': '607'},
              {'room': '608'},
              {'room': '609'},
              {'room': '610'},
              {'room': '611'},
              {'room': '612'}
            ]
          },
          {
            'floor': "7F",
            "floors": [
              {'room': '701'},
              {'room': '702'},
              {'room': '703'},
              {'room': '704'},
              {'room': '705'},
              {'room': '706'}
            ]
          },
          {
            'floor': "8F",
            "floors": [
              {'room': '801'},
              {'room': '802'},
              {'room': '803'},
              {'room': '804'},
              {'room': '805'},
              {'room': '806'},
              {'room': '807'},
              {'room': '808'},
              {'room': '809'},
              {'room': '810'},
              {'room': '811'},
              {'room': '812'}
            ]
          },
        ]
      },
      {
        'unit': '三单元',
        'units': [
          {
            'floor': "1F",
            "floors": [
              {'room': '101'},
              {'room': '102'},
              {'room': '103'},
              {'room': '104'},
              {'room': '105'},
              {'room': '106'}
            ]
          },
          {
            'floor': "2F",
            "floors": [
              {'room': '201'},
              {'room': '202'},
              {'room': '203'},
              {'room': '204'},
              {'room': '205'},
              {'room': '206'},
              {'room': '207'},
              {'room': '208'},
              {'room': '209'},
              {'room': '210'},
              {'room': '211'},
              {'room': '212'}
            ]
          },
          {
            'floor': "3F",
            "floors": [
              {'room': '301'},
              {'room': '302'},
              {'room': '303'},
              {'room': '304'},
              {'room': '305'},
              {'room': '306'}
            ]
          },
          {
            'floor': "4F",
            "floors": [
              {'room': '401'},
              {'room': '402'},
              {'room': '403'},
              {'room': '404'},
              {'room': '405'},
              {'room': '406'},
              {'room': '407'},
              {'room': '408'},
              {'room': '409'},
              {'room': '410'},
              {'room': '411'},
              {'room': '412'}
            ]
          },
          {
            'floor': "5F",
            "floors": [
              {'room': '501'},
              {'room': '502'},
              {'room': '503'},
              {'room': '504'},
              {'room': '505'},
              {'room': '506'}
            ]
          },
          {
            'floor': "6F",
            "floors": [
              {'room': '601'},
              {'room': '602'},
              {'room': '603'},
              {'room': '604'},
              {'room': '605'},
              {'room': '606'},
              {'room': '607'},
              {'room': '608'},
              {'room': '609'},
              {'room': '610'},
              {'room': '611'},
              {'room': '612'}
            ]
          },
          {
            'floor': "7F",
            "floors": [
              {'room': '701'},
              {'room': '702'},
              {'room': '703'},
              {'room': '704'},
              {'room': '705'},
              {'room': '706'}
            ]
          },
          {
            'floor': "8F",
            "floors": [
              {'room': '801'},
              {'room': '802'},
              {'room': '803'},
              {'room': '804'},
              {'room': '805'},
              {'room': '806'},
              {'room': '807'},
              {'room': '808'},
              {'room': '809'},
              {'room': '810'},
              {'room': '811'},
              {'room': '812'}
            ]
          },
        ]
      },
      {
        'unit': '四单元',
        'units': [
          {
            'floor': "1F",
            "floors": [
              {'room': '101'},
              {'room': '102'},
              {'room': '103'},
              {'room': '104'},
              {'room': '105'},
              {'room': '106'}
            ]
          },
          {
            'floor': "2F",
            "floors": [
              {'room': '201'},
              {'room': '202'},
              {'room': '203'},
              {'room': '204'},
              {'room': '205'},
              {'room': '206'},
              {'room': '207'},
              {'room': '208'},
              {'room': '209'},
              {'room': '210'},
              {'room': '211'},
              {'room': '212'}
            ]
          },
          {
            'floor': "3F",
            "floors": [
              {'room': '301'},
              {'room': '302'},
              {'room': '303'},
              {'room': '304'},
              {'room': '305'},
              {'room': '306'}
            ]
          },
          {
            'floor': "4F",
            "floors": [
              {'room': '401'},
              {'room': '402'},
              {'room': '403'},
              {'room': '404'},
              {'room': '405'},
              {'room': '406'},
              {'room': '407'},
              {'room': '408'},
              {'room': '409'},
              {'room': '410'},
              {'room': '411'},
              {'room': '412'}
            ]
          },
          {
            'floor': "5F",
            "floors": [
              {'room': '501'},
              {'room': '502'},
              {'room': '503'},
              {'room': '504'},
              {'room': '505'},
              {'room': '506'}
            ]
          },
          {
            'floor': "6F",
            "floors": [
              {'room': '601'},
              {'room': '602'},
              {'room': '603'},
              {'room': '604'},
              {'room': '605'},
              {'room': '606'},
              {'room': '607'},
              {'room': '608'},
              {'room': '609'},
              {'room': '610'},
              {'room': '611'},
              {'room': '612'}
            ]
          },
          {
            'floor': "7F",
            "floors": [
              {'room': '701'},
              {'room': '702'},
              {'room': '703'},
              {'room': '704'},
              {'room': '705'},
              {'room': '706'}
            ]
          },
          {
            'floor': "8F",
            "floors": [
              {'room': '801'},
              {'room': '802'},
              {'room': '803'},
              {'room': '804'},
              {'room': '805'},
              {'room': '806'},
              {'room': '807'},
              {'room': '808'},
              {'room': '809'},
              {'room': '810'},
              {'room': '811'},
              {'room': '812'}
            ]
          },
        ]
      }
    ],
  },
  {
    'houseName': '4栋',
    'houseId': '4',
    'building': [
      {
        'unit': '一单元',
        'units': [
          {
            'floor': "1F",
            "floors": [
              {'room': '101'},
              {'room': '102'},
              {'room': '103'},
              {'room': '104'},
              {'room': '105'},
              {'room': '106'}
            ]
          },
          {
            'floor': "2F",
            "floors": [
              {'room': '201'},
              {'room': '202'},
              {'room': '203'},
              {'room': '204'},
              {'room': '205'},
              {'room': '206'},
              {'room': '207'},
              {'room': '208'},
              {'room': '209'},
              {'room': '210'},
              {'room': '211'},
              {'room': '212'}
            ]
          },
          {
            'floor': "3F",
            "floors": [
              {'room': '301'},
              {'room': '302'},
              {'room': '303'},
              {'room': '304'},
              {'room': '305'},
              {'room': '306'}
            ]
          },
          {
            'floor': "4F",
            "floors": [
              {'room': '401'},
              {'room': '402'},
              {'room': '403'},
              {'room': '404'},
              {'room': '405'},
              {'room': '406'},
              {'room': '407'},
              {'room': '408'},
              {'room': '409'},
              {'room': '410'},
              {'room': '411'},
              {'room': '412'}
            ]
          },
          {
            'floor': "5F",
            "floors": [
              {'room': '501'},
              {'room': '502'},
              {'room': '503'},
              {'room': '504'},
              {'room': '505'},
              {'room': '506'}
            ]
          },
          {
            'floor': "6F",
            "floors": [
              {'room': '601'},
              {'room': '602'},
              {'room': '603'},
              {'room': '604'},
              {'room': '605'},
              {'room': '606'},
              {'room': '607'},
              {'room': '608'},
              {'room': '609'},
              {'room': '610'},
              {'room': '611'},
              {'room': '612'}
            ]
          },
          {
            'floor': "7F",
            "floors": [
              {'room': '701'},
              {'room': '702'},
              {'room': '703'},
              {'room': '704'},
              {'room': '705'},
              {'room': '706'}
            ]
          },
          {
            'floor': "8F",
            "floors": [
              {'room': '801'},
              {'room': '802'},
              {'room': '803'},
              {'room': '804'},
              {'room': '805'},
              {'room': '806'},
              {'room': '807'},
              {'room': '808'},
              {'room': '809'},
              {'room': '810'},
              {'room': '811'},
              {'room': '812'}
            ]
          },
        ]
      },
      {
        'unit': '二单元',
        'units': [
          {
            'floor': "1F",
            "floors": [
              {'room': '101'},
              {'room': '102'},
              {'room': '103'},
              {'room': '104'},
              {'room': '105'},
              {'room': '106'}
            ]
          },
          {
            'floor': "2F",
            "floors": [
              {'room': '201'},
              {'room': '202'},
              {'room': '203'},
              {'room': '204'},
              {'room': '205'},
              {'room': '206'},
              {'room': '207'},
              {'room': '208'},
              {'room': '209'},
              {'room': '210'},
              {'room': '211'},
              {'room': '212'}
            ]
          },
          {
            'floor': "3F",
            "floors": [
              {'room': '301'},
              {'room': '302'},
              {'room': '303'},
              {'room': '304'},
              {'room': '305'},
              {'room': '306'}
            ]
          },
          {
            'floor': "4F",
            "floors": [
              {'room': '401'},
              {'room': '402'},
              {'room': '403'},
              {'room': '404'},
              {'room': '405'},
              {'room': '406'},
              {'room': '407'},
              {'room': '408'},
              {'room': '409'},
              {'room': '410'},
              {'room': '411'},
              {'room': '412'}
            ]
          },
          {
            'floor': "5F",
            "floors": [
              {'room': '501'},
              {'room': '502'},
              {'room': '503'},
              {'room': '504'},
              {'room': '505'},
              {'room': '506'}
            ]
          },
          {
            'floor': "6F",
            "floors": [
              {'room': '601'},
              {'room': '602'},
              {'room': '603'},
              {'room': '604'},
              {'room': '605'},
              {'room': '606'},
              {'room': '607'},
              {'room': '608'},
              {'room': '609'},
              {'room': '610'},
              {'room': '611'},
              {'room': '612'}
            ]
          },
          {
            'floor': "7F",
            "floors": [
              {'room': '701'},
              {'room': '702'},
              {'room': '703'},
              {'room': '704'},
              {'room': '705'},
              {'room': '706'}
            ]
          },
          {
            'floor': "8F",
            "floors": [
              {'room': '801'},
              {'room': '802'},
              {'room': '803'},
              {'room': '804'},
              {'room': '805'},
              {'room': '806'},
              {'room': '807'},
              {'room': '808'},
              {'room': '809'},
              {'room': '810'},
              {'room': '811'},
              {'room': '812'}
            ]
          },
        ]
      },
      {
        'unit': '三单元',
        'units': [
          {
            'floor': "1F",
            "floors": [
              {'room': '101'},
              {'room': '102'},
              {'room': '103'},
              {'room': '104'},
              {'room': '105'},
              {'room': '106'}
            ]
          },
          {
            'floor': "2F",
            "floors": [
              {'room': '201'},
              {'room': '202'},
              {'room': '203'},
              {'room': '204'},
              {'room': '205'},
              {'room': '206'},
              {'room': '207'},
              {'room': '208'},
              {'room': '209'},
              {'room': '210'},
              {'room': '211'},
              {'room': '212'}
            ]
          },
          {
            'floor': "3F",
            "floors": [
              {'room': '301'},
              {'room': '302'},
              {'room': '303'},
              {'room': '304'},
              {'room': '305'},
              {'room': '306'}
            ]
          },
          {
            'floor': "4F",
            "floors": [
              {'room': '401'},
              {'room': '402'},
              {'room': '403'},
              {'room': '404'},
              {'room': '405'},
              {'room': '406'},
              {'room': '407'},
              {'room': '408'},
              {'room': '409'},
              {'room': '410'},
              {'room': '411'},
              {'room': '412'}
            ]
          },
          {
            'floor': "5F",
            "floors": [
              {'room': '501'},
              {'room': '502'},
              {'room': '503'},
              {'room': '504'},
              {'room': '505'},
              {'room': '506'}
            ]
          },
          {
            'floor': "6F",
            "floors": [
              {'room': '601'},
              {'room': '602'},
              {'room': '603'},
              {'room': '604'},
              {'room': '605'},
              {'room': '606'},
              {'room': '607'},
              {'room': '608'},
              {'room': '609'},
              {'room': '610'},
              {'room': '611'},
              {'room': '612'}
            ]
          },
          {
            'floor': "7F",
            "floors": [
              {'room': '701'},
              {'room': '702'},
              {'room': '703'},
              {'room': '704'},
              {'room': '705'},
              {'room': '706'}
            ]
          },
          {
            'floor': "8F",
            "floors": [
              {'room': '801'},
              {'room': '802'},
              {'room': '803'},
              {'room': '804'},
              {'room': '805'},
              {'room': '806'},
              {'room': '807'},
              {'room': '808'},
              {'room': '809'},
              {'room': '810'},
              {'room': '811'},
              {'room': '812'}
            ]
          },
        ]
      },
      {
        'unit': '四单元',
        'units': [
          {
            'floor': "1F",
            "floors": [
              {'room': '101'},
              {'room': '102'},
              {'room': '103'},
              {'room': '104'},
              {'room': '105'},
              {'room': '106'}
            ]
          },
          {
            'floor': "2F",
            "floors": [
              {'room': '201'},
              {'room': '202'},
              {'room': '203'},
              {'room': '204'},
              {'room': '205'},
              {'room': '206'},
              {'room': '207'},
              {'room': '208'},
              {'room': '209'},
              {'room': '210'},
              {'room': '211'},
              {'room': '212'}
            ]
          },
          {
            'floor': "3F",
            "floors": [
              {'room': '301'},
              {'room': '302'},
              {'room': '303'},
              {'room': '304'},
              {'room': '305'},
              {'room': '306'}
            ]
          },
          {
            'floor': "4F",
            "floors": [
              {'room': '401'},
              {'room': '402'},
              {'room': '403'},
              {'room': '404'},
              {'room': '405'},
              {'room': '406'},
              {'room': '407'},
              {'room': '408'},
              {'room': '409'},
              {'room': '410'},
              {'room': '411'},
              {'room': '412'}
            ]
          },
          {
            'floor': "5F",
            "floors": [
              {'room': '501'},
              {'room': '502'},
              {'room': '503'},
              {'room': '504'},
              {'room': '505'},
              {'room': '506'}
            ]
          },
          {
            'floor': "6F",
            "floors": [
              {'room': '601'},
              {'room': '602'},
              {'room': '603'},
              {'room': '604'},
              {'room': '605'},
              {'room': '606'},
              {'room': '607'},
              {'room': '608'},
              {'room': '609'},
              {'room': '610'},
              {'room': '611'},
              {'room': '612'}
            ]
          },
          {
            'floor': "7F",
            "floors": [
              {'room': '701'},
              {'room': '702'},
              {'room': '703'},
              {'room': '704'},
              {'room': '705'},
              {'room': '706'}
            ]
          },
          {
            'floor': "8F",
            "floors": [
              {'room': '801'},
              {'room': '802'},
              {'room': '803'},
              {'room': '804'},
              {'room': '805'},
              {'room': '806'},
              {'room': '807'},
              {'room': '808'},
              {'room': '809'},
              {'room': '810'},
              {'room': '811'},
              {'room': '812'}
            ]
          },
        ]
      }
    ],
  },
  {
    'houseName': '5栋',
    'houseId': '5',
    'building': [
      {
        'unit': '一单元',
        'units': [
          {
            'floor': "1F",
            "floors": [
              {'room': '101'},
              {'room': '102'},
              {'room': '103'},
              {'room': '104'},
              {'room': '105'},
              {'room': '106'}
            ]
          },
          {
            'floor': "2F",
            "floors": [
              {'room': '201'},
              {'room': '202'},
              {'room': '203'},
              {'room': '204'},
              {'room': '205'},
              {'room': '206'},
              {'room': '207'},
              {'room': '208'},
              {'room': '209'},
              {'room': '210'},
              {'room': '211'},
              {'room': '212'}
            ]
          },
          {
            'floor': "3F",
            "floors": [
              {'room': '301'},
              {'room': '302'},
              {'room': '303'},
              {'room': '304'},
              {'room': '305'},
              {'room': '306'}
            ]
          },
          {
            'floor': "4F",
            "floors": [
              {'room': '401'},
              {'room': '402'},
              {'room': '403'},
              {'room': '404'},
              {'room': '405'},
              {'room': '406'},
              {'room': '407'},
              {'room': '408'},
              {'room': '409'},
              {'room': '410'},
              {'room': '411'},
              {'room': '412'}
            ]
          },
          {
            'floor': "5F",
            "floors": [
              {'room': '501'},
              {'room': '502'},
              {'room': '503'},
              {'room': '504'},
              {'room': '505'},
              {'room': '506'}
            ]
          },
          {
            'floor': "6F",
            "floors": [
              {'room': '601'},
              {'room': '602'},
              {'room': '603'},
              {'room': '604'},
              {'room': '605'},
              {'room': '606'},
              {'room': '607'},
              {'room': '608'},
              {'room': '609'},
              {'room': '610'},
              {'room': '611'},
              {'room': '612'}
            ]
          },
          {
            'floor': "7F",
            "floors": [
              {'room': '701'},
              {'room': '702'},
              {'room': '703'},
              {'room': '704'},
              {'room': '705'},
              {'room': '706'}
            ]
          },
          {
            'floor': "8F",
            "floors": [
              {'room': '801'},
              {'room': '802'},
              {'room': '803'},
              {'room': '804'},
              {'room': '805'},
              {'room': '806'},
              {'room': '807'},
              {'room': '808'},
              {'room': '809'},
              {'room': '810'},
              {'room': '811'},
              {'room': '812'}
            ]
          },
        ]
      },
      {
        'unit': '二单元',
        'units': [
          {
            'floor': "1F",
            "floors": [
              {'room': '101'},
              {'room': '102'},
              {'room': '103'},
              {'room': '104'},
              {'room': '105'},
              {'room': '106'}
            ]
          },
          {
            'floor': "2F",
            "floors": [
              {'room': '201'},
              {'room': '202'},
              {'room': '203'},
              {'room': '204'},
              {'room': '205'},
              {'room': '206'},
              {'room': '207'},
              {'room': '208'},
              {'room': '209'},
              {'room': '210'},
              {'room': '211'},
              {'room': '212'}
            ]
          },
          {
            'floor': "3F",
            "floors": [
              {'room': '301'},
              {'room': '302'},
              {'room': '303'},
              {'room': '304'},
              {'room': '305'},
              {'room': '306'}
            ]
          },
          {
            'floor': "4F",
            "floors": [
              {'room': '401'},
              {'room': '402'},
              {'room': '403'},
              {'room': '404'},
              {'room': '405'},
              {'room': '406'},
              {'room': '407'},
              {'room': '408'},
              {'room': '409'},
              {'room': '410'},
              {'room': '411'},
              {'room': '412'}
            ]
          },
          {
            'floor': "5F",
            "floors": [
              {'room': '501'},
              {'room': '502'},
              {'room': '503'},
              {'room': '504'},
              {'room': '505'},
              {'room': '506'}
            ]
          },
          {
            'floor': "6F",
            "floors": [
              {'room': '601'},
              {'room': '602'},
              {'room': '603'},
              {'room': '604'},
              {'room': '605'},
              {'room': '606'},
              {'room': '607'},
              {'room': '608'},
              {'room': '609'},
              {'room': '610'},
              {'room': '611'},
              {'room': '612'}
            ]
          },
          {
            'floor': "7F",
            "floors": [
              {'room': '701'},
              {'room': '702'},
              {'room': '703'},
              {'room': '704'},
              {'room': '705'},
              {'room': '706'}
            ]
          },
          {
            'floor': "8F",
            "floors": [
              {'room': '801'},
              {'room': '802'},
              {'room': '803'},
              {'room': '804'},
              {'room': '805'},
              {'room': '806'},
              {'room': '807'},
              {'room': '808'},
              {'room': '809'},
              {'room': '810'},
              {'room': '811'},
              {'room': '812'}
            ]
          },
        ]
      },
      {
        'unit': '三单元',
        'units': [
          {
            'floor': "1F",
            "floors": [
              {'room': '101'},
              {'room': '102'},
              {'room': '103'},
              {'room': '104'},
              {'room': '105'},
              {'room': '106'}
            ]
          },
          {
            'floor': "2F",
            "floors": [
              {'room': '201'},
              {'room': '202'},
              {'room': '203'},
              {'room': '204'},
              {'room': '205'},
              {'room': '206'},
              {'room': '207'},
              {'room': '208'},
              {'room': '209'},
              {'room': '210'},
              {'room': '211'},
              {'room': '212'}
            ]
          },
          {
            'floor': "3F",
            "floors": [
              {'room': '301'},
              {'room': '302'},
              {'room': '303'},
              {'room': '304'},
              {'room': '305'},
              {'room': '306'}
            ]
          },
          {
            'floor': "4F",
            "floors": [
              {'room': '401'},
              {'room': '402'},
              {'room': '403'},
              {'room': '404'},
              {'room': '405'},
              {'room': '406'},
              {'room': '407'},
              {'room': '408'},
              {'room': '409'},
              {'room': '410'},
              {'room': '411'},
              {'room': '412'}
            ]
          },
          {
            'floor': "5F",
            "floors": [
              {'room': '501'},
              {'room': '502'},
              {'room': '503'},
              {'room': '504'},
              {'room': '505'},
              {'room': '506'}
            ]
          },
          {
            'floor': "6F",
            "floors": [
              {'room': '601'},
              {'room': '602'},
              {'room': '603'},
              {'room': '604'},
              {'room': '605'},
              {'room': '606'},
              {'room': '607'},
              {'room': '608'},
              {'room': '609'},
              {'room': '610'},
              {'room': '611'},
              {'room': '612'}
            ]
          },
          {
            'floor': "7F",
            "floors": [
              {'room': '701'},
              {'room': '702'},
              {'room': '703'},
              {'room': '704'},
              {'room': '705'},
              {'room': '706'}
            ]
          },
          {
            'floor': "8F",
            "floors": [
              {'room': '801'},
              {'room': '802'},
              {'room': '803'},
              {'room': '804'},
              {'room': '805'},
              {'room': '806'},
              {'room': '807'},
              {'room': '808'},
              {'room': '809'},
              {'room': '810'},
              {'room': '811'},
              {'room': '812'}
            ]
          },
        ]
      },
      {
        'unit': '四单元',
        'units': [
          {
            'floor': "1F",
            "floors": [
              {'room': '101'},
              {'room': '102'},
              {'room': '103'},
              {'room': '104'},
              {'room': '105'},
              {'room': '106'}
            ]
          },
          {
            'floor': "2F",
            "floors": [
              {'room': '201'},
              {'room': '202'},
              {'room': '203'},
              {'room': '204'},
              {'room': '205'},
              {'room': '206'},
              {'room': '207'},
              {'room': '208'},
              {'room': '209'},
              {'room': '210'},
              {'room': '211'},
              {'room': '212'}
            ]
          },
          {
            'floor': "3F",
            "floors": [
              {'room': '301'},
              {'room': '302'},
              {'room': '303'},
              {'room': '304'},
              {'room': '305'},
              {'room': '306'}
            ]
          },
          {
            'floor': "4F",
            "floors": [
              {'room': '401'},
              {'room': '402'},
              {'room': '403'},
              {'room': '404'},
              {'room': '405'},
              {'room': '406'},
              {'room': '407'},
              {'room': '408'},
              {'room': '409'},
              {'room': '410'},
              {'room': '411'},
              {'room': '412'}
            ]
          },
          {
            'floor': "5F",
            "floors": [
              {'room': '501'},
              {'room': '502'},
              {'room': '503'},
              {'room': '504'},
              {'room': '505'},
              {'room': '506'}
            ]
          },
          {
            'floor': "6F",
            "floors": [
              {'room': '601'},
              {'room': '602'},
              {'room': '603'},
              {'room': '604'},
              {'room': '605'},
              {'room': '606'},
              {'room': '607'},
              {'room': '608'},
              {'room': '609'},
              {'room': '610'},
              {'room': '611'},
              {'room': '612'}
            ]
          },
          {
            'floor': "7F",
            "floors": [
              {'room': '701'},
              {'room': '702'},
              {'room': '703'},
              {'room': '704'},
              {'room': '705'},
              {'room': '706'}
            ]
          },
          {
            'floor': "8F",
            "floors": [
              {'room': '801'},
              {'room': '802'},
              {'room': '803'},
              {'room': '804'},
              {'room': '805'},
              {'room': '806'},
              {'room': '807'},
              {'room': '808'},
              {'room': '809'},
              {'room': '810'},
              {'room': '811'},
              {'room': '812'}
            ]
          },
        ]
      }
    ],
  },
  {
    'houseName': '6栋',
    'houseId': '6',
    'building': [
      {
        'unit': '一单元',
        'units': [
          {
            'floor': "1F",
            "floors": [
              {'room': '101'},
              {'room': '102'},
              {'room': '103'},
              {'room': '104'},
              {'room': '105'},
              {'room': '106'}
            ]
          },
          {
            'floor': "2F",
            "floors": [
              {'room': '201'},
              {'room': '202'},
              {'room': '203'},
              {'room': '204'},
              {'room': '205'},
              {'room': '206'},
              {'room': '207'},
              {'room': '208'},
              {'room': '209'},
              {'room': '210'},
              {'room': '211'},
              {'room': '212'}
            ]
          },
          {
            'floor': "3F",
            "floors": [
              {'room': '301'},
              {'room': '302'},
              {'room': '303'},
              {'room': '304'},
              {'room': '305'},
              {'room': '306'}
            ]
          },
          {
            'floor': "4F",
            "floors": [
              {'room': '401'},
              {'room': '402'},
              {'room': '403'},
              {'room': '404'},
              {'room': '405'},
              {'room': '406'},
              {'room': '407'},
              {'room': '408'},
              {'room': '409'},
              {'room': '410'},
              {'room': '411'},
              {'room': '412'}
            ]
          },
          {
            'floor': "5F",
            "floors": [
              {'room': '501'},
              {'room': '502'},
              {'room': '503'},
              {'room': '504'},
              {'room': '505'},
              {'room': '506'}
            ]
          },
          {
            'floor': "6F",
            "floors": [
              {'room': '601'},
              {'room': '602'},
              {'room': '603'},
              {'room': '604'},
              {'room': '605'},
              {'room': '606'},
              {'room': '607'},
              {'room': '608'},
              {'room': '609'},
              {'room': '610'},
              {'room': '611'},
              {'room': '612'}
            ]
          },
          {
            'floor': "7F",
            "floors": [
              {'room': '701'},
              {'room': '702'},
              {'room': '703'},
              {'room': '704'},
              {'room': '705'},
              {'room': '706'}
            ]
          },
          {
            'floor': "8F",
            "floors": [
              {'room': '801'},
              {'room': '802'},
              {'room': '803'},
              {'room': '804'},
              {'room': '805'},
              {'room': '806'},
              {'room': '807'},
              {'room': '808'},
              {'room': '809'},
              {'room': '810'},
              {'room': '811'},
              {'room': '812'}
            ]
          },
        ]
      },
      {
        'unit': '二单元',
        'units': [
          {
            'floor': "1F",
            "floors": [
              {'room': '101'},
              {'room': '102'},
              {'room': '103'},
              {'room': '104'},
              {'room': '105'},
              {'room': '106'}
            ]
          },
          {
            'floor': "2F",
            "floors": [
              {'room': '201'},
              {'room': '202'},
              {'room': '203'},
              {'room': '204'},
              {'room': '205'},
              {'room': '206'},
              {'room': '207'},
              {'room': '208'},
              {'room': '209'},
              {'room': '210'},
              {'room': '211'},
              {'room': '212'}
            ]
          },
          {
            'floor': "3F",
            "floors": [
              {'room': '301'},
              {'room': '302'},
              {'room': '303'},
              {'room': '304'},
              {'room': '305'},
              {'room': '306'}
            ]
          },
          {
            'floor': "4F",
            "floors": [
              {'room': '401'},
              {'room': '402'},
              {'room': '403'},
              {'room': '404'},
              {'room': '405'},
              {'room': '406'},
              {'room': '407'},
              {'room': '408'},
              {'room': '409'},
              {'room': '410'},
              {'room': '411'},
              {'room': '412'}
            ]
          },
          {
            'floor': "5F",
            "floors": [
              {'room': '501'},
              {'room': '502'},
              {'room': '503'},
              {'room': '504'},
              {'room': '505'},
              {'room': '506'}
            ]
          },
          {
            'floor': "6F",
            "floors": [
              {'room': '601'},
              {'room': '602'},
              {'room': '603'},
              {'room': '604'},
              {'room': '605'},
              {'room': '606'},
              {'room': '607'},
              {'room': '608'},
              {'room': '609'},
              {'room': '610'},
              {'room': '611'},
              {'room': '612'}
            ]
          },
          {
            'floor': "7F",
            "floors": [
              {'room': '701'},
              {'room': '702'},
              {'room': '703'},
              {'room': '704'},
              {'room': '705'},
              {'room': '706'}
            ]
          },
          {
            'floor': "8F",
            "floors": [
              {'room': '801'},
              {'room': '802'},
              {'room': '803'},
              {'room': '804'},
              {'room': '805'},
              {'room': '806'},
              {'room': '807'},
              {'room': '808'},
              {'room': '809'},
              {'room': '810'},
              {'room': '811'},
              {'room': '812'}
            ]
          },
        ]
      },
      {
        'unit': '三单元',
        'units': [
          {
            'floor': "1F",
            "floors": [
              {'room': '101'},
              {'room': '102'},
              {'room': '103'},
              {'room': '104'},
              {'room': '105'},
              {'room': '106'}
            ]
          },
          {
            'floor': "2F",
            "floors": [
              {'room': '201'},
              {'room': '202'},
              {'room': '203'},
              {'room': '204'},
              {'room': '205'},
              {'room': '206'},
              {'room': '207'},
              {'room': '208'},
              {'room': '209'},
              {'room': '210'},
              {'room': '211'},
              {'room': '212'}
            ]
          },
          {
            'floor': "3F",
            "floors": [
              {'room': '301'},
              {'room': '302'},
              {'room': '303'},
              {'room': '304'},
              {'room': '305'},
              {'room': '306'}
            ]
          },
          {
            'floor': "4F",
            "floors": [
              {'room': '401'},
              {'room': '402'},
              {'room': '403'},
              {'room': '404'},
              {'room': '405'},
              {'room': '406'},
              {'room': '407'},
              {'room': '408'},
              {'room': '409'},
              {'room': '410'},
              {'room': '411'},
              {'room': '412'}
            ]
          },
          {
            'floor': "5F",
            "floors": [
              {'room': '501'},
              {'room': '502'},
              {'room': '503'},
              {'room': '504'},
              {'room': '505'},
              {'room': '506'}
            ]
          },
          {
            'floor': "6F",
            "floors": [
              {'room': '601'},
              {'room': '602'},
              {'room': '603'},
              {'room': '604'},
              {'room': '605'},
              {'room': '606'},
              {'room': '607'},
              {'room': '608'},
              {'room': '609'},
              {'room': '610'},
              {'room': '611'},
              {'room': '612'}
            ]
          },
          {
            'floor': "7F",
            "floors": [
              {'room': '701'},
              {'room': '702'},
              {'room': '703'},
              {'room': '704'},
              {'room': '705'},
              {'room': '706'}
            ]
          },
          {
            'floor': "8F",
            "floors": [
              {'room': '801'},
              {'room': '802'},
              {'room': '803'},
              {'room': '804'},
              {'room': '805'},
              {'room': '806'},
              {'room': '807'},
              {'room': '808'},
              {'room': '809'},
              {'room': '810'},
              {'room': '811'},
              {'room': '812'}
            ]
          },
        ]
      },
      {
        'unit': '四单元',
        'units': [
          {
            'floor': "1F",
            "floors": [
              {'room': '101'},
              {'room': '102'},
              {'room': '103'},
              {'room': '104'},
              {'room': '105'},
              {'room': '106'}
            ]
          },
          {
            'floor': "2F",
            "floors": [
              {'room': '201'},
              {'room': '202'},
              {'room': '203'},
              {'room': '204'},
              {'room': '205'},
              {'room': '206'},
              {'room': '207'},
              {'room': '208'},
              {'room': '209'},
              {'room': '210'},
              {'room': '211'},
              {'room': '212'}
            ]
          },
          {
            'floor': "3F",
            "floors": [
              {'room': '301'},
              {'room': '302'},
              {'room': '303'},
              {'room': '304'},
              {'room': '305'},
              {'room': '306'}
            ]
          },
          {
            'floor': "4F",
            "floors": [
              {'room': '401'},
              {'room': '402'},
              {'room': '403'},
              {'room': '404'},
              {'room': '405'},
              {'room': '406'},
              {'room': '407'},
              {'room': '408'},
              {'room': '409'},
              {'room': '410'},
              {'room': '411'},
              {'room': '412'}
            ]
          },
          {
            'floor': "5F",
            "floors": [
              {'room': '501'},
              {'room': '502'},
              {'room': '503'},
              {'room': '504'},
              {'room': '505'},
              {'room': '506'}
            ]
          },
          {
            'floor': "6F",
            "floors": [
              {'room': '601'},
              {'room': '602'},
              {'room': '603'},
              {'room': '604'},
              {'room': '605'},
              {'room': '606'},
              {'room': '607'},
              {'room': '608'},
              {'room': '609'},
              {'room': '610'},
              {'room': '611'},
              {'room': '612'}
            ]
          },
          {
            'floor': "7F",
            "floors": [
              {'room': '701'},
              {'room': '702'},
              {'room': '703'},
              {'room': '704'},
              {'room': '705'},
              {'room': '706'}
            ]
          },
          {
            'floor': "8F",
            "floors": [
              {'room': '801'},
              {'room': '802'},
              {'room': '803'},
              {'room': '804'},
              {'room': '805'},
              {'room': '806'},
              {'room': '807'},
              {'room': '808'},
              {'room': '809'},
              {'room': '810'},
              {'room': '811'},
              {'room': '812'}
            ]
          },
        ]
      }
    ],
  },
  // {
  //   'houseName': '7栋',
  //   'houseId': '7',
  //   'building': [
  //     {
  //       'unit': '一单元',
  //       'units': [
  //         {
  //           'floor': "1F",
  //           "floors": [
  //             {'room': '101'},
  //             {'room': '102'},
  //             {'room': '103'},
  //             {'room': '104'},
  //             {'room': '105'},
  //             {'room': '106'}
  //           ]
  //         },
  //         {
  //           'floor': "2F",
  //           "floors": [
  //             {'room': '201'},
  //             {'room': '202'},
  //             {'room': '203'},
  //             {'room': '204'},
  //             {'room': '205'},
  //             {'room': '206'},
  //             {'room': '207'},
  //             {'room': '208'},
  //             {'room': '209'},
  //             {'room': '210'},
  //             {'room': '211'},
  //             {'room': '212'}
  //           ]
  //         },
  //         {
  //           'floor': "3F",
  //           "floors": [
  //             {'room': '301'},
  //             {'room': '302'},
  //             {'room': '303'},
  //             {'room': '304'},
  //             {'room': '305'},
  //             {'room': '306'}
  //           ]
  //         },
  //         {
  //           'floor': "4F",
  //           "floors": [
  //             {'room': '401'},
  //             {'room': '402'},
  //             {'room': '403'},
  //             {'room': '404'},
  //             {'room': '405'},
  //             {'room': '406'},
  //             {'room': '407'},
  //             {'room': '408'},
  //             {'room': '409'},
  //             {'room': '410'},
  //             {'room': '411'},
  //             {'room': '412'}
  //           ]
  //         },
  //         {
  //           'floor': "5F",
  //           "floors": [
  //             {'room': '501'},
  //             {'room': '502'},
  //             {'room': '503'},
  //             {'room': '504'},
  //             {'room': '505'},
  //             {'room': '506'}
  //           ]
  //         },
  //         {
  //           'floor': "6F",
  //           "floors": [
  //             {'room': '601'},
  //             {'room': '602'},
  //             {'room': '603'},
  //             {'room': '604'},
  //             {'room': '605'},
  //             {'room': '606'},
  //             {'room': '607'},
  //             {'room': '608'},
  //             {'room': '609'},
  //             {'room': '610'},
  //             {'room': '611'},
  //             {'room': '612'}
  //           ]
  //         },
  //         {
  //           'floor': "7F",
  //           "floors": [
  //             {'room': '701'},
  //             {'room': '702'},
  //             {'room': '703'},
  //             {'room': '704'},
  //             {'room': '705'},
  //             {'room': '706'}
  //           ]
  //         },
  //         {
  //           'floor': "8F",
  //           "floors": [
  //             {'room': '801'},
  //             {'room': '802'},
  //             {'room': '803'},
  //             {'room': '804'},
  //             {'room': '805'},
  //             {'room': '806'},
  //             {'room': '807'},
  //             {'room': '808'},
  //             {'room': '809'},
  //             {'room': '810'},
  //             {'room': '811'},
  //             {'room': '812'}
  //           ]
  //         },
  //       ]
  //     },
  //     {
  //       'unit': '二单元',
  //       'units': [
  //         {
  //           'floor': "1F",
  //           "floors": [
  //             {'room': '101'},
  //             {'room': '102'},
  //             {'room': '103'},
  //             {'room': '104'},
  //             {'room': '105'},
  //             {'room': '106'}
  //           ]
  //         },
  //         {
  //           'floor': "2F",
  //           "floors": [
  //             {'room': '201'},
  //             {'room': '202'},
  //             {'room': '203'},
  //             {'room': '204'},
  //             {'room': '205'},
  //             {'room': '206'},
  //             {'room': '207'},
  //             {'room': '208'},
  //             {'room': '209'},
  //             {'room': '210'},
  //             {'room': '211'},
  //             {'room': '212'}
  //           ]
  //         },
  //         {
  //           'floor': "3F",
  //           "floors": [
  //             {'room': '301'},
  //             {'room': '302'},
  //             {'room': '303'},
  //             {'room': '304'},
  //             {'room': '305'},
  //             {'room': '306'}
  //           ]
  //         },
  //         {
  //           'floor': "4F",
  //           "floors": [
  //             {'room': '401'},
  //             {'room': '402'},
  //             {'room': '403'},
  //             {'room': '404'},
  //             {'room': '405'},
  //             {'room': '406'},
  //             {'room': '407'},
  //             {'room': '408'},
  //             {'room': '409'},
  //             {'room': '410'},
  //             {'room': '411'},
  //             {'room': '412'}
  //           ]
  //         },
  //         {
  //           'floor': "5F",
  //           "floors": [
  //             {'room': '501'},
  //             {'room': '502'},
  //             {'room': '503'},
  //             {'room': '504'},
  //             {'room': '505'},
  //             {'room': '506'}
  //           ]
  //         },
  //         {
  //           'floor': "6F",
  //           "floors": [
  //             {'room': '601'},
  //             {'room': '602'},
  //             {'room': '603'},
  //             {'room': '604'},
  //             {'room': '605'},
  //             {'room': '606'},
  //             {'room': '607'},
  //             {'room': '608'},
  //             {'room': '609'},
  //             {'room': '610'},
  //             {'room': '611'},
  //             {'room': '612'}
  //           ]
  //         },
  //         {
  //           'floor': "7F",
  //           "floors": [
  //             {'room': '701'},
  //             {'room': '702'},
  //             {'room': '703'},
  //             {'room': '704'},
  //             {'room': '705'},
  //             {'room': '706'}
  //           ]
  //         },
  //         {
  //           'floor': "8F",
  //           "floors": [
  //             {'room': '801'},
  //             {'room': '802'},
  //             {'room': '803'},
  //             {'room': '804'},
  //             {'room': '805'},
  //             {'room': '806'},
  //             {'room': '807'},
  //             {'room': '808'},
  //             {'room': '809'},
  //             {'room': '810'},
  //             {'room': '811'},
  //             {'room': '812'}
  //           ]
  //         },
  //       ]
  //     },
  //     {
  //       'unit': '三单元',
  //       'units': [
  //         {
  //           'floor': "1F",
  //           "floors": [
  //             {'room': '101'},
  //             {'room': '102'},
  //             {'room': '103'},
  //             {'room': '104'},
  //             {'room': '105'},
  //             {'room': '106'}
  //           ]
  //         },
  //         {
  //           'floor': "2F",
  //           "floors": [
  //             {'room': '201'},
  //             {'room': '202'},
  //             {'room': '203'},
  //             {'room': '204'},
  //             {'room': '205'},
  //             {'room': '206'},
  //             {'room': '207'},
  //             {'room': '208'},
  //             {'room': '209'},
  //             {'room': '210'},
  //             {'room': '211'},
  //             {'room': '212'}
  //           ]
  //         },
  //         {
  //           'floor': "3F",
  //           "floors": [
  //             {'room': '301'},
  //             {'room': '302'},
  //             {'room': '303'},
  //             {'room': '304'},
  //             {'room': '305'},
  //             {'room': '306'}
  //           ]
  //         },
  //         {
  //           'floor': "4F",
  //           "floors": [
  //             {'room': '401'},
  //             {'room': '402'},
  //             {'room': '403'},
  //             {'room': '404'},
  //             {'room': '405'},
  //             {'room': '406'},
  //             {'room': '407'},
  //             {'room': '408'},
  //             {'room': '409'},
  //             {'room': '410'},
  //             {'room': '411'},
  //             {'room': '412'}
  //           ]
  //         },
  //         {
  //           'floor': "5F",
  //           "floors": [
  //             {'room': '501'},
  //             {'room': '502'},
  //             {'room': '503'},
  //             {'room': '504'},
  //             {'room': '505'},
  //             {'room': '506'}
  //           ]
  //         },
  //         {
  //           'floor': "6F",
  //           "floors": [
  //             {'room': '601'},
  //             {'room': '602'},
  //             {'room': '603'},
  //             {'room': '604'},
  //             {'room': '605'},
  //             {'room': '606'},
  //             {'room': '607'},
  //             {'room': '608'},
  //             {'room': '609'},
  //             {'room': '610'},
  //             {'room': '611'},
  //             {'room': '612'}
  //           ]
  //         },
  //         {
  //           'floor': "7F",
  //           "floors": [
  //             {'room': '701'},
  //             {'room': '702'},
  //             {'room': '703'},
  //             {'room': '704'},
  //             {'room': '705'},
  //             {'room': '706'}
  //           ]
  //         },
  //         {
  //           'floor': "8F",
  //           "floors": [
  //             {'room': '801'},
  //             {'room': '802'},
  //             {'room': '803'},
  //             {'room': '804'},
  //             {'room': '805'},
  //             {'room': '806'},
  //             {'room': '807'},
  //             {'room': '808'},
  //             {'room': '809'},
  //             {'room': '810'},
  //             {'room': '811'},
  //             {'room': '812'}
  //           ]
  //         },
  //       ]
  //     },
  //     {
  //       'unit': '四单元',
  //       'units': [
  //         {
  //           'floor': "1F",
  //           "floors": [
  //             {'room': '101'},
  //             {'room': '102'},
  //             {'room': '103'},
  //             {'room': '104'},
  //             {'room': '105'},
  //             {'room': '106'}
  //           ]
  //         },
  //         {
  //           'floor': "2F",
  //           "floors": [
  //             {'room': '201'},
  //             {'room': '202'},
  //             {'room': '203'},
  //             {'room': '204'},
  //             {'room': '205'},
  //             {'room': '206'},
  //             {'room': '207'},
  //             {'room': '208'},
  //             {'room': '209'},
  //             {'room': '210'},
  //             {'room': '211'},
  //             {'room': '212'}
  //           ]
  //         },
  //         {
  //           'floor': "3F",
  //           "floors": [
  //             {'room': '301'},
  //             {'room': '302'},
  //             {'room': '303'},
  //             {'room': '304'},
  //             {'room': '305'},
  //             {'room': '306'}
  //           ]
  //         },
  //         {
  //           'floor': "4F",
  //           "floors": [
  //             {'room': '401'},
  //             {'room': '402'},
  //             {'room': '403'},
  //             {'room': '404'},
  //             {'room': '405'},
  //             {'room': '406'},
  //             {'room': '407'},
  //             {'room': '408'},
  //             {'room': '409'},
  //             {'room': '410'},
  //             {'room': '411'},
  //             {'room': '412'}
  //           ]
  //         },
  //         {
  //           'floor': "5F",
  //           "floors": [
  //             {'room': '501'},
  //             {'room': '502'},
  //             {'room': '503'},
  //             {'room': '504'},
  //             {'room': '505'},
  //             {'room': '506'}
  //           ]
  //         },
  //         {
  //           'floor': "6F",
  //           "floors": [
  //             {'room': '601'},
  //             {'room': '602'},
  //             {'room': '603'},
  //             {'room': '604'},
  //             {'room': '605'},
  //             {'room': '606'},
  //             {'room': '607'},
  //             {'room': '608'},
  //             {'room': '609'},
  //             {'room': '610'},
  //             {'room': '611'},
  //             {'room': '612'}
  //           ]
  //         },
  //         {
  //           'floor': "7F",
  //           "floors": [
  //             {'room': '701'},
  //             {'room': '702'},
  //             {'room': '703'},
  //             {'room': '704'},
  //             {'room': '705'},
  //             {'room': '706'}
  //           ]
  //         },
  //         {
  //           'floor': "8F",
  //           "floors": [
  //             {'room': '801'},
  //             {'room': '802'},
  //             {'room': '803'},
  //             {'room': '804'},
  //             {'room': '805'},
  //             {'room': '806'},
  //             {'room': '807'},
  //             {'room': '808'},
  //             {'room': '809'},
  //             {'room': '810'},
  //             {'room': '811'},
  //             {'room': '812'}
  //           ]
  //         },
  //       ]
  //     }
  //   ],
  // },
  // {
  //   'houseName': '8栋',
  //   'houseId': '8',
  //   'building': [
  //     {
  //       'unit': '一单元',
  //       'units': [
  //         {
  //           'floor': "1F",
  //           "floors": [
  //             {'room': '101'},
  //             {'room': '102'},
  //             {'room': '103'},
  //             {'room': '104'},
  //             {'room': '105'},
  //             {'room': '106'}
  //           ]
  //         },
  //         {
  //           'floor': "2F",
  //           "floors": [
  //             {'room': '201'},
  //             {'room': '202'},
  //             {'room': '203'},
  //             {'room': '204'},
  //             {'room': '205'},
  //             {'room': '206'},
  //             {'room': '207'},
  //             {'room': '208'},
  //             {'room': '209'},
  //             {'room': '210'},
  //             {'room': '211'},
  //             {'room': '212'}
  //           ]
  //         },
  //         {
  //           'floor': "3F",
  //           "floors": [
  //             {'room': '301'},
  //             {'room': '302'},
  //             {'room': '303'},
  //             {'room': '304'},
  //             {'room': '305'},
  //             {'room': '306'}
  //           ]
  //         },
  //         {
  //           'floor': "4F",
  //           "floors": [
  //             {'room': '401'},
  //             {'room': '402'},
  //             {'room': '403'},
  //             {'room': '404'},
  //             {'room': '405'},
  //             {'room': '406'},
  //             {'room': '407'},
  //             {'room': '408'},
  //             {'room': '409'},
  //             {'room': '410'},
  //             {'room': '411'},
  //             {'room': '412'}
  //           ]
  //         },
  //         {
  //           'floor': "5F",
  //           "floors": [
  //             {'room': '501'},
  //             {'room': '502'},
  //             {'room': '503'},
  //             {'room': '504'},
  //             {'room': '505'},
  //             {'room': '506'}
  //           ]
  //         },
  //         {
  //           'floor': "6F",
  //           "floors": [
  //             {'room': '601'},
  //             {'room': '602'},
  //             {'room': '603'},
  //             {'room': '604'},
  //             {'room': '605'},
  //             {'room': '606'},
  //             {'room': '607'},
  //             {'room': '608'},
  //             {'room': '609'},
  //             {'room': '610'},
  //             {'room': '611'},
  //             {'room': '612'}
  //           ]
  //         },
  //         {
  //           'floor': "7F",
  //           "floors": [
  //             {'room': '701'},
  //             {'room': '702'},
  //             {'room': '703'},
  //             {'room': '704'},
  //             {'room': '705'},
  //             {'room': '706'}
  //           ]
  //         },
  //         {
  //           'floor': "8F",
  //           "floors": [
  //             {'room': '801'},
  //             {'room': '802'},
  //             {'room': '803'},
  //             {'room': '804'},
  //             {'room': '805'},
  //             {'room': '806'},
  //             {'room': '807'},
  //             {'room': '808'},
  //             {'room': '809'},
  //             {'room': '810'},
  //             {'room': '811'},
  //             {'room': '812'}
  //           ]
  //         },
  //       ]
  //     },
  //     {
  //       'unit': '二单元',
  //       'units': [
  //         {
  //           'floor': "1F",
  //           "floors": [
  //             {'room': '101'},
  //             {'room': '102'},
  //             {'room': '103'},
  //             {'room': '104'},
  //             {'room': '105'},
  //             {'room': '106'}
  //           ]
  //         },
  //         {
  //           'floor': "2F",
  //           "floors": [
  //             {'room': '201'},
  //             {'room': '202'},
  //             {'room': '203'},
  //             {'room': '204'},
  //             {'room': '205'},
  //             {'room': '206'},
  //             {'room': '207'},
  //             {'room': '208'},
  //             {'room': '209'},
  //             {'room': '210'},
  //             {'room': '211'},
  //             {'room': '212'}
  //           ]
  //         },
  //         {
  //           'floor': "3F",
  //           "floors": [
  //             {'room': '301'},
  //             {'room': '302'},
  //             {'room': '303'},
  //             {'room': '304'},
  //             {'room': '305'},
  //             {'room': '306'}
  //           ]
  //         },
  //         {
  //           'floor': "4F",
  //           "floors": [
  //             {'room': '401'},
  //             {'room': '402'},
  //             {'room': '403'},
  //             {'room': '404'},
  //             {'room': '405'},
  //             {'room': '406'},
  //             {'room': '407'},
  //             {'room': '408'},
  //             {'room': '409'},
  //             {'room': '410'},
  //             {'room': '411'},
  //             {'room': '412'}
  //           ]
  //         },
  //         {
  //           'floor': "5F",
  //           "floors": [
  //             {'room': '501'},
  //             {'room': '502'},
  //             {'room': '503'},
  //             {'room': '504'},
  //             {'room': '505'},
  //             {'room': '506'}
  //           ]
  //         },
  //         {
  //           'floor': "6F",
  //           "floors": [
  //             {'room': '601'},
  //             {'room': '602'},
  //             {'room': '603'},
  //             {'room': '604'},
  //             {'room': '605'},
  //             {'room': '606'},
  //             {'room': '607'},
  //             {'room': '608'},
  //             {'room': '609'},
  //             {'room': '610'},
  //             {'room': '611'},
  //             {'room': '612'}
  //           ]
  //         },
  //         {
  //           'floor': "7F",
  //           "floors": [
  //             {'room': '701'},
  //             {'room': '702'},
  //             {'room': '703'},
  //             {'room': '704'},
  //             {'room': '705'},
  //             {'room': '706'}
  //           ]
  //         },
  //         {
  //           'floor': "8F",
  //           "floors": [
  //             {'room': '801'},
  //             {'room': '802'},
  //             {'room': '803'},
  //             {'room': '804'},
  //             {'room': '805'},
  //             {'room': '806'},
  //             {'room': '807'},
  //             {'room': '808'},
  //             {'room': '809'},
  //             {'room': '810'},
  //             {'room': '811'},
  //             {'room': '812'}
  //           ]
  //         },
  //       ]
  //     },
  //     {
  //       'unit': '三单元',
  //       'units': [
  //         {
  //           'floor': "1F",
  //           "floors": [
  //             {'room': '101'},
  //             {'room': '102'},
  //             {'room': '103'},
  //             {'room': '104'},
  //             {'room': '105'},
  //             {'room': '106'}
  //           ]
  //         },
  //         {
  //           'floor': "2F",
  //           "floors": [
  //             {'room': '201'},
  //             {'room': '202'},
  //             {'room': '203'},
  //             {'room': '204'},
  //             {'room': '205'},
  //             {'room': '206'},
  //             {'room': '207'},
  //             {'room': '208'},
  //             {'room': '209'},
  //             {'room': '210'},
  //             {'room': '211'},
  //             {'room': '212'}
  //           ]
  //         },
  //         {
  //           'floor': "3F",
  //           "floors": [
  //             {'room': '301'},
  //             {'room': '302'},
  //             {'room': '303'},
  //             {'room': '304'},
  //             {'room': '305'},
  //             {'room': '306'}
  //           ]
  //         },
  //         {
  //           'floor': "4F",
  //           "floors": [
  //             {'room': '401'},
  //             {'room': '402'},
  //             {'room': '403'},
  //             {'room': '404'},
  //             {'room': '405'},
  //             {'room': '406'},
  //             {'room': '407'},
  //             {'room': '408'},
  //             {'room': '409'},
  //             {'room': '410'},
  //             {'room': '411'},
  //             {'room': '412'}
  //           ]
  //         },
  //         {
  //           'floor': "5F",
  //           "floors": [
  //             {'room': '501'},
  //             {'room': '502'},
  //             {'room': '503'},
  //             {'room': '504'},
  //             {'room': '505'},
  //             {'room': '506'}
  //           ]
  //         },
  //         {
  //           'floor': "6F",
  //           "floors": [
  //             {'room': '601'},
  //             {'room': '602'},
  //             {'room': '603'},
  //             {'room': '604'},
  //             {'room': '605'},
  //             {'room': '606'},
  //             {'room': '607'},
  //             {'room': '608'},
  //             {'room': '609'},
  //             {'room': '610'},
  //             {'room': '611'},
  //             {'room': '612'}
  //           ]
  //         },
  //         {
  //           'floor': "7F",
  //           "floors": [
  //             {'room': '701'},
  //             {'room': '702'},
  //             {'room': '703'},
  //             {'room': '704'},
  //             {'room': '705'},
  //             {'room': '706'}
  //           ]
  //         },
  //         {
  //           'floor': "8F",
  //           "floors": [
  //             {'room': '801'},
  //             {'room': '802'},
  //             {'room': '803'},
  //             {'room': '804'},
  //             {'room': '805'},
  //             {'room': '806'},
  //             {'room': '807'},
  //             {'room': '808'},
  //             {'room': '809'},
  //             {'room': '810'},
  //             {'room': '811'},
  //             {'room': '812'}
  //           ]
  //         },
  //       ]
  //     },
  //     {
  //       'unit': '四单元',
  //       'units': [
  //         {
  //           'floor': "1F",
  //           "floors": [
  //             {'room': '101'},
  //             {'room': '102'},
  //             {'room': '103'},
  //             {'room': '104'},
  //             {'room': '105'},
  //             {'room': '106'}
  //           ]
  //         },
  //         {
  //           'floor': "2F",
  //           "floors": [
  //             {'room': '201'},
  //             {'room': '202'},
  //             {'room': '203'},
  //             {'room': '204'},
  //             {'room': '205'},
  //             {'room': '206'},
  //             {'room': '207'},
  //             {'room': '208'},
  //             {'room': '209'},
  //             {'room': '210'},
  //             {'room': '211'},
  //             {'room': '212'}
  //           ]
  //         },
  //         {
  //           'floor': "3F",
  //           "floors": [
  //             {'room': '301'},
  //             {'room': '302'},
  //             {'room': '303'},
  //             {'room': '304'},
  //             {'room': '305'},
  //             {'room': '306'}
  //           ]
  //         },
  //         {
  //           'floor': "4F",
  //           "floors": [
  //             {'room': '401'},
  //             {'room': '402'},
  //             {'room': '403'},
  //             {'room': '404'},
  //             {'room': '405'},
  //             {'room': '406'},
  //             {'room': '407'},
  //             {'room': '408'},
  //             {'room': '409'},
  //             {'room': '410'},
  //             {'room': '411'},
  //             {'room': '412'}
  //           ]
  //         },
  //         {
  //           'floor': "5F",
  //           "floors": [
  //             {'room': '501'},
  //             {'room': '502'},
  //             {'room': '503'},
  //             {'room': '504'},
  //             {'room': '505'},
  //             {'room': '506'}
  //           ]
  //         },
  //         {
  //           'floor': "6F",
  //           "floors": [
  //             {'room': '601'},
  //             {'room': '602'},
  //             {'room': '603'},
  //             {'room': '604'},
  //             {'room': '605'},
  //             {'room': '606'},
  //             {'room': '607'},
  //             {'room': '608'},
  //             {'room': '609'},
  //             {'room': '610'},
  //             {'room': '611'},
  //             {'room': '612'}
  //           ]
  //         },
  //         {
  //           'floor': "7F",
  //           "floors": [
  //             {'room': '701'},
  //             {'room': '702'},
  //             {'room': '703'},
  //             {'room': '704'},
  //             {'room': '705'},
  //             {'room': '706'}
  //           ]
  //         },
  //         {
  //           'floor': "8F",
  //           "floors": [
  //             {'room': '801'},
  //             {'room': '802'},
  //             {'room': '803'},
  //             {'room': '804'},
  //             {'room': '805'},
  //             {'room': '806'},
  //             {'room': '807'},
  //             {'room': '808'},
  //             {'room': '809'},
  //             {'room': '810'},
  //             {'room': '811'},
  //             {'room': '812'}
  //           ]
  //         },
  //       ]
  //     }
  //   ],
  // },
  // {
  //   'houseName': '9栋',
  //   'houseId': '9',
  //   'building': [
  //     {
  //       'unit': '一单元',
  //       'units': [
  //         {
  //           'floor': "1F",
  //           "floors": [
  //             {'room': '101'},
  //             {'room': '102'},
  //             {'room': '103'},
  //             {'room': '104'},
  //             {'room': '105'},
  //             {'room': '106'}
  //           ]
  //         },
  //         {
  //           'floor': "2F",
  //           "floors": [
  //             {'room': '201'},
  //             {'room': '202'},
  //             {'room': '203'},
  //             {'room': '204'},
  //             {'room': '205'},
  //             {'room': '206'},
  //             {'room': '207'},
  //             {'room': '208'},
  //             {'room': '209'},
  //             {'room': '210'},
  //             {'room': '211'},
  //             {'room': '212'}
  //           ]
  //         },
  //         {
  //           'floor': "3F",
  //           "floors": [
  //             {'room': '301'},
  //             {'room': '302'},
  //             {'room': '303'},
  //             {'room': '304'},
  //             {'room': '305'},
  //             {'room': '306'}
  //           ]
  //         },
  //         {
  //           'floor': "4F",
  //           "floors": [
  //             {'room': '401'},
  //             {'room': '402'},
  //             {'room': '403'},
  //             {'room': '404'},
  //             {'room': '405'},
  //             {'room': '406'},
  //             {'room': '407'},
  //             {'room': '408'},
  //             {'room': '409'},
  //             {'room': '410'},
  //             {'room': '411'},
  //             {'room': '412'}
  //           ]
  //         },
  //         {
  //           'floor': "5F",
  //           "floors": [
  //             {'room': '501'},
  //             {'room': '502'},
  //             {'room': '503'},
  //             {'room': '504'},
  //             {'room': '505'},
  //             {'room': '506'}
  //           ]
  //         },
  //         {
  //           'floor': "6F",
  //           "floors": [
  //             {'room': '601'},
  //             {'room': '602'},
  //             {'room': '603'},
  //             {'room': '604'},
  //             {'room': '605'},
  //             {'room': '606'},
  //             {'room': '607'},
  //             {'room': '608'},
  //             {'room': '609'},
  //             {'room': '610'},
  //             {'room': '611'},
  //             {'room': '612'}
  //           ]
  //         },
  //         {
  //           'floor': "7F",
  //           "floors": [
  //             {'room': '701'},
  //             {'room': '702'},
  //             {'room': '703'},
  //             {'room': '704'},
  //             {'room': '705'},
  //             {'room': '706'}
  //           ]
  //         },
  //         {
  //           'floor': "8F",
  //           "floors": [
  //             {'room': '801'},
  //             {'room': '802'},
  //             {'room': '803'},
  //             {'room': '804'},
  //             {'room': '805'},
  //             {'room': '806'},
  //             {'room': '807'},
  //             {'room': '808'},
  //             {'room': '809'},
  //             {'room': '810'},
  //             {'room': '811'},
  //             {'room': '812'}
  //           ]
  //         },
  //       ]
  //     },
  //     {
  //       'unit': '二单元',
  //       'units': [
  //         {
  //           'floor': "1F",
  //           "floors": [
  //             {'room': '101'},
  //             {'room': '102'},
  //             {'room': '103'},
  //             {'room': '104'},
  //             {'room': '105'},
  //             {'room': '106'}
  //           ]
  //         },
  //         {
  //           'floor': "2F",
  //           "floors": [
  //             {'room': '201'},
  //             {'room': '202'},
  //             {'room': '203'},
  //             {'room': '204'},
  //             {'room': '205'},
  //             {'room': '206'},
  //             {'room': '207'},
  //             {'room': '208'},
  //             {'room': '209'},
  //             {'room': '210'},
  //             {'room': '211'},
  //             {'room': '212'}
  //           ]
  //         },
  //         {
  //           'floor': "3F",
  //           "floors": [
  //             {'room': '301'},
  //             {'room': '302'},
  //             {'room': '303'},
  //             {'room': '304'},
  //             {'room': '305'},
  //             {'room': '306'}
  //           ]
  //         },
  //         {
  //           'floor': "4F",
  //           "floors": [
  //             {'room': '401'},
  //             {'room': '402'},
  //             {'room': '403'},
  //             {'room': '404'},
  //             {'room': '405'},
  //             {'room': '406'},
  //             {'room': '407'},
  //             {'room': '408'},
  //             {'room': '409'},
  //             {'room': '410'},
  //             {'room': '411'},
  //             {'room': '412'}
  //           ]
  //         },
  //         {
  //           'floor': "5F",
  //           "floors": [
  //             {'room': '501'},
  //             {'room': '502'},
  //             {'room': '503'},
  //             {'room': '504'},
  //             {'room': '505'},
  //             {'room': '506'}
  //           ]
  //         },
  //         {
  //           'floor': "6F",
  //           "floors": [
  //             {'room': '601'},
  //             {'room': '602'},
  //             {'room': '603'},
  //             {'room': '604'},
  //             {'room': '605'},
  //             {'room': '606'},
  //             {'room': '607'},
  //             {'room': '608'},
  //             {'room': '609'},
  //             {'room': '610'},
  //             {'room': '611'},
  //             {'room': '612'}
  //           ]
  //         },
  //         {
  //           'floor': "7F",
  //           "floors": [
  //             {'room': '701'},
  //             {'room': '702'},
  //             {'room': '703'},
  //             {'room': '704'},
  //             {'room': '705'},
  //             {'room': '706'}
  //           ]
  //         },
  //         {
  //           'floor': "8F",
  //           "floors": [
  //             {'room': '801'},
  //             {'room': '802'},
  //             {'room': '803'},
  //             {'room': '804'},
  //             {'room': '805'},
  //             {'room': '806'},
  //             {'room': '807'},
  //             {'room': '808'},
  //             {'room': '809'},
  //             {'room': '810'},
  //             {'room': '811'},
  //             {'room': '812'}
  //           ]
  //         },
  //       ]
  //     },
  //     {
  //       'unit': '三单元',
  //       'units': [
  //         {
  //           'floor': "1F",
  //           "floors": [
  //             {'room': '101'},
  //             {'room': '102'},
  //             {'room': '103'},
  //             {'room': '104'},
  //             {'room': '105'},
  //             {'room': '106'}
  //           ]
  //         },
  //         {
  //           'floor': "2F",
  //           "floors": [
  //             {'room': '201'},
  //             {'room': '202'},
  //             {'room': '203'},
  //             {'room': '204'},
  //             {'room': '205'},
  //             {'room': '206'},
  //             {'room': '207'},
  //             {'room': '208'},
  //             {'room': '209'},
  //             {'room': '210'},
  //             {'room': '211'},
  //             {'room': '212'}
  //           ]
  //         },
  //         {
  //           'floor': "3F",
  //           "floors": [
  //             {'room': '301'},
  //             {'room': '302'},
  //             {'room': '303'},
  //             {'room': '304'},
  //             {'room': '305'},
  //             {'room': '306'}
  //           ]
  //         },
  //         {
  //           'floor': "4F",
  //           "floors": [
  //             {'room': '401'},
  //             {'room': '402'},
  //             {'room': '403'},
  //             {'room': '404'},
  //             {'room': '405'},
  //             {'room': '406'},
  //             {'room': '407'},
  //             {'room': '408'},
  //             {'room': '409'},
  //             {'room': '410'},
  //             {'room': '411'},
  //             {'room': '412'}
  //           ]
  //         },
  //         {
  //           'floor': "5F",
  //           "floors": [
  //             {'room': '501'},
  //             {'room': '502'},
  //             {'room': '503'},
  //             {'room': '504'},
  //             {'room': '505'},
  //             {'room': '506'}
  //           ]
  //         },
  //         {
  //           'floor': "6F",
  //           "floors": [
  //             {'room': '601'},
  //             {'room': '602'},
  //             {'room': '603'},
  //             {'room': '604'},
  //             {'room': '605'},
  //             {'room': '606'},
  //             {'room': '607'},
  //             {'room': '608'},
  //             {'room': '609'},
  //             {'room': '610'},
  //             {'room': '611'},
  //             {'room': '612'}
  //           ]
  //         },
  //         {
  //           'floor': "7F",
  //           "floors": [
  //             {'room': '701'},
  //             {'room': '702'},
  //             {'room': '703'},
  //             {'room': '704'},
  //             {'room': '705'},
  //             {'room': '706'}
  //           ]
  //         },
  //         {
  //           'floor': "8F",
  //           "floors": [
  //             {'room': '801'},
  //             {'room': '802'},
  //             {'room': '803'},
  //             {'room': '804'},
  //             {'room': '805'},
  //             {'room': '806'},
  //             {'room': '807'},
  //             {'room': '808'},
  //             {'room': '809'},
  //             {'room': '810'},
  //             {'room': '811'},
  //             {'room': '812'}
  //           ]
  //         },
  //       ]
  //     },
  //     {
  //       'unit': '四单元',
  //       'units': [
  //         {
  //           'floor': "1F",
  //           "floors": [
  //             {'room': '101'},
  //             {'room': '102'},
  //             {'room': '103'},
  //             {'room': '104'},
  //             {'room': '105'},
  //             {'room': '106'}
  //           ]
  //         },
  //         {
  //           'floor': "2F",
  //           "floors": [
  //             {'room': '201'},
  //             {'room': '202'},
  //             {'room': '203'},
  //             {'room': '204'},
  //             {'room': '205'},
  //             {'room': '206'},
  //             {'room': '207'},
  //             {'room': '208'},
  //             {'room': '209'},
  //             {'room': '210'},
  //             {'room': '211'},
  //             {'room': '212'}
  //           ]
  //         },
  //         {
  //           'floor': "3F",
  //           "floors": [
  //             {'room': '301'},
  //             {'room': '302'},
  //             {'room': '303'},
  //             {'room': '304'},
  //             {'room': '305'},
  //             {'room': '306'}
  //           ]
  //         },
  //         {
  //           'floor': "4F",
  //           "floors": [
  //             {'room': '401'},
  //             {'room': '402'},
  //             {'room': '403'},
  //             {'room': '404'},
  //             {'room': '405'},
  //             {'room': '406'},
  //             {'room': '407'},
  //             {'room': '408'},
  //             {'room': '409'},
  //             {'room': '410'},
  //             {'room': '411'},
  //             {'room': '412'}
  //           ]
  //         },
  //         {
  //           'floor': "5F",
  //           "floors": [
  //             {'room': '501'},
  //             {'room': '502'},
  //             {'room': '503'},
  //             {'room': '504'},
  //             {'room': '505'},
  //             {'room': '506'}
  //           ]
  //         },
  //         {
  //           'floor': "6F",
  //           "floors": [
  //             {'room': '601'},
  //             {'room': '602'},
  //             {'room': '603'},
  //             {'room': '604'},
  //             {'room': '605'},
  //             {'room': '606'},
  //             {'room': '607'},
  //             {'room': '608'},
  //             {'room': '609'},
  //             {'room': '610'},
  //             {'room': '611'},
  //             {'room': '612'}
  //           ]
  //         },
  //         {
  //           'floor': "7F",
  //           "floors": [
  //             {'room': '701'},
  //             {'room': '702'},
  //             {'room': '703'},
  //             {'room': '704'},
  //             {'room': '705'},
  //             {'room': '706'}
  //           ]
  //         },
  //         {
  //           'floor': "8F",
  //           "floors": [
  //             {'room': '801'},
  //             {'room': '802'},
  //             {'room': '803'},
  //             {'room': '804'},
  //             {'room': '805'},
  //             {'room': '806'},
  //             {'room': '807'},
  //             {'room': '808'},
  //             {'room': '809'},
  //             {'room': '810'},
  //             {'room': '811'},
  //             {'room': '812'}
  //           ]
  //         },
  //       ]
  //     }
  //   ],
  // },
  // {
  //   'houseName': '10栋',
  //   'houseId': '10',
  //   'building': [
  //     {
  //       'unit': '一单元',
  //       'units': [
  //         {
  //           'floor': "1F",
  //           "floors": [
  //             {'room': '101'},
  //             {'room': '102'},
  //             {'room': '103'},
  //             {'room': '104'},
  //             {'room': '105'},
  //             {'room': '106'}
  //           ]
  //         },
  //         {
  //           'floor': "2F",
  //           "floors": [
  //             {'room': '201'},
  //             {'room': '202'},
  //             {'room': '203'},
  //             {'room': '204'},
  //             {'room': '205'},
  //             {'room': '206'},
  //             {'room': '207'},
  //             {'room': '208'},
  //             {'room': '209'},
  //             {'room': '210'},
  //             {'room': '211'},
  //             {'room': '212'}
  //           ]
  //         },
  //         {
  //           'floor': "3F",
  //           "floors": [
  //             {'room': '301'},
  //             {'room': '302'},
  //             {'room': '303'},
  //             {'room': '304'},
  //             {'room': '305'},
  //             {'room': '306'}
  //           ]
  //         },
  //         {
  //           'floor': "4F",
  //           "floors": [
  //             {'room': '401'},
  //             {'room': '402'},
  //             {'room': '403'},
  //             {'room': '404'},
  //             {'room': '405'},
  //             {'room': '406'},
  //             {'room': '407'},
  //             {'room': '408'},
  //             {'room': '409'},
  //             {'room': '410'},
  //             {'room': '411'},
  //             {'room': '412'}
  //           ]
  //         },
  //         {
  //           'floor': "5F",
  //           "floors": [
  //             {'room': '501'},
  //             {'room': '502'},
  //             {'room': '503'},
  //             {'room': '504'},
  //             {'room': '505'},
  //             {'room': '506'}
  //           ]
  //         },
  //         {
  //           'floor': "6F",
  //           "floors": [
  //             {'room': '601'},
  //             {'room': '602'},
  //             {'room': '603'},
  //             {'room': '604'},
  //             {'room': '605'},
  //             {'room': '606'},
  //             {'room': '607'},
  //             {'room': '608'},
  //             {'room': '609'},
  //             {'room': '610'},
  //             {'room': '611'},
  //             {'room': '612'}
  //           ]
  //         },
  //         {
  //           'floor': "7F",
  //           "floors": [
  //             {'room': '701'},
  //             {'room': '702'},
  //             {'room': '703'},
  //             {'room': '704'},
  //             {'room': '705'},
  //             {'room': '706'}
  //           ]
  //         },
  //         {
  //           'floor': "8F",
  //           "floors": [
  //             {'room': '801'},
  //             {'room': '802'},
  //             {'room': '803'},
  //             {'room': '804'},
  //             {'room': '805'},
  //             {'room': '806'},
  //             {'room': '807'},
  //             {'room': '808'},
  //             {'room': '809'},
  //             {'room': '810'},
  //             {'room': '811'},
  //             {'room': '812'}
  //           ]
  //         },
  //       ]
  //     },
  //     {
  //       'unit': '二单元',
  //       'units': [
  //         {
  //           'floor': "1F",
  //           "floors": [
  //             {'room': '101'},
  //             {'room': '102'},
  //             {'room': '103'},
  //             {'room': '104'},
  //             {'room': '105'},
  //             {'room': '106'}
  //           ]
  //         },
  //         {
  //           'floor': "2F",
  //           "floors": [
  //             {'room': '201'},
  //             {'room': '202'},
  //             {'room': '203'},
  //             {'room': '204'},
  //             {'room': '205'},
  //             {'room': '206'},
  //             {'room': '207'},
  //             {'room': '208'},
  //             {'room': '209'},
  //             {'room': '210'},
  //             {'room': '211'},
  //             {'room': '212'}
  //           ]
  //         },
  //         {
  //           'floor': "3F",
  //           "floors": [
  //             {'room': '301'},
  //             {'room': '302'},
  //             {'room': '303'},
  //             {'room': '304'},
  //             {'room': '305'},
  //             {'room': '306'}
  //           ]
  //         },
  //         {
  //           'floor': "4F",
  //           "floors": [
  //             {'room': '401'},
  //             {'room': '402'},
  //             {'room': '403'},
  //             {'room': '404'},
  //             {'room': '405'},
  //             {'room': '406'},
  //             {'room': '407'},
  //             {'room': '408'},
  //             {'room': '409'},
  //             {'room': '410'},
  //             {'room': '411'},
  //             {'room': '412'}
  //           ]
  //         },
  //         {
  //           'floor': "5F",
  //           "floors": [
  //             {'room': '501'},
  //             {'room': '502'},
  //             {'room': '503'},
  //             {'room': '504'},
  //             {'room': '505'},
  //             {'room': '506'}
  //           ]
  //         },
  //         {
  //           'floor': "6F",
  //           "floors": [
  //             {'room': '601'},
  //             {'room': '602'},
  //             {'room': '603'},
  //             {'room': '604'},
  //             {'room': '605'},
  //             {'room': '606'},
  //             {'room': '607'},
  //             {'room': '608'},
  //             {'room': '609'},
  //             {'room': '610'},
  //             {'room': '611'},
  //             {'room': '612'}
  //           ]
  //         },
  //         {
  //           'floor': "7F",
  //           "floors": [
  //             {'room': '701'},
  //             {'room': '702'},
  //             {'room': '703'},
  //             {'room': '704'},
  //             {'room': '705'},
  //             {'room': '706'}
  //           ]
  //         },
  //         {
  //           'floor': "8F",
  //           "floors": [
  //             {'room': '801'},
  //             {'room': '802'},
  //             {'room': '803'},
  //             {'room': '804'},
  //             {'room': '805'},
  //             {'room': '806'},
  //             {'room': '807'},
  //             {'room': '808'},
  //             {'room': '809'},
  //             {'room': '810'},
  //             {'room': '811'},
  //             {'room': '812'}
  //           ]
  //         },
  //       ]
  //     },
  //     {
  //       'unit': '三单元',
  //       'units': [
  //         {
  //           'floor': "1F",
  //           "floors": [
  //             {'room': '101'},
  //             {'room': '102'},
  //             {'room': '103'},
  //             {'room': '104'},
  //             {'room': '105'},
  //             {'room': '106'}
  //           ]
  //         },
  //         {
  //           'floor': "2F",
  //           "floors": [
  //             {'room': '201'},
  //             {'room': '202'},
  //             {'room': '203'},
  //             {'room': '204'},
  //             {'room': '205'},
  //             {'room': '206'},
  //             {'room': '207'},
  //             {'room': '208'},
  //             {'room': '209'},
  //             {'room': '210'},
  //             {'room': '211'},
  //             {'room': '212'}
  //           ]
  //         },
  //         {
  //           'floor': "3F",
  //           "floors": [
  //             {'room': '301'},
  //             {'room': '302'},
  //             {'room': '303'},
  //             {'room': '304'},
  //             {'room': '305'},
  //             {'room': '306'}
  //           ]
  //         },
  //         {
  //           'floor': "4F",
  //           "floors": [
  //             {'room': '401'},
  //             {'room': '402'},
  //             {'room': '403'},
  //             {'room': '404'},
  //             {'room': '405'},
  //             {'room': '406'},
  //             {'room': '407'},
  //             {'room': '408'},
  //             {'room': '409'},
  //             {'room': '410'},
  //             {'room': '411'},
  //             {'room': '412'}
  //           ]
  //         },
  //         {
  //           'floor': "5F",
  //           "floors": [
  //             {'room': '501'},
  //             {'room': '502'},
  //             {'room': '503'},
  //             {'room': '504'},
  //             {'room': '505'},
  //             {'room': '506'}
  //           ]
  //         },
  //         {
  //           'floor': "6F",
  //           "floors": [
  //             {'room': '601'},
  //             {'room': '602'},
  //             {'room': '603'},
  //             {'room': '604'},
  //             {'room': '605'},
  //             {'room': '606'},
  //             {'room': '607'},
  //             {'room': '608'},
  //             {'room': '609'},
  //             {'room': '610'},
  //             {'room': '611'},
  //             {'room': '612'}
  //           ]
  //         },
  //         {
  //           'floor': "7F",
  //           "floors": [
  //             {'room': '701'},
  //             {'room': '702'},
  //             {'room': '703'},
  //             {'room': '704'},
  //             {'room': '705'},
  //             {'room': '706'}
  //           ]
  //         },
  //         {
  //           'floor': "8F",
  //           "floors": [
  //             {'room': '801'},
  //             {'room': '802'},
  //             {'room': '803'},
  //             {'room': '804'},
  //             {'room': '805'},
  //             {'room': '806'},
  //             {'room': '807'},
  //             {'room': '808'},
  //             {'room': '809'},
  //             {'room': '810'},
  //             {'room': '811'},
  //             {'room': '812'}
  //           ]
  //         },
  //       ]
  //     },
  //     {
  //       'unit': '四单元',
  //       'units': [
  //         {
  //           'floor': "1F",
  //           "floors": [
  //             {'room': '101'},
  //             {'room': '102'},
  //             {'room': '103'},
  //             {'room': '104'},
  //             {'room': '105'},
  //             {'room': '106'}
  //           ]
  //         },
  //         {
  //           'floor': "2F",
  //           "floors": [
  //             {'room': '201'},
  //             {'room': '202'},
  //             {'room': '203'},
  //             {'room': '204'},
  //             {'room': '205'},
  //             {'room': '206'},
  //             {'room': '207'},
  //             {'room': '208'},
  //             {'room': '209'},
  //             {'room': '210'},
  //             {'room': '211'},
  //             {'room': '212'}
  //           ]
  //         },
  //         {
  //           'floor': "3F",
  //           "floors": [
  //             {'room': '301'},
  //             {'room': '302'},
  //             {'room': '303'},
  //             {'room': '304'},
  //             {'room': '305'},
  //             {'room': '306'}
  //           ]
  //         },
  //         {
  //           'floor': "4F",
  //           "floors": [
  //             {'room': '401'},
  //             {'room': '402'},
  //             {'room': '403'},
  //             {'room': '404'},
  //             {'room': '405'},
  //             {'room': '406'},
  //             {'room': '407'},
  //             {'room': '408'},
  //             {'room': '409'},
  //             {'room': '410'},
  //             {'room': '411'},
  //             {'room': '412'}
  //           ]
  //         },
  //         {
  //           'floor': "5F",
  //           "floors": [
  //             {'room': '501'},
  //             {'room': '502'},
  //             {'room': '503'},
  //             {'room': '504'},
  //             {'room': '505'},
  //             {'room': '506'}
  //           ]
  //         },
  //         {
  //           'floor': "6F",
  //           "floors": [
  //             {'room': '601'},
  //             {'room': '602'},
  //             {'room': '603'},
  //             {'room': '604'},
  //             {'room': '605'},
  //             {'room': '606'},
  //             {'room': '607'},
  //             {'room': '608'},
  //             {'room': '609'},
  //             {'room': '610'},
  //             {'room': '611'},
  //             {'room': '612'}
  //           ]
  //         },
  //         {
  //           'floor': "7F",
  //           "floors": [
  //             {'room': '701'},
  //             {'room': '702'},
  //             {'room': '703'},
  //             {'room': '704'},
  //             {'room': '705'},
  //             {'room': '706'}
  //           ]
  //         },
  //         {
  //           'floor': "8F",
  //           "floors": [
  //             {'room': '801'},
  //             {'room': '802'},
  //             {'room': '803'},
  //             {'room': '804'},
  //             {'room': '805'},
  //             {'room': '806'},
  //             {'room': '807'},
  //             {'room': '808'},
  //             {'room': '809'},
  //             {'room': '810'},
  //             {'room': '811'},
  //             {'room': '812'}
  //           ]
  //         },
  //       ]
  //     }
  //   ],
  // },
  // {
  //   'houseName': '11栋',
  //   'houseId': '11',
  //   'building': [
  //     {
  //       'unit': '一单元',
  //       'units': [
  //         {
  //           'floor': "1F",
  //           "floors": [
  //             {'room': '101'},
  //             {'room': '102'},
  //             {'room': '103'},
  //             {'room': '104'},
  //             {'room': '105'},
  //             {'room': '106'}
  //           ]
  //         },
  //         {
  //           'floor': "2F",
  //           "floors": [
  //             {'room': '201'},
  //             {'room': '202'},
  //             {'room': '203'},
  //             {'room': '204'},
  //             {'room': '205'},
  //             {'room': '206'},
  //             {'room': '207'},
  //             {'room': '208'},
  //             {'room': '209'},
  //             {'room': '210'},
  //             {'room': '211'},
  //             {'room': '212'}
  //           ]
  //         },
  //         {
  //           'floor': "3F",
  //           "floors": [
  //             {'room': '301'},
  //             {'room': '302'},
  //             {'room': '303'},
  //             {'room': '304'},
  //             {'room': '305'},
  //             {'room': '306'}
  //           ]
  //         },
  //         {
  //           'floor': "4F",
  //           "floors": [
  //             {'room': '401'},
  //             {'room': '402'},
  //             {'room': '403'},
  //             {'room': '404'},
  //             {'room': '405'},
  //             {'room': '406'},
  //             {'room': '407'},
  //             {'room': '408'},
  //             {'room': '409'},
  //             {'room': '410'},
  //             {'room': '411'},
  //             {'room': '412'}
  //           ]
  //         },
  //         {
  //           'floor': "5F",
  //           "floors": [
  //             {'room': '501'},
  //             {'room': '502'},
  //             {'room': '503'},
  //             {'room': '504'},
  //             {'room': '505'},
  //             {'room': '506'}
  //           ]
  //         },
  //         {
  //           'floor': "6F",
  //           "floors": [
  //             {'room': '601'},
  //             {'room': '602'},
  //             {'room': '603'},
  //             {'room': '604'},
  //             {'room': '605'},
  //             {'room': '606'},
  //             {'room': '607'},
  //             {'room': '608'},
  //             {'room': '609'},
  //             {'room': '610'},
  //             {'room': '611'},
  //             {'room': '612'}
  //           ]
  //         },
  //         {
  //           'floor': "7F",
  //           "floors": [
  //             {'room': '701'},
  //             {'room': '702'},
  //             {'room': '703'},
  //             {'room': '704'},
  //             {'room': '705'},
  //             {'room': '706'}
  //           ]
  //         },
  //         {
  //           'floor': "8F",
  //           "floors": [
  //             {'room': '801'},
  //             {'room': '802'},
  //             {'room': '803'},
  //             {'room': '804'},
  //             {'room': '805'},
  //             {'room': '806'},
  //             {'room': '807'},
  //             {'room': '808'},
  //             {'room': '809'},
  //             {'room': '810'},
  //             {'room': '811'},
  //             {'room': '812'}
  //           ]
  //         },
  //       ]
  //     },
  //     {
  //       'unit': '二单元',
  //       'units': [
  //         {
  //           'floor': "1F",
  //           "floors": [
  //             {'room': '101'},
  //             {'room': '102'},
  //             {'room': '103'},
  //             {'room': '104'},
  //             {'room': '105'},
  //             {'room': '106'}
  //           ]
  //         },
  //         {
  //           'floor': "2F",
  //           "floors": [
  //             {'room': '201'},
  //             {'room': '202'},
  //             {'room': '203'},
  //             {'room': '204'},
  //             {'room': '205'},
  //             {'room': '206'},
  //             {'room': '207'},
  //             {'room': '208'},
  //             {'room': '209'},
  //             {'room': '210'},
  //             {'room': '211'},
  //             {'room': '212'}
  //           ]
  //         },
  //         {
  //           'floor': "3F",
  //           "floors": [
  //             {'room': '301'},
  //             {'room': '302'},
  //             {'room': '303'},
  //             {'room': '304'},
  //             {'room': '305'},
  //             {'room': '306'}
  //           ]
  //         },
  //         {
  //           'floor': "4F",
  //           "floors": [
  //             {'room': '401'},
  //             {'room': '402'},
  //             {'room': '403'},
  //             {'room': '404'},
  //             {'room': '405'},
  //             {'room': '406'},
  //             {'room': '407'},
  //             {'room': '408'},
  //             {'room': '409'},
  //             {'room': '410'},
  //             {'room': '411'},
  //             {'room': '412'}
  //           ]
  //         },
  //         {
  //           'floor': "5F",
  //           "floors": [
  //             {'room': '501'},
  //             {'room': '502'},
  //             {'room': '503'},
  //             {'room': '504'},
  //             {'room': '505'},
  //             {'room': '506'}
  //           ]
  //         },
  //         {
  //           'floor': "6F",
  //           "floors": [
  //             {'room': '601'},
  //             {'room': '602'},
  //             {'room': '603'},
  //             {'room': '604'},
  //             {'room': '605'},
  //             {'room': '606'},
  //             {'room': '607'},
  //             {'room': '608'},
  //             {'room': '609'},
  //             {'room': '610'},
  //             {'room': '611'},
  //             {'room': '612'}
  //           ]
  //         },
  //         {
  //           'floor': "7F",
  //           "floors": [
  //             {'room': '701'},
  //             {'room': '702'},
  //             {'room': '703'},
  //             {'room': '704'},
  //             {'room': '705'},
  //             {'room': '706'}
  //           ]
  //         },
  //         {
  //           'floor': "8F",
  //           "floors": [
  //             {'room': '801'},
  //             {'room': '802'},
  //             {'room': '803'},
  //             {'room': '804'},
  //             {'room': '805'},
  //             {'room': '806'},
  //             {'room': '807'},
  //             {'room': '808'},
  //             {'room': '809'},
  //             {'room': '810'},
  //             {'room': '811'},
  //             {'room': '812'}
  //           ]
  //         },
  //       ]
  //     },
  //     {
  //       'unit': '三单元',
  //       'units': [
  //         {
  //           'floor': "1F",
  //           "floors": [
  //             {'room': '101'},
  //             {'room': '102'},
  //             {'room': '103'},
  //             {'room': '104'},
  //             {'room': '105'},
  //             {'room': '106'}
  //           ]
  //         },
  //         {
  //           'floor': "2F",
  //           "floors": [
  //             {'room': '201'},
  //             {'room': '202'},
  //             {'room': '203'},
  //             {'room': '204'},
  //             {'room': '205'},
  //             {'room': '206'},
  //             {'room': '207'},
  //             {'room': '208'},
  //             {'room': '209'},
  //             {'room': '210'},
  //             {'room': '211'},
  //             {'room': '212'}
  //           ]
  //         },
  //         {
  //           'floor': "3F",
  //           "floors": [
  //             {'room': '301'},
  //             {'room': '302'},
  //             {'room': '303'},
  //             {'room': '304'},
  //             {'room': '305'},
  //             {'room': '306'}
  //           ]
  //         },
  //         {
  //           'floor': "4F",
  //           "floors": [
  //             {'room': '401'},
  //             {'room': '402'},
  //             {'room': '403'},
  //             {'room': '404'},
  //             {'room': '405'},
  //             {'room': '406'},
  //             {'room': '407'},
  //             {'room': '408'},
  //             {'room': '409'},
  //             {'room': '410'},
  //             {'room': '411'},
  //             {'room': '412'}
  //           ]
  //         },
  //         {
  //           'floor': "5F",
  //           "floors": [
  //             {'room': '501'},
  //             {'room': '502'},
  //             {'room': '503'},
  //             {'room': '504'},
  //             {'room': '505'},
  //             {'room': '506'}
  //           ]
  //         },
  //         {
  //           'floor': "6F",
  //           "floors": [
  //             {'room': '601'},
  //             {'room': '602'},
  //             {'room': '603'},
  //             {'room': '604'},
  //             {'room': '605'},
  //             {'room': '606'},
  //             {'room': '607'},
  //             {'room': '608'},
  //             {'room': '609'},
  //             {'room': '610'},
  //             {'room': '611'},
  //             {'room': '612'}
  //           ]
  //         },
  //         {
  //           'floor': "7F",
  //           "floors": [
  //             {'room': '701'},
  //             {'room': '702'},
  //             {'room': '703'},
  //             {'room': '704'},
  //             {'room': '705'},
  //             {'room': '706'}
  //           ]
  //         },
  //         {
  //           'floor': "8F",
  //           "floors": [
  //             {'room': '801'},
  //             {'room': '802'},
  //             {'room': '803'},
  //             {'room': '804'},
  //             {'room': '805'},
  //             {'room': '806'},
  //             {'room': '807'},
  //             {'room': '808'},
  //             {'room': '809'},
  //             {'room': '810'},
  //             {'room': '811'},
  //             {'room': '812'}
  //           ]
  //         },
  //       ]
  //     },
  //     {
  //       'unit': '四单元',
  //       'units': [
  //         {
  //           'floor': "1F",
  //           "floors": [
  //             {'room': '101'},
  //             {'room': '102'},
  //             {'room': '103'},
  //             {'room': '104'},
  //             {'room': '105'},
  //             {'room': '106'}
  //           ]
  //         },
  //         {
  //           'floor': "2F",
  //           "floors": [
  //             {'room': '201'},
  //             {'room': '202'},
  //             {'room': '203'},
  //             {'room': '204'},
  //             {'room': '205'},
  //             {'room': '206'},
  //             {'room': '207'},
  //             {'room': '208'},
  //             {'room': '209'},
  //             {'room': '210'},
  //             {'room': '211'},
  //             {'room': '212'}
  //           ]
  //         },
  //         {
  //           'floor': "3F",
  //           "floors": [
  //             {'room': '301'},
  //             {'room': '302'},
  //             {'room': '303'},
  //             {'room': '304'},
  //             {'room': '305'},
  //             {'room': '306'}
  //           ]
  //         },
  //         {
  //           'floor': "4F",
  //           "floors": [
  //             {'room': '401'},
  //             {'room': '402'},
  //             {'room': '403'},
  //             {'room': '404'},
  //             {'room': '405'},
  //             {'room': '406'},
  //             {'room': '407'},
  //             {'room': '408'},
  //             {'room': '409'},
  //             {'room': '410'},
  //             {'room': '411'},
  //             {'room': '412'}
  //           ]
  //         },
  //         {
  //           'floor': "5F",
  //           "floors": [
  //             {'room': '501'},
  //             {'room': '502'},
  //             {'room': '503'},
  //             {'room': '504'},
  //             {'room': '505'},
  //             {'room': '506'}
  //           ]
  //         },
  //         {
  //           'floor': "6F",
  //           "floors": [
  //             {'room': '601'},
  //             {'room': '602'},
  //             {'room': '603'},
  //             {'room': '604'},
  //             {'room': '605'},
  //             {'room': '606'},
  //             {'room': '607'},
  //             {'room': '608'},
  //             {'room': '609'},
  //             {'room': '610'},
  //             {'room': '611'},
  //             {'room': '612'}
  //           ]
  //         },
  //         {
  //           'floor': "7F",
  //           "floors": [
  //             {'room': '701'},
  //             {'room': '702'},
  //             {'room': '703'},
  //             {'room': '704'},
  //             {'room': '705'},
  //             {'room': '706'}
  //           ]
  //         },
  //         {
  //           'floor': "8F",
  //           "floors": [
  //             {'room': '801'},
  //             {'room': '802'},
  //             {'room': '803'},
  //             {'room': '804'},
  //             {'room': '805'},
  //             {'room': '806'},
  //             {'room': '807'},
  //             {'room': '808'},
  //             {'room': '809'},
  //             {'room': '810'},
  //             {'room': '811'},
  //             {'room': '812'}
  //           ]
  //         },
  //       ]
  //     }
  //   ],
  // },
  // {
  //   'houseName': '12栋',
  //   'houseId': '12',
  //   'building': [
  //     {
  //       'unit': '一单元',
  //       'units': [
  //         {
  //           'floor': "1F",
  //           "floors": [
  //             {'room': '101'},
  //             {'room': '102'},
  //             {'room': '103'},
  //             {'room': '104'},
  //             {'room': '105'},
  //             {'room': '106'}
  //           ]
  //         },
  //         {
  //           'floor': "2F",
  //           "floors": [
  //             {'room': '201'},
  //             {'room': '202'},
  //             {'room': '203'},
  //             {'room': '204'},
  //             {'room': '205'},
  //             {'room': '206'},
  //             {'room': '207'},
  //             {'room': '208'},
  //             {'room': '209'},
  //             {'room': '210'},
  //             {'room': '211'},
  //             {'room': '212'}
  //           ]
  //         },
  //         {
  //           'floor': "3F",
  //           "floors": [
  //             {'room': '301'},
  //             {'room': '302'},
  //             {'room': '303'},
  //             {'room': '304'},
  //             {'room': '305'},
  //             {'room': '306'}
  //           ]
  //         },
  //         {
  //           'floor': "4F",
  //           "floors": [
  //             {'room': '401'},
  //             {'room': '402'},
  //             {'room': '403'},
  //             {'room': '404'},
  //             {'room': '405'},
  //             {'room': '406'},
  //             {'room': '407'},
  //             {'room': '408'},
  //             {'room': '409'},
  //             {'room': '410'},
  //             {'room': '411'},
  //             {'room': '412'}
  //           ]
  //         },
  //         {
  //           'floor': "5F",
  //           "floors": [
  //             {'room': '501'},
  //             {'room': '502'},
  //             {'room': '503'},
  //             {'room': '504'},
  //             {'room': '505'},
  //             {'room': '506'}
  //           ]
  //         },
  //         {
  //           'floor': "6F",
  //           "floors": [
  //             {'room': '601'},
  //             {'room': '602'},
  //             {'room': '603'},
  //             {'room': '604'},
  //             {'room': '605'},
  //             {'room': '606'},
  //             {'room': '607'},
  //             {'room': '608'},
  //             {'room': '609'},
  //             {'room': '610'},
  //             {'room': '611'},
  //             {'room': '612'}
  //           ]
  //         },
  //         {
  //           'floor': "7F",
  //           "floors": [
  //             {'room': '701'},
  //             {'room': '702'},
  //             {'room': '703'},
  //             {'room': '704'},
  //             {'room': '705'},
  //             {'room': '706'}
  //           ]
  //         },
  //         {
  //           'floor': "8F",
  //           "floors": [
  //             {'room': '801'},
  //             {'room': '802'},
  //             {'room': '803'},
  //             {'room': '804'},
  //             {'room': '805'},
  //             {'room': '806'},
  //             {'room': '807'},
  //             {'room': '808'},
  //             {'room': '809'},
  //             {'room': '810'},
  //             {'room': '811'},
  //             {'room': '812'}
  //           ]
  //         },
  //       ]
  //     },
  //     {
  //       'unit': '二单元',
  //       'units': [
  //         {
  //           'floor': "1F",
  //           "floors": [
  //             {'room': '101'},
  //             {'room': '102'},
  //             {'room': '103'},
  //             {'room': '104'},
  //             {'room': '105'},
  //             {'room': '106'}
  //           ]
  //         },
  //         {
  //           'floor': "2F",
  //           "floors": [
  //             {'room': '201'},
  //             {'room': '202'},
  //             {'room': '203'},
  //             {'room': '204'},
  //             {'room': '205'},
  //             {'room': '206'},
  //             {'room': '207'},
  //             {'room': '208'},
  //             {'room': '209'},
  //             {'room': '210'},
  //             {'room': '211'},
  //             {'room': '212'}
  //           ]
  //         },
  //         {
  //           'floor': "3F",
  //           "floors": [
  //             {'room': '301'},
  //             {'room': '302'},
  //             {'room': '303'},
  //             {'room': '304'},
  //             {'room': '305'},
  //             {'room': '306'}
  //           ]
  //         },
  //         {
  //           'floor': "4F",
  //           "floors": [
  //             {'room': '401'},
  //             {'room': '402'},
  //             {'room': '403'},
  //             {'room': '404'},
  //             {'room': '405'},
  //             {'room': '406'},
  //             {'room': '407'},
  //             {'room': '408'},
  //             {'room': '409'},
  //             {'room': '410'},
  //             {'room': '411'},
  //             {'room': '412'}
  //           ]
  //         },
  //         {
  //           'floor': "5F",
  //           "floors": [
  //             {'room': '501'},
  //             {'room': '502'},
  //             {'room': '503'},
  //             {'room': '504'},
  //             {'room': '505'},
  //             {'room': '506'}
  //           ]
  //         },
  //         {
  //           'floor': "6F",
  //           "floors": [
  //             {'room': '601'},
  //             {'room': '602'},
  //             {'room': '603'},
  //             {'room': '604'},
  //             {'room': '605'},
  //             {'room': '606'},
  //             {'room': '607'},
  //             {'room': '608'},
  //             {'room': '609'},
  //             {'room': '610'},
  //             {'room': '611'},
  //             {'room': '612'}
  //           ]
  //         },
  //         {
  //           'floor': "7F",
  //           "floors": [
  //             {'room': '701'},
  //             {'room': '702'},
  //             {'room': '703'},
  //             {'room': '704'},
  //             {'room': '705'},
  //             {'room': '706'}
  //           ]
  //         },
  //         {
  //           'floor': "8F",
  //           "floors": [
  //             {'room': '801'},
  //             {'room': '802'},
  //             {'room': '803'},
  //             {'room': '804'},
  //             {'room': '805'},
  //             {'room': '806'},
  //             {'room': '807'},
  //             {'room': '808'},
  //             {'room': '809'},
  //             {'room': '810'},
  //             {'room': '811'},
  //             {'room': '812'}
  //           ]
  //         },
  //       ]
  //     },
  //     {
  //       'unit': '三单元',
  //       'units': [
  //         {
  //           'floor': "1F",
  //           "floors": [
  //             {'room': '101'},
  //             {'room': '102'},
  //             {'room': '103'},
  //             {'room': '104'},
  //             {'room': '105'},
  //             {'room': '106'}
  //           ]
  //         },
  //         {
  //           'floor': "2F",
  //           "floors": [
  //             {'room': '201'},
  //             {'room': '202'},
  //             {'room': '203'},
  //             {'room': '204'},
  //             {'room': '205'},
  //             {'room': '206'},
  //             {'room': '207'},
  //             {'room': '208'},
  //             {'room': '209'},
  //             {'room': '210'},
  //             {'room': '211'},
  //             {'room': '212'}
  //           ]
  //         },
  //         {
  //           'floor': "3F",
  //           "floors": [
  //             {'room': '301'},
  //             {'room': '302'},
  //             {'room': '303'},
  //             {'room': '304'},
  //             {'room': '305'},
  //             {'room': '306'}
  //           ]
  //         },
  //         {
  //           'floor': "4F",
  //           "floors": [
  //             {'room': '401'},
  //             {'room': '402'},
  //             {'room': '403'},
  //             {'room': '404'},
  //             {'room': '405'},
  //             {'room': '406'},
  //             {'room': '407'},
  //             {'room': '408'},
  //             {'room': '409'},
  //             {'room': '410'},
  //             {'room': '411'},
  //             {'room': '412'}
  //           ]
  //         },
  //         {
  //           'floor': "5F",
  //           "floors": [
  //             {'room': '501'},
  //             {'room': '502'},
  //             {'room': '503'},
  //             {'room': '504'},
  //             {'room': '505'},
  //             {'room': '506'}
  //           ]
  //         },
  //         {
  //           'floor': "6F",
  //           "floors": [
  //             {'room': '601'},
  //             {'room': '602'},
  //             {'room': '603'},
  //             {'room': '604'},
  //             {'room': '605'},
  //             {'room': '606'},
  //             {'room': '607'},
  //             {'room': '608'},
  //             {'room': '609'},
  //             {'room': '610'},
  //             {'room': '611'},
  //             {'room': '612'}
  //           ]
  //         },
  //         {
  //           'floor': "7F",
  //           "floors": [
  //             {'room': '701'},
  //             {'room': '702'},
  //             {'room': '703'},
  //             {'room': '704'},
  //             {'room': '705'},
  //             {'room': '706'}
  //           ]
  //         },
  //         {
  //           'floor': "8F",
  //           "floors": [
  //             {'room': '801'},
  //             {'room': '802'},
  //             {'room': '803'},
  //             {'room': '804'},
  //             {'room': '805'},
  //             {'room': '806'},
  //             {'room': '807'},
  //             {'room': '808'},
  //             {'room': '809'},
  //             {'room': '810'},
  //             {'room': '811'},
  //             {'room': '812'}
  //           ]
  //         },
  //       ]
  //     },
  //     {
  //       'unit': '四单元',
  //       'units': [
  //         {
  //           'floor': "1F",
  //           "floors": [
  //             {'room': '101'},
  //             {'room': '102'},
  //             {'room': '103'},
  //             {'room': '104'},
  //             {'room': '105'},
  //             {'room': '106'}
  //           ]
  //         },
  //         {
  //           'floor': "2F",
  //           "floors": [
  //             {'room': '201'},
  //             {'room': '202'},
  //             {'room': '203'},
  //             {'room': '204'},
  //             {'room': '205'},
  //             {'room': '206'},
  //             {'room': '207'},
  //             {'room': '208'},
  //             {'room': '209'},
  //             {'room': '210'},
  //             {'room': '211'},
  //             {'room': '212'}
  //           ]
  //         },
  //         {
  //           'floor': "3F",
  //           "floors": [
  //             {'room': '301'},
  //             {'room': '302'},
  //             {'room': '303'},
  //             {'room': '304'},
  //             {'room': '305'},
  //             {'room': '306'}
  //           ]
  //         },
  //         {
  //           'floor': "4F",
  //           "floors": [
  //             {'room': '401'},
  //             {'room': '402'},
  //             {'room': '403'},
  //             {'room': '404'},
  //             {'room': '405'},
  //             {'room': '406'},
  //             {'room': '407'},
  //             {'room': '408'},
  //             {'room': '409'},
  //             {'room': '410'},
  //             {'room': '411'},
  //             {'room': '412'}
  //           ]
  //         },
  //         {
  //           'floor': "5F",
  //           "floors": [
  //             {'room': '501'},
  //             {'room': '502'},
  //             {'room': '503'},
  //             {'room': '504'},
  //             {'room': '505'},
  //             {'room': '506'}
  //           ]
  //         },
  //         {
  //           'floor': "6F",
  //           "floors": [
  //             {'room': '601'},
  //             {'room': '602'},
  //             {'room': '603'},
  //             {'room': '604'},
  //             {'room': '605'},
  //             {'room': '606'},
  //             {'room': '607'},
  //             {'room': '608'},
  //             {'room': '609'},
  //             {'room': '610'},
  //             {'room': '611'},
  //             {'room': '612'}
  //           ]
  //         },
  //         {
  //           'floor': "7F",
  //           "floors": [
  //             {'room': '701'},
  //             {'room': '702'},
  //             {'room': '703'},
  //             {'room': '704'},
  //             {'room': '705'},
  //             {'room': '706'}
  //           ]
  //         },
  //         {
  //           'floor': "8F",
  //           "floors": [
  //             {'room': '801'},
  //             {'room': '802'},
  //             {'room': '803'},
  //             {'room': '804'},
  //             {'room': '805'},
  //             {'room': '806'},
  //             {'room': '807'},
  //             {'room': '808'},
  //             {'room': '809'},
  //             {'room': '810'},
  //             {'room': '811'},
  //             {'room': '812'}
  //           ]
  //         },
  //       ]
  //     }
  //   ],
  // },
  // {
  //   'houseName': '13栋',
  //   'houseId': '13',
  //   'building': [
  //     {
  //       'unit': '一单元',
  //       'units': [
  //         {
  //           'floor': "1F",
  //           "floors": [
  //             {'room': '101'},
  //             {'room': '102'},
  //             {'room': '103'},
  //             {'room': '104'},
  //             {'room': '105'},
  //             {'room': '106'}
  //           ]
  //         },
  //         {
  //           'floor': "2F",
  //           "floors": [
  //             {'room': '201'},
  //             {'room': '202'},
  //             {'room': '203'},
  //             {'room': '204'},
  //             {'room': '205'},
  //             {'room': '206'},
  //             {'room': '207'},
  //             {'room': '208'},
  //             {'room': '209'},
  //             {'room': '210'},
  //             {'room': '211'},
  //             {'room': '212'}
  //           ]
  //         },
  //         {
  //           'floor': "3F",
  //           "floors": [
  //             {'room': '301'},
  //             {'room': '302'},
  //             {'room': '303'},
  //             {'room': '304'},
  //             {'room': '305'},
  //             {'room': '306'}
  //           ]
  //         },
  //         {
  //           'floor': "4F",
  //           "floors": [
  //             {'room': '401'},
  //             {'room': '402'},
  //             {'room': '403'},
  //             {'room': '404'},
  //             {'room': '405'},
  //             {'room': '406'},
  //             {'room': '407'},
  //             {'room': '408'},
  //             {'room': '409'},
  //             {'room': '410'},
  //             {'room': '411'},
  //             {'room': '412'}
  //           ]
  //         },
  //         {
  //           'floor': "5F",
  //           "floors": [
  //             {'room': '501'},
  //             {'room': '502'},
  //             {'room': '503'},
  //             {'room': '504'},
  //             {'room': '505'},
  //             {'room': '506'}
  //           ]
  //         },
  //         {
  //           'floor': "6F",
  //           "floors": [
  //             {'room': '601'},
  //             {'room': '602'},
  //             {'room': '603'},
  //             {'room': '604'},
  //             {'room': '605'},
  //             {'room': '606'},
  //             {'room': '607'},
  //             {'room': '608'},
  //             {'room': '609'},
  //             {'room': '610'},
  //             {'room': '611'},
  //             {'room': '612'}
  //           ]
  //         },
  //         {
  //           'floor': "7F",
  //           "floors": [
  //             {'room': '701'},
  //             {'room': '702'},
  //             {'room': '703'},
  //             {'room': '704'},
  //             {'room': '705'},
  //             {'room': '706'}
  //           ]
  //         },
  //         {
  //           'floor': "8F",
  //           "floors": [
  //             {'room': '801'},
  //             {'room': '802'},
  //             {'room': '803'},
  //             {'room': '804'},
  //             {'room': '805'},
  //             {'room': '806'},
  //             {'room': '807'},
  //             {'room': '808'},
  //             {'room': '809'},
  //             {'room': '810'},
  //             {'room': '811'},
  //             {'room': '812'}
  //           ]
  //         },
  //       ]
  //     },
  //     {
  //       'unit': '二单元',
  //       'units': [
  //         {
  //           'floor': "1F",
  //           "floors": [
  //             {'room': '101'},
  //             {'room': '102'},
  //             {'room': '103'},
  //             {'room': '104'},
  //             {'room': '105'},
  //             {'room': '106'}
  //           ]
  //         },
  //         {
  //           'floor': "2F",
  //           "floors": [
  //             {'room': '201'},
  //             {'room': '202'},
  //             {'room': '203'},
  //             {'room': '204'},
  //             {'room': '205'},
  //             {'room': '206'},
  //             {'room': '207'},
  //             {'room': '208'},
  //             {'room': '209'},
  //             {'room': '210'},
  //             {'room': '211'},
  //             {'room': '212'}
  //           ]
  //         },
  //         {
  //           'floor': "3F",
  //           "floors": [
  //             {'room': '301'},
  //             {'room': '302'},
  //             {'room': '303'},
  //             {'room': '304'},
  //             {'room': '305'},
  //             {'room': '306'}
  //           ]
  //         },
  //         {
  //           'floor': "4F",
  //           "floors": [
  //             {'room': '401'},
  //             {'room': '402'},
  //             {'room': '403'},
  //             {'room': '404'},
  //             {'room': '405'},
  //             {'room': '406'},
  //             {'room': '407'},
  //             {'room': '408'},
  //             {'room': '409'},
  //             {'room': '410'},
  //             {'room': '411'},
  //             {'room': '412'}
  //           ]
  //         },
  //         {
  //           'floor': "5F",
  //           "floors": [
  //             {'room': '501'},
  //             {'room': '502'},
  //             {'room': '503'},
  //             {'room': '504'},
  //             {'room': '505'},
  //             {'room': '506'}
  //           ]
  //         },
  //         {
  //           'floor': "6F",
  //           "floors": [
  //             {'room': '601'},
  //             {'room': '602'},
  //             {'room': '603'},
  //             {'room': '604'},
  //             {'room': '605'},
  //             {'room': '606'},
  //             {'room': '607'},
  //             {'room': '608'},
  //             {'room': '609'},
  //             {'room': '610'},
  //             {'room': '611'},
  //             {'room': '612'}
  //           ]
  //         },
  //         {
  //           'floor': "7F",
  //           "floors": [
  //             {'room': '701'},
  //             {'room': '702'},
  //             {'room': '703'},
  //             {'room': '704'},
  //             {'room': '705'},
  //             {'room': '706'}
  //           ]
  //         },
  //         {
  //           'floor': "8F",
  //           "floors": [
  //             {'room': '801'},
  //             {'room': '802'},
  //             {'room': '803'},
  //             {'room': '804'},
  //             {'room': '805'},
  //             {'room': '806'},
  //             {'room': '807'},
  //             {'room': '808'},
  //             {'room': '809'},
  //             {'room': '810'},
  //             {'room': '811'},
  //             {'room': '812'}
  //           ]
  //         },
  //       ]
  //     },
  //     {
  //       'unit': '三单元',
  //       'units': [
  //         {
  //           'floor': "1F",
  //           "floors": [
  //             {'room': '101'},
  //             {'room': '102'},
  //             {'room': '103'},
  //             {'room': '104'},
  //             {'room': '105'},
  //             {'room': '106'}
  //           ]
  //         },
  //         {
  //           'floor': "2F",
  //           "floors": [
  //             {'room': '201'},
  //             {'room': '202'},
  //             {'room': '203'},
  //             {'room': '204'},
  //             {'room': '205'},
  //             {'room': '206'},
  //             {'room': '207'},
  //             {'room': '208'},
  //             {'room': '209'},
  //             {'room': '210'},
  //             {'room': '211'},
  //             {'room': '212'}
  //           ]
  //         },
  //         {
  //           'floor': "3F",
  //           "floors": [
  //             {'room': '301'},
  //             {'room': '302'},
  //             {'room': '303'},
  //             {'room': '304'},
  //             {'room': '305'},
  //             {'room': '306'}
  //           ]
  //         },
  //         {
  //           'floor': "4F",
  //           "floors": [
  //             {'room': '401'},
  //             {'room': '402'},
  //             {'room': '403'},
  //             {'room': '404'},
  //             {'room': '405'},
  //             {'room': '406'},
  //             {'room': '407'},
  //             {'room': '408'},
  //             {'room': '409'},
  //             {'room': '410'},
  //             {'room': '411'},
  //             {'room': '412'}
  //           ]
  //         },
  //         {
  //           'floor': "5F",
  //           "floors": [
  //             {'room': '501'},
  //             {'room': '502'},
  //             {'room': '503'},
  //             {'room': '504'},
  //             {'room': '505'},
  //             {'room': '506'}
  //           ]
  //         },
  //         {
  //           'floor': "6F",
  //           "floors": [
  //             {'room': '601'},
  //             {'room': '602'},
  //             {'room': '603'},
  //             {'room': '604'},
  //             {'room': '605'},
  //             {'room': '606'},
  //             {'room': '607'},
  //             {'room': '608'},
  //             {'room': '609'},
  //             {'room': '610'},
  //             {'room': '611'},
  //             {'room': '612'}
  //           ]
  //         },
  //         {
  //           'floor': "7F",
  //           "floors": [
  //             {'room': '701'},
  //             {'room': '702'},
  //             {'room': '703'},
  //             {'room': '704'},
  //             {'room': '705'},
  //             {'room': '706'}
  //           ]
  //         },
  //         {
  //           'floor': "8F",
  //           "floors": [
  //             {'room': '801'},
  //             {'room': '802'},
  //             {'room': '803'},
  //             {'room': '804'},
  //             {'room': '805'},
  //             {'room': '806'},
  //             {'room': '807'},
  //             {'room': '808'},
  //             {'room': '809'},
  //             {'room': '810'},
  //             {'room': '811'},
  //             {'room': '812'}
  //           ]
  //         },
  //       ]
  //     },
  //     {
  //       'unit': '四单元',
  //       'units': [
  //         {
  //           'floor': "1F",
  //           "floors": [
  //             {'room': '101'},
  //             {'room': '102'},
  //             {'room': '103'},
  //             {'room': '104'},
  //             {'room': '105'},
  //             {'room': '106'}
  //           ]
  //         },
  //         {
  //           'floor': "2F",
  //           "floors": [
  //             {'room': '201'},
  //             {'room': '202'},
  //             {'room': '203'},
  //             {'room': '204'},
  //             {'room': '205'},
  //             {'room': '206'},
  //             {'room': '207'},
  //             {'room': '208'},
  //             {'room': '209'},
  //             {'room': '210'},
  //             {'room': '211'},
  //             {'room': '212'}
  //           ]
  //         },
  //         {
  //           'floor': "3F",
  //           "floors": [
  //             {'room': '301'},
  //             {'room': '302'},
  //             {'room': '303'},
  //             {'room': '304'},
  //             {'room': '305'},
  //             {'room': '306'}
  //           ]
  //         },
  //         {
  //           'floor': "4F",
  //           "floors": [
  //             {'room': '401'},
  //             {'room': '402'},
  //             {'room': '403'},
  //             {'room': '404'},
  //             {'room': '405'},
  //             {'room': '406'},
  //             {'room': '407'},
  //             {'room': '408'},
  //             {'room': '409'},
  //             {'room': '410'},
  //             {'room': '411'},
  //             {'room': '412'}
  //           ]
  //         },
  //         {
  //           'floor': "5F",
  //           "floors": [
  //             {'room': '501'},
  //             {'room': '502'},
  //             {'room': '503'},
  //             {'room': '504'},
  //             {'room': '505'},
  //             {'room': '506'}
  //           ]
  //         },
  //         {
  //           'floor': "6F",
  //           "floors": [
  //             {'room': '601'},
  //             {'room': '602'},
  //             {'room': '603'},
  //             {'room': '604'},
  //             {'room': '605'},
  //             {'room': '606'},
  //             {'room': '607'},
  //             {'room': '608'},
  //             {'room': '609'},
  //             {'room': '610'},
  //             {'room': '611'},
  //             {'room': '612'}
  //           ]
  //         },
  //         {
  //           'floor': "7F",
  //           "floors": [
  //             {'room': '701'},
  //             {'room': '702'},
  //             {'room': '703'},
  //             {'room': '704'},
  //             {'room': '705'},
  //             {'room': '706'}
  //           ]
  //         },
  //         {
  //           'floor': "8F",
  //           "floors": [
  //             {'room': '801'},
  //             {'room': '802'},
  //             {'room': '803'},
  //             {'room': '804'},
  //             {'room': '805'},
  //             {'room': '806'},
  //             {'room': '807'},
  //             {'room': '808'},
  //             {'room': '809'},
  //             {'room': '810'},
  //             {'room': '811'},
  //             {'room': '812'}
  //           ]
  //         },
  //       ]
  //     }
  //   ],
  // },
  // {
  //   'houseName': '14栋',
  //   'houseId': '14',
  //   'building': [
  //     {
  //       'unit': '一单元',
  //       'units': [
  //         {
  //           'floor': "1F",
  //           "floors": [
  //             {'room': '101'},
  //             {'room': '102'},
  //             {'room': '103'},
  //             {'room': '104'},
  //             {'room': '105'},
  //             {'room': '106'}
  //           ]
  //         },
  //         {
  //           'floor': "2F",
  //           "floors": [
  //             {'room': '201'},
  //             {'room': '202'},
  //             {'room': '203'},
  //             {'room': '204'},
  //             {'room': '205'},
  //             {'room': '206'},
  //             {'room': '207'},
  //             {'room': '208'},
  //             {'room': '209'},
  //             {'room': '210'},
  //             {'room': '211'},
  //             {'room': '212'}
  //           ]
  //         },
  //         {
  //           'floor': "3F",
  //           "floors": [
  //             {'room': '301'},
  //             {'room': '302'},
  //             {'room': '303'},
  //             {'room': '304'},
  //             {'room': '305'},
  //             {'room': '306'}
  //           ]
  //         },
  //         {
  //           'floor': "4F",
  //           "floors": [
  //             {'room': '401'},
  //             {'room': '402'},
  //             {'room': '403'},
  //             {'room': '404'},
  //             {'room': '405'},
  //             {'room': '406'},
  //             {'room': '407'},
  //             {'room': '408'},
  //             {'room': '409'},
  //             {'room': '410'},
  //             {'room': '411'},
  //             {'room': '412'}
  //           ]
  //         },
  //         {
  //           'floor': "5F",
  //           "floors": [
  //             {'room': '501'},
  //             {'room': '502'},
  //             {'room': '503'},
  //             {'room': '504'},
  //             {'room': '505'},
  //             {'room': '506'}
  //           ]
  //         },
  //         {
  //           'floor': "6F",
  //           "floors": [
  //             {'room': '601'},
  //             {'room': '602'},
  //             {'room': '603'},
  //             {'room': '604'},
  //             {'room': '605'},
  //             {'room': '606'},
  //             {'room': '607'},
  //             {'room': '608'},
  //             {'room': '609'},
  //             {'room': '610'},
  //             {'room': '611'},
  //             {'room': '612'}
  //           ]
  //         },
  //         {
  //           'floor': "7F",
  //           "floors": [
  //             {'room': '701'},
  //             {'room': '702'},
  //             {'room': '703'},
  //             {'room': '704'},
  //             {'room': '705'},
  //             {'room': '706'}
  //           ]
  //         },
  //         {
  //           'floor': "8F",
  //           "floors": [
  //             {'room': '801'},
  //             {'room': '802'},
  //             {'room': '803'},
  //             {'room': '804'},
  //             {'room': '805'},
  //             {'room': '806'},
  //             {'room': '807'},
  //             {'room': '808'},
  //             {'room': '809'},
  //             {'room': '810'},
  //             {'room': '811'},
  //             {'room': '812'}
  //           ]
  //         },
  //       ]
  //     },
  //     {
  //       'unit': '二单元',
  //       'units': [
  //         {
  //           'floor': "1F",
  //           "floors": [
  //             {'room': '101'},
  //             {'room': '102'},
  //             {'room': '103'},
  //             {'room': '104'},
  //             {'room': '105'},
  //             {'room': '106'}
  //           ]
  //         },
  //         {
  //           'floor': "2F",
  //           "floors": [
  //             {'room': '201'},
  //             {'room': '202'},
  //             {'room': '203'},
  //             {'room': '204'},
  //             {'room': '205'},
  //             {'room': '206'},
  //             {'room': '207'},
  //             {'room': '208'},
  //             {'room': '209'},
  //             {'room': '210'},
  //             {'room': '211'},
  //             {'room': '212'}
  //           ]
  //         },
  //         {
  //           'floor': "3F",
  //           "floors": [
  //             {'room': '301'},
  //             {'room': '302'},
  //             {'room': '303'},
  //             {'room': '304'},
  //             {'room': '305'},
  //             {'room': '306'}
  //           ]
  //         },
  //         {
  //           'floor': "4F",
  //           "floors": [
  //             {'room': '401'},
  //             {'room': '402'},
  //             {'room': '403'},
  //             {'room': '404'},
  //             {'room': '405'},
  //             {'room': '406'},
  //             {'room': '407'},
  //             {'room': '408'},
  //             {'room': '409'},
  //             {'room': '410'},
  //             {'room': '411'},
  //             {'room': '412'}
  //           ]
  //         },
  //         {
  //           'floor': "5F",
  //           "floors": [
  //             {'room': '501'},
  //             {'room': '502'},
  //             {'room': '503'},
  //             {'room': '504'},
  //             {'room': '505'},
  //             {'room': '506'}
  //           ]
  //         },
  //         {
  //           'floor': "6F",
  //           "floors": [
  //             {'room': '601'},
  //             {'room': '602'},
  //             {'room': '603'},
  //             {'room': '604'},
  //             {'room': '605'},
  //             {'room': '606'},
  //             {'room': '607'},
  //             {'room': '608'},
  //             {'room': '609'},
  //             {'room': '610'},
  //             {'room': '611'},
  //             {'room': '612'}
  //           ]
  //         },
  //         {
  //           'floor': "7F",
  //           "floors": [
  //             {'room': '701'},
  //             {'room': '702'},
  //             {'room': '703'},
  //             {'room': '704'},
  //             {'room': '705'},
  //             {'room': '706'}
  //           ]
  //         },
  //         {
  //           'floor': "8F",
  //           "floors": [
  //             {'room': '801'},
  //             {'room': '802'},
  //             {'room': '803'},
  //             {'room': '804'},
  //             {'room': '805'},
  //             {'room': '806'},
  //             {'room': '807'},
  //             {'room': '808'},
  //             {'room': '809'},
  //             {'room': '810'},
  //             {'room': '811'},
  //             {'room': '812'}
  //           ]
  //         },
  //       ]
  //     },
  //     {
  //       'unit': '三单元',
  //       'units': [
  //         {
  //           'floor': "1F",
  //           "floors": [
  //             {'room': '101'},
  //             {'room': '102'},
  //             {'room': '103'},
  //             {'room': '104'},
  //             {'room': '105'},
  //             {'room': '106'}
  //           ]
  //         },
  //         {
  //           'floor': "2F",
  //           "floors": [
  //             {'room': '201'},
  //             {'room': '202'},
  //             {'room': '203'},
  //             {'room': '204'},
  //             {'room': '205'},
  //             {'room': '206'},
  //             {'room': '207'},
  //             {'room': '208'},
  //             {'room': '209'},
  //             {'room': '210'},
  //             {'room': '211'},
  //             {'room': '212'}
  //           ]
  //         },
  //         {
  //           'floor': "3F",
  //           "floors": [
  //             {'room': '301'},
  //             {'room': '302'},
  //             {'room': '303'},
  //             {'room': '304'},
  //             {'room': '305'},
  //             {'room': '306'}
  //           ]
  //         },
  //         {
  //           'floor': "4F",
  //           "floors": [
  //             {'room': '401'},
  //             {'room': '402'},
  //             {'room': '403'},
  //             {'room': '404'},
  //             {'room': '405'},
  //             {'room': '406'},
  //             {'room': '407'},
  //             {'room': '408'},
  //             {'room': '409'},
  //             {'room': '410'},
  //             {'room': '411'},
  //             {'room': '412'}
  //           ]
  //         },
  //         {
  //           'floor': "5F",
  //           "floors": [
  //             {'room': '501'},
  //             {'room': '502'},
  //             {'room': '503'},
  //             {'room': '504'},
  //             {'room': '505'},
  //             {'room': '506'}
  //           ]
  //         },
  //         {
  //           'floor': "6F",
  //           "floors": [
  //             {'room': '601'},
  //             {'room': '602'},
  //             {'room': '603'},
  //             {'room': '604'},
  //             {'room': '605'},
  //             {'room': '606'},
  //             {'room': '607'},
  //             {'room': '608'},
  //             {'room': '609'},
  //             {'room': '610'},
  //             {'room': '611'},
  //             {'room': '612'}
  //           ]
  //         },
  //         {
  //           'floor': "7F",
  //           "floors": [
  //             {'room': '701'},
  //             {'room': '702'},
  //             {'room': '703'},
  //             {'room': '704'},
  //             {'room': '705'},
  //             {'room': '706'}
  //           ]
  //         },
  //         {
  //           'floor': "8F",
  //           "floors": [
  //             {'room': '801'},
  //             {'room': '802'},
  //             {'room': '803'},
  //             {'room': '804'},
  //             {'room': '805'},
  //             {'room': '806'},
  //             {'room': '807'},
  //             {'room': '808'},
  //             {'room': '809'},
  //             {'room': '810'},
  //             {'room': '811'},
  //             {'room': '812'}
  //           ]
  //         },
  //       ]
  //     },
  //     {
  //       'unit': '四单元',
  //       'units': [
  //         {
  //           'floor': "1F",
  //           "floors": [
  //             {'room': '101'},
  //             {'room': '102'},
  //             {'room': '103'},
  //             {'room': '104'},
  //             {'room': '105'},
  //             {'room': '106'}
  //           ]
  //         },
  //         {
  //           'floor': "2F",
  //           "floors": [
  //             {'room': '201'},
  //             {'room': '202'},
  //             {'room': '203'},
  //             {'room': '204'},
  //             {'room': '205'},
  //             {'room': '206'},
  //             {'room': '207'},
  //             {'room': '208'},
  //             {'room': '209'},
  //             {'room': '210'},
  //             {'room': '211'},
  //             {'room': '212'}
  //           ]
  //         },
  //         {
  //           'floor': "3F",
  //           "floors": [
  //             {'room': '301'},
  //             {'room': '302'},
  //             {'room': '303'},
  //             {'room': '304'},
  //             {'room': '305'},
  //             {'room': '306'}
  //           ]
  //         },
  //         {
  //           'floor': "4F",
  //           "floors": [
  //             {'room': '401'},
  //             {'room': '402'},
  //             {'room': '403'},
  //             {'room': '404'},
  //             {'room': '405'},
  //             {'room': '406'},
  //             {'room': '407'},
  //             {'room': '408'},
  //             {'room': '409'},
  //             {'room': '410'},
  //             {'room': '411'},
  //             {'room': '412'}
  //           ]
  //         },
  //         {
  //           'floor': "5F",
  //           "floors": [
  //             {'room': '501'},
  //             {'room': '502'},
  //             {'room': '503'},
  //             {'room': '504'},
  //             {'room': '505'},
  //             {'room': '506'}
  //           ]
  //         },
  //         {
  //           'floor': "6F",
  //           "floors": [
  //             {'room': '601'},
  //             {'room': '602'},
  //             {'room': '603'},
  //             {'room': '604'},
  //             {'room': '605'},
  //             {'room': '606'},
  //             {'room': '607'},
  //             {'room': '608'},
  //             {'room': '609'},
  //             {'room': '610'},
  //             {'room': '611'},
  //             {'room': '612'}
  //           ]
  //         },
  //         {
  //           'floor': "7F",
  //           "floors": [
  //             {'room': '701'},
  //             {'room': '702'},
  //             {'room': '703'},
  //             {'room': '704'},
  //             {'room': '705'},
  //             {'room': '706'}
  //           ]
  //         },
  //         {
  //           'floor': "8F",
  //           "floors": [
  //             {'room': '801'},
  //             {'room': '802'},
  //             {'room': '803'},
  //             {'room': '804'},
  //             {'room': '805'},
  //             {'room': '806'},
  //             {'room': '807'},
  //             {'room': '808'},
  //             {'room': '809'},
  //             {'room': '810'},
  //             {'room': '811'},
  //             {'room': '812'}
  //           ]
  //         },
  //       ]
  //     }
  //   ],
  // },
  // {
  //   'houseName': '15栋',
  //   'houseId': '15',
  //   'building': [
  //     {
  //       'unit': '一单元',
  //       'units': [
  //         {
  //           'floor': "1F",
  //           "floors": [
  //             {'room': '101'},
  //             {'room': '102'},
  //             {'room': '103'},
  //             {'room': '104'},
  //             {'room': '105'},
  //             {'room': '106'}
  //           ]
  //         },
  //         {
  //           'floor': "2F",
  //           "floors": [
  //             {'room': '201'},
  //             {'room': '202'},
  //             {'room': '203'},
  //             {'room': '204'},
  //             {'room': '205'},
  //             {'room': '206'},
  //             {'room': '207'},
  //             {'room': '208'},
  //             {'room': '209'},
  //             {'room': '210'},
  //             {'room': '211'},
  //             {'room': '212'}
  //           ]
  //         },
  //         {
  //           'floor': "3F",
  //           "floors": [
  //             {'room': '301'},
  //             {'room': '302'},
  //             {'room': '303'},
  //             {'room': '304'},
  //             {'room': '305'},
  //             {'room': '306'}
  //           ]
  //         },
  //         {
  //           'floor': "4F",
  //           "floors": [
  //             {'room': '401'},
  //             {'room': '402'},
  //             {'room': '403'},
  //             {'room': '404'},
  //             {'room': '405'},
  //             {'room': '406'},
  //             {'room': '407'},
  //             {'room': '408'},
  //             {'room': '409'},
  //             {'room': '410'},
  //             {'room': '411'},
  //             {'room': '412'}
  //           ]
  //         },
  //         {
  //           'floor': "5F",
  //           "floors": [
  //             {'room': '501'},
  //             {'room': '502'},
  //             {'room': '503'},
  //             {'room': '504'},
  //             {'room': '505'},
  //             {'room': '506'}
  //           ]
  //         },
  //         {
  //           'floor': "6F",
  //           "floors": [
  //             {'room': '601'},
  //             {'room': '602'},
  //             {'room': '603'},
  //             {'room': '604'},
  //             {'room': '605'},
  //             {'room': '606'},
  //             {'room': '607'},
  //             {'room': '608'},
  //             {'room': '609'},
  //             {'room': '610'},
  //             {'room': '611'},
  //             {'room': '612'}
  //           ]
  //         },
  //         {
  //           'floor': "7F",
  //           "floors": [
  //             {'room': '701'},
  //             {'room': '702'},
  //             {'room': '703'},
  //             {'room': '704'},
  //             {'room': '705'},
  //             {'room': '706'}
  //           ]
  //         },
  //         {
  //           'floor': "8F",
  //           "floors": [
  //             {'room': '801'},
  //             {'room': '802'},
  //             {'room': '803'},
  //             {'room': '804'},
  //             {'room': '805'},
  //             {'room': '806'},
  //             {'room': '807'},
  //             {'room': '808'},
  //             {'room': '809'},
  //             {'room': '810'},
  //             {'room': '811'},
  //             {'room': '812'}
  //           ]
  //         },
  //       ]
  //     },
  //     {
  //       'unit': '二单元',
  //       'units': [
  //         {
  //           'floor': "1F",
  //           "floors": [
  //             {'room': '101'},
  //             {'room': '102'},
  //             {'room': '103'},
  //             {'room': '104'},
  //             {'room': '105'},
  //             {'room': '106'}
  //           ]
  //         },
  //         {
  //           'floor': "2F",
  //           "floors": [
  //             {'room': '201'},
  //             {'room': '202'},
  //             {'room': '203'},
  //             {'room': '204'},
  //             {'room': '205'},
  //             {'room': '206'},
  //             {'room': '207'},
  //             {'room': '208'},
  //             {'room': '209'},
  //             {'room': '210'},
  //             {'room': '211'},
  //             {'room': '212'}
  //           ]
  //         },
  //         {
  //           'floor': "3F",
  //           "floors": [
  //             {'room': '301'},
  //             {'room': '302'},
  //             {'room': '303'},
  //             {'room': '304'},
  //             {'room': '305'},
  //             {'room': '306'}
  //           ]
  //         },
  //         {
  //           'floor': "4F",
  //           "floors": [
  //             {'room': '401'},
  //             {'room': '402'},
  //             {'room': '403'},
  //             {'room': '404'},
  //             {'room': '405'},
  //             {'room': '406'},
  //             {'room': '407'},
  //             {'room': '408'},
  //             {'room': '409'},
  //             {'room': '410'},
  //             {'room': '411'},
  //             {'room': '412'}
  //           ]
  //         },
  //         {
  //           'floor': "5F",
  //           "floors": [
  //             {'room': '501'},
  //             {'room': '502'},
  //             {'room': '503'},
  //             {'room': '504'},
  //             {'room': '505'},
  //             {'room': '506'}
  //           ]
  //         },
  //         {
  //           'floor': "6F",
  //           "floors": [
  //             {'room': '601'},
  //             {'room': '602'},
  //             {'room': '603'},
  //             {'room': '604'},
  //             {'room': '605'},
  //             {'room': '606'},
  //             {'room': '607'},
  //             {'room': '608'},
  //             {'room': '609'},
  //             {'room': '610'},
  //             {'room': '611'},
  //             {'room': '612'}
  //           ]
  //         },
  //         {
  //           'floor': "7F",
  //           "floors": [
  //             {'room': '701'},
  //             {'room': '702'},
  //             {'room': '703'},
  //             {'room': '704'},
  //             {'room': '705'},
  //             {'room': '706'}
  //           ]
  //         },
  //         {
  //           'floor': "8F",
  //           "floors": [
  //             {'room': '801'},
  //             {'room': '802'},
  //             {'room': '803'},
  //             {'room': '804'},
  //             {'room': '805'},
  //             {'room': '806'},
  //             {'room': '807'},
  //             {'room': '808'},
  //             {'room': '809'},
  //             {'room': '810'},
  //             {'room': '811'},
  //             {'room': '812'}
  //           ]
  //         },
  //       ]
  //     },
  //     {
  //       'unit': '三单元',
  //       'units': [
  //         {
  //           'floor': "1F",
  //           "floors": [
  //             {'room': '101'},
  //             {'room': '102'},
  //             {'room': '103'},
  //             {'room': '104'},
  //             {'room': '105'},
  //             {'room': '106'}
  //           ]
  //         },
  //         {
  //           'floor': "2F",
  //           "floors": [
  //             {'room': '201'},
  //             {'room': '202'},
  //             {'room': '203'},
  //             {'room': '204'},
  //             {'room': '205'},
  //             {'room': '206'},
  //             {'room': '207'},
  //             {'room': '208'},
  //             {'room': '209'},
  //             {'room': '210'},
  //             {'room': '211'},
  //             {'room': '212'}
  //           ]
  //         },
  //         {
  //           'floor': "3F",
  //           "floors": [
  //             {'room': '301'},
  //             {'room': '302'},
  //             {'room': '303'},
  //             {'room': '304'},
  //             {'room': '305'},
  //             {'room': '306'}
  //           ]
  //         },
  //         {
  //           'floor': "4F",
  //           "floors": [
  //             {'room': '401'},
  //             {'room': '402'},
  //             {'room': '403'},
  //             {'room': '404'},
  //             {'room': '405'},
  //             {'room': '406'},
  //             {'room': '407'},
  //             {'room': '408'},
  //             {'room': '409'},
  //             {'room': '410'},
  //             {'room': '411'},
  //             {'room': '412'}
  //           ]
  //         },
  //         {
  //           'floor': "5F",
  //           "floors": [
  //             {'room': '501'},
  //             {'room': '502'},
  //             {'room': '503'},
  //             {'room': '504'},
  //             {'room': '505'},
  //             {'room': '506'}
  //           ]
  //         },
  //         {
  //           'floor': "6F",
  //           "floors": [
  //             {'room': '601'},
  //             {'room': '602'},
  //             {'room': '603'},
  //             {'room': '604'},
  //             {'room': '605'},
  //             {'room': '606'},
  //             {'room': '607'},
  //             {'room': '608'},
  //             {'room': '609'},
  //             {'room': '610'},
  //             {'room': '611'},
  //             {'room': '612'}
  //           ]
  //         },
  //         {
  //           'floor': "7F",
  //           "floors": [
  //             {'room': '701'},
  //             {'room': '702'},
  //             {'room': '703'},
  //             {'room': '704'},
  //             {'room': '705'},
  //             {'room': '706'}
  //           ]
  //         },
  //         {
  //           'floor': "8F",
  //           "floors": [
  //             {'room': '801'},
  //             {'room': '802'},
  //             {'room': '803'},
  //             {'room': '804'},
  //             {'room': '805'},
  //             {'room': '806'},
  //             {'room': '807'},
  //             {'room': '808'},
  //             {'room': '809'},
  //             {'room': '810'},
  //             {'room': '811'},
  //             {'room': '812'}
  //           ]
  //         },
  //       ]
  //     },
  //     {
  //       'unit': '四单元',
  //       'units': [
  //         {
  //           'floor': "1F",
  //           "floors": [
  //             {'room': '101'},
  //             {'room': '102'},
  //             {'room': '103'},
  //             {'room': '104'},
  //             {'room': '105'},
  //             {'room': '106'}
  //           ]
  //         },
  //         {
  //           'floor': "2F",
  //           "floors": [
  //             {'room': '201'},
  //             {'room': '202'},
  //             {'room': '203'},
  //             {'room': '204'},
  //             {'room': '205'},
  //             {'room': '206'},
  //             {'room': '207'},
  //             {'room': '208'},
  //             {'room': '209'},
  //             {'room': '210'},
  //             {'room': '211'},
  //             {'room': '212'}
  //           ]
  //         },
  //         {
  //           'floor': "3F",
  //           "floors": [
  //             {'room': '301'},
  //             {'room': '302'},
  //             {'room': '303'},
  //             {'room': '304'},
  //             {'room': '305'},
  //             {'room': '306'}
  //           ]
  //         },
  //         {
  //           'floor': "4F",
  //           "floors": [
  //             {'room': '401'},
  //             {'room': '402'},
  //             {'room': '403'},
  //             {'room': '404'},
  //             {'room': '405'},
  //             {'room': '406'},
  //             {'room': '407'},
  //             {'room': '408'},
  //             {'room': '409'},
  //             {'room': '410'},
  //             {'room': '411'},
  //             {'room': '412'}
  //           ]
  //         },
  //         {
  //           'floor': "5F",
  //           "floors": [
  //             {'room': '501'},
  //             {'room': '502'},
  //             {'room': '503'},
  //             {'room': '504'},
  //             {'room': '505'},
  //             {'room': '506'}
  //           ]
  //         },
  //         {
  //           'floor': "6F",
  //           "floors": [
  //             {'room': '601'},
  //             {'room': '602'},
  //             {'room': '603'},
  //             {'room': '604'},
  //             {'room': '605'},
  //             {'room': '606'},
  //             {'room': '607'},
  //             {'room': '608'},
  //             {'room': '609'},
  //             {'room': '610'},
  //             {'room': '611'},
  //             {'room': '612'}
  //           ]
  //         },
  //         {
  //           'floor': "7F",
  //           "floors": [
  //             {'room': '701'},
  //             {'room': '702'},
  //             {'room': '703'},
  //             {'room': '704'},
  //             {'room': '705'},
  //             {'room': '706'}
  //           ]
  //         },
  //         {
  //           'floor': "8F",
  //           "floors": [
  //             {'room': '801'},
  //             {'room': '802'},
  //             {'room': '803'},
  //             {'room': '804'},
  //             {'room': '805'},
  //             {'room': '806'},
  //             {'room': '807'},
  //             {'room': '808'},
  //             {'room': '809'},
  //             {'room': '810'},
  //             {'room': '811'},
  //             {'room': '812'}
  //           ]
  //         },
  //       ]
  //     }
  //   ],
  // },
  // {
  //   'houseName': '16栋',
  //   'houseId': '16',
  //   'building': [
  //     {
  //       'unit': '一单元',
  //       'units': [
  //         {
  //           'floor': "1F",
  //           "floors": [
  //             {'room': '101'},
  //             {'room': '102'},
  //             {'room': '103'},
  //             {'room': '104'},
  //             {'room': '105'},
  //             {'room': '106'}
  //           ]
  //         },
  //         {
  //           'floor': "2F",
  //           "floors": [
  //             {'room': '201'},
  //             {'room': '202'},
  //             {'room': '203'},
  //             {'room': '204'},
  //             {'room': '205'},
  //             {'room': '206'},
  //             {'room': '207'},
  //             {'room': '208'},
  //             {'room': '209'},
  //             {'room': '210'},
  //             {'room': '211'},
  //             {'room': '212'}
  //           ]
  //         },
  //         {
  //           'floor': "3F",
  //           "floors": [
  //             {'room': '301'},
  //             {'room': '302'},
  //             {'room': '303'},
  //             {'room': '304'},
  //             {'room': '305'},
  //             {'room': '306'}
  //           ]
  //         },
  //         {
  //           'floor': "4F",
  //           "floors": [
  //             {'room': '401'},
  //             {'room': '402'},
  //             {'room': '403'},
  //             {'room': '404'},
  //             {'room': '405'},
  //             {'room': '406'},
  //             {'room': '407'},
  //             {'room': '408'},
  //             {'room': '409'},
  //             {'room': '410'},
  //             {'room': '411'},
  //             {'room': '412'}
  //           ]
  //         },
  //         {
  //           'floor': "5F",
  //           "floors": [
  //             {'room': '501'},
  //             {'room': '502'},
  //             {'room': '503'},
  //             {'room': '504'},
  //             {'room': '505'},
  //             {'room': '506'}
  //           ]
  //         },
  //         {
  //           'floor': "6F",
  //           "floors": [
  //             {'room': '601'},
  //             {'room': '602'},
  //             {'room': '603'},
  //             {'room': '604'},
  //             {'room': '605'},
  //             {'room': '606'},
  //             {'room': '607'},
  //             {'room': '608'},
  //             {'room': '609'},
  //             {'room': '610'},
  //             {'room': '611'},
  //             {'room': '612'}
  //           ]
  //         },
  //         {
  //           'floor': "7F",
  //           "floors": [
  //             {'room': '701'},
  //             {'room': '702'},
  //             {'room': '703'},
  //             {'room': '704'},
  //             {'room': '705'},
  //             {'room': '706'}
  //           ]
  //         },
  //         {
  //           'floor': "8F",
  //           "floors": [
  //             {'room': '801'},
  //             {'room': '802'},
  //             {'room': '803'},
  //             {'room': '804'},
  //             {'room': '805'},
  //             {'room': '806'},
  //             {'room': '807'},
  //             {'room': '808'},
  //             {'room': '809'},
  //             {'room': '810'},
  //             {'room': '811'},
  //             {'room': '812'}
  //           ]
  //         },
  //       ]
  //     },
  //     {
  //       'unit': '二单元',
  //       'units': [
  //         {
  //           'floor': "1F",
  //           "floors": [
  //             {'room': '101'},
  //             {'room': '102'},
  //             {'room': '103'},
  //             {'room': '104'},
  //             {'room': '105'},
  //             {'room': '106'}
  //           ]
  //         },
  //         {
  //           'floor': "2F",
  //           "floors": [
  //             {'room': '201'},
  //             {'room': '202'},
  //             {'room': '203'},
  //             {'room': '204'},
  //             {'room': '205'},
  //             {'room': '206'},
  //             {'room': '207'},
  //             {'room': '208'},
  //             {'room': '209'},
  //             {'room': '210'},
  //             {'room': '211'},
  //             {'room': '212'}
  //           ]
  //         },
  //         {
  //           'floor': "3F",
  //           "floors": [
  //             {'room': '301'},
  //             {'room': '302'},
  //             {'room': '303'},
  //             {'room': '304'},
  //             {'room': '305'},
  //             {'room': '306'}
  //           ]
  //         },
  //         {
  //           'floor': "4F",
  //           "floors": [
  //             {'room': '401'},
  //             {'room': '402'},
  //             {'room': '403'},
  //             {'room': '404'},
  //             {'room': '405'},
  //             {'room': '406'},
  //             {'room': '407'},
  //             {'room': '408'},
  //             {'room': '409'},
  //             {'room': '410'},
  //             {'room': '411'},
  //             {'room': '412'}
  //           ]
  //         },
  //         {
  //           'floor': "5F",
  //           "floors": [
  //             {'room': '501'},
  //             {'room': '502'},
  //             {'room': '503'},
  //             {'room': '504'},
  //             {'room': '505'},
  //             {'room': '506'}
  //           ]
  //         },
  //         {
  //           'floor': "6F",
  //           "floors": [
  //             {'room': '601'},
  //             {'room': '602'},
  //             {'room': '603'},
  //             {'room': '604'},
  //             {'room': '605'},
  //             {'room': '606'},
  //             {'room': '607'},
  //             {'room': '608'},
  //             {'room': '609'},
  //             {'room': '610'},
  //             {'room': '611'},
  //             {'room': '612'}
  //           ]
  //         },
  //         {
  //           'floor': "7F",
  //           "floors": [
  //             {'room': '701'},
  //             {'room': '702'},
  //             {'room': '703'},
  //             {'room': '704'},
  //             {'room': '705'},
  //             {'room': '706'}
  //           ]
  //         },
  //         {
  //           'floor': "8F",
  //           "floors": [
  //             {'room': '801'},
  //             {'room': '802'},
  //             {'room': '803'},
  //             {'room': '804'},
  //             {'room': '805'},
  //             {'room': '806'},
  //             {'room': '807'},
  //             {'room': '808'},
  //             {'room': '809'},
  //             {'room': '810'},
  //             {'room': '811'},
  //             {'room': '812'}
  //           ]
  //         },
  //       ]
  //     },
  //     {
  //       'unit': '三单元',
  //       'units': [
  //         {
  //           'floor': "1F",
  //           "floors": [
  //             {'room': '101'},
  //             {'room': '102'},
  //             {'room': '103'},
  //             {'room': '104'},
  //             {'room': '105'},
  //             {'room': '106'}
  //           ]
  //         },
  //         {
  //           'floor': "2F",
  //           "floors": [
  //             {'room': '201'},
  //             {'room': '202'},
  //             {'room': '203'},
  //             {'room': '204'},
  //             {'room': '205'},
  //             {'room': '206'},
  //             {'room': '207'},
  //             {'room': '208'},
  //             {'room': '209'},
  //             {'room': '210'},
  //             {'room': '211'},
  //             {'room': '212'}
  //           ]
  //         },
  //         {
  //           'floor': "3F",
  //           "floors": [
  //             {'room': '301'},
  //             {'room': '302'},
  //             {'room': '303'},
  //             {'room': '304'},
  //             {'room': '305'},
  //             {'room': '306'}
  //           ]
  //         },
  //         {
  //           'floor': "4F",
  //           "floors": [
  //             {'room': '401'},
  //             {'room': '402'},
  //             {'room': '403'},
  //             {'room': '404'},
  //             {'room': '405'},
  //             {'room': '406'},
  //             {'room': '407'},
  //             {'room': '408'},
  //             {'room': '409'},
  //             {'room': '410'},
  //             {'room': '411'},
  //             {'room': '412'}
  //           ]
  //         },
  //         {
  //           'floor': "5F",
  //           "floors": [
  //             {'room': '501'},
  //             {'room': '502'},
  //             {'room': '503'},
  //             {'room': '504'},
  //             {'room': '505'},
  //             {'room': '506'}
  //           ]
  //         },
  //         {
  //           'floor': "6F",
  //           "floors": [
  //             {'room': '601'},
  //             {'room': '602'},
  //             {'room': '603'},
  //             {'room': '604'},
  //             {'room': '605'},
  //             {'room': '606'},
  //             {'room': '607'},
  //             {'room': '608'},
  //             {'room': '609'},
  //             {'room': '610'},
  //             {'room': '611'},
  //             {'room': '612'}
  //           ]
  //         },
  //         {
  //           'floor': "7F",
  //           "floors": [
  //             {'room': '701'},
  //             {'room': '702'},
  //             {'room': '703'},
  //             {'room': '704'},
  //             {'room': '705'},
  //             {'room': '706'}
  //           ]
  //         },
  //         {
  //           'floor': "8F",
  //           "floors": [
  //             {'room': '801'},
  //             {'room': '802'},
  //             {'room': '803'},
  //             {'room': '804'},
  //             {'room': '805'},
  //             {'room': '806'},
  //             {'room': '807'},
  //             {'room': '808'},
  //             {'room': '809'},
  //             {'room': '810'},
  //             {'room': '811'},
  //             {'room': '812'}
  //           ]
  //         },
  //       ]
  //     },
  //     {
  //       'unit': '四单元',
  //       'units': [
  //         {
  //           'floor': "1F",
  //           "floors": [
  //             {'room': '101'},
  //             {'room': '102'},
  //             {'room': '103'},
  //             {'room': '104'},
  //             {'room': '105'},
  //             {'room': '106'}
  //           ]
  //         },
  //         {
  //           'floor': "2F",
  //           "floors": [
  //             {'room': '201'},
  //             {'room': '202'},
  //             {'room': '203'},
  //             {'room': '204'},
  //             {'room': '205'},
  //             {'room': '206'},
  //             {'room': '207'},
  //             {'room': '208'},
  //             {'room': '209'},
  //             {'room': '210'},
  //             {'room': '211'},
  //             {'room': '212'}
  //           ]
  //         },
  //         {
  //           'floor': "3F",
  //           "floors": [
  //             {'room': '301'},
  //             {'room': '302'},
  //             {'room': '303'},
  //             {'room': '304'},
  //             {'room': '305'},
  //             {'room': '306'}
  //           ]
  //         },
  //         {
  //           'floor': "4F",
  //           "floors": [
  //             {'room': '401'},
  //             {'room': '402'},
  //             {'room': '403'},
  //             {'room': '404'},
  //             {'room': '405'},
  //             {'room': '406'},
  //             {'room': '407'},
  //             {'room': '408'},
  //             {'room': '409'},
  //             {'room': '410'},
  //             {'room': '411'},
  //             {'room': '412'}
  //           ]
  //         },
  //         {
  //           'floor': "5F",
  //           "floors": [
  //             {'room': '501'},
  //             {'room': '502'},
  //             {'room': '503'},
  //             {'room': '504'},
  //             {'room': '505'},
  //             {'room': '506'}
  //           ]
  //         },
  //         {
  //           'floor': "6F",
  //           "floors": [
  //             {'room': '601'},
  //             {'room': '602'},
  //             {'room': '603'},
  //             {'room': '604'},
  //             {'room': '605'},
  //             {'room': '606'},
  //             {'room': '607'},
  //             {'room': '608'},
  //             {'room': '609'},
  //             {'room': '610'},
  //             {'room': '611'},
  //             {'room': '612'}
  //           ]
  //         },
  //         {
  //           'floor': "7F",
  //           "floors": [
  //             {'room': '701'},
  //             {'room': '702'},
  //             {'room': '703'},
  //             {'room': '704'},
  //             {'room': '705'},
  //             {'room': '706'}
  //           ]
  //         },
  //         {
  //           'floor': "8F",
  //           "floors": [
  //             {'room': '801'},
  //             {'room': '802'},
  //             {'room': '803'},
  //             {'room': '804'},
  //             {'room': '805'},
  //             {'room': '806'},
  //             {'room': '807'},
  //             {'room': '808'},
  //             {'room': '809'},
  //             {'room': '810'},
  //             {'room': '811'},
  //             {'room': '812'}
  //           ]
  //         },
  //       ]
  //     }
  //   ],
  // },
  // {
  //   'houseName': '17栋',
  //   'houseId': '17',
  //   'building': [
  //     {
  //       'unit': '一单元',
  //       'units': [
  //         {
  //           'floor': "1F",
  //           "floors": [
  //             {'room': '101'},
  //             {'room': '102'},
  //             {'room': '103'},
  //             {'room': '104'},
  //             {'room': '105'},
  //             {'room': '106'}
  //           ]
  //         },
  //         {
  //           'floor': "2F",
  //           "floors": [
  //             {'room': '201'},
  //             {'room': '202'},
  //             {'room': '203'},
  //             {'room': '204'},
  //             {'room': '205'},
  //             {'room': '206'},
  //             {'room': '207'},
  //             {'room': '208'},
  //             {'room': '209'},
  //             {'room': '210'},
  //             {'room': '211'},
  //             {'room': '212'}
  //           ]
  //         },
  //         {
  //           'floor': "3F",
  //           "floors": [
  //             {'room': '301'},
  //             {'room': '302'},
  //             {'room': '303'},
  //             {'room': '304'},
  //             {'room': '305'},
  //             {'room': '306'}
  //           ]
  //         },
  //         {
  //           'floor': "4F",
  //           "floors": [
  //             {'room': '401'},
  //             {'room': '402'},
  //             {'room': '403'},
  //             {'room': '404'},
  //             {'room': '405'},
  //             {'room': '406'},
  //             {'room': '407'},
  //             {'room': '408'},
  //             {'room': '409'},
  //             {'room': '410'},
  //             {'room': '411'},
  //             {'room': '412'}
  //           ]
  //         },
  //         {
  //           'floor': "5F",
  //           "floors": [
  //             {'room': '501'},
  //             {'room': '502'},
  //             {'room': '503'},
  //             {'room': '504'},
  //             {'room': '505'},
  //             {'room': '506'}
  //           ]
  //         },
  //         {
  //           'floor': "6F",
  //           "floors": [
  //             {'room': '601'},
  //             {'room': '602'},
  //             {'room': '603'},
  //             {'room': '604'},
  //             {'room': '605'},
  //             {'room': '606'},
  //             {'room': '607'},
  //             {'room': '608'},
  //             {'room': '609'},
  //             {'room': '610'},
  //             {'room': '611'},
  //             {'room': '612'}
  //           ]
  //         },
  //         {
  //           'floor': "7F",
  //           "floors": [
  //             {'room': '701'},
  //             {'room': '702'},
  //             {'room': '703'},
  //             {'room': '704'},
  //             {'room': '705'},
  //             {'room': '706'}
  //           ]
  //         },
  //         {
  //           'floor': "8F",
  //           "floors": [
  //             {'room': '801'},
  //             {'room': '802'},
  //             {'room': '803'},
  //             {'room': '804'},
  //             {'room': '805'},
  //             {'room': '806'},
  //             {'room': '807'},
  //             {'room': '808'},
  //             {'room': '809'},
  //             {'room': '810'},
  //             {'room': '811'},
  //             {'room': '812'}
  //           ]
  //         },
  //       ]
  //     },
  //     {
  //       'unit': '二单元',
  //       'units': [
  //         {
  //           'floor': "1F",
  //           "floors": [
  //             {'room': '101'},
  //             {'room': '102'},
  //             {'room': '103'},
  //             {'room': '104'},
  //             {'room': '105'},
  //             {'room': '106'}
  //           ]
  //         },
  //         {
  //           'floor': "2F",
  //           "floors": [
  //             {'room': '201'},
  //             {'room': '202'},
  //             {'room': '203'},
  //             {'room': '204'},
  //             {'room': '205'},
  //             {'room': '206'},
  //             {'room': '207'},
  //             {'room': '208'},
  //             {'room': '209'},
  //             {'room': '210'},
  //             {'room': '211'},
  //             {'room': '212'}
  //           ]
  //         },
  //         {
  //           'floor': "3F",
  //           "floors": [
  //             {'room': '301'},
  //             {'room': '302'},
  //             {'room': '303'},
  //             {'room': '304'},
  //             {'room': '305'},
  //             {'room': '306'}
  //           ]
  //         },
  //         {
  //           'floor': "4F",
  //           "floors": [
  //             {'room': '401'},
  //             {'room': '402'},
  //             {'room': '403'},
  //             {'room': '404'},
  //             {'room': '405'},
  //             {'room': '406'},
  //             {'room': '407'},
  //             {'room': '408'},
  //             {'room': '409'},
  //             {'room': '410'},
  //             {'room': '411'},
  //             {'room': '412'}
  //           ]
  //         },
  //         {
  //           'floor': "5F",
  //           "floors": [
  //             {'room': '501'},
  //             {'room': '502'},
  //             {'room': '503'},
  //             {'room': '504'},
  //             {'room': '505'},
  //             {'room': '506'}
  //           ]
  //         },
  //         {
  //           'floor': "6F",
  //           "floors": [
  //             {'room': '601'},
  //             {'room': '602'},
  //             {'room': '603'},
  //             {'room': '604'},
  //             {'room': '605'},
  //             {'room': '606'},
  //             {'room': '607'},
  //             {'room': '608'},
  //             {'room': '609'},
  //             {'room': '610'},
  //             {'room': '611'},
  //             {'room': '612'}
  //           ]
  //         },
  //         {
  //           'floor': "7F",
  //           "floors": [
  //             {'room': '701'},
  //             {'room': '702'},
  //             {'room': '703'},
  //             {'room': '704'},
  //             {'room': '705'},
  //             {'room': '706'}
  //           ]
  //         },
  //         {
  //           'floor': "8F",
  //           "floors": [
  //             {'room': '801'},
  //             {'room': '802'},
  //             {'room': '803'},
  //             {'room': '804'},
  //             {'room': '805'},
  //             {'room': '806'},
  //             {'room': '807'},
  //             {'room': '808'},
  //             {'room': '809'},
  //             {'room': '810'},
  //             {'room': '811'},
  //             {'room': '812'}
  //           ]
  //         },
  //       ]
  //     },
  //     {
  //       'unit': '三单元',
  //       'units': [
  //         {
  //           'floor': "1F",
  //           "floors": [
  //             {'room': '101'},
  //             {'room': '102'},
  //             {'room': '103'},
  //             {'room': '104'},
  //             {'room': '105'},
  //             {'room': '106'}
  //           ]
  //         },
  //         {
  //           'floor': "2F",
  //           "floors": [
  //             {'room': '201'},
  //             {'room': '202'},
  //             {'room': '203'},
  //             {'room': '204'},
  //             {'room': '205'},
  //             {'room': '206'},
  //             {'room': '207'},
  //             {'room': '208'},
  //             {'room': '209'},
  //             {'room': '210'},
  //             {'room': '211'},
  //             {'room': '212'}
  //           ]
  //         },
  //         {
  //           'floor': "3F",
  //           "floors": [
  //             {'room': '301'},
  //             {'room': '302'},
  //             {'room': '303'},
  //             {'room': '304'},
  //             {'room': '305'},
  //             {'room': '306'}
  //           ]
  //         },
  //         {
  //           'floor': "4F",
  //           "floors": [
  //             {'room': '401'},
  //             {'room': '402'},
  //             {'room': '403'},
  //             {'room': '404'},
  //             {'room': '405'},
  //             {'room': '406'},
  //             {'room': '407'},
  //             {'room': '408'},
  //             {'room': '409'},
  //             {'room': '410'},
  //             {'room': '411'},
  //             {'room': '412'}
  //           ]
  //         },
  //         {
  //           'floor': "5F",
  //           "floors": [
  //             {'room': '501'},
  //             {'room': '502'},
  //             {'room': '503'},
  //             {'room': '504'},
  //             {'room': '505'},
  //             {'room': '506'}
  //           ]
  //         },
  //         {
  //           'floor': "6F",
  //           "floors": [
  //             {'room': '601'},
  //             {'room': '602'},
  //             {'room': '603'},
  //             {'room': '604'},
  //             {'room': '605'},
  //             {'room': '606'},
  //             {'room': '607'},
  //             {'room': '608'},
  //             {'room': '609'},
  //             {'room': '610'},
  //             {'room': '611'},
  //             {'room': '612'}
  //           ]
  //         },
  //         {
  //           'floor': "7F",
  //           "floors": [
  //             {'room': '701'},
  //             {'room': '702'},
  //             {'room': '703'},
  //             {'room': '704'},
  //             {'room': '705'},
  //             {'room': '706'}
  //           ]
  //         },
  //         {
  //           'floor': "8F",
  //           "floors": [
  //             {'room': '801'},
  //             {'room': '802'},
  //             {'room': '803'},
  //             {'room': '804'},
  //             {'room': '805'},
  //             {'room': '806'},
  //             {'room': '807'},
  //             {'room': '808'},
  //             {'room': '809'},
  //             {'room': '810'},
  //             {'room': '811'},
  //             {'room': '812'}
  //           ]
  //         },
  //       ]
  //     },
  //     {
  //       'unit': '四单元',
  //       'units': [
  //         {
  //           'floor': "1F",
  //           "floors": [
  //             {'room': '101'},
  //             {'room': '102'},
  //             {'room': '103'},
  //             {'room': '104'},
  //             {'room': '105'},
  //             {'room': '106'}
  //           ]
  //         },
  //         {
  //           'floor': "2F",
  //           "floors": [
  //             {'room': '201'},
  //             {'room': '202'},
  //             {'room': '203'},
  //             {'room': '204'},
  //             {'room': '205'},
  //             {'room': '206'},
  //             {'room': '207'},
  //             {'room': '208'},
  //             {'room': '209'},
  //             {'room': '210'},
  //             {'room': '211'},
  //             {'room': '212'}
  //           ]
  //         },
  //         {
  //           'floor': "3F",
  //           "floors": [
  //             {'room': '301'},
  //             {'room': '302'},
  //             {'room': '303'},
  //             {'room': '304'},
  //             {'room': '305'},
  //             {'room': '306'}
  //           ]
  //         },
  //         {
  //           'floor': "4F",
  //           "floors": [
  //             {'room': '401'},
  //             {'room': '402'},
  //             {'room': '403'},
  //             {'room': '404'},
  //             {'room': '405'},
  //             {'room': '406'},
  //             {'room': '407'},
  //             {'room': '408'},
  //             {'room': '409'},
  //             {'room': '410'},
  //             {'room': '411'},
  //             {'room': '412'}
  //           ]
  //         },
  //         {
  //           'floor': "5F",
  //           "floors": [
  //             {'room': '501'},
  //             {'room': '502'},
  //             {'room': '503'},
  //             {'room': '504'},
  //             {'room': '505'},
  //             {'room': '506'}
  //           ]
  //         },
  //         {
  //           'floor': "6F",
  //           "floors": [
  //             {'room': '601'},
  //             {'room': '602'},
  //             {'room': '603'},
  //             {'room': '604'},
  //             {'room': '605'},
  //             {'room': '606'},
  //             {'room': '607'},
  //             {'room': '608'},
  //             {'room': '609'},
  //             {'room': '610'},
  //             {'room': '611'},
  //             {'room': '612'}
  //           ]
  //         },
  //         {
  //           'floor': "7F",
  //           "floors": [
  //             {'room': '701'},
  //             {'room': '702'},
  //             {'room': '703'},
  //             {'room': '704'},
  //             {'room': '705'},
  //             {'room': '706'}
  //           ]
  //         },
  //         {
  //           'floor': "8F",
  //           "floors": [
  //             {'room': '801'},
  //             {'room': '802'},
  //             {'room': '803'},
  //             {'room': '804'},
  //             {'room': '805'},
  //             {'room': '806'},
  //             {'room': '807'},
  //             {'room': '808'},
  //             {'room': '809'},
  //             {'room': '810'},
  //             {'room': '811'},
  //             {'room': '812'}
  //           ]
  //         },
  //       ]
  //     }
  //   ],
  // },
  // {
  //   'houseName': '18栋',
  //   'houseId': '18',
  //   'building': [
  //     {
  //       'unit': '一单元',
  //       'units': [
  //         {
  //           'floor': "1F",
  //           "floors": [
  //             {'room': '101'},
  //             {'room': '102'},
  //             {'room': '103'},
  //             {'room': '104'},
  //             {'room': '105'},
  //             {'room': '106'}
  //           ]
  //         },
  //         {
  //           'floor': "2F",
  //           "floors": [
  //             {'room': '201'},
  //             {'room': '202'},
  //             {'room': '203'},
  //             {'room': '204'},
  //             {'room': '205'},
  //             {'room': '206'},
  //             {'room': '207'},
  //             {'room': '208'},
  //             {'room': '209'},
  //             {'room': '210'},
  //             {'room': '211'},
  //             {'room': '212'}
  //           ]
  //         },
  //         {
  //           'floor': "3F",
  //           "floors": [
  //             {'room': '301'},
  //             {'room': '302'},
  //             {'room': '303'},
  //             {'room': '304'},
  //             {'room': '305'},
  //             {'room': '306'}
  //           ]
  //         },
  //         {
  //           'floor': "4F",
  //           "floors": [
  //             {'room': '401'},
  //             {'room': '402'},
  //             {'room': '403'},
  //             {'room': '404'},
  //             {'room': '405'},
  //             {'room': '406'},
  //             {'room': '407'},
  //             {'room': '408'},
  //             {'room': '409'},
  //             {'room': '410'},
  //             {'room': '411'},
  //             {'room': '412'}
  //           ]
  //         },
  //         {
  //           'floor': "5F",
  //           "floors": [
  //             {'room': '501'},
  //             {'room': '502'},
  //             {'room': '503'},
  //             {'room': '504'},
  //             {'room': '505'},
  //             {'room': '506'}
  //           ]
  //         },
  //         {
  //           'floor': "6F",
  //           "floors": [
  //             {'room': '601'},
  //             {'room': '602'},
  //             {'room': '603'},
  //             {'room': '604'},
  //             {'room': '605'},
  //             {'room': '606'},
  //             {'room': '607'},
  //             {'room': '608'},
  //             {'room': '609'},
  //             {'room': '610'},
  //             {'room': '611'},
  //             {'room': '612'}
  //           ]
  //         },
  //         {
  //           'floor': "7F",
  //           "floors": [
  //             {'room': '701'},
  //             {'room': '702'},
  //             {'room': '703'},
  //             {'room': '704'},
  //             {'room': '705'},
  //             {'room': '706'}
  //           ]
  //         },
  //         {
  //           'floor': "8F",
  //           "floors": [
  //             {'room': '801'},
  //             {'room': '802'},
  //             {'room': '803'},
  //             {'room': '804'},
  //             {'room': '805'},
  //             {'room': '806'},
  //             {'room': '807'},
  //             {'room': '808'},
  //             {'room': '809'},
  //             {'room': '810'},
  //             {'room': '811'},
  //             {'room': '812'}
  //           ]
  //         },
  //       ]
  //     },
  //     {
  //       'unit': '二单元',
  //       'units': [
  //         {
  //           'floor': "1F",
  //           "floors": [
  //             {'room': '101'},
  //             {'room': '102'},
  //             {'room': '103'},
  //             {'room': '104'},
  //             {'room': '105'},
  //             {'room': '106'}
  //           ]
  //         },
  //         {
  //           'floor': "2F",
  //           "floors": [
  //             {'room': '201'},
  //             {'room': '202'},
  //             {'room': '203'},
  //             {'room': '204'},
  //             {'room': '205'},
  //             {'room': '206'},
  //             {'room': '207'},
  //             {'room': '208'},
  //             {'room': '209'},
  //             {'room': '210'},
  //             {'room': '211'},
  //             {'room': '212'}
  //           ]
  //         },
  //         {
  //           'floor': "3F",
  //           "floors": [
  //             {'room': '301'},
  //             {'room': '302'},
  //             {'room': '303'},
  //             {'room': '304'},
  //             {'room': '305'},
  //             {'room': '306'}
  //           ]
  //         },
  //         {
  //           'floor': "4F",
  //           "floors": [
  //             {'room': '401'},
  //             {'room': '402'},
  //             {'room': '403'},
  //             {'room': '404'},
  //             {'room': '405'},
  //             {'room': '406'},
  //             {'room': '407'},
  //             {'room': '408'},
  //             {'room': '409'},
  //             {'room': '410'},
  //             {'room': '411'},
  //             {'room': '412'}
  //           ]
  //         },
  //         {
  //           'floor': "5F",
  //           "floors": [
  //             {'room': '501'},
  //             {'room': '502'},
  //             {'room': '503'},
  //             {'room': '504'},
  //             {'room': '505'},
  //             {'room': '506'}
  //           ]
  //         },
  //         {
  //           'floor': "6F",
  //           "floors": [
  //             {'room': '601'},
  //             {'room': '602'},
  //             {'room': '603'},
  //             {'room': '604'},
  //             {'room': '605'},
  //             {'room': '606'},
  //             {'room': '607'},
  //             {'room': '608'},
  //             {'room': '609'},
  //             {'room': '610'},
  //             {'room': '611'},
  //             {'room': '612'}
  //           ]
  //         },
  //         {
  //           'floor': "7F",
  //           "floors": [
  //             {'room': '701'},
  //             {'room': '702'},
  //             {'room': '703'},
  //             {'room': '704'},
  //             {'room': '705'},
  //             {'room': '706'}
  //           ]
  //         },
  //         {
  //           'floor': "8F",
  //           "floors": [
  //             {'room': '801'},
  //             {'room': '802'},
  //             {'room': '803'},
  //             {'room': '804'},
  //             {'room': '805'},
  //             {'room': '806'},
  //             {'room': '807'},
  //             {'room': '808'},
  //             {'room': '809'},
  //             {'room': '810'},
  //             {'room': '811'},
  //             {'room': '812'}
  //           ]
  //         },
  //       ]
  //     },
  //     {
  //       'unit': '三单元',
  //       'units': [
  //         {
  //           'floor': "1F",
  //           "floors": [
  //             {'room': '101'},
  //             {'room': '102'},
  //             {'room': '103'},
  //             {'room': '104'},
  //             {'room': '105'},
  //             {'room': '106'}
  //           ]
  //         },
  //         {
  //           'floor': "2F",
  //           "floors": [
  //             {'room': '201'},
  //             {'room': '202'},
  //             {'room': '203'},
  //             {'room': '204'},
  //             {'room': '205'},
  //             {'room': '206'},
  //             {'room': '207'},
  //             {'room': '208'},
  //             {'room': '209'},
  //             {'room': '210'},
  //             {'room': '211'},
  //             {'room': '212'}
  //           ]
  //         },
  //         {
  //           'floor': "3F",
  //           "floors": [
  //             {'room': '301'},
  //             {'room': '302'},
  //             {'room': '303'},
  //             {'room': '304'},
  //             {'room': '305'},
  //             {'room': '306'}
  //           ]
  //         },
  //         {
  //           'floor': "4F",
  //           "floors": [
  //             {'room': '401'},
  //             {'room': '402'},
  //             {'room': '403'},
  //             {'room': '404'},
  //             {'room': '405'},
  //             {'room': '406'},
  //             {'room': '407'},
  //             {'room': '408'},
  //             {'room': '409'},
  //             {'room': '410'},
  //             {'room': '411'},
  //             {'room': '412'}
  //           ]
  //         },
  //         {
  //           'floor': "5F",
  //           "floors": [
  //             {'room': '501'},
  //             {'room': '502'},
  //             {'room': '503'},
  //             {'room': '504'},
  //             {'room': '505'},
  //             {'room': '506'}
  //           ]
  //         },
  //         {
  //           'floor': "6F",
  //           "floors": [
  //             {'room': '601'},
  //             {'room': '602'},
  //             {'room': '603'},
  //             {'room': '604'},
  //             {'room': '605'},
  //             {'room': '606'},
  //             {'room': '607'},
  //             {'room': '608'},
  //             {'room': '609'},
  //             {'room': '610'},
  //             {'room': '611'},
  //             {'room': '612'}
  //           ]
  //         },
  //         {
  //           'floor': "7F",
  //           "floors": [
  //             {'room': '701'},
  //             {'room': '702'},
  //             {'room': '703'},
  //             {'room': '704'},
  //             {'room': '705'},
  //             {'room': '706'}
  //           ]
  //         },
  //         {
  //           'floor': "8F",
  //           "floors": [
  //             {'room': '801'},
  //             {'room': '802'},
  //             {'room': '803'},
  //             {'room': '804'},
  //             {'room': '805'},
  //             {'room': '806'},
  //             {'room': '807'},
  //             {'room': '808'},
  //             {'room': '809'},
  //             {'room': '810'},
  //             {'room': '811'},
  //             {'room': '812'}
  //           ]
  //         },
  //       ]
  //     },
  //     {
  //       'unit': '四单元',
  //       'units': [
  //         {
  //           'floor': "1F",
  //           "floors": [
  //             {'room': '101'},
  //             {'room': '102'},
  //             {'room': '103'},
  //             {'room': '104'},
  //             {'room': '105'},
  //             {'room': '106'}
  //           ]
  //         },
  //         {
  //           'floor': "2F",
  //           "floors": [
  //             {'room': '201'},
  //             {'room': '202'},
  //             {'room': '203'},
  //             {'room': '204'},
  //             {'room': '205'},
  //             {'room': '206'},
  //             {'room': '207'},
  //             {'room': '208'},
  //             {'room': '209'},
  //             {'room': '210'},
  //             {'room': '211'},
  //             {'room': '212'}
  //           ]
  //         },
  //         {
  //           'floor': "3F",
  //           "floors": [
  //             {'room': '301'},
  //             {'room': '302'},
  //             {'room': '303'},
  //             {'room': '304'},
  //             {'room': '305'},
  //             {'room': '306'}
  //           ]
  //         },
  //         {
  //           'floor': "4F",
  //           "floors": [
  //             {'room': '401'},
  //             {'room': '402'},
  //             {'room': '403'},
  //             {'room': '404'},
  //             {'room': '405'},
  //             {'room': '406'},
  //             {'room': '407'},
  //             {'room': '408'},
  //             {'room': '409'},
  //             {'room': '410'},
  //             {'room': '411'},
  //             {'room': '412'}
  //           ]
  //         },
  //         {
  //           'floor': "5F",
  //           "floors": [
  //             {'room': '501'},
  //             {'room': '502'},
  //             {'room': '503'},
  //             {'room': '504'},
  //             {'room': '505'},
  //             {'room': '506'}
  //           ]
  //         },
  //         {
  //           'floor': "6F",
  //           "floors": [
  //             {'room': '601'},
  //             {'room': '602'},
  //             {'room': '603'},
  //             {'room': '604'},
  //             {'room': '605'},
  //             {'room': '606'},
  //             {'room': '607'},
  //             {'room': '608'},
  //             {'room': '609'},
  //             {'room': '610'},
  //             {'room': '611'},
  //             {'room': '612'}
  //           ]
  //         },
  //         {
  //           'floor': "7F",
  //           "floors": [
  //             {'room': '701'},
  //             {'room': '702'},
  //             {'room': '703'},
  //             {'room': '704'},
  //             {'room': '705'},
  //             {'room': '706'}
  //           ]
  //         },
  //         {
  //           'floor': "8F",
  //           "floors": [
  //             {'room': '801'},
  //             {'room': '802'},
  //             {'room': '803'},
  //             {'room': '804'},
  //             {'room': '805'},
  //             {'room': '806'},
  //             {'room': '807'},
  //             {'room': '808'},
  //             {'room': '809'},
  //             {'room': '810'},
  //             {'room': '811'},
  //             {'room': '812'}
  //           ]
  //         },
  //       ]
  //     }
  //   ],
  // },
  // {
  //   'houseName': '19栋',
  //   'houseId': '19',
  //   'building': [
  //     {
  //       'unit': '一单元',
  //       'units': [
  //         {
  //           'floor': "1F",
  //           "floors": [
  //             {'room': '101'},
  //             {'room': '102'},
  //             {'room': '103'},
  //             {'room': '104'},
  //             {'room': '105'},
  //             {'room': '106'}
  //           ]
  //         },
  //         {
  //           'floor': "2F",
  //           "floors": [
  //             {'room': '201'},
  //             {'room': '202'},
  //             {'room': '203'},
  //             {'room': '204'},
  //             {'room': '205'},
  //             {'room': '206'},
  //             {'room': '207'},
  //             {'room': '208'},
  //             {'room': '209'},
  //             {'room': '210'},
  //             {'room': '211'},
  //             {'room': '212'}
  //           ]
  //         },
  //         {
  //           'floor': "3F",
  //           "floors": [
  //             {'room': '301'},
  //             {'room': '302'},
  //             {'room': '303'},
  //             {'room': '304'},
  //             {'room': '305'},
  //             {'room': '306'}
  //           ]
  //         },
  //         {
  //           'floor': "4F",
  //           "floors": [
  //             {'room': '401'},
  //             {'room': '402'},
  //             {'room': '403'},
  //             {'room': '404'},
  //             {'room': '405'},
  //             {'room': '406'},
  //             {'room': '407'},
  //             {'room': '408'},
  //             {'room': '409'},
  //             {'room': '410'},
  //             {'room': '411'},
  //             {'room': '412'}
  //           ]
  //         },
  //         {
  //           'floor': "5F",
  //           "floors": [
  //             {'room': '501'},
  //             {'room': '502'},
  //             {'room': '503'},
  //             {'room': '504'},
  //             {'room': '505'},
  //             {'room': '506'}
  //           ]
  //         },
  //         {
  //           'floor': "6F",
  //           "floors": [
  //             {'room': '601'},
  //             {'room': '602'},
  //             {'room': '603'},
  //             {'room': '604'},
  //             {'room': '605'},
  //             {'room': '606'},
  //             {'room': '607'},
  //             {'room': '608'},
  //             {'room': '609'},
  //             {'room': '610'},
  //             {'room': '611'},
  //             {'room': '612'}
  //           ]
  //         },
  //         {
  //           'floor': "7F",
  //           "floors": [
  //             {'room': '701'},
  //             {'room': '702'},
  //             {'room': '703'},
  //             {'room': '704'},
  //             {'room': '705'},
  //             {'room': '706'}
  //           ]
  //         },
  //         {
  //           'floor': "8F",
  //           "floors": [
  //             {'room': '801'},
  //             {'room': '802'},
  //             {'room': '803'},
  //             {'room': '804'},
  //             {'room': '805'},
  //             {'room': '806'},
  //             {'room': '807'},
  //             {'room': '808'},
  //             {'room': '809'},
  //             {'room': '810'},
  //             {'room': '811'},
  //             {'room': '812'}
  //           ]
  //         },
  //       ]
  //     },
  //     {
  //       'unit': '二单元',
  //       'units': [
  //         {
  //           'floor': "1F",
  //           "floors": [
  //             {'room': '101'},
  //             {'room': '102'},
  //             {'room': '103'},
  //             {'room': '104'},
  //             {'room': '105'},
  //             {'room': '106'}
  //           ]
  //         },
  //         {
  //           'floor': "2F",
  //           "floors": [
  //             {'room': '201'},
  //             {'room': '202'},
  //             {'room': '203'},
  //             {'room': '204'},
  //             {'room': '205'},
  //             {'room': '206'},
  //             {'room': '207'},
  //             {'room': '208'},
  //             {'room': '209'},
  //             {'room': '210'},
  //             {'room': '211'},
  //             {'room': '212'}
  //           ]
  //         },
  //         {
  //           'floor': "3F",
  //           "floors": [
  //             {'room': '301'},
  //             {'room': '302'},
  //             {'room': '303'},
  //             {'room': '304'},
  //             {'room': '305'},
  //             {'room': '306'}
  //           ]
  //         },
  //         {
  //           'floor': "4F",
  //           "floors": [
  //             {'room': '401'},
  //             {'room': '402'},
  //             {'room': '403'},
  //             {'room': '404'},
  //             {'room': '405'},
  //             {'room': '406'},
  //             {'room': '407'},
  //             {'room': '408'},
  //             {'room': '409'},
  //             {'room': '410'},
  //             {'room': '411'},
  //             {'room': '412'}
  //           ]
  //         },
  //         {
  //           'floor': "5F",
  //           "floors": [
  //             {'room': '501'},
  //             {'room': '502'},
  //             {'room': '503'},
  //             {'room': '504'},
  //             {'room': '505'},
  //             {'room': '506'}
  //           ]
  //         },
  //         {
  //           'floor': "6F",
  //           "floors": [
  //             {'room': '601'},
  //             {'room': '602'},
  //             {'room': '603'},
  //             {'room': '604'},
  //             {'room': '605'},
  //             {'room': '606'},
  //             {'room': '607'},
  //             {'room': '608'},
  //             {'room': '609'},
  //             {'room': '610'},
  //             {'room': '611'},
  //             {'room': '612'}
  //           ]
  //         },
  //         {
  //           'floor': "7F",
  //           "floors": [
  //             {'room': '701'},
  //             {'room': '702'},
  //             {'room': '703'},
  //             {'room': '704'},
  //             {'room': '705'},
  //             {'room': '706'}
  //           ]
  //         },
  //         {
  //           'floor': "8F",
  //           "floors": [
  //             {'room': '801'},
  //             {'room': '802'},
  //             {'room': '803'},
  //             {'room': '804'},
  //             {'room': '805'},
  //             {'room': '806'},
  //             {'room': '807'},
  //             {'room': '808'},
  //             {'room': '809'},
  //             {'room': '810'},
  //             {'room': '811'},
  //             {'room': '812'}
  //           ]
  //         },
  //       ]
  //     },
  //     {
  //       'unit': '三单元',
  //       'units': [
  //         {
  //           'floor': "1F",
  //           "floors": [
  //             {'room': '101'},
  //             {'room': '102'},
  //             {'room': '103'},
  //             {'room': '104'},
  //             {'room': '105'},
  //             {'room': '106'}
  //           ]
  //         },
  //         {
  //           'floor': "2F",
  //           "floors": [
  //             {'room': '201'},
  //             {'room': '202'},
  //             {'room': '203'},
  //             {'room': '204'},
  //             {'room': '205'},
  //             {'room': '206'},
  //             {'room': '207'},
  //             {'room': '208'},
  //             {'room': '209'},
  //             {'room': '210'},
  //             {'room': '211'},
  //             {'room': '212'}
  //           ]
  //         },
  //         {
  //           'floor': "3F",
  //           "floors": [
  //             {'room': '301'},
  //             {'room': '302'},
  //             {'room': '303'},
  //             {'room': '304'},
  //             {'room': '305'},
  //             {'room': '306'}
  //           ]
  //         },
  //         {
  //           'floor': "4F",
  //           "floors": [
  //             {'room': '401'},
  //             {'room': '402'},
  //             {'room': '403'},
  //             {'room': '404'},
  //             {'room': '405'},
  //             {'room': '406'},
  //             {'room': '407'},
  //             {'room': '408'},
  //             {'room': '409'},
  //             {'room': '410'},
  //             {'room': '411'},
  //             {'room': '412'}
  //           ]
  //         },
  //         {
  //           'floor': "5F",
  //           "floors": [
  //             {'room': '501'},
  //             {'room': '502'},
  //             {'room': '503'},
  //             {'room': '504'},
  //             {'room': '505'},
  //             {'room': '506'}
  //           ]
  //         },
  //         {
  //           'floor': "6F",
  //           "floors": [
  //             {'room': '601'},
  //             {'room': '602'},
  //             {'room': '603'},
  //             {'room': '604'},
  //             {'room': '605'},
  //             {'room': '606'},
  //             {'room': '607'},
  //             {'room': '608'},
  //             {'room': '609'},
  //             {'room': '610'},
  //             {'room': '611'},
  //             {'room': '612'}
  //           ]
  //         },
  //         {
  //           'floor': "7F",
  //           "floors": [
  //             {'room': '701'},
  //             {'room': '702'},
  //             {'room': '703'},
  //             {'room': '704'},
  //             {'room': '705'},
  //             {'room': '706'}
  //           ]
  //         },
  //         {
  //           'floor': "8F",
  //           "floors": [
  //             {'room': '801'},
  //             {'room': '802'},
  //             {'room': '803'},
  //             {'room': '804'},
  //             {'room': '805'},
  //             {'room': '806'},
  //             {'room': '807'},
  //             {'room': '808'},
  //             {'room': '809'},
  //             {'room': '810'},
  //             {'room': '811'},
  //             {'room': '812'}
  //           ]
  //         },
  //       ]
  //     },
  //     {
  //       'unit': '四单元',
  //       'units': [
  //         {
  //           'floor': "1F",
  //           "floors": [
  //             {'room': '101'},
  //             {'room': '102'},
  //             {'room': '103'},
  //             {'room': '104'},
  //             {'room': '105'},
  //             {'room': '106'}
  //           ]
  //         },
  //         {
  //           'floor': "2F",
  //           "floors": [
  //             {'room': '201'},
  //             {'room': '202'},
  //             {'room': '203'},
  //             {'room': '204'},
  //             {'room': '205'},
  //             {'room': '206'},
  //             {'room': '207'},
  //             {'room': '208'},
  //             {'room': '209'},
  //             {'room': '210'},
  //             {'room': '211'},
  //             {'room': '212'}
  //           ]
  //         },
  //         {
  //           'floor': "3F",
  //           "floors": [
  //             {'room': '301'},
  //             {'room': '302'},
  //             {'room': '303'},
  //             {'room': '304'},
  //             {'room': '305'},
  //             {'room': '306'}
  //           ]
  //         },
  //         {
  //           'floor': "4F",
  //           "floors": [
  //             {'room': '401'},
  //             {'room': '402'},
  //             {'room': '403'},
  //             {'room': '404'},
  //             {'room': '405'},
  //             {'room': '406'},
  //             {'room': '407'},
  //             {'room': '408'},
  //             {'room': '409'},
  //             {'room': '410'},
  //             {'room': '411'},
  //             {'room': '412'}
  //           ]
  //         },
  //         {
  //           'floor': "5F",
  //           "floors": [
  //             {'room': '501'},
  //             {'room': '502'},
  //             {'room': '503'},
  //             {'room': '504'},
  //             {'room': '505'},
  //             {'room': '506'}
  //           ]
  //         },
  //         {
  //           'floor': "6F",
  //           "floors": [
  //             {'room': '601'},
  //             {'room': '602'},
  //             {'room': '603'},
  //             {'room': '604'},
  //             {'room': '605'},
  //             {'room': '606'},
  //             {'room': '607'},
  //             {'room': '608'},
  //             {'room': '609'},
  //             {'room': '610'},
  //             {'room': '611'},
  //             {'room': '612'}
  //           ]
  //         },
  //         {
  //           'floor': "7F",
  //           "floors": [
  //             {'room': '701'},
  //             {'room': '702'},
  //             {'room': '703'},
  //             {'room': '704'},
  //             {'room': '705'},
  //             {'room': '706'}
  //           ]
  //         },
  //         {
  //           'floor': "8F",
  //           "floors": [
  //             {'room': '801'},
  //             {'room': '802'},
  //             {'room': '803'},
  //             {'room': '804'},
  //             {'room': '805'},
  //             {'room': '806'},
  //             {'room': '807'},
  //             {'room': '808'},
  //             {'room': '809'},
  //             {'room': '810'},
  //             {'room': '811'},
  //             {'room': '812'}
  //           ]
  //         },
  //       ]
  //     }
  //   ],
  // },
];
