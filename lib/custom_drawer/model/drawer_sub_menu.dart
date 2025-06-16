class DrawerSubMenuMenuItem {
  final String title;
  final String route;

  final bool isVisible;
  final String iconUrl;
  bool isSelected;

  DrawerSubMenuMenuItem({required this.title, required this.iconUrl, this.isVisible = true, this.isSelected = false, required this.route});

  DrawerSubMenuMenuItem copyWith({String? title, String? route, Function()? onTap, bool? isVisible, String? iconUrl, bool? isSelected}) {
    return DrawerSubMenuMenuItem(
      title: title ?? this.title,
      route: route ?? this.route,

      isVisible: isVisible ?? this.isVisible,
      iconUrl: iconUrl ?? this.iconUrl,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  toJson() => {'title': title, 'route': route, 'isVisible': isVisible, 'iconUrl': iconUrl, 'isSelected': isSelected};

  fromJson(Map<String, dynamic> json) => DrawerSubMenuMenuItem(
    title: json['title'],
    route: json['route'],
    isVisible: json['isVisible'],
    iconUrl: json['iconUrl'],
    isSelected: json['isSelected'],
  );
}
