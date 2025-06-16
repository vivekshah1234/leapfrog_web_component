import 'package:flutter/cupertino.dart';

class DrawerStyle {
  const DrawerStyle._();
  static const DrawerStyle drawerStyle = DrawerStyle._();

  static TextStyle headerTextStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: CupertinoColors.white,
  );
  static TextStyle menuTextStyle = TextStyle(
    fontSize: 16,
    color: CupertinoColors.white,
  );
  static TextStyle selectedMenuTextStyle = TextStyle(
    fontSize: 16,
    color: CupertinoColors.activeBlue,
  );

  static var userNameStyle = TextStyle(
    fontSize: 16,
    color: CupertinoColors.white,
  );

  static var userLastNameStyle = TextStyle(
    fontSize: 16,
    color: CupertinoColors.white,
  );
}
