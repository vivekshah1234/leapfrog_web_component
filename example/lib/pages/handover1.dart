import 'package:flutter/material.dart';

import '../wrap_with_drawer.dart';

class Handover1 extends StatelessWidget {
  const Handover1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WrapWithDrawer(
        pageTitle: "Handover1 Screen",
        child: Center(child: Text("Handover1 Screen")),
      ),
    );
  }
}
