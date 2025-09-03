import 'package:flutter/material.dart';
import 'package:leapfrog_web_component/custom_drawer/model/drawer_menu_item.dart';
import 'package:leapfrog_web_component/custom_drawer/widget/header_with_animation.dart';
import 'package:leapfrog_web_component/custom_drawer/widget/web_drawer.dart';
import 'package:leapfrog_web_component_example/route/router_name.dart';

List<DrawerMenuItem> menuItems = [
  DrawerMenuItem(
    title: 'Buying Station',
    route: RouteName.byuingstation,
    iconUrl: "assets/piggy-bank.png",
    isExpanded: ValueNotifier(false),
    menuId: 001,
    subCategories: [
      DrawerMenuItem(menuId: 001, subMenuId: 01, title: 'Quality', iconUrl: "assets/piggy-bank.png", route: RouteName.byuingstation1),
      DrawerMenuItem(menuId: 001, subMenuId: 02, title: 'Opetation', iconUrl: "assets/piggy-bank.png", route: RouteName.byuingstation2),
    ],
  ),
  DrawerMenuItem(menuId: 004, title: 'Procurement', iconUrl: "assets/box.png", route: RouteName.procurement),
  DrawerMenuItem(
    menuId: 005,
    title: 'Handover',
    iconUrl: "assets/settings.png",
    isExpanded: ValueNotifier(false),
    route: RouteName.handover,
    subCategories: [
      DrawerMenuItem(menuId: 005, subMenuId: 03, title: 'Handover1', iconUrl: "assets/settings.png", route: RouteName.handover1),
      DrawerMenuItem(menuId: 005, subMenuId: 04, iconUrl: "assets/settings.png", title: 'Handover2', route: RouteName.handover2),
    ],
  ),
  DrawerMenuItem(menuId: 008, title: 'Sales Invoice', isExpanded: ValueNotifier(false), iconUrl: "assets/user.png", route: RouteName.saleinvoice),
];

class WrapWithDrawer extends StatelessWidget {
  const WrapWithDrawer({super.key, required this.child, required this.pageTitle});
  final Widget child;
  final String pageTitle;

  @override
  /* <<<<<<<<<<<<<<  ✨ Windsurf Command ⭐ >>>>>>>>>>>>>>>> */
  /// Builds a Scaffold widget with a CustomDrawer as its left side drawer.
  ///
  /// The drawer is populated with [menuItems], which is a list of drawer menu items.
  /// Each item is a [DrawerMenuItem] instance, which must have a unique [menuId] and
  /// can have an optional [title], [iconUrl], [route], [isExpanded], and [subCategories].
  ///
  /// The drawer also has a profile header section at the top, which displays the user's
  /// first and last name, email, and a logout button. The background color of the header
  /// section is [profileBackground].
  ///
  /// Additionally, the drawer has a search bar at the top, which is enabled by default.
  /// The search bar is hidden when [isSearchShow] is set to false.
  ///
  /// The drawer's main background color is [drawerColor], and the color of the drawer
  /// icons is [drawerIconColor].
  ///
  /// The application version is displayed at the bottom of the drawer, which is set to
  /// [version].
  ///
  /// The text style for the title is [titleStyle], and the text style for the user name
  /// is [userNameStyle].
  ///
  /// The color of the drawer text for selected menu item is [drawerTextSelectedColor].
  ///
  /// The optional widget before the menu list is [searchPrefix], which is currently empty.
  ///
  /// The visibility of the clear icon is toggled by [isShowClearIcon], which is currently
  /// set to false.
  ///
  /// The visibility of the user name is toggled by [isShowUserName], which is currently
  /// set to true.
  ///
  /// The header widget is [headerWidget], which is currently empty.
  ///
  /// The drawer header is a custom widget that displays the user's avatar, name, and
  /// email. The header is created using [drawerHeader].
  ///
  /// The main body content is shown alongside the drawer and is wrapped in an
  /// [Expanded] widget. The content is passed as the [child] parameter.
  ///
  /// The [onMenuTap] callback is called when the user taps on a menu item. It is passed
  /// the tapped menu item as a parameter.
  ///
  /// The [onLogOutClick] callback is called when the user clicks on the logout button.
  /// It is currently empty.
  /* <<<<<<<<<<  418787fd-116c-45c7-a509-cc6d35b0436c  >>>>>>>>>>> */
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(backgroundColor: Colors.white),
      body: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          WebDrawer(
            menuItems: ValueNotifier(menuItems),
            onMenuTap: (menuItem) {},
            onLogOutClick: () {},
            menuItemIconSize: 20,
            drawerIconSize: 24,
            isSearchShow: true,
            drawerBackground: Colors.black,
            version: "1.0.0",
            drawerIconColor: Colors.white,
            menuItemTextStyle: const TextStyle(color: Colors.white, fontSize: 12),
            searchPrefix: SizedBox(),
            isShowClearIcon: true,
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
          ),
          Expanded(
            child: Column(
              children: [
                SizedBox(
                  height: 80,
                  width: MediaQuery.of(context).size.width,
                  child: HeaderWithAnimation(
                    headerColor: Colors.black,
                    title: "Title",
                    userFirstName: "User Name",
                    userLastName: "Last Name",
                    isShowUserProfile: true,
                    isShowUserName: true,
                    titleStyle: TextStyle(color: Colors.white),
                    userNameStyle: TextStyle(color: Colors.white),
                    profileImage: "assets/user_place_holder.png",
                  ),
                ),
                Expanded(child: Container(color: Colors.red, child: child)),
              ],
            ),
          ), // Main body content shown alongside the drawer.
        ],
      ),
    );
  }
}
