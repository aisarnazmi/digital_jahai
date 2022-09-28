import 'package:flutter/services.dart';

import 'package:get/get.dart';

class MenuController extends GetxController {
  var isDrawerOpen = false.obs;
  var isDragging = false.obs;

  var xOffsetMain = 0.0.obs;
  var yOffsetMain = 0.0.obs;
  var scaleFactorMain = 1.0.obs;
  var scaleFactorDrawer = 0.1.obs;

  void openDrawer() {
    xOffsetMain.value = 240;
    yOffsetMain.value = 140;
    scaleFactorMain.value = 0.7;
    scaleFactorDrawer.value = 1;
    isDrawerOpen.value = true;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

  }

  void closeDrawer() {
    xOffsetMain.value = 0;
    yOffsetMain.value = 0;
    scaleFactorMain.value = 1;
    scaleFactorDrawer.value = 0.1;
    isDrawerOpen.value = false;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
  }
}
