library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:leapfrog_web_component/custom_drawer/constant/drawer_colors.dart';
import 'package:leapfrog_web_component/custom_drawer/model/drawer_menu_item.dart'
    show DrawerMenuItem;
import 'package:leapfrog_web_component/custom_drawer/widget/header_with_animation.dart';
import 'package:leapfrog_web_component/custom_drawer/widget/web_drawer.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({
    super.key,
    required this.child,
    required this.onMenuTap,
    Widget? prefix,
    Widget? drawerIcon,
    Widget? drawerHeader,
    this.headerWidget,
    this.drawerIconSize = 24,
    this.menuItems = const [],
    this.drawerIconColor = DrawerColors.drawerIconColor,
    this.headerColor = DrawerColors.haderColor,
    this.drawerColor = DrawerColors.drawerBackground,
    this.drawerTextSelectedColor = DrawerColors.drawerIconColor,
    this.titleName,
    TextStyle? titleStyle,
    TextStyle? drawerTextStyle,
    TextStyle? userNameStyle,
    TextStyle? userLatsNameStyle,
    Color? profileBackground,
    this.profileImageUrl,
    this.version,
    this.userFirstName,
    this.userEmail,
    this.userLastName,
    this.isSearchShow = false,
    this.isShowUserProfile = false,
    this.isShowClearIcon = false,
    this.isShowUserName = false,
    Widget? expandIcon,
    Widget? collapsedIcon,
    this.customAppBarWidget,
    required this.onLogOutClick,
  }) : prefix = prefix ?? const SizedBox.shrink(),
       drawerIcon = drawerIcon ?? const Icon(Icons.menu),
       titleStyle = const TextStyle(color: Colors.white, fontSize: 20),
       drawerTextStyle = const TextStyle(color: Colors.white, fontSize: 20),
       userNameStyle = const TextStyle(color: Colors.white, fontSize: 16),
       userLatsNameStyle = const TextStyle(color: Colors.white, fontSize: 16),
       profileBackground = profileBackground ?? Colors.transparent,
       expandIcon =
           expandIcon ?? const Icon(Icons.expand_more, color: Colors.white),
       collapsedIcon =
           collapsedIcon ?? const Icon(Icons.expand_less, color: Colors.white),
       drawerHeader = drawerHeader ?? const SizedBox.shrink();

  /// Page to display left side of the drawer
  final Widget child;

  final Widget prefix;

  /// Drawer header
  final Widget? drawerHeader;

  /// Header widget
  final Widget? headerWidget;

  /// Widget shown as the icon to expand the drawer.
  final Widget expandIcon;

  /// Widget shown as the icon to collapse the drawer.
  final Widget collapsedIcon;

  /// Drawer icon
  final Widget drawerIcon;

  /// Drawer header color
  final Color headerColor;

  /// Background color of the drawer
  final Color drawerColor;

  /// Background color of the profile
  final Color profileBackground;

  /// Selected text color of the drawer
  final Color drawerTextSelectedColor;

  /// Is show search to hanlde visibility of search box
  final bool isSearchShow;

  /// Is show profile to handle visibility of profile
  final bool isShowUserProfile;

  /// Is show user name to handle visibility of user name
  final bool isShowUserName;

  /// drawer icon size
  final double drawerIconSize;

  /// dawer icon color
  final Color drawerIconColor;

  /// Page title
  final String? titleName;

  /// Title TextStyle
  final TextStyle? titleStyle;

  // User name style
  final TextStyle? userNameStyle;

  /// User first name
  final String? userFirstName;

  /// User last name
  final String? userLastName;

  /// User email
  final String? userEmail;

  /// User profile image
  final String? profileImageUrl;

  /// Last name style
  final TextStyle? userLatsNameStyle;

  /// Version of the app
  final String? version;

  /// Menu items to display in the drawer
  final List<DrawerMenuItem> menuItems;

  /// on menu tap to handle navigation
  final Function(String menuPath) onMenuTap;

  /// on logout click to handle logout
  final Function onLogOutClick;

  /// Optional text style used for drawer menu items.
  final TextStyle? drawerTextStyle;

  final bool isShowClearIcon;

  /// Custom widget to be displayed in the AppBar
  final Widget? customAppBarWidget;

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  void initState() {
    filerManuList.value.addAll(widget.menuItems);
    super.initState();
  }

  /// Internal scaffold key for controlling drawer open/close programmatically.
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController searchController = TextEditingController();

  ValueNotifier<List<DrawerMenuItem>> filerManuList = ValueNotifier([]);

  Timer? _debounce;

  void searchMenu(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    List<DrawerMenuItem> result = [];
    _debounce = Timer(const Duration(milliseconds: 500), () {
      final lowerQuery = query.toLowerCase();
      result =
          widget.menuItems
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

  void closeDrawer(Size size) {
    if (size.width < 600) {
      _scaffoldKey.currentState?.closeDrawer();
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    closeDrawer(size);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.transparent,
      appBar:
          size.width < 600
              ? AppBar(
                centerTitle: false,
                backgroundColor: widget.drawerColor,
                title:
                    widget.titleName != null
                        ? Text(widget.titleName!, style: widget.titleStyle)
                        : null,
                leading: IconButton(
                  icon: widget.drawerIcon,
                  color: widget.drawerIconColor,
                  iconSize: widget.drawerIconSize,
                  onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                ),
                toolbarHeight: 64,
                elevation: 0,
              )
              : null,
      drawer:
          size.width < 600
              ? Drawer(
                elevation: 0,
                backgroundColor: widget.drawerColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: ValueListenableBuilder<List<DrawerMenuItem>>(
                        valueListenable: filerManuList,
                        builder: (context, value, child) {
                          return Column(
                            children: [
                              SizedBox(height: 10),
                              widget.drawerHeader ?? const SizedBox(),
                              SizedBox(height: 10),
                              if (widget.isSearchShow) ...[
                                if (_scaffoldKey.currentState?.isDrawerOpen ??
                                    false) ...[
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
                                      height:
                                          50, // Fixed height for the TextField
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
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                            borderSide: BorderSide.none,
                                          ),
                                        ),
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
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
                                                _scaffoldKey
                                                            .currentState
                                                            ?.isDrawerOpen ??
                                                        false
                                                    ? ExpansionTile(
                                                      backgroundColor:
                                                          item.subCategories !=
                                                                  null
                                                              ? Colors
                                                                  .transparent
                                                              : (item.isSelected
                                                                  ? Colors
                                                                      .white12
                                                                  : Colors
                                                                      .white10),
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
                                                          _scaffoldKey
                                                                      .currentState
                                                                      ?.isDrawerOpen ??
                                                                  false
                                                              ? (expanded) {
                                                                changeMenu(
                                                                  item.title,
                                                                  null,
                                                                  item,
                                                                  (route) {
                                                                    if (item.subCategories ==
                                                                        null) {
                                                                      widget.onMenuTap(
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
                                                          _scaffoldKey
                                                                      .currentState
                                                                      ?.isDrawerOpen ??
                                                                  false
                                                              ? Text(
                                                                item.title,
                                                                style: TextStyle(
                                                                  color:
                                                                      Colors
                                                                          .white,
                                                                ),
                                                              )
                                                              : const SizedBox.shrink(),
                                                      trailing:
                                                          _scaffoldKey
                                                                      .currentState
                                                                      ?.isDrawerOpen ??
                                                                  false
                                                              ? Visibility(
                                                                visible:
                                                                    (item.subCategories !=
                                                                            null &&
                                                                        item
                                                                            .subCategories!
                                                                            .isNotEmpty),
                                                                child: ValueListenableBuilder(
                                                                  valueListenable:
                                                                      item.isExpanded,
                                                                  builder: (
                                                                    context,
                                                                    value,
                                                                    child,
                                                                  ) {
                                                                    return value
                                                                        ? widget
                                                                            .expandIcon
                                                                        : widget
                                                                            .collapsedIcon;
                                                                  },
                                                                ),
                                                              )
                                                              : const SizedBox.shrink(),
                                                      children:
                                                          _scaffoldKey
                                                                      .currentState
                                                                      ?.isDrawerOpen ??
                                                                  false
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
                                                                      child: Theme(
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
                                                                              _scaffoldKey.currentState?.isDrawerOpen ??
                                                                                      false
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
                                                            widget
                                                                .drawerIconSize,
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
                    ColoredBox(
                      color: Colors.red,
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          print("Logout clicked");
                          widget.onLogOutClick();
                        },
                        child: ListTile(
                          onTap: () {
                            print("object");
                            widget.onLogOutClick();
                          },
                          title: const Text(
                            "Logout",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
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
              )
              : SizedBox.shrink(),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (size.width > 600) ...[
            WebDrawer(
              drawerTextSelectedColor: widget.drawerTextSelectedColor,
              drawerBackground: widget.drawerColor,
              menuItems: ValueNotifier(widget.menuItems),
              isSearchShow: widget.isSearchShow,
              onMenuTap: (String navigationRoute) {
                return widget.onMenuTap(navigationRoute);
              },
              drawerTextStyle: widget.drawerTextStyle,
              prefix: widget.prefix,
              isShowClearIcon: widget.isShowClearIcon,
              drawerIcon: widget.drawerIcon,
              drawerIconColor: DrawerColors.drawerIconColor,
              drawerIconSize: widget.drawerIconSize,
              onLogOutClick: widget.onLogOutClick,
              profileBackground: widget.profileBackground,
              version: widget.version,
              name: widget.userFirstName ?? "",
              lastName: widget.userLastName ?? "",
              email: widget.userEmail ?? "",
              drawerHeader: widget.drawerHeader,
            ),
          ],

          Expanded(
            child: Column(
              children: [
                if (size.width > 600) ...[
                  widget.headerWidget ??
                      HeaderWithAnimation(
                        headerColor: widget.headerColor,
                        title: widget.titleName ?? "",
                        userFirstName: widget.userFirstName ?? "",
                        userLastName: widget.userLastName ?? "",
                        isShowUserProfile: widget.isShowUserProfile,
                        isShowUserName: widget.isShowUserName,
                        titleStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                        userNameStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        profileImage: widget.profileImageUrl,
                      ),
                ],
                Expanded(child: widget.child),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void changeMenu(
    String? title,
    String? childTitle,
    DrawerMenuItem item,
    Function(String route) onTap,
    bool isExpanded,
  ) {
    for (DrawerMenuItem menu in widget.menuItems) {
      final isSelectedMenu = menu.title == title;
      // Reset selection
      menu.isSelected = false;

      // Handle top-level menu selection
      if (isSelectedMenu) {
        menu.isSelected = true;
        menu.isExpanded.value = isExpanded;
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
}
