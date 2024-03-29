// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

// Project imports:
import '../constants/color.dart';
import '../controllers/menu_controller.dart';
import '../controllers/translate_controller.dart';
import '../views/menu_view.dart';
import '../views/translate_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [MenuScreen(), TranslateScreen()],
    ));
  }
}

class MenuScreen extends StatelessWidget {
  final menuC = Get.find<MenuController>();
  final translateC = Get.find<TranslateController>();

  MenuScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          padding: EdgeInsets.only(top: 75.h, left: 25.w, bottom: 40.h),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                colorPrimaryLight,
                colorPrimaryDark,
              ],
            ),
          ),
          child: AnimatedContainer(
              transform: Matrix4.translationValues(
                  (menuC.isDrawerOpen.isTrue
                      ? 0
                      : -MediaQuery.of(context).size.width),
                  0,
                  0),
              duration: Duration(milliseconds: 200),
              child: MenuView()),
        ));
  }
}

class TranslateScreen extends StatelessWidget {
  final menuC = Get.find<MenuController>();
  final translateC = Get.find<TranslateController>();

  TranslateScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();

            if (menuC.isDrawerOpen.isTrue) {
              menuC.closeDrawer();
            }
          },
          // onHorizontalDragStart: (details) => menuC.isDragging.value = true,
          // onHorizontalDragUpdate: (details) {
          //   if (menuC.isDragging.isFalse) {
          //     return;
          //   }
          //   const delta = 1;

          //   if (details.delta.dx > delta) {
          //     menuC.openDrawer();
          //   } else if (details.delta.dx < -delta) {
          //     menuC.closeDrawer();
          //   }

          //   menuC.isDragging.value = false;
          // },
          child: AnimatedContainer(
            transform: Matrix4.translationValues(
                menuC.xOffsetMain.value, menuC.yOffsetMain.value, 0)
              ..scale(menuC.scaleFactorMain.value),
            duration: Duration(milliseconds: 200),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  offset: Offset(5, 10),
                  blurRadius: 40.0,
                  color: colorShadow.withOpacity(0.5),
                )
              ],
            ),
            child: ClipRRect(
                borderRadius:
                    BorderRadius.circular(menuC.isDrawerOpen.isTrue ? 35 : 0),
                child: TranslateView()),
          ),
        ));
  }
}
