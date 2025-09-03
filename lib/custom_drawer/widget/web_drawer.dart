import 'dart:async';

import 'package:flutter/material.dart';
import 'package:leapfrog_web_component/custom_drawer/constant/drawer_colors.dart';
import 'package:leapfrog_web_component/custom_drawer/model/drawer_menu_item.dart';

import 'animated_menu_item.dart';

class WebDrawer extends StatefulWidget {
  const WebDrawer({
    super.key,
    required this.menuItems,
    required this.onMenuTap,
    required this.onLogOutClick,

    this.drawerBackground = const Color(0xFF0D1B2A),
    Widget? searchPrefix,

    this.drawerHeader,
    Widget? drawerIcon,
    this.version,
    this.drawerIconColor = DrawerColors.drawerIconColor,
    this.drawerIconSize = 18,
    this.menuItemIconSize = 18,
    this.isSearchShow = false,
    required this.menuItemTextStyle,
    this.isShowClearIcon = false,
  }) : searchPrefix = searchPrefix ?? const SizedBox.shrink(),
       drawerIcon = drawerIcon ?? const Icon(Icons.menu);

  final ValueNotifier<List<DrawerMenuItem>> menuItems;
  final Function(DrawerMenuItem navigaionRoute) onMenuTap;
  final Function onLogOutClick;
  final Color drawerBackground;
  final Widget searchPrefix;

  final Widget? drawerHeader;
  final Widget drawerIcon;
  final bool isSearchShow;
  final Color drawerIconColor;
  final double drawerIconSize;
  final double menuItemIconSize;
  final String? version;
  final bool isShowClearIcon;
  final TextStyle menuItemTextStyle;

  @override
  State<WebDrawer> createState() => _WebDrawerState();
}

class _WebDrawerState extends State<WebDrawer> {
  // Text field controller for search functionality in the drawer.
  // It is used to manage the text input from the user.
  TextEditingController searchController = TextEditingController();
  // ValueNotifier for the main menu items.
  // It is used to manage the state of the main menu items in the drawer.
  ValueNotifier<List<DrawerMenuItem>> mainMenuItem = ValueNotifier([]);

  // ValueNotifier for the filtered menu items.
  // It is used to manage the state of the filtered menu items based on the search input.
  ValueNotifier<List<DrawerMenuItem>> filerManuList = ValueNotifier([]);

  // ValueNotifier for the menu open state.
  // It is used to manage the state of the menu open or close state in the drawer.
  ValueNotifier<bool> isMenuOpen = ValueNotifier(true);

  // ValueNotifier for the drawer expand state.
  // It is used to manage the state of the drawer expand or collapse state.
  ValueNotifier<bool> isDrawerExpand = ValueNotifier(true);

  // ValueNotifier for the selected menu item id.
  // It is used to manage the state of the currently selected menu item in the drawer.
  ValueNotifier<int> currentMenuId = ValueNotifier(0);

  // Timer for debouncing the search input.
  // It is used to delay the search functionality to avoid unnecessary API calls or heavy computations.
  Timer? _debounce;
  @override
  void initState() {
    super.initState();
    mainMenuItem = widget.menuItems;
    filerManuList.value.addAll(widget.menuItems.value);
  }

  /// Changes the selected menu and submenu items in the drawer based on the provided titles and routes.
  ///
  /// The [title] parameter represents the title of the top-level menu item.
  /// The [childTitle] parameter represents the title of the submenu item.
  /// The [item] parameter represents the selected menu item object.
  /// The [onTap] parameter is a callback function that is called when a menu item is tapped.
  /// The [isExpanded] parameter represents the expanded state of the drawer.
  void changeMenu(int? menuId, String? childTitle, Function(DrawerMenuItem drawerMenuItem) onTap, bool isExpanded) {
    print("Selected Menu Item Id $menuId");
    // for (var menu in mainMenuItem.value) {
    //   print("object Menu Id ${menu.menuId}");
    //   // Reset isSelected for the main menu item
    //   menu.isSelected.value = false;
    //   print("object Menu Selected ${menu.isSelected.value}");
    //
    //   // Reset isSelected for all subcategories, if any
    //   if (menu.subCategories != null) {
    //     for (var subMenu in menu.subCategories!) {
    //       subMenu.isSelected.value = false;
    //     }
    //   }
    //
    //   // Check if the current menu's menuId matches the provided menuId
    //   final isSelectedMenu = menu.menuId == menuId;
    //   // if (isSelectedMenu) {
    //   //   menu.isSelected.value = true;
    //   //   print("object Mathe c ${menu.isSelected.value}");
    //   //   onTap(menu);
    //   //   return;
    //   // }
    //
    //   // // Handle subcategories if they exist and childTitle is provided
    //   // if (menu.subCategories != null && childTitle != null) {
    //   //   for (var subMenu in menu.subCategories!) {
    //   //     final isSelectedSubMenu = subMenu.title == childTitle;
    //   //     if (isSelectedSubMenu) {
    //   //       subMenu.isSelected.value = true;
    //   //       menu.isExpanded.value = isExpanded; // Expand parent menu if needed
    //   //       onTap(subMenu);
    //   //       return;
    //   //     }
    //   //   }
    //   // }
    // }
  }

  /* <<<<<<<<<<<<<<  ✨ Windsurf Command ⭐ >>>>>>>>>>>>>>>> */
  /// Closes the drawer after a delay of 3 seconds if the width of the screen is less than 600.
  ///
  /// The [size] parameter is the size of the screen.
  /// This method is used to close the drawer after a delay to avoid accidental closure of the drawer.
  ///
  /* <<<<<<<<<<  f1cabb38-2b1b-4426-baec-e7054a22713e  >>>>>>>>>>> */
  void closeDrawer(Size size) {
    if (size.width < 600) {
      Future.delayed(const Duration(seconds: 3), () {
        isMenuOpen.value = !isMenuOpen.value;
        isDrawerExpand.value = !isDrawerExpand.value;
      });
    }
  }

  /* <<<<<<<<<<<<<<  ✨ Windsurf Command ⭐ >>>>>>>>>>>>>>>> */
  /// Toggles the state of the drawer.
  ///
  /// The drawer is closed with a animation after a delay of 300 milliseconds.
  ///
  /* <<<<<<<<<<  659208a8-bb6a-49e0-b091-ef2c85394f4a  >>>>>>>>>>> */
  void drawerStateChange() {
    isMenuOpen.value = !isMenuOpen.value;
    Future.delayed(const Duration(milliseconds: 300), () {
      isDrawerExpand.value = !isDrawerExpand.value;
    });
  }

  /* <<<<<<<<<<<<<<  ✨ Windsurf Command ⭐ >>>>>>>>>>>>>>>> */
  /// Searches the drawer menu items based on the provided query.
  ///
  /// The search functionality uses a debounce timer to delay the search
  /// by 500 milliseconds to avoid unnecessary API calls or heavy computations.
  ///
  /// The search is done by matching the provided query with the menu item
  /// titles and their sub menu item titles. The search is case-insensitive.
  ///
  /// The method returns a list of DrawerMenuItem objects that match the
  /// search query. The returned list is updated in the ValueNotifier object
  /// filerManuList.
  ///
  /* <<<<<<<<<<  789bedcf-8e0b-40c1-9b29-0bd14a5841ca  >>>>>>>>>>> */
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
                final matchingSubMenus = menu.subCategories?.where((subMenu) => subMenu.title.toLowerCase().startsWith(lowerQuery)).toList();
                return isMainMatch || (matchingSubMenus != null && matchingSubMenus.isNotEmpty);
              })
              .map((menu) {
                final matchingSubMenus = menu.subCategories?.where((subMenu) => menu.menuId == subMenu.menuId).toList();
                return DrawerMenuItem(
                  menuId: menu.menuId,
                  subMenuId: menu.subMenuId,
                  isSelected: menu.isSelected,
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

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    // closeDrawer(size);
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
                                      prefixIcon: widget.searchPrefix,
                                      suffixIconColor: Colors.white,
                                      hintStyle: const TextStyle(color: Colors.white60),
                                      suffixIcon:
                                          widget.isShowClearIcon
                                              ? IconButton(
                                                icon: Icon(Icons.clear, color: Colors.white),
                                                onPressed: () {
                                                  searchController.clear();
                                                  searchMenu('');
                                                },
                                              )
                                              : null,
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
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
                                      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                                      child: Container(
                                        margin: EdgeInsets.only(bottom: 10),
                                        child: AnimatedMenuItem(
                                          isMenuOpen: isMenuOpen,
                                          item: item,
                                          mainMenuItem: ValueNotifier(value),
                                          menuItemIconSize: widget.menuItemIconSize,
                                          menuItemTextStyle: widget.menuItemTextStyle,
                                          onMenuTap: (p0) {},
                                        ),
                                        // isMenuOpen.value
                                        //     ? ExpansionTile(
                                        //       backgroundColor:
                                        //           item.subCategories != null
                                        //               ? Colors.transparent
                                        //               : (item.isSelected.value ? Colors.white12 : Colors.white10),
                                        //       childrenPadding: const EdgeInsets.symmetric(horizontal: 10),
                                        //       dense: false,
                                        //       tilePadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                        //       initiallyExpanded: item.isExpanded.value,
                                        //       onExpansionChanged:
                                        //           isMenuOpen.value
                                        //               ? (expanded) {
                                        //                 print("LLLL");
                                        //                 // changeMenu(item.menuId, null, (item) {
                                        //                 //   if (item.subCategories == null) {
                                        //                 //     widget.onMenuTap(item);
                                        //                 //   }
                                        //                 // }, expanded);
                                        //                 //item.isExpanded.value = expanded;
                                        //               }
                                        //               : null,
                                        //       leading: Padding(
                                        //         padding: const EdgeInsets.only(left: 10, top: 10, bottom: 10),
                                        //         child: Image.asset(
                                        //           item.iconUrl,
                                        //           color: Colors.white,
                                        //           height: widget.menuItemIconSize,
                                        //           width: widget.menuItemIconSize,
                                        //         ),
                                        //       ),
                                        //       title:
                                        //           isMenuOpen.value ? Text(item.title, style: widget.menuItemTextStyle) : const SizedBox.shrink(),
                                        //       trailing:
                                        //           isMenuOpen.value
                                        //               ? ValueListenableBuilder<bool>(
                                        //                 valueListenable: item.isExpanded,
                                        //                 builder:
                                        //                     (context, value, child) => Visibility(
                                        //                       visible: (item.subCategories != null && item.subCategories!.isNotEmpty),
                                        //                       child: Icon(
                                        //                         item.isExpanded.value ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                                        //                         color: Colors.white,
                                        //                       ),
                                        //                     ),
                                        //               )
                                        //               : const SizedBox.shrink(),
                                        //       children:
                                        //           isMenuOpen.value
                                        //               ? (item.subCategories != null)
                                        //                   ? item.subCategories!.map((subItem) {
                                        //                     return Visibility(
                                        //                       visible: subItem.isVisible,
                                        //                       child:
                                        //                           isMenuOpen.value
                                        //                               ? Theme(
                                        //                                 data: Theme.of(context).copyWith(
                                        //                                   dividerColor: Colors.transparent,
                                        //                                   expansionTileTheme: ExpansionTileThemeData(
                                        //                                     backgroundColor:
                                        //                                         subItem.isSelected.value ? Colors.white12 : Colors.transparent,
                                        //                                     shape: RoundedRectangleBorder(
                                        //                                       borderRadius: BorderRadius.circular(10),
                                        //                                     ),
                                        //                                   ),
                                        //                                 ),
                                        //                                 child: ExpansionTile(
                                        //                                   onExpansionChanged: (value) {
                                        //                                     changeMenu(null, subItem.title, (subItem) {
                                        //                                       widget.onMenuTap(subItem);
                                        //                                     }, false);
                                        //                                   },
                                        //                                   tilePadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                        //                                   trailing: SizedBox.shrink(),
                                        //                                   leading: Padding(
                                        //                                     padding: const EdgeInsets.only(left: 30, top: 10, bottom: 10),
                                        //                                     child: Image.asset(
                                        //                                       item.iconUrl,
                                        //                                       color: Colors.white,
                                        //                                       height: widget.menuItemIconSize,
                                        //                                       width: widget.menuItemIconSize,
                                        //                                     ),
                                        //                                   ),
                                        //                                   title:
                                        //                                       isMenuOpen.value
                                        //                                           ? Text(
                                        //                                             subItem.title,
                                        //                                             style: widget.menuItemTextStyle,
                                        //                                             maxLines: 1,
                                        //                                             overflow: TextOverflow.ellipsis,
                                        //                                             softWrap: true,
                                        //                                           )
                                        //                                           : SizedBox.shrink(),
                                        //                                 ),
                                        //                               )
                                        //                               : Image.asset(
                                        //                                 subItem.iconUrl,
                                        //                                 color: Colors.white,
                                        //                                 height: widget.menuItemIconSize,
                                        //                               ),
                                        //                     );
                                        //                   }).toList()
                                        //                   : []
                                        //               : [],
                                        //     )
                                        //     : Container(
                                        //       decoration: BoxDecoration(
                                        //         color: item.isSelected.value ? Colors.white12 : Colors.transparent,
                                        //         borderRadius: BorderRadius.circular(10),
                                        //       ),
                                        //       //margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                        //       padding: const EdgeInsets.symmetric(vertical: 20),
                                        //       child: Image.asset(item.iconUrl, color: Colors.white, height: widget.menuItemIconSize),
                                        //     ),
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
                  tilePadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  leading: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: Icon(Icons.logout, color: widget.drawerIconColor, size: widget.menuItemIconSize),
                  ),
                  title:
                      isMenuOpen.value
                          ? Padding(padding: const EdgeInsets.only(top: 10), child: Text("Logout", style: widget.menuItemTextStyle))
                          : const SizedBox.shrink(),
                  backgroundColor: Colors.transparent,
                  textColor: Colors.white,
                  iconColor: Colors.white,
                  trailing: const SizedBox(width: 0, height: 0),
                ),
                if (widget.version != null)
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "V ${widget.version ?? ""}",
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ),
              ],
            ),
          ),
    );
  }
}
