import 'package:flutter/material.dart';
import 'package:movieapp/ui/ui_bottom_navigation.dart';

void handleAfterSignIn(BuildContext context) {
  Future.delayed(const Duration(milliseconds: 1000)).then((value) {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => const UiBottomNavigation()));
  });
}
