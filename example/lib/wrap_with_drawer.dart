import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:leapfrog_web_component/custom_drawer/custome_web_drawer.dart';

import 'main.dart';

class WrapWithDrawer extends StatelessWidget {
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
        menuItems: menuItems,
        onMenuTap: (route) => context.push(route),
        profileImageUrl: 'assets/user_place_holder.png',
        onLogOutClick: () {
          print("Log out clicked");
        },
        isShowUserProfile: true,
        profileBackground: Colors.black,
        drawerIconSize: 26,
        userFirstName: "John",
        userLastName: "Doe",
        titleName: pageTitle,
        isSearchShow: true,
        headerColor: Colors.black,
        drawerColor: Colors.black,
        version: "1.0.0",
        titleStyle: const TextStyle(color: Colors.white, fontSize: 20),
        userNameStyle: const TextStyle(color: Colors.white, fontSize: 16),
        drawerIconColor: Colors.white,
        userEmail: "jH9o7@example.com",
        drawerTextSelectedColor: Colors.white,
        prefix: SizedBox(),
        isShowClearIcon: false,
        isShowUserName: true,
        drawerHeader: Column(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage('assets/user_place_holder.png'),
            ),
            SizedBox(height: 10),
            Text(
              "John Doe",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              "jH9o7@example.com",
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
            SizedBox(height: 10),
          ],
        ),
        child: child,
      ),
    );
  }
}
