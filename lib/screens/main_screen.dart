import 'package:flutter/material.dart';

import 'package:digital_jahai/screens/drawer_screen.dart';
import 'package:digital_jahai/screens/translate_screen.dart';
class MainScreen extends StatelessWidget {

  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [DrawerScreen(), TranslateScreen()],
    ));
  }
}