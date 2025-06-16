import 'package:flutter/material.dart';

import '../wrap_with_drawer.dart';

class Invoice extends StatelessWidget {
  const Invoice({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WrapWithDrawer(
        pageTitle: "Invoice Screen",
        child: Center(child: Text("Invoice Screen")),
      ),
    );
  }
}
