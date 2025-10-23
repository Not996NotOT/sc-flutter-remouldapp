import 'package:flutter/material.dart';

class CommonNavBottomBar extends StatefulWidget {

  
  CommonNavBottomBar({Key key}):super(key: key);

  @override
  State<CommonNavBottomBar> createState() => _CommonNavBottomBarState();
}

class _CommonNavBottomBarState extends State<CommonNavBottomBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: kBottomNavigationBarHeight,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          
        ],
      ),
    );
  }
}

class CommonNavBottomBarItem extends StatefulWidget {

  Image icon;
  Image selectIcon;
  Text title;
  CommonNavBottomBarItem({Key key,this.icon,this.title,this.selectIcon}):super(key: key);

  @override
  State<CommonNavBottomBarItem> createState() => _CommonNavBottomBarItemState();
}

class _CommonNavBottomBarItemState extends State<CommonNavBottomBarItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          widget.icon ?? SizedBox() ,
          widget.title?? SizedBox(),
        ],
      ),
      onTap: (){

      },
    );
  }
}

