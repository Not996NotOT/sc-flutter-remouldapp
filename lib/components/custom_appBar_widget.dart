import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatefulWidget {
  final EdgeInsetsGeometry padding;
  final double height;
  final List<Color> bgColorList;
  final Text title;
  final Widget leftTool;
  final Widget rightTool;

  const CustomAppBar(
      {Key key,
      this.padding,
      this.height,
      this.bgColorList,
      this.title,
      this.leftTool,
      this.rightTool})
      : super(key: key);

  @override
  _CustomAppBarState createState() => _CustomAppBarState(
      padding, height, bgColorList, title, leftTool, rightTool);
}

class _CustomAppBarState extends State<CustomAppBar> {
// CustomAppBar List<ReleaseModel> releaseList = [];
  final EdgeInsetsGeometry padding;
  final double height;
  final List bgColorList;
  final Text title;
  final Widget leftTool;
  final Widget rightTool;

  _CustomAppBarState(this.padding, this.height, this.bgColorList, this.title,
      this.leftTool, this.rightTool);

  @override
  void initState() {
    super.initState();
//    releaseList.add(new ReleaseModel("", new List()));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        //背景装饰
        gradient: RadialGradient(
            //背景径向渐变
            colors: (bgColorList == null)
                ? [Colors.greenAccent, Colors.greenAccent]
                : bgColorList,
            center: Alignment.topLeft,
            radius: 5),
      ),
      height: height,
      padding: padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        //交叉轴的布局方式，对于column来说就是水平方向的布局方式
        crossAxisAlignment: CrossAxisAlignment.center,
        //就是字child的垂直布局方向，向上还是向下
        verticalDirection: VerticalDirection.down,
        children: <Widget>[
          Container(child: leftTool == null ? null : leftTool),
          Container(child: title == null ? null : title),
          Container(child: rightTool == null ? null : rightTool)
        ],
      ),
    );
  }
}
