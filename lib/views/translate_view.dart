// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:lottie/lottie.dart';
import 'package:sticky_headers/sticky_headers.dart';

// Project imports:
import '../constants/color.dart';
import '../controllers/menu_controller.dart';
import '../controllers/translate_controller.dart';

class TranslateView extends GetView<TranslateController> {
  TranslateView({Key? key}) : super(key: key);

  final menuC = Get.find<MenuController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TranslateController>(
        init: TranslateController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: colorBackgroundDark,
            body: SafeArea(
              child: SingleChildScrollView(
                controller: controller.scrollController,
                child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.0.w),
                              child: IconButton(
                                  onPressed: () => menuC.openDrawer(),
                                  icon: SvgPicture.asset(
                                      'assets/images/menu.svg',
                                      semanticsLabel: 'Menu')),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 20.0.w),
                              decoration: BoxDecoration(
                                  color: colorSecondaryDark,
                                  boxShadow: [
                                    BoxShadow(
                                      offset: Offset(3, 3),
                                      blurRadius: 10.0,
                                      color:
                                          colorSecondaryDark.withOpacity(0.5),
                                    )
                                  ],
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0))),
                              child: IconButton(
                                onPressed: () {
                                  Get.toNamed('/library');
                                },
                                color: colorTextLight,
                                icon: Icon(
                                  Icons.menu_book,
                                  size: 22.w,
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
                                    color: colorPrimaryLight,
                                    fontSize: 36.sp,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: -1,
                                    wordSpacing: 5,
                                    height: 1.2.h),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 10.h),
                        StickyHeader(
                          header: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                color: colorBackgroundDark,
                                child: Container(
                                  margin: EdgeInsets.fromLTRB(
                                      20.w, 10.h, 20.w, 10.h),
                                  decoration: BoxDecoration(
                                    color: colorBackgroundLight,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        offset: Offset(0, 2),
                                        blurRadius: 3.0,
                                        color: colorShadow.withOpacity(0.3),
                                      )
                                    ],
                                  ),
                                  child: TextFormField(
                                    controller: controller.searchController,
                                    onTap: () => menuC.closeDrawer(),
                                    onChanged: (_) {
                                      controller.isTyping.value = true;
                                      controller.update();

                                      controller.serchDebouncer.run(() {
                                        controller.isTyping.value = false;
                                        controller.toTop();
                                        controller.update();
                                        controller.resetList();
                                        controller.initGetTranslationFuture();
                                      });
                                    },
                                    decoration: InputDecoration(
                                      hintText:
                                          "Enter ${controller.originLang.value} term...",
                                      hintStyle: TextStyle(
                                          color: colorPlaceholderText),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)),
                                          borderSide: BorderSide(
                                              color: colorTransparent)),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)),
                                          borderSide:
                                              BorderSide(color: colorBorder)),
                                      prefixIcon: Icon(
                                        IconlyBroken.search,
                                        color: colorPlaceholderText,
                                        size: 22,
                                      ),
                                      suffixIcon: controller
                                                  .searchController.text ==
                                              ""
                                          ? null
                                          : IconButton(
                                              color: colorPlaceholderText,
                                              iconSize: 24,
                                              icon: controller.isTyping.value
                                                  ? Lottie.asset(
                                                      'assets/lottie/typing-animation.json')
                                                  : Icon(Icons.close),
                                              onPressed: () {
                                                controller.searchController
                                                    .clear();
                                                controller.isTyping.value =
                                                    false;
                                                controller.toTop();
                                                controller.update();
                                                controller.resetList();
                                                controller
                                                    .initGetTranslationFuture();
                                              }),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10.h)
                            ],
                          ),
                          content: controller.translationListBuilder(),
                        ),
                      ],
                    ) //TranslateView
                    ),
              ),
            ),
            bottomSheet: controller.languageSwitcher(),
            floatingActionButton: AnimatedOpacity(
                duration: Duration(milliseconds: 500),
                opacity: controller.scrollTop.isTrue ? 1.0 : 0.0,
                child: Container(
                  margin: EdgeInsets.only(bottom: 60.h, right: 10.w),
                  decoration: BoxDecoration(
                      color: colorSecondaryDark,
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(3, 3),
                          blurRadius: 10.0,
                          color: colorSecondaryDark.withOpacity(0.5),
                        )
                      ],
                      borderRadius: BorderRadius.all(Radius.circular(50.0))),
                  child: IconButton(
                    onPressed: () {
                      controller.toTop();
                    },
                    color: colorTextLight,
                    icon: Icon(
                      IconlyLight.arrow_up_2,
                      size: 22,
                    ),
                  ),
                )),
          );
        });
  }
}
