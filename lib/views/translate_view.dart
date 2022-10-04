// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:lottie/lottie.dart';

// Project imports:
import '../controllers/menu_controller.dart';
import '../controllers/translate_controller.dart';
import '../views/library_view.dart';

class TranslateView extends GetView<TranslateController> {
  TranslateView({Key? key}) : super(key: key);

  final menuC = Get.find<MenuController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TranslateController>(
      init: TranslateController(),
      builder: (controller) {
      return Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0.w),
                child: IconButton(
                    onPressed: () => menuC.openDrawer(),
                    icon: SvgPicture.asset('assets/images/menu.svg',
                        semanticsLabel: 'Menu')),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0.w),
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
                          color: const Color(0xffec6882).withOpacity(0.4),
                        )
                      ],
                      borderRadius: BorderRadius.all(Radius.circular(50.0))),
                  child: IconButton(
                    onPressed: () {
                      Get.to(() => LibraryView());
                    },
                    color: Colors.white,
                    icon: Icon(
                      Icons.menu_book,
                      size: 22.w,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 20.0.w),
                child: Text(
                  "Jahai Language\nRepository",
                  style: TextStyle(
                      color: const Color(0xff181d5f),
                      fontSize: 36.sp,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -1),
                ),
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0.w, vertical: 20.0.h),
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: 20.0.w, vertical: 5.0.h // 5 top and bottom
                  ),
              decoration: BoxDecoration(
                color: Colors.white,
                // color: Colors.grey[100],
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 2),
                    blurRadius: 3.0,
                    color: Color(0xFF8B8DA3).withOpacity(0.3),
                  )
                ],
              ),
              child: TextFormField(
                controller: controller.searchController,
                onTap: () => menuC.closeDrawer(),
                onChanged: (_) {
                  controller.isTyping.value = true;
                  controller.update();

                  controller.debouncer.run(() {
                    controller.update();
                    controller.isTyping.value = false;
                    controller.initGetTranslationFuture();
                    controller.update();
                  });
                },
                decoration: InputDecoration(
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  icon: Icon(
                    IconlyBroken.search,
                    color: Colors.black54,
                    size: 22,
                  ),
                  hintText: "Enter ${controller.originLang.value} term...",
                  hintStyle: TextStyle(color: Colors.black54),
                  suffixIcon: controller.searchController.text == ""
                      ? null
                      : IconButton(
                          color: Colors.black54,
                          iconSize: 24,
                          icon: controller.isTyping.value
                              ? Lottie.asset(
                                  'assets/lottie/typing-animation.json')
                              : Icon(Icons.close),
                          onPressed: () {
                            controller.searchController.clear();
                            controller.isTyping.value = false;
                            controller.update();
                            controller.initGetTranslationFuture();
                            controller.update();
                          }),
                ),
              ),
            ),
          ),
          controller.translationList()
        ],
      );
    });
  }
}
