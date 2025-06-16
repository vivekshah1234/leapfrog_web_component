
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:leapfrog_web_component_example/route/router_name.dart';

import '../main.dart';
import '../pages/byuning_stattion1.dart';
import '../pages/byuning_stattion2.dart';
import '../pages/handover.dart';
import '../pages/handover1.dart';
import '../pages/handover2.dart';
import '../pages/invoice.dart';
import '../pages/procurement.dart';

GoRouter router = GoRouter(
  initialLocation: RouteName.byuingstation,
  // onException: (context, state, router) {
  //   print("CURRENT PATH ${state.fullPath}");
  // },
  errorBuilder: (context, val) => Scaffold(body: Center(child: Text("404 ${val.error}"))),
  routes: [
    GoRoute(
      path: RouteName.byuingstation,
      builder: (context, state) => const HomeScreen(),
      routes: [
        GoRoute(path: RouteName.byuingstation1, builder: (context, state) => const ByuningStattion1()),
        GoRoute(path: RouteName.byuingstation2, builder: (context, state) => const ByuningStattion2()),
      ],
    ),
    GoRoute(
      path: RouteName.handover,
      builder: (context, state) => const Handover(),
      routes: [
        GoRoute(path: RouteName.handover1, builder: (context, state) => const Handover1()),
        GoRoute(path: RouteName.handover2, builder: (context, state) => const Handover2()),
      ],
    ),
    GoRoute(path: RouteName.saleinvoice, builder: (context, state) => const Invoice()),
    GoRoute(path: RouteName.procurement, builder: (context, state) => const Procurement()),
  ],
);
