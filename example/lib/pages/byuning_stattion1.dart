import 'package:flutter/material.dart';

import '../wrap_with_drawer.dart';

class ByuningStattion1 extends StatelessWidget {
  const ByuningStattion1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WrapWithDrawer(
        pageTitle: "Byuning Stattion 1",
        child: Center(child: Text("Byuning Stattion 1")),
      ),
    );
  }
}
