import 'package:flutter/material.dart';

import 'package:digital_jahai/views/menu_view.dart';
import 'package:digital_jahai/views/translate_view.dart';
class HomeView extends StatelessWidget {

  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [MenuView(), TranslateView()],
    ));
  }
}




