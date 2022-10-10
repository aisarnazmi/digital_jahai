// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:lottie/lottie.dart';
import 'package:sticky_headers/sticky_headers.dart';

// Project imports:
import '../controllers/manage_term_controller.dart';
import '../controllers/menu_controller.dart';
import '../utils/debounce.dart';

class ManageTermView extends GetView<ManageTermController> {
  ManageTermView({Key? key}) : super(key: key);

  final menuC = Get.find<MenuController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ManageTermController>(
        init: ManageTermController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: const Color(0xfffafafa),
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
                                    BorderRadius.all(Radius.circular(50.0))),
                            child: IconButton(
                              onPressed: () {
                                Get.back();
                              },
                              color: Colors.white,
                              icon: Icon(
                                IconlyLight.arrow_left_2,
                                size: 22,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30.h),
                      StickyHeader(
                          header: Container(
                            margin: EdgeInsets.symmetric(horizontal: 20.w),
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.0.w,
                                vertical: 5.0.h // 5 top and bottom
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
                              onChanged: (_) {
                                controller.isTyping.value = true;
                                controller.update();

                                Debouncer(milliseconds: 1500).run(() {
                                  controller.update();
                                  controller.isTyping.value = false;
                                  controller.terms = [];
                                  controller.getTermList();
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
                                hintText: "Search...",
                                hintStyle: TextStyle(color: Colors.black54),
                                suffixIcon: controller
                                            .searchController.text ==
                                        ""
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
                                          controller.terms = [];
                                          controller.getTermList();
                                          controller.update();
                                        }),
                              ),
                            ),
                          ),
                          content: Column(
                            children: [
                              Container(
                                  margin:
                                      EdgeInsets.fromLTRB(25.w, 25.h, 25.w, 0),
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
                duration: Duration(milliseconds: 1000),
                opacity: controller.scrollTop.isTrue ? 1.0 : 0.0,
                child: Container(
                  margin: EdgeInsets.only(bottom: 8.h, right: 10.w),
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
                      controller.scrollController.animateTo(0,
                          duration:
                              Duration(milliseconds: 500), //duration of scroll
                          curve: Curves.fastOutSlowIn //scroll type
                          );

                      Debouncer(milliseconds: 500).run(() {
                        controller.update();
                        controller.scrollTop.value = false;
                      });
                    },
                    color: Colors.white,
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
