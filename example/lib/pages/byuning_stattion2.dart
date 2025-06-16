import 'package:flutter/material.dart';

import '../wrap_with_drawer.dart';

class ByuningStattion2 extends StatelessWidget {
  const ByuningStattion2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WrapWithDrawer(
        pageTitle: "Byuning Stattion 2",
        child: Center(child: Text("Byuning Stattion 2")),
      ),
    );
  }
}
