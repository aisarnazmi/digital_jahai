import 'package:digital_jahai/controllers/screen_controller.dart';
import 'package:digital_jahai/screens/drawer_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:digital_jahai/screens/translate_screen.dart';
// import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class MainScreen extends StatelessWidget {
  final screenC = Get.put(ScreenController());

  MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [drawerScreen(), translateScreen(screenC)],
    ));
  }
}

Widget drawerScreen() {
  return DrawerScreen();
}

Widget translateScreen(screenC) {
  return Obx(() => GestureDetector(
        onTap: () => screenC.closeDrawer(),
        onHorizontalDragStart: (details) => screenC.isDragging.value = true,
        onHorizontalDragUpdate: (details) {
          if (!screenC.isDragging.value) {
            return;
          }
          const delta = 1;

          if (details.delta.dx > delta) {
            screenC.openDrawer();
          } else if (details.delta.dx < -delta) {
            screenC.closeDrawer();
          }

          screenC.isDragging.value = false;
        },
        child: AnimatedContainer(
          transform: Matrix4.translationValues(
              screenC.xOffsetMain.value, screenC.yOffsetMain.value, 0)
            ..scale(screenC.scaleFactorMain.value),
          duration: Duration(milliseconds: 200),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                offset: Offset(5, 10),
                blurRadius: 40.0,
                color: Color.fromARGB(255, 139, 141, 163).withOpacity(0.4),
              )
            ],
          ),
          child: ClipRRect(
              borderRadius:
                  BorderRadius.circular(screenC.isDrawerOpen.value ? 35 : 0),
              child: TranslateScreen()),
        ),
      ));
}


// SOLOMON BOTTOM NAVIGATION
// int _selectedIndex = 0;

// final _layoutPage = [
//   const TranslateScreen(),
//   const LibraryScreen(),
// ];

// void _onItemTapped(int index) {
//   setState(() {
//     _selectedIndex = index;
//   });
// }
//
// @override
// return Scafold(
//   body: SafeArea(child: _layoutPage.elementAt(_selectedIndex)),
//   bottomNavigationBar: Container(
//    decoration: BoxDecoration(
//      color: Colors.grey[50],
//      borderRadius: const BorderRadius.only(
//        topLeft: Radius.circular(15),
//        topRight: Radius.circular(15),
//      ),
//      boxShadow: [
//        BoxShadow(
//          color: Colors.grey.withOpacity(0.3),
//          spreadRadius: 5,
//          blurRadius: 5,
//          offset: const Offset(0, 3), // changes position of shadow
//        ),
//      ],
//    ),
//    child: SafeArea(
//      child: SalomonBottomBar(
//        margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
//        items: [
//          SalomonBottomBarItem(
//            icon: const Icon(Icons.translate),
//            title: const Text('Translate'),
//          ),
//          SalomonBottomBarItem(
//            icon: const Icon(Icons.library_add),
//            title: const Text('Library'),
//          ),
//        ],
//        currentIndex: _selectedIndex,
//        selectedItemColor: Colors.indigo[800],
//        onTap: _onItemTapped,
//      ),
//    ),
// ))
