import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import 'package:digital_jahai/screens/translate_screen.dart';
import 'package:digital_jahai/screens/library_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final _layoutPage = [
    const TranslateScreen(),
    const LibraryScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TranslateScreen(),
        // body: SafeArea(child: _layoutPage.elementAt(_selectedIndex)),
        // bottomNavigationBar: Container(
        //   decoration: BoxDecoration(
        //     color: Colors.grey[50],
        //     borderRadius: const BorderRadius.only(
        //       topLeft: Radius.circular(15),
        //       topRight: Radius.circular(15),
        //     ),
        //     boxShadow: [
        //       BoxShadow(
        //         color: Colors.grey.withOpacity(0.3),
        //         spreadRadius: 5,
        //         blurRadius: 5,
        //         offset: const Offset(0, 3), // changes position of shadow
        //       ),
        //     ],
        //   ),
        //   child: SafeArea(
        //     child: SalomonBottomBar(
        //       margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
        //       items: [
        //         SalomonBottomBarItem(
        //           icon: const Icon(Icons.translate),
        //           title: const Text('Translate'),
        //         ),
        //         SalomonBottomBarItem(
        //           icon: const Icon(Icons.library_add),
        //           title: const Text('Library'),
        //         ),
        //       ],
        //       currentIndex: _selectedIndex,
        //       selectedItemColor: Colors.indigo[800],
        //       onTap: _onItemTapped,
        //     ),
        //   ),
        // )
      );
  }
}
