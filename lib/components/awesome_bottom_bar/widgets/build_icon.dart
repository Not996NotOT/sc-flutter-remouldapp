import 'package:flutter/material.dart';

import '../count_style.dart';
import '../tab_item.dart';

class BuildIcon extends StatelessWidget {
  final TabItem item;
  final double iconSize;
  final Color iconColor;
  final CountStyle countStyle;
  final bool isSelect;

  const BuildIcon({
    Key key,
    this.item,
    this.iconColor,
    this.iconSize = 22,
    this.countStyle,
    this.isSelect = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget icon;
    if(item is TabItemImage){
      TabItemImage image = item;
      icon = Image.asset(isSelect ? image.selectIcon : image.icon,width: iconSize,height: iconSize,fit: BoxFit.contain,);
    }else{
      icon = Icon(
        item.icon,
        size: iconSize,
        color: iconColor,
      );
    }

    if (item.count is Widget) {
      double sizeBadge = countStyle.size ?? 18;
      return Stack(
        clipBehavior: Clip.none,
        children: [
         item is TabItemIcon ? Icon(
            item.icon,
            size: iconSize,
            color: iconColor,
          ) : Image.asset(isSelect ? (item as TabItemImage).selectIcon : (item as TabItemImage).icon,width: iconSize,height: iconSize,fit: BoxFit.contain,),
          PositionedDirectional(
            start: iconSize - sizeBadge / 2,
            top: -sizeBadge / 2,
            child: item.count,
          ),
        ],
      );
    }
    return icon;
  }
}
