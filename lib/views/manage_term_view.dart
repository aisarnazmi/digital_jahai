// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:lottie/lottie.dart';
import 'package:sticky_headers/sticky_headers.dart';

// Project imports:
import '../constants/color.dart';
import '../controllers/manage_term_controller.dart';
import '../controllers/menu_controller.dart';

class ManageTermView extends GetView<ManageTermController> {
  ManageTermView({Key? key}) : super(key: key);

  final menuC = Get.find<MenuController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ManageTermController>(
        init: ManageTermController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: colorBackgroundDark,
            body: SafeArea(
              child: SingleChildScrollView(
                controller: controller.scrollController,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0.h),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 20.0.w),
                            decoration: BoxDecoration(
                                color: colorSecondaryDark,
                                boxShadow: [
                                  BoxShadow(
                                    offset: Offset(3, 3),
                                    blurRadius: 10.0,
                                    color: colorSecondaryDark.withOpacity(0.5),
                                  )
                                ],
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50.0))),
                            child: IconButton(
                              onPressed: () {
                                Get.back();
                              },
                              color: colorTextLight,
                              icon: Icon(
                                IconlyLight.arrow_left_2,
                                size: 22,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),
                      StickyHeader(
                          header: Container(
                            margin:
                                EdgeInsets.symmetric(horizontal: 20.w),
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
                                  controller.update();
                                  controller.isTyping.value = false;
                                  controller.resetList();
                                  controller.getTermList();
                                });
                              },
                              decoration: InputDecoration(
                                  hintText: "Search...",
                                  hintStyle:
                                      TextStyle(color: colorPlaceholderText),
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
                                            controller.isTyping.value = false;
                                            controller.update();
                                            controller.resetList();
                                            controller.getTermList();
                                          })),
                            ),
                          ),
                          content: Column(
                            children: [
                              Container(
                                  margin:
                                      EdgeInsets.fromLTRB(25.w, 20.h, 25.w, 0),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colors.grey.shade300,
                                              width: 1)))),
                              controller.termListBuilder(),
                              if (controller.currentPage <
                                  controller.lastPage) ...[
                                Container(
                                  padding:
                                      EdgeInsets.only(top: 30.h, bottom: 30),
                                  child: Lottie.asset(
                                      'assets/lottie/typing-animation.json',
                                      height: 36),
                                )
                              ]
                            ],
                          )),
                    ],
                  ),
                ),
              ),
            ),
            floatingActionButton: AnimatedOpacity(
                duration: Duration(milliseconds: 500),
                opacity: controller.scrollTop.isTrue ? 1.0 : 0.0,
                child: Container(
                  margin: EdgeInsets.only(bottom: 8.h, right: 10.w),
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
