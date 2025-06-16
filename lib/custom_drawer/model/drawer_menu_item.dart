import 'package:flutter/material.dart';
import 'package:leapfrog_web_component/custom_drawer/model/drawer_sub_menu.dart';


class DrawerMenuItem {
  final String title;
  final String route;
  final bool isVisible;
  final String iconUrl;
  bool isSelected;
  ValueNotifier<bool> isExpanded = ValueNotifier(false);
  List<DrawerSubMenuMenuItem>? subCategories;

  DrawerMenuItem({
    required this.title,
    required this.iconUrl,
    this.isVisible = true,
    required this.isExpanded,
    this.isSelected = false,
    required this.route,
    this.subCategories,
  });

  DrawerMenuItem copyWith({
    String? menuId,
    String? title,
    String? route,
    bool? isVisible,
    String? iconUrl,
    bool isSelected = false,
    ValueNotifier<bool>? isExpanded,
    List<DrawerSubMenuMenuItem>? subCategories,
  }) {
    return DrawerMenuItem(
      title: title ?? this.title,
      route: route ?? this.route,
      isVisible: isVisible ?? this.isVisible,
      iconUrl: iconUrl ?? this.iconUrl,
      isSelected: isSelected,
      isExpanded: isExpanded ?? this.isExpanded,
      subCategories: subCategories ?? this.subCategories,
    );
  }

  toJson() => {
    'title': title,
    'route': route,

    'isVisible': isVisible,
    'iconUrl': iconUrl,
    'isSelected': isSelected,
    'isExpanded': isExpanded,
    'subCategories': subCategories,
  };

  fromJson(Map<String, dynamic> json) => DrawerMenuItem(
    title: json['title'],
    route: json['route'],

    isVisible: json['isVisible'],
    iconUrl: json['iconUrl'],
    isSelected: json['isSelected'],
    isExpanded: json['isExpanded'],
    subCategories: json['subCategories'],
  );
}
