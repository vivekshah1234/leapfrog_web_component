import 'dart:async';

import 'package:flutter/material.dart';
import 'package:leapfrog_web_component/custom_drawer/constant/drawer_colors.dart';
import 'package:leapfrog_web_component/custom_drawer/model/drawer_menu_item.dart';

class WebDrawer extends StatefulWidget {
  const WebDrawer({
    super.key,
    required this.menuItems,
    required this.onMenuTap,
    required this.onLogOutClick,
    required this.drawerTextSelectedColor,
    this.drawerBackground = const Color(0xFF0D1B2A),
    Widget? prefix,

    this.drawerHeader,
    Widget? drawerIcon,
    Color? profileBackground,
    this.name,
    this.lastName,
    this.email,
    this.version,
    this.drawerIconColor = DrawerColors.drawerIconColor,
    this.drawerIconSize = 18,
    this.isSearchShow = false,
    this.isShowClearIcon = false,
    TextStyle? drawerTextStyle,
  }) : prefix = prefix ?? const SizedBox.shrink(),
       drawerIcon = drawerIcon ?? const Icon(Icons.menu),

       profileBackground = profileBackground ?? Colors.white;

  final ValueNotifier<List<DrawerMenuItem>> menuItems;
  final Function(String navigaionRoute) onMenuTap;
  final Function onLogOutClick;
  final Color drawerBackground;
  final Color drawerTextSelectedColor;
  final Widget prefix;

  final Widget? drawerHeader;
  final Widget drawerIcon;
  final bool isSearchShow;
  final Color drawerIconColor;
  final Color? profileBackground;
  final double drawerIconSize;
  final String? version;
  final String? name;
  final String? lastName;
  final String? email;
  final bool isShowClearIcon;

  @override
  State<WebDrawer> createState() => _WebDrawerState();
}

class _WebDrawerState extends State<WebDrawer> {
  TextEditingController searchController = TextEditingController();
  ValueNotifier<List<DrawerMenuItem>> mainMenuItem = ValueNotifier([]);
  ValueNotifier<List<DrawerMenuItem>> filerManuList = ValueNotifier([]);
  ValueNotifier<bool> isMenuOpen = ValueNotifier(true);
  ValueNotifier<bool> isDrawerExpand = ValueNotifier(true);
  ValueNotifier<int> selectedMenuId = ValueNotifier(0);
  Timer? _debounce;
  @override
  void initState() {
    super.initState();
    mainMenuItem = widget.menuItems;
    filerManuList.value.addAll(widget.menuItems.value);
  }

  void changeMenu(
    String? title,
    String? childTitle,
    DrawerMenuItem item,
    Function(String route) onTap,
    bool isExpanded,
  ) {
    for (var menu in mainMenuItem.value) {
      final isCurrent = menu.title == item.title;
      final isSelectedMenu = menu.title == title;

      // Expand the current item
      menu.isExpanded.value = isCurrent;
      // Reset selection
      menu.isSelected = false;

      // Handle top-level menu selection
      if (isSelectedMenu) {
        menu.isSelected = true;
        onTap(menu.route);
      }

      // Handle subcategories
      if (menu.subCategories != null) {
        for (var subMenu in menu.subCategories!) {
          subMenu.isSelected = subMenu.title == childTitle;
          if (subMenu.isSelected) {
            onTap(subMenu.route);
          } else {
            subMenu.isSelected = false;
          }
        }
      }
    }
  }

  void drawerStateChange() {
    isMenuOpen.value = !isMenuOpen.value;
    Future.delayed(const Duration(milliseconds: 500), () {
      isDrawerExpand.value = !isDrawerExpand.value;
    });
  }

  void searchMenu(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    List<DrawerMenuItem> result = [];
    _debounce = Timer(const Duration(milliseconds: 500), () {
      final lowerQuery = query.toLowerCase();
      result =
          mainMenuItem.value
              .where((menu) {
                String menuTitle = menu.title.toLowerCase();
                final isMainMatch = menuTitle.startsWith(lowerQuery);
                final matchingSubMenus =
                    menu.subCategories
                        ?.where(
                          (subMenu) => subMenu.title.toLowerCase().startsWith(
                            lowerQuery,
                          ),
                        )
                        .toList();
                return isMainMatch ||
                    (matchingSubMenus != null && matchingSubMenus.isNotEmpty);
              })
              .map((menu) {
                final matchingSubMenus =
                    menu.subCategories
                        ?.where(
                          (subMenu) => subMenu.title.toLowerCase().startsWith(
                            lowerQuery,
                          ),
                        )
                        .toList();
                return DrawerMenuItem(
                  title: menu.title,
                  route: menu.route,
                  iconUrl: menu.iconUrl,
                  isExpanded: menu.isExpanded,

                  subCategories: matchingSubMenus,
                );
              })
              .toList();
      filerManuList.value = result;
    });
  }

  String getUserInitials(String firstName, [String? lastName]) {
    String firstInitial =
        firstName.isNotEmpty ? firstName[0].toUpperCase() : '';
    String lastInitial =
        (lastName != null && lastName.isNotEmpty)
            ? lastName[0].toUpperCase()
            : '';
    return '$firstInitial$lastInitial';
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isMenuOpen,
      builder:
          (context, value, child) => AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            width: isMenuOpen.value ? 300 : 64,
            color: widget.drawerBackground,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: widget.drawerIcon,
                      color: widget.drawerIconColor,
                      iconSize: widget.drawerIconSize,
                      onPressed: () => drawerStateChange(),
                    ),
                  ),
                ),
                if (isMenuOpen.value) ...[
                  const SizedBox(height: 10),
                  if (widget.drawerHeader != null) widget.drawerHeader!,
                  const SizedBox(height: 20),
                ],
                Expanded(
                  child: ValueListenableBuilder<List<DrawerMenuItem>>(
                    valueListenable: filerManuList,
                    builder: (context, value, child) {
                      return Column(
                        children: [
                          if (widget.isSearchShow) ...[
                            if (isMenuOpen.value) ...[
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.white10,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  height: 50, // Fixed height for the TextField
                                  child: TextField(
                                    controller: searchController,
                                    onChanged: (value) => searchMenu(value),
                                    decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            vertical: 12,
                                          ), // Vertical padding for text
                                      hintText: 'Search',
                                      isDense: true,
                                      prefixIcon: widget.prefix,
                                      suffixIconColor: Colors.white,
                                      hintStyle: const TextStyle(
                                        color: Colors.white60,
                                      ),
                                      suffixIcon:
                                          widget.isShowClearIcon
                                              ? IconButton(
                                                icon: Icon(
                                                  Icons.clear,
                                                  color: Colors.white,
                                                ),
                                                onPressed: () {
                                                  searchController.clear();
                                                  searchMenu('');
                                                },
                                              )
                                              : null,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],
                          ],
                          Expanded(
                            child: ListView(
                              shrinkWrap: true,
                              children:
                                  (value.map((item) {
                                    return Theme(
                                      data: Theme.of(context).copyWith(
                                        dividerColor: Colors.transparent,
                                      ),
                                      child: Container(
                                        margin: EdgeInsets.only(bottom: 10),
                                        child:
                                            isMenuOpen.value
                                                ? ExpansionTile(
                                                  backgroundColor:
                                                      item.subCategories != null
                                                          ? Colors.transparent
                                                          : (item.isSelected
                                                              ? Colors.white12
                                                              : Colors.white10),
                                                  childrenPadding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                      ),
                                                  dense: false,
                                                  tilePadding:
                                                      const EdgeInsets.symmetric(
                                                        vertical: 5,
                                                        horizontal: 10,
                                                      ),
                                                  initiallyExpanded:
                                                      item.isExpanded.value,
                                                  onExpansionChanged:
                                                      isMenuOpen.value
                                                          ? (expanded) {
                                                            if (!isMenuOpen
                                                                .value)
                                                              return;
                                                            changeMenu(
                                                              item.title,
                                                              null,
                                                              item,
                                                              (route) {
                                                                if (item.subCategories ==
                                                                    null) {
                                                                  widget
                                                                      .onMenuTap(
                                                                        route,
                                                                      );
                                                                }
                                                              },
                                                              expanded,
                                                            );
                                                          }
                                                          : null,
                                                  leading: Padding(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 8,
                                                          vertical: 16,
                                                        ),
                                                    child: Image.asset(
                                                      item.iconUrl,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  title:
                                                      isMenuOpen.value
                                                          ? Text(
                                                            item.title,
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          )
                                                          : const SizedBox.shrink(),
                                                  trailing:
                                                      isMenuOpen.value
                                                          ? Visibility(
                                                            visible:
                                                                (item.subCategories !=
                                                                        null &&
                                                                    item
                                                                        .subCategories!
                                                                        .isNotEmpty),
                                                            child: Icon(
                                                              item
                                                                      .isExpanded
                                                                      .value
                                                                  ? Icons
                                                                      .arrow_drop_up
                                                                  : Icons
                                                                      .arrow_drop_down,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          )
                                                          : const SizedBox.shrink(),
                                                  children:
                                                      isMenuOpen.value
                                                          ? (item.subCategories !=
                                                                  null)
                                                              ? item.subCategories!.map((
                                                                subItem,
                                                              ) {
                                                                //log("Sub Menu ${subItem.toJson()}");
                                                                return Visibility(
                                                                  visible:
                                                                      subItem
                                                                          .isVisible,
                                                                  child:
                                                                      isMenuOpen
                                                                              .value
                                                                          ? Theme(
                                                                            data: Theme.of(
                                                                              context,
                                                                            ).copyWith(
                                                                              dividerColor:
                                                                                  Colors.transparent,
                                                                              expansionTileTheme: ExpansionTileThemeData(
                                                                                backgroundColor:
                                                                                    subItem.isSelected
                                                                                        ? Colors.white12
                                                                                        : Colors.transparent,
                                                                                shape: RoundedRectangleBorder(
                                                                                  borderRadius: BorderRadius.circular(
                                                                                    10,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            child: ExpansionTile(
                                                                              onExpansionChanged: (
                                                                                value,
                                                                              ) {
                                                                                changeMenu(
                                                                                  null,
                                                                                  subItem.title,
                                                                                  item,
                                                                                  (
                                                                                    route,
                                                                                  ) {
                                                                                    widget.onMenuTap(
                                                                                      "${item.route}/$route",
                                                                                    );
                                                                                  },
                                                                                  false,
                                                                                );
                                                                              },
                                                                              tilePadding: const EdgeInsets.symmetric(
                                                                                vertical:
                                                                                    5,
                                                                                horizontal:
                                                                                    10,
                                                                              ),
                                                                              trailing:
                                                                                  SizedBox.shrink(),
                                                                              leading: Padding(
                                                                                padding: const EdgeInsets.symmetric(
                                                                                  horizontal:
                                                                                      30,
                                                                                ),
                                                                                child: Image.asset(
                                                                                  subItem.iconUrl,
                                                                                  color:
                                                                                      Colors.white,
                                                                                  height:
                                                                                      18,
                                                                                ),
                                                                              ),
                                                                              title:
                                                                                  isMenuOpen.value
                                                                                      ? Text(
                                                                                        subItem.title,
                                                                                        style: TextStyle(
                                                                                          color:
                                                                                              Colors.white,
                                                                                        ),
                                                                                        maxLines:
                                                                                            1,
                                                                                        overflow:
                                                                                            TextOverflow.ellipsis,
                                                                                        softWrap:
                                                                                            true,
                                                                                      )
                                                                                      : SizedBox.shrink(),
                                                                            ),
                                                                          )
                                                                          : Image.asset(
                                                                            subItem.iconUrl,
                                                                            color:
                                                                                Colors.white,
                                                                            height:
                                                                                widget.drawerIconSize,
                                                                          ),
                                                                );
                                                              }).toList()
                                                              : []
                                                          : [],
                                                )
                                                : Container(
                                                  decoration: BoxDecoration(
                                                    color:
                                                        item.isSelected
                                                            ? Colors.white12
                                                            : Colors
                                                                .transparent,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          10,
                                                        ),
                                                  ),
                                                  //margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        vertical: 20,
                                                      ),
                                                  child: Image.asset(
                                                    item.iconUrl,
                                                    color: Colors.white,
                                                    height:
                                                        widget.drawerIconSize,
                                                  ),
                                                ),
                                      ),
                                    );
                                  }).toList()),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                ExpansionTile(
                  onExpansionChanged: (value) => widget.onLogOutClick(),
                  tilePadding: const EdgeInsets.symmetric(
                    vertical: 5,
                    horizontal: 10,
                  ),
                  leading: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 16,
                    ),
                    child: Icon(
                      Icons.logout,
                      color: widget.drawerIconColor,
                      size: widget.drawerIconSize,
                    ),
                  ),
                  title:
                      isMenuOpen.value
                          ? Text(
                            "Logout",
                            style: TextStyle(
                              color: widget.drawerTextSelectedColor,
                            ),
                          )
                          : const SizedBox.shrink(),
                  backgroundColor: Colors.transparent,
                  textColor: Colors.white,
                  iconColor: Colors.white,
                  trailing: const SizedBox.shrink(),
                ),
                if (widget.version != null)
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "V ${widget.version ?? ""}",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
    );
  }
}
