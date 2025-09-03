import 'package:flutter/cupertino.dart';

class DrawerMenuItem {
  final int menuId;
  final int? subMenuId;
  final String title;
  final String route;
  final bool isVisible;
  final String iconUrl;
  ValueNotifier<bool> isSelected;
  ValueNotifier<bool> isExpanded;
  List<DrawerMenuItem>? subCategories;

  DrawerMenuItem({
    required this.title,
    required this.iconUrl,
    this.isVisible = true,
    ValueNotifier<bool>? isSelected,
    ValueNotifier<bool>? isExpanded,
    required this.route,
    this.subCategories,
    required this.menuId,
    this.subMenuId,
  }) : isSelected = isSelected ?? ValueNotifier(false),
       isExpanded = isExpanded ?? ValueNotifier(false);

  Map<String, dynamic> toJson() => {
    'title': title,
    'route': route,
    'menuId': menuId,
    'subMenuId': subMenuId,
    'isVisible': isVisible,
    'iconUrl': iconUrl,
    'isSelected': isSelected,
    'isExpanded': isExpanded,
    'subCategories': subCategories,
  };

  fromJson(Map<String, dynamic> json) => DrawerMenuItem(
    title: json['title'],
    route: json['route'],
    menuId: json['menuId'],
    subMenuId: json['subMenuId'],
    isVisible: json['isVisible'],
    iconUrl: json['iconUrl'],
    isSelected: json['isSelected'],
    isExpanded: json['isExpanded'],
    subCategories: json['subCategories'],
  );
}
