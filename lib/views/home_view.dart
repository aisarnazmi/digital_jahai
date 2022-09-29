import 'package:digital_jahai/controllers/translate_controller.dart';
import 'package:flutter/material.dart';

import 'package:digital_jahai/views/menu_view.dart';
import 'package:digital_jahai/views/translate_view.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/menu_controller.dart';
class HomeView extends StatelessWidget {

  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [MenuView(), TranslateScreen()],
    ));
  }
}

class TranslateScreen extends StatelessWidget {
   TranslateScreen({Key? key}) : super(key: key);

  final menuC = Get.find<MenuController>();
  final translateC = Get.find<TranslateController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => GestureDetector(
          onTap: () => menuC.closeDrawer(),
          onHorizontalDragStart: (details) => menuC.isDragging.value = true,
          onHorizontalDragUpdate: (details) {
            if (!menuC.isDragging.value) {
              return;
            }
            const delta = 1;

            if (details.delta.dx > delta) {
              menuC.openDrawer();
            } else if (details.delta.dx < -delta) {
              menuC.closeDrawer();
            }

            menuC.isDragging.value = false;
          },
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
                  color: Color.fromARGB(255, 139, 141, 163).withOpacity(0.4),
                )
              ],
            ),
            child: ClipRRect(
                borderRadius:
                    BorderRadius.circular(menuC.isDrawerOpen.value ? 35 : 0),
                child: Scaffold(
                  backgroundColor: const Color(0xfffafafa),
                  body: SafeArea(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0.h),
                        child: TranslateView() //TranslateView
                      ),
                    ),
                  ),
                  bottomSheet: Container(
                    margin: EdgeInsets.only(bottom: 5.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      // borderRadius: const BorderRadius.only(
                      //   topLeft: Radius.circular(15),
                      //   topRight: Radius.circular(15),
                      // ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.5),
                          spreadRadius: 7,
                          blurRadius: 5,
                          offset:
                              const Offset(7, 0), // changes position of shadow
                        ),
                      ],
                    ),
                    height: 80.0.h,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        const Spacer(),
                        Expanded(
                          child: Center(
                              child: Text(
                            translateC.capitalize(translateC.originLang.value),
                            style: TextStyle(
                                color: Colors.grey[800],
                                fontWeight: FontWeight.w600,
                                fontSize: 14.sp),
                          )),
                        ),
                        Expanded(
                          flex: 3,
                          child: Center(
                            child: Container(
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: const [
                                      Color(0xffeb7c91),
                                      Color(0xffec6882),
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      offset: Offset(5, 10),
                                      blurRadius: 20.0,
                                      color: const Color(0xffec6882)
                                          .withOpacity(0.4),
                                    )
                                  ],
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15.0))),
                              child: IconButton(
                                onPressed: () {
                                  // setState(() {
                                    translateC.switchLang();
                                  // });
                                },
                                color: Colors.white,
                                icon: Icon(
                                  Icons.swap_horiz,
                                  size: 24.w,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                              child: Text(
                            translateC.capitalize(translateC.transLang.value),
                            style: TextStyle(
                                color: Colors.grey[800],
                                fontWeight: FontWeight.w600,
                                fontSize: 14.sp),
                          )),
                        ),
                        const Spacer()
                      ],
                    ),
                  ),
                )),
          ),
        ));
  }
}



