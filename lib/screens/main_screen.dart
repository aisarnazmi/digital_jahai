import 'package:digital_jahai/controllers/screen_controller.dart';
import 'package:digital_jahai/screens/drawer_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';

import 'package:digital_jahai/screens/translate_screen.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class MainScreen extends StatelessWidget {
  final screenC = Get.put(ScreenController());

  MainScreen({Key? key}) : super(key: key);

  static Future<void> _onOpen(LinkableElement link) async {
    if (await canLaunch(link.url)) {
      await launch(link.url);
    } else {
      throw 'Could not launch $link';
    }
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(
        Duration(microseconds: 1300),
        () => {
              showCupertinoModalBottomSheet(
                  expand: false,
                  context: context,
                  backgroundColor: Colors.white,
                  builder: (context) => InstallKeyboardDialog()),
            });
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

class InstallKeyboardDialog extends StatelessWidget {
  const InstallKeyboardDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
        child: SafeArea(
      top: false,
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(25.0.w, 10.0.h, 25.0.w, 20.0.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.close)),
              ),
              SizedBox(
                height: 8.0.h,
              ),
              Text(
                  "Digital Jahai application required International Phonetic Alphabet (IPA) Keyboard to be used with Jahai terms."),
              SizedBox(
                height: 20.0.h,
              ),
              Text(
                  "Please install IPA keyboard using link below and, follow the installation steps: ",
                  style: TextStyle(fontWeight: FontWeight.w600)),
              SizedBox(
                height: 15.0.h,
              ),
              Linkify(
                onOpen: MainScreen._onOpen,
                options: LinkifyOptions(humanize: false),
                text:
                    "Android Platform: https://play.google.com/store/apps/details?id=com.google.android.inputmethod.latin",
              ),
              Text(
                  "\nStep to add IPA language on Gboard:-\n\n1. Open the Settings app.\n2. System > Languages & input > Keyboard > Virtual keyboard\n3. Tap Gboard and then Languages\n4. Pick International Phonetic Alphabet (IPA) language."),
              SizedBox(
                height: 15.0.h,
              ),
              Linkify(
                  onOpen: MainScreen._onOpen,
                  options: LinkifyOptions(humanize: false),
                  text:
                      "IOS Platform: https://apps.apple.com/my/app/ipa-phonetic-keyboard/id1440241497"),
              Text(
                  "\nStep to add IPA language on IOS Keyboard:-\n\n1. Open the Settings app\n2. Go to General > Keyboard > Keyboards\n3. Tap on 'Add New Keyboard'.\n4. Add 'IPA Keyboard' from the 'Third-Party Keyboards list'."),
              SizedBox(
                height: 15.0.h,
              ),
              Text(
                  "* Now you can use IPA language while typing by switching keyboard language to IPA.")
            ],
          ),
        ),
      ),
    ));
  }
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
