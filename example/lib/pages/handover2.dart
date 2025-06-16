import 'package:flutter/material.dart';

import '../wrap_with_drawer.dart';

class Handover2 extends StatelessWidget {
  const Handover2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WrapWithDrawer(
        pageTitle: "Handover2 Screen",
        child: Center(child: Text("Handover2 Screen")),
      ),
    );
  }
}
