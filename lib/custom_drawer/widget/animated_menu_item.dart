import 'package:flutter/material.dart';

import '../model/drawer_menu_item.dart';

class AnimatedMenuItem extends StatelessWidget {
  final DrawerMenuItem item;
  final ValueNotifier<bool> isMenuOpen;
  final TextStyle menuItemTextStyle;
  final double menuItemIconSize;
  final Function(DrawerMenuItem) onMenuTap;
  final ValueNotifier<List<DrawerMenuItem>> mainMenuItem;

  const AnimatedMenuItem({
    Key? key,
    required this.item,
    required this.isMenuOpen,
    required this.menuItemTextStyle,
    required this.menuItemIconSize,
    required this.onMenuTap,
    required this.mainMenuItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: item.isExpanded,
      builder: (context, isExpanded, child) {
        return Column(
          children: [
            GestureDetector(
              onTap: () {
                if (item.subCategories != null && item.subCategories!.isNotEmpty) {
                  item.isExpanded.value = !item.isExpanded.value; // Toggle expansion
                } else {
                  changeMenu(item.menuId, null, item, onMenuTap, true);
                }
              },
              child: ValueListenableBuilder<bool>(
                valueListenable: item.isSelected,
                builder: (context, isSelected, child) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    color: isSelected ? Colors.white12 : Colors.transparent, // Highlight based on isSelected
                    child: Row(
                      children: [
                        // Leading icon
                        Padding(
                          padding: const EdgeInsets.only(left: 10, top: 10, bottom: 10),
                          child: Image.asset(item.iconUrl, color: Colors.white, height: menuItemIconSize, width: menuItemIconSize),
                        ),
                        // Title
                        Expanded(
                          child: ValueListenableBuilder<bool>(
                            valueListenable: isMenuOpen,
                            builder: (context, menuOpen, child) {
                              return menuOpen
                                  ? Text(item.title, style: menuItemTextStyle, maxLines: 1, overflow: TextOverflow.ellipsis)
                                  : const SizedBox.shrink();
                            },
                          ),
                        ),
                        // Trailing icon for expandable items
                        ValueListenableBuilder<bool>(
                          valueListenable: isMenuOpen,
                          builder: (context, menuOpen, child) {
                            return menuOpen && item.subCategories != null && item.subCategories!.isNotEmpty
                                ? Icon(isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down, color: Colors.white)
                                : const SizedBox.shrink();
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            // Subcategories
            ValueListenableBuilder<bool>(
              valueListenable: isMenuOpen,
              builder: (context, menuOpen, child) {
                return menuOpen && isExpanded && item.subCategories != null && item.subCategories!.isNotEmpty
                    ? Column(
                      children:
                          item.subCategories!.map((subItem) {
                            return Visibility(
                              visible: subItem.isVisible,
                              child: GestureDetector(
                                onTap: () {
                                  changeMenu(null, subItem.title, subItem, onMenuTap, false);
                                },
                                child: ValueListenableBuilder<bool>(
                                  valueListenable: subItem.isSelected,
                                  builder: (context, isSubSelected, child) {
                                    return AnimatedContainer(
                                      duration: const Duration(milliseconds: 300),
                                      curve: Curves.easeInOut,
                                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10).copyWith(left: 30),
                                      color: isSubSelected ? Colors.white12 : Colors.transparent,
                                      child: Row(
                                        children: [
                                          // Leading icon
                                          Padding(
                                            padding: const EdgeInsets.only(top: 10, bottom: 10),
                                            child: Image.asset(
                                              subItem.iconUrl,
                                              color: Colors.white,
                                              height: menuItemIconSize,
                                              width: menuItemIconSize,
                                            ),
                                          ),
                                          // Title
                                          Expanded(
                                            child: ValueListenableBuilder<bool>(
                                              valueListenable: isMenuOpen,
                                              builder: (context, menuOpen, child) {
                                                return menuOpen
                                                    ? Text(subItem.title, style: menuItemTextStyle, maxLines: 1, overflow: TextOverflow.ellipsis)
                                                    : const SizedBox.shrink();
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          }).toList(),
                    )
                    : const SizedBox.shrink();
              },
            ),
          ],
        );
      },
    );
  }

  void changeMenu(int? menuId, String? childTitle, DrawerMenuItem item, Function(DrawerMenuItem drawerMenuItem) onTap, bool isExpanded) {
    for (var menu in mainMenuItem.value) {
      // Reset isSelected for all main menu items
      menu.isSelected.value = false;
      // Reset isSelected for all subcategories, if any
      if (menu.subCategories != null) {
        for (var subMenu in menu.subCategories!) {
          subMenu.isSelected.value = false;
        }
      }

      // Match main menu by menuId
      if (menuId != null && menu.menuId == menuId) {
        menu.isSelected.value = true;
        menu.isExpanded.value = isExpanded;
        onTap(menu);
        return;
      }

      // Match submenu by childTitle
      if (childTitle != null && menu.subCategories != null) {
        for (var subMenu in menu.subCategories!) {
          if (subMenu.title == childTitle) {
            subMenu.isSelected.value = true;
            menu.isExpanded.value = isExpanded;
            onTap(subMenu);
            return;
          }
        }
      }
    }
  }
}
