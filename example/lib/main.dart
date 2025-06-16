// ignore_for_file: implementation_imports

import 'package:flutter/material.dart';
import 'package:leapfrog_web_component/custom_drawer/model/drawer_menu_item.dart';
import 'package:leapfrog_web_component/custom_drawer/model/drawer_sub_menu.dart';
import 'package:leapfrog_web_component_example/route/app_router.dart';
import 'package:leapfrog_web_component_example/route/router_name.dart';
import 'package:leapfrog_web_component_example/wrap_with_drawer.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

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

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)),
      routerConfig: router,
      //home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WrapWithDrawer(
        pageTitle: "Home Screen",
        child: Center(child: Text("Home Screen")),
      ),
    );
  }
}
