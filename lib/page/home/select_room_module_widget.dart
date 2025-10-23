import 'package:flutter/material.dart';
import 'package:notarization_station_app/appTheme.dart';
import 'package:notarization_station_app/base_framework/widget/provider_widget.dart';
import 'package:notarization_station_app/page/home/scale_widget.dart';
import 'package:notarization_station_app/page/home/vm/select_room_module_vm.dart';
import 'package:notarization_station_app/page/login/vm/user_view_model.dart';
import 'package:notarization_station_app/utils/event_bus_instance.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class SelectRoomModuleWidget extends StatefulWidget {
  const SelectRoomModuleWidget({Key key}) : super(key: key);

  @override
  State<SelectRoomModuleWidget> createState() => _SelectRoomModuleWidgetState();
}

class _SelectRoomModuleWidgetState extends State<SelectRoomModuleWidget> {
  SelectRoomModuleViewModel _viewModel;

  int buildingIndex = 0;

  var selectRoomEventBus;

  @override
  void initState() {
    super.initState();
    selectRoomEventBus = eventBus.on<EventBusInstanceEvent>().listen((event) {
      _viewModel.dealSelectedHouse(event);
    });
  }

  @override
  void dispose() {
    super.dispose();
    selectRoomEventBus.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<UserViewModel>(builder: (context, userViewModel, child) {
        return ProviderWidget<SelectRoomModuleViewModel>(
          builder: (context, vm, child) {
            return Column(
              children: [
                _hasSelectedRoomWidget(),
                _buildingsWidget(),
                vm.buildingList[buildingIndex].unitList.isNotEmpty
                    ? Expanded(
                        child: HouseBuildingsCollectionWidget(
                          dataSource: vm.buildingList[buildingIndex].unitList,
                          buildingIndex: buildingIndex,
                          isForbiden: vm.isForbidden,
                        ),
                      )
                    : Container()
              ],
            );
          },
          model: SelectRoomModuleViewModel(),
          onModelReady: (vm) {
            vm.initData();
            _viewModel = vm;
          },
        );
      }),
    );
  }

  // 顶部已选择的房间信息
  Widget _hasSelectedRoomWidget() {
    return _viewModel.hasSelectedList.isEmpty
        ? Container()
        : Container(
            alignment: Alignment.topLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 16.0, top: 20.0),
                  child: Text(
                    '我已选择',
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 30.0, top: 10.0, right: 30.0, bottom: 10.0),
                  child: Wrap(
                    spacing: 10.0,
                    runSpacing: 10.0,
                    children: _viewModel.hasSelectedList
                        .map((e) => Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 5.0),
                              alignment: Alignment.center,
                              width: 150.0,
                              height: 40.0,
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(10.0),
                                  border: Border.all(
                                      color: const Color(0xFFF4F4F4),
                                      width: 1.0)),
                              child: Text(
                                e['name'],
                                style: const TextStyle(
                                    fontSize: 14.0, color: Colors.white),
                              ),
                            ))
                        .toList(),
                  ),
                )
              ],
            ),
          );
  }

  // 楼栋数
  Widget _buildingsWidget() {
    return _viewModel.buildings.isNotEmpty
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Container(
                height: 100,
                alignment: Alignment.center,
                child: HouseFlowWidget(
                  dataSource: _viewModel.buildings,
                  count: 5,
                  onTapChanged: (index) {
                    setState(() {
                      buildingIndex = index;
                    });
                  },
                )

                //  ScaleView(
                //   callBack: (ScaleModel model) {
                //     setState(() {
                //       buildingIndex = _viewModel.buildings.indexOf(model);
                //     });
                //   },
                //   controller: ScaleViewController(
                //     dataSource: _viewModel.buildings,
                //     amout: 7,
                //     maxSize: 60.0,
                //     currentIndex: 3,
                //     borderRadius: 30.0,
                //     selectColor: AppTheme.themeBlue,
                //     unSelectColor: Colors.grey[200],
                //   ),
                // ),
                ),
          )
        : Container();
  }
}

// ignore: must_be_immutable
class HouseBuildingsCollectionWidget extends StatefulWidget {
  List<UnitModel> dataSource;
  int buildingIndex;
  bool isForbiden;
  HouseBuildingsCollectionWidget(
      {Key key, this.dataSource, this.buildingIndex, this.isForbiden})
      : super(key: key);

  @override
  State<HouseBuildingsCollectionWidget> createState() =>
      _HouseBuildingsCollectionWidgetState();
}

class _HouseBuildingsCollectionWidgetState
    extends State<HouseBuildingsCollectionWidget>
    with TickerProviderStateMixin {
  TabController _tabController;

  List<UnitModel> dataSource;

// tabController 点击及滑动触发事件
  void _tabControllerScroll(int index) {
    _tabController.animateTo(index);
  }

  @override
  void initState() {
    super.initState();
    dataSource = widget.dataSource;
    _tabController = TabController(length: dataSource.length, vsync: this);
    // _tabController.addListener(() {
    //   int tempIndex = 0;
    //   tempIndex = _tabController.offset ~/ MediaQuery.of(context).size.width;
    //   if (_tabController.offset % MediaQuery.of(context).size.width >
    //       MediaQuery.of(context).size.width / 2) {
    //     tempIndex++;
    //   }
    //   _tabControllerScroll(tempIndex);
    // });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          tabs: dataSource
              .map((e) => Tab(
                    text: e.unitName,
                  ))
              .toList(),
          labelColor: Colors.black,
          unselectedLabelColor: Colors.black,
          indicatorColor: AppTheme.themeBlue,
          indicatorSize: TabBarIndicatorSize.label,
          indicatorWeight: 2.0,
          controller: _tabController,
          // onTap: (index) {
          //   _tabControllerScroll(index);
          // },
        ),
        Expanded(
          child: TabBarView(
              children: dataSource
                  .map((e) => CollectionSectionScrollController(
                        model: e,
                        buildingIndex: widget.buildingIndex,
                        unitIndex: dataSource.indexOf(e),
                        isForbiden: widget.isForbiden,
                      ))
                  .toList(),
              controller: _tabController),
        ),
      ],
    );
  }
}

// ignore: must_be_immutable
class CollectionSectionScrollController extends StatefulWidget {
  UnitModel model;

  int buildingIndex;

  int unitIndex;

  bool isForbiden;

  CollectionSectionScrollController(
      {Key key,
      this.model,
      this.buildingIndex,
      this.unitIndex,
      this.isForbiden})
      : super(key: key);

  @override
  State<CollectionSectionScrollController> createState() =>
      _CollectionSectionScrollControllerState();
}

class _CollectionSectionScrollControllerState
    extends State<CollectionSectionScrollController> {
  //
  ItemScrollController _itemScrollController;
  ItemPositionsListener _itemPositionListener;

  List<UnitModel> dataSource;

  // 楼层索引
  List<String> floorIndexList = [];

  // 索引当前的位置
  int scrollIndex = 0;

  // eventBus
  var houseEventBus;

// 当前第几栋楼
  int buildingIndex = 0;

// 是否禁止选房
  bool isForbidden = false;

  @override
  void initState() {
    super.initState();

    _initAllController();
    widget.model.roomList.forEach((e) {
      floorIndexList.add(e.floorName);
    });
  }

// 初始化所有的Controller
  void _initAllController() {
    _itemPositionListener = ItemPositionsListener.create();
    _itemScrollController = ItemScrollController();
    _itemPositionListener.itemPositions.addListener(() {
      int tempIndex = 0;
      tempIndex = _itemPositionListener.itemPositions.value.first.index;
      if (scrollIndex != tempIndex) {
        setState(() {
          scrollIndex = tempIndex;
        });
      }
    });
  }

// 滑动到指定位置
  void _controllerScroll(int index) {
    _itemScrollController.jumpTo(
      index: index,
    );
    setState(() {
      if (scrollIndex != index) {
        scrollIndex = index;
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _itemScrollController = null;
    _itemPositionListener = null;
  }

  @override
  Widget build(BuildContext context) {
    return _wholePageView(widget.model);
  }

  // page view
  Widget _wholePageView(UnitModel model) {
    return Container(
      // color: Color.fromRGBO(Random().nextInt(255), Random().nextInt(255),
      //     Random().nextInt(255), 1),
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          _listView(model),
          Positioned(right: 0.0, child: _rightIndexBar()),
        ],
      ),
    );
  }

  // 楼层view
  Widget _listView(UnitModel model) {
    return ScrollablePositionedList.builder(
      itemCount: model.roomList.length,
      itemScrollController: _itemScrollController,
      itemPositionsListener: _itemPositionListener,
      itemBuilder: (context, index) {
        return _floorView(model.roomList[index], index);
      },
    );
  }

  // 每层的view
  Widget _floorView(FloorModel model, int floorIndex) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      margin: EdgeInsets.only(right: 30.0, left: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Text(
              '${model.floorName}',
              style: TextStyle(
                fontSize: 13.0,
              ),
            ),
          ),
          _gridView(model, floorIndex),
        ],
      ),
    );
  }

  // 房间view
  Widget _gridView(FloorModel model, int floorIndex) {
    return GridView.builder(
      itemCount: model.roomList.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 10.0,
        crossAxisSpacing: 10.0,
        childAspectRatio: 2,
      ),
      itemBuilder: (context, index) {
        return _gridItem(model.roomList[index], floorIndex, index);
      },
    );
  }

  //  grid item
  Widget _gridItem(HouseModel model, int floorIndex, int index) {
    return GestureDetector(
      child: Container(
        alignment: Alignment.center,
        // padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: model.isSelected ? Colors.red : Colors.white,
          border: Border.all(
            color: Colors.grey[500],
            width: 0.50,
          ),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Text(
          model.houseName ?? '',
          style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: model.isSelected ? Colors.white : Colors.black),
        ),
      ),
      onTap: !widget.isForbiden
          ? () {
              setState(() {
                widget.model.roomList[floorIndex].roomList.forEach((e) {
                  if (e.houseName == model.houseName) {
                    e.isSelected = !model.isSelected;
                    eventBus.fire(EventBusInstanceEvent(source: {
                      'model': model,
                      'index': [
                        widget.buildingIndex,
                        widget.unitIndex,
                        floorIndex,
                        index
                      ]
                    }));
                  }
                });
              });
            }
          : null,
    );
  }

  // 右侧的索引栏
  Widget _rightIndexBar() {
    return Container(
      width: 30.0,
      height: 150.0,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'F',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
              color: Colors.orangeAccent,
            ),
          ),
          Expanded(
              child: ListView.builder(
            itemCount: floorIndexList.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                child: Container(
                  height: 20.0,
                  child: Text(
                    '${floorIndexList[index]}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14.0,
                      color: scrollIndex == index
                          ? Colors.orangeAccent
                          : Colors.black,
                    ),
                  ),
                ),
                onTap: () {
                  // _itemScrollController.jumpTo(
                  //   index: index,
                  // );
                  _controllerScroll(index);
                },
              );
            },
          ))
        ],
      ),
    );
  }
}
