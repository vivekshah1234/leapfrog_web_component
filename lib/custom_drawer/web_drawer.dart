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
    Widget? expandIcon,
    Widget? collapsedIcon,
    this.logOutText,
    this.size,
    this.drawerTextStyle,
    this.versionTextStyle,
    this.searchTextStyle,
  }) : prefix = prefix ?? const SizedBox.shrink(),
       drawerIcon = drawerIcon ?? const Icon(Icons.menu),
       expandIcon = expandIcon ?? const Icon(Icons.expand_more, color: Colors.white),
       collapsedIcon = collapsedIcon ?? const Icon(Icons.expand_less, color: Colors.white),
       profileBackground = profileBackground ?? Colors.white;

  /// List of items to be displayed in the drawer menu.
  final ValueNotifier<List<DrawerMenuItem>> menuItems;

  /// Callback function triggered when a menu item is tapped.
  /// Returns the navigation route associated with the tapped item.
  final Function(String navigationRoute) onMenuTap;

  /// Callback function triggered when the logout action is tapped.
  final Function onLogOutClick;

  /// Background color of the drawer.
  final Color drawerBackground;

  /// Text color for the selected menu item.
  final Color drawerTextSelectedColor;

  /// Widget displayed as a prefix (e.g., logo or avatar) in the drawer.
  final Widget prefix;

  /// Widget shown as the icon to expand the drawer.
  final Widget expandIcon;

  /// Widget shown as the icon to collapse the drawer.
  final Widget collapsedIcon;

  /// Optional widget displayed as the drawer header (e.g., user info, profile).
  final Widget? drawerHeader;

  /// Widget used as the drawer's main icon (typically hamburger menu).
  final Widget drawerIcon;

  /// Whether the search bar should be displayed at the top of the drawer.
  final bool isSearchShow;

  /// Color of the drawer icon.
  final Color drawerIconColor;

  /// Background color for the profile section in the drawer (if applicable).
  final Color? profileBackground;

  /// Size of the drawer icon.
  final double drawerIconSize;

  /// Optional app version string displayed in the drawer (usually at the bottom).
  final String? version;

  /// Optional user's first name to be displayed.
  final String? name;

  /// Optional user's last name to be displayed.
  final String? lastName;

  /// Optional user's email to be displayed.
  final String? email;

  /// Optional custom text to be shown for the logout option.
  final String? logOutText;

  /// Whether to show a clear icon (usually in search bar).
  final bool isShowClearIcon;

  /// Optional size of the drawer (typically used when drawer is customized).
  final Size? size;

  /// Optional text style used for drawer menu items.
  final TextStyle? drawerTextStyle;

  /// Optional text style used for displaying the app version.
  final TextStyle? versionTextStyle;

  /// Optional text style used for the search field in the drawer.
  final TextStyle? searchTextStyle;

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

  void changeMenu(String? title, String? childTitle, DrawerMenuItem item, Function(String route) onTap, bool isExpanded) {
    for (var menu in mainMenuItem.value) {
      final isSelectedMenu = menu.title == title;
      // Reset selection
      menu.isSelected = false;

      // Handle top-level menu selection
      if (isSelectedMenu) {
        menu.isSelected = true;
        menu.isExpanded.value = isExpanded;
        onTap(menu.route);
      } else {
        menu.isSelected = false;
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

  drawerStateChange() {
    isMenuOpen.value = !isMenuOpen.value;
    Future.delayed(const Duration(milliseconds: 500), () {
      isDrawerExpand.value = !isDrawerExpand.value;
    });
  }

  searchMenu(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    List<DrawerMenuItem> result = [];
    _debounce = Timer(const Duration(milliseconds: 500), () {
      final lowerQuery = query.toLowerCase();
      result = mainMenuItem.value
          .where((menu) {
            String menuTitle = menu.title.toLowerCase();
            final isMainMatch = menuTitle.startsWith(lowerQuery);
            final matchingSubMenus = menu.subCategories?.where((subMenu) => subMenu.title.toLowerCase().startsWith(lowerQuery)).toList();
            return isMainMatch || (matchingSubMenus != null && matchingSubMenus.isNotEmpty);
          })
          .map((menu) {
            final matchingSubMenus = menu.subCategories?.where((subMenu) => subMenu.title.toLowerCase().startsWith(lowerQuery)).toList();
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
    String firstInitial = firstName.isNotEmpty ? firstName[0].toUpperCase() : '';
    String lastInitial = (lastName != null && lastName.isNotEmpty) ? lastName[0].toUpperCase() : '';
    return '$firstInitial$lastInitial';
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isMenuOpen,
      builder: (context, value, child) => AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        width: isMenuOpen.value ? 300 : 64,
        color: widget.drawerBackground,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
            if (isMenuOpen.value) ...[const SizedBox(height: 10), if (widget.drawerHeader != null) widget.drawerHeader!, const SizedBox(height: 20)],
            Expanded(
              child: ValueListenableBuilder<List<DrawerMenuItem>>(
                valueListenable: filerManuList,
                builder: (context, value, child) {
                  return Column(
                    children: [
                      if (widget.isSearchShow) ...[
                        if (isMenuOpen.value) ...[
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(10)),
                              height: 50, // Fixed height for the TextField
                              child: TextField(
                                controller: searchController,
                                onChanged: (value) => searchMenu(value),
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(vertical: 12), // Vertical padding for text
                                  hintText: 'Search',
                                  isDense: true,
                                  prefixIcon: widget.prefix,
                                  suffixIconColor: widget.drawerIconColor,
                                  hintStyle: const TextStyle(color: Colors.white60),
                                  suffixIcon: widget.isShowClearIcon
                                      ? IconButton(
                                          icon: Icon(Icons.clear, color: widget.drawerIconColor),
                                          onPressed: () {
                                            searchController.clear();
                                            searchMenu('');
                                          },
                                        )
                                      : null,
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                ),
                                style: widget.searchTextStyle,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ],
                      Expanded(
                        child: ListView(
                          shrinkWrap: true,
                          children: (value.map((item) {
                            return Theme(
                              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                              child: isMenuOpen.value
                                  ? ExpansionTile(
                                      backgroundColor: item.subCategories != null
                                          ? Colors.transparent
                                          : (item.isSelected ? Colors.white12 : Colors.white10),
                                      childrenPadding: const EdgeInsets.symmetric(horizontal: 10),
                                      dense: false,
                                      tilePadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                      initiallyExpanded: item.isExpanded.value,
                                      onExpansionChanged: isMenuOpen.value
                                          ? (expanded) {
                                              if (!isMenuOpen.value) return;
                                              changeMenu(item.title, null, item, (route) {
                                                if (item.subCategories == null) {
                                                  widget.onMenuTap(route);
                                                }
                                              }, expanded);
                                            }
                                          : null,
                                      leading: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                                        child: Image.asset(item.iconUrl, color: widget.drawerIconColor),
                                      ),
                                      title: isMenuOpen.value ? Text(item.title, style: widget.drawerTextStyle) : const SizedBox.shrink(),

                                      trailing: isMenuOpen.value
                                          ? Visibility(
                                              visible: (item.subCategories != null && item.subCategories!.isNotEmpty),
                                              child: ValueListenableBuilder<bool>(
                                                valueListenable: item.isExpanded,
                                                builder: (context, value, child) => value ? widget.expandIcon : widget.collapsedIcon,
                                              ),
                                            )
                                          : const SizedBox.shrink(),
                                      children: isMenuOpen.value
                                          ? (item.subCategories != null)
                                                ? item.subCategories!.map((subItem) {
                                                    return Visibility(
                                                      visible: subItem.isVisible,
                                                      child: isMenuOpen.value
                                                          ? Theme(
                                                              data: Theme.of(context).copyWith(
                                                                dividerColor: Colors.transparent,
                                                                expansionTileTheme: ExpansionTileThemeData(
                                                                  backgroundColor: subItem.isSelected ? Colors.white12 : Colors.transparent,
                                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                                ),
                                                              ),
                                                              child: ExpansionTile(
                                                                onExpansionChanged: (value) {
                                                                  changeMenu(null, subItem.title, item, (route) {
                                                                    widget.onMenuTap("${item.route}/$route");
                                                                  }, false);
                                                                },
                                                                tilePadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                                                trailing: SizedBox.shrink(),
                                                                leading: Padding(
                                                                  padding: const EdgeInsets.symmetric(horizontal: 30),
                                                                  child: Image.asset(subItem.iconUrl, color: widget.drawerIconColor, height: 18),
                                                                ),
                                                                title: isMenuOpen.value
                                                                    ? Text(
                                                                        subItem.title,
                                                                        style: widget.drawerTextStyle,
                                                                        maxLines: 1,
                                                                        overflow: TextOverflow.ellipsis,
                                                                        softWrap: true,
                                                                      )
                                                                    : SizedBox.shrink(),
                                                              ),
                                                            )
                                                          : Image.asset(
                                                              subItem.iconUrl,
                                                              color: widget.drawerIconColor,
                                                              height: widget.drawerIconSize,
                                                            ),
                                                    );
                                                  }).toList()
                                                : []
                                          : [],
                                    )
                                  : Container(
                                      decoration: BoxDecoration(
                                        color: item.isSelected ? Colors.white12 : Colors.transparent,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      //margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                      padding: const EdgeInsets.symmetric(vertical: 20),
                                      child: Image.asset(item.iconUrl, color: widget.drawerIconColor, height: widget.drawerIconSize),
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
              onExpansionChanged: (value) => drawerStateChange(),
              tilePadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              leading: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: Icon(Icons.logout, color: widget.drawerIconColor, size: widget.drawerIconSize),
              ),
              title: isMenuOpen.value ? Text(widget.logOutText ?? "Logout", style: widget.drawerTextStyle) : const SizedBox.shrink(),
              backgroundColor: Colors.transparent,
              textColor: Colors.white,
              iconColor: Colors.white,
              trailing: const SizedBox.shrink(),
              children: [
                ListTile(
                  onTap: () => widget.onLogOutClick(),
                  title: Text(widget.logOutText ?? "Logout", style: widget.drawerTextStyle),
                ),
              ],
            ),
            if (widget.version != null)
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("V ${widget.version ?? ""}", textAlign: TextAlign.center, style: widget.versionTextStyle),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
