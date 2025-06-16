import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:leapfrog_web_component/custom_drawer/custome_web_drawer.dart';
import 'package:leapfrog_web_component/custom_drawer/model/drawer_menu_item.dart';
import 'package:leapfrog_web_component/custom_drawer/model/drawer_sub_menu.dart';
import 'package:leapfrog_web_component_example/route/router_name.dart';

// Main drawer menu item for "Buying Station"
// This item contains two expandable submenus: "Quality" and "Operation".
// - `title`: Display name for the menu.
// - `route`: Main navigation route when tapped (if not expanded).
// - `iconUrl`: Icon shown beside the menu title.
// - `isExpanded`: Controls the expand/collapse state of its submenus (reactive via ValueNotifier).
// - `subCategories`: List of nested submenu items under this category.

List<DrawerMenuItem> menuItems = [
  DrawerMenuItem(
    title: 'Buying Station',
    route: RouteName.byuingstation,
    iconUrl: "assets/piggy-bank.png",
    isExpanded: ValueNotifier(false),
    subCategories: [
      DrawerSubMenuMenuItem(title: 'Quality', iconUrl: "assets/piggy-bank.png", route: RouteName.byuingstation1),
      DrawerSubMenuMenuItem(title: 'Opetation', iconUrl: "assets/piggy-bank.png", route: RouteName.byuingstation2),
    ],
  ),
  DrawerMenuItem(title: 'Procurement', iconUrl: "assets/box.png", isExpanded: ValueNotifier(false), route: RouteName.procurement),
  DrawerMenuItem(
    title: 'Handover',
    iconUrl: "assets/settings.png",
    isExpanded: ValueNotifier(false),
    route: RouteName.handover,
    subCategories: [
      DrawerSubMenuMenuItem(title: 'Handover1', iconUrl: "assets/settings.png", route: RouteName.handover1),
      DrawerSubMenuMenuItem(iconUrl: "assets/settings.png", title: 'Handover2', route: RouteName.handover2),
    ],
  ),
  DrawerMenuItem(title: 'Sales Invoice', isExpanded: ValueNotifier(false), iconUrl: "assets/user.png", route: RouteName.saleinvoice),
];

class WrapWithDrawer extends StatelessWidget {
  const WrapWithDrawer({super.key, required this.child, required this.pageTitle});

  const WrapWithDrawer({
    super.key,
    required this.child,
    required this.pageTitle,
  });
  final Widget child;
  final String pageTitle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(backgroundColor: Colors.white),
      body: CustomDrawer(
        // This is a highly customizable drawer widget for navigation and user profile display.
        // It supports profile header, logout handling, theming, and dynamic menu rendering.
        menuItems: menuItems,
        // List of drawer menu items.
        onMenuTap: (route) => context.push(route),
        // Handles navigation on menu tap.
        profileImageUrl: 'assets/user_place_holder.png',
        // Placeholder image for user avatar.
        onLogOutClick: () {},
        // Logout button callback (currently empty).
        isShowUserProfile: true,
        // Show/hide the user profile section at the top.
        profileBackground: Colors.black,
        // Background color of the profile header section.
        drawerIconSize: 26,
        // Size of icons shown in the drawer menu.
        userFirstName: "John",
        // User's first name.
        userLastName: "Doe",
        // User's last name.
        titleName: pageTitle,
        // Page title shown in the drawer's header.
        isSearchShow: true,
        // Toggle to show/hide the search bar inside the drawer.
        headerColor: Colors.black,
        // Color of the drawer header section.
        drawerColor: Colors.black,
        // Main background color of the drawer.
        version: "1.0.0",
        // Application version displayed in the drawer.
        titleStyle: const TextStyle(color: Colors.white, fontSize: 20),
        // Text style for title.
        userNameStyle: const TextStyle(color: Colors.white, fontSize: 16),
        // Text style for user name.
        drawerIconColor: Colors.white,
        // Color of the drawer icons.
        userEmail: "jH9o7@example.com",
        // Email displayed under user's name.
        drawerTextSelectedColor: Colors.white,
        // Highlight color for selected menu item.
        prefix: SizedBox(),
        // Optional widget before menu list (currently empty).
        isShowClearIcon: false,
        // Toggle visibility of clear icon (unused here).
        isShowUserName: true,
        // Show/hide user's name in the drawer.
        // Custom drawer header widget (replaces default) showing avatar, name, and email.
        drawerHeader: Column(
          children: [
            CircleAvatar(radius: 40, backgroundImage: AssetImage('assets/user_place_holder.png')),
            SizedBox(height: 10),
            Text("John Doe", style: TextStyle(color: Colors.white, fontSize: 16)),
            SizedBox(height: 10),
            Text("jH9o7@example.com", style: TextStyle(color: Colors.white, fontSize: 12)),
            SizedBox(height: 10),
          ],
        ),
        child: child, // Main body content shown alongside the drawer.
      ),
    );
  }
}
