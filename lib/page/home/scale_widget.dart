import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../utils/common_tools.dart';

/// scaleView
///
///

// ignore: must_be_immutable
class ScaleView extends StatefulWidget {
  Function callBack;

  ScaleViewController controller;

  ScaleView({Key key, this.callBack, this.controller}) : super(key: key);

  @override
  State<ScaleView> createState() => _ScaleViewState();
}

class _ScaleViewState extends State<ScaleView> {
  List<ScaleModel> data = [];

  @override
  void initState() {
    super.initState();
    wjPrint('widget.controller.dataSource: ${widget.controller.dataSource}');
    data = widget.controller.dataSource ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return data.isEmpty
        ? Container()
        : Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: data.map((e) {
                return _ScaleItemWidget(
                  model: e,
                  callBack: widget.callBack,
                  controller: widget.controller,
                );
              }).toList(),
            ),
          );
  }
}

/// 缩放的item
// ignore: must_be_immutable
class _ScaleItemWidget extends StatefulWidget {
  ScaleModel model;

  Function callBack;

  ScaleViewController controller;

  _ScaleItemWidget({Key key, this.model, this.callBack, this.controller})
      : super(key: key);

  @override
  State<_ScaleItemWidget> createState() => __ScaleItemWidgetState();
}

class __ScaleItemWidgetState extends State<_ScaleItemWidget> {
  ScaleViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
    _dealModelItemState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void _dealModelItemState() {
    widget.controller.dataSource.forEach((element) {
      widget.controller.dataSource[widget.controller.currentIndex].state =
          KScaleViewState.center;
      int elementIndex = widget.controller.dataSource.indexOf(element);
      if (elementIndex == widget.controller.currentIndex) {
        return;
      }
      if (widget.controller.amout == 7) {
        if ((elementIndex - widget.controller.currentIndex).abs() == 1) {
          widget.controller.dataSource[elementIndex].state =
              KScaleViewState.first;
        } else if ((elementIndex - widget.controller.currentIndex).abs() == 2) {
          widget.controller.dataSource[elementIndex].state =
              KScaleViewState.second;
        } else {
          widget.controller.dataSource[elementIndex].state =
              KScaleViewState.other;
        }
      }

      if (widget.controller.amout == 5) {
        if ((elementIndex - widget.controller.currentIndex).abs() == 1) {
          widget.controller.dataSource[elementIndex].state =
              KScaleViewState.first;
        } else if ((elementIndex - widget.controller.currentIndex).abs() == 2) {
          widget.controller.dataSource[elementIndex].state =
              KScaleViewState.second;
        }
      }

      if (widget.controller.amout == 3) {
        if ((elementIndex - widget.controller.currentIndex).abs() == 1) {
          widget.controller.dataSource[elementIndex].state =
              KScaleViewState.first;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = 0;
    double fontSize = 0;
    if (widget.model.state == KScaleViewState.other) {
      width = 0;
    } else if (widget.model.state == KScaleViewState.center) {
      width = widget.controller.maxSize;
      fontSize = 20.0;
    } else if (widget.model.state == KScaleViewState.first) {
      width = widget.controller.maxSize * 0.8;
      fontSize = 20 * 0.8;
    } else if (widget.model.state == KScaleViewState.second) {
      width = widget.controller.maxSize * 0.6;
      fontSize = 20 * 0.6;
    } else {
      fontSize = 20 * 0.4;
      width = widget.controller.maxSize * 0.4;
    }

    return GestureDetector(
      child: AnimatedContainer(
        curve: Curves.fastLinearToSlowEaseIn,
        width: width,
        height: width,
        duration: Duration(milliseconds: 500),
        decoration: BoxDecoration(
            color: widget.model.state == KScaleViewState.center
                ? widget.controller.selectColor
                : widget.controller.unSelectColor,
            borderRadius: BorderRadius.circular(width / 2.0),
            boxShadow: [
              BoxShadow(
                  color: Color(0xFFF4F4F4), blurRadius: 3.0, spreadRadius: 6.0)
            ]),
        child: Center(
          child: Text(
            widget.model.title,
            style: TextStyle(
                color: widget.model.state == KScaleViewState.center
                    ? Colors.white
                    : Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: fontSize),
          ),
        ),
      ),
      onTap: () {
        int index = widget.controller.dataSource.indexOf(widget.model);
        widget.controller.currentIndex = index;
        setState(() {});
        _dealModelItemState();
        widget.callBack(widget.model);
      },
    );
  }
}

/// 缩放的数据model
class ScaleModel {
  String title;
  String id;
  KScaleViewState state;
  bool isSelected;
  int index;
  ScaleModel(
      {this.title,
      this.id,
      this.state = KScaleViewState.other,
      this.index,
      this.isSelected = false})
      : assert(id != null, throw "id can not to be null");
  ScaleModel.fromJson(Map json)
      : title = json['title'] ?? '',
        id = json['id'] ?? '',
        index = json['index'] ?? 0;

  Map toJson() {
    Map json = new Map();
    json['title'] = title;
    json['id'] = id;
    json['index'] = index;
    return json;
  }
}

enum KScaleViewState { center, first, second, third, other }

/// controller
class ScaleViewController {
  ScaleViewController({
    this.maxSize = 100.0,
    this.currentIndex = 3,
    this.selectColor = Colors.blue,
    this.unSelectColor = Colors.grey,
    this.borderRadius = 50.0,
    this.amout = 7,
    this.dataSource,
  })  : assert(amout.isOdd && amout < 8,
            "count must be even and must samller than 8"),
        assert(maxSize > 0, "size must be greater than 0"),
        assert(currentIndex >= 0 && currentIndex < amout,
            "index must be greater than 0"),
        assert(dataSource != null && dataSource.length > 0,
            "data must be not null"),
        assert(selectColor != null, "select color can not be null"),
        assert(unSelectColor != null, "unSelect color can not be null"),
        assert(borderRadius > 0, "borderRadius must be greater than 0");

  // 中间视图的最大大小
  double maxSize;

// 默认展示的中间位置
  int currentIndex;

  // 选中的颜色
  Color selectColor;

// 未选中的颜色
  Color unSelectColor;

// 边框的圆角
  double borderRadius;

// 数据源
  List<ScaleModel> dataSource;
  // 设置左右的数量
  int amout = 3;

  dispose() {
    dataSource = null;
    maxSize = null;
    currentIndex = null;
    selectColor = null;
    amout = null;
    borderRadius = null;
    unSelectColor = null;
  }
}

extension myViewState on KScaleViewState {
  String toStr() => this.toString();
  int get index =>
      ["center", "first", "second", "third", "other"].indexOf(toStr());
}

// ignore: must_be_immutable
class HouseFlowWidget extends StatefulWidget {
  List<ScaleModel> dataSource;

  int count;

  Function onTapChanged;

  HouseFlowWidget({Key key, this.dataSource, this.count, this.onTapChanged})
      : super(key: key);

  @override
  State<HouseFlowWidget> createState() => _HouseFlowWidgetState();
}

class _HouseFlowWidgetState extends State<HouseFlowWidget> {
  var _filtersPerScreen;
  var _viewportFractionPerItem;

  int _page;

  PageController _controller;

  int filterCount;

  @override
  void initState() {
    super.initState();
    _filtersPerScreen = widget.count;
    filterCount = widget.dataSource.length;
    _viewportFractionPerItem = 1.0 / _filtersPerScreen;
    _page = 0;
    _controller = PageController(
      initialPage: _page,
      viewportFraction: _viewportFractionPerItem,
    );
    _controller.addListener(_onPageChanged);
  }

  void _onPageChanged() {
    final page = (_controller.page ?? 0).round();
    if (page != _page) {
      _page = page;
      setState(() {
        widget.dataSource.forEach((element) {
          element.isSelected = false;
        });
        widget.dataSource[page].isSelected = true;
      });
      widget.onTapChanged(page);
    }
  }

  void _onFilterTapped(int index) {
    _controller.animateToPage(
      index,
      duration: const Duration(milliseconds: 450),
      curve: Curves.ease,
    );
    setState(() {
      widget.dataSource.forEach((element) {
        element.isSelected = false;
      });
      widget.dataSource[index].isSelected = true;
    });
    widget.onTapChanged(index);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildHouseHorizalList({
    ViewportOffset viewportOffset,
    double itemSize,
  }) {
    return Container(
      height: itemSize,
      margin: EdgeInsets.symmetric(vertical: 12),
      child: Flow(
          delegate: CarouselFlowDelegate(
            viewportOffset: viewportOffset,
            filtersPerScreen: _filtersPerScreen,
          ),
          children: widget.dataSource.map((e) {
            int index = widget.dataSource.indexOf(e);
            return FilterItem(
                onFilterSelected: () => _onFilterTapped(index),
                model: widget.dataSource[index]);
          }).toList()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scrollable(
      controller: _controller,
      axisDirection: AxisDirection.right,
      physics: const PageScrollPhysics(),
      viewportBuilder: (context, viewportOffset) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final itemSize = constraints.maxWidth * _viewportFractionPerItem;
            viewportOffset
              ..applyViewportDimension(constraints.maxWidth)
              ..applyContentDimensions(0.0, itemSize * (filterCount - 1));

            return _buildHouseHorizalList(
                viewportOffset: viewportOffset, itemSize: itemSize);
          },
        );
      },
    );
  }
}

class CarouselFlowDelegate extends FlowDelegate {
  CarouselFlowDelegate({
    this.viewportOffset,
    this.filtersPerScreen,
  }) : super(repaint: viewportOffset);

  final ViewportOffset viewportOffset;
  final int filtersPerScreen;

  @override
  void paintChildren(FlowPaintingContext context) {
    final count = context.childCount;

    // All available painting width
    final size = context.size.width;

    // The distance that a single item "page" takes up from the perspective
    // of the scroll paging system. We also use this size for the width and
    // height of a single item.
    final itemExtent = size / filtersPerScreen;

    // The current scroll position expressed as an item fraction, e.g., 0.0,
    // or 1.0, or 1.3, or 2.9, etc. A value of 1.3 indicates that item at
    // index 1 is active, and the user has scrolled 30% towards the item at
    // index 2.
    final active = viewportOffset.pixels / itemExtent;

    // Index of the first item we need to paint at this moment.
    // At most, we paint 3 items to the left of the active item.
    final min = math.max(0, active.floor() - 3).toInt();

    // Index of the last item we need to paint at this moment.
    // At most, we paint 3 items to the right of the active item.
    final max = math.min(count - 1, active.ceil() + 3).toInt();

    // Generate transforms for the visible items and sort by distance.
    for (var index = min; index <= max; index++) {
      wjPrint("active.floor(): ${active.floor()}");
      wjPrint("active.ceil(): ${active.ceil()}");
      final itemXFromCenter = itemExtent * index - viewportOffset.pixels;
      final percentFromCenter = 1.0 - (itemXFromCenter / (size / 2)).abs();
      final itemScale = 0.5 + (percentFromCenter * 0.5);
      final opacity = 0.25 + (percentFromCenter * 0.75);

      final itemTransform = Matrix4.identity()
        ..translate((size - itemExtent) / 2)
        ..translate(itemXFromCenter)
        ..translate(itemExtent / 2, itemExtent / 2)
        ..multiply(Matrix4.diagonal3Values(itemScale, itemScale, 1.0))
        ..translate(-itemExtent / 2, -itemExtent / 2);

      context.paintChild(
        index,
        transform: itemTransform,
        opacity: opacity,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CarouselFlowDelegate oldDelegate) {
    return oldDelegate.viewportOffset != viewportOffset;
  }
}

@immutable
class FilterItem extends StatelessWidget {
  const FilterItem({
    this.model,
    this.onFilterSelected,
  });

  final ScaleModel model;
  final VoidCallback onFilterSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onFilterSelected,
      child: AspectRatio(
        aspectRatio: 1.0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipOval(
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: model.isSelected ? Colors.blue : Colors.grey[300],
                  boxShadow: model.isSelected
                      ? [
                          BoxShadow(
                              color: Color(0xFFF4F4F4),
                              offset: Offset(0, 3),
                              blurRadius: 6,
                              spreadRadius: 10)
                        ]
                      : []),
              child: Text(
                model.title ?? '',
                style: TextStyle(
                    fontSize: 18,
                    color: model.isSelected ? Colors.white : Colors.black),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
