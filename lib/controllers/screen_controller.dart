import 'package:flutter/services.dart';

import 'package:get/get.dart';

class ScreenController extends GetxController {
  RxBool isDrawerOpen = false.obs;
  RxBool isDragging = false.obs;

  RxDouble xOffset = 0.0.obs;
  RxDouble yOffset = 0.0.obs;
  RxDouble scaleFactor = 1.0.obs;

  void openDrawer() {
    xOffset.value = 240;
    yOffset.value = 115;
    scaleFactor.value = 0.7;
    isDrawerOpen.value = true;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

  }

  void closeDrawer() {
    xOffset.value = 0;
    yOffset.value = 0;
    scaleFactor.value = 1;
    isDrawerOpen.value = false;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
  }
}
