import 'package:flutter/material.dart';

import 'package:digital_jahai/views/drawer_view.dart';
import 'package:digital_jahai/views/translate_view.dart';
class MainView extends StatelessWidget {

  const MainView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [DrawerView(), TranslateView()],
    ));
  }
}