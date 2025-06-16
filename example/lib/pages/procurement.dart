import 'package:flutter/material.dart';

import '../wrap_with_drawer.dart';

class Procurement extends StatelessWidget {
  const Procurement({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WrapWithDrawer(
        pageTitle: "Procurement Screen",
        child: Center(child: Text("Procurement Screen")),
      ),
    );
  }
}
