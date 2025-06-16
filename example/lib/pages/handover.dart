import 'package:flutter/material.dart';

import '../wrap_with_drawer.dart';

class Handover extends StatelessWidget {
  const Handover({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WrapWithDrawer(
        pageTitle: "Handover Screen",
        child: Center(child: Text("Handover Screen")),
      ),
    );
  }
}
