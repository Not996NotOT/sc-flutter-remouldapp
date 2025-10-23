import 'package:flutter/material.dart';

class TabItem<T> {
  final T icon;
  final String title;
  final Widget count;
  final String key;

  const TabItem({
    this.icon,
    this.title,
    this.count,
    this.key,
  });

}

class TabItemIcon<T> extends TabItem{
  final T icon;
  final String title;
  final Widget count;
  final String key;

  const TabItemIcon({
    this.icon,
    this.title,
    this.count,
    this.key,
  }) : assert(icon is IconData || icon is Widget, 'TabItemIcon only support IconData and Widget');
}

class TabItemImage<T> extends TabItem {
  final String icon;
  final String selectIcon;
  final String title;
  final Widget count;
  final String key;

  const TabItemImage({
    this.icon,
    this.selectIcon,
    this.title,
    this.count,
    this.key,
  }) : assert(icon is String && selectIcon is String,'TabItemImage icon and selectIcon only support String');
}
