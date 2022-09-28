import 'package:digital_jahai/controllers/menu_controller.dart';
import 'package:digital_jahai/controllers/translate_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:digital_jahai/screens/library_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconly/iconly.dart';
import 'package:flutter_svg/svg.dart';

class TranslateScreen extends StatefulWidget {
  const TranslateScreen({Key? key}) : super(key: key);

  @override
  State<TranslateScreen> createState() => _TranslateScreenState();
}

class _TranslateScreenState extends State<TranslateScreen> {
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
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 10.0.w),
                                  child: IconButton(
                                      onPressed: () => menuC.openDrawer(),
                                      icon: SvgPicture.asset(
                                          'assets/images/menu.svg',
                                          semanticsLabel: 'Menu')),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 20.0.w),
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
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(50.0))),
                                    child: IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        const LibraryScreen()));
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
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20.0.w, vertical: 20.0.h),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20.0.w,
                                    vertical: 5.0.h // 5 top and bottom
                                    ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  // color: Colors.grey[100],
                                  border:
                                      Border.all(color: Colors.grey.shade300),
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
                                  controller: translateC.searchController,
                                  onTap: () => menuC.closeDrawer(),
                                  onChanged: (value) {
                                    // setState(() {
                                    // _searchController.text = val;
                                    // _onSearchChanged(_searchController.text);
                                    // });
                                    setState(() {
                                      translateC.debouncer.run(() {
                                        if (value != '') {
                                          translateC.getTranslation();
                                        }
                                      });
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
                                    hintText:
                                        "Enter ${translateC.originLang.value} term...",
                                    hintStyle: TextStyle(color: Colors.black54),
                                    suffixIcon:
                                        translateC.searchController.text == ""
                                            ? null
                                            : IconButton(
                                                color: Colors.black54,
                                                iconSize: 24,
                                                icon: Icon(Icons.close),
                                                onPressed: () {
                                                  setState(() {
                                                    translateC.searchController
                                                        .clear();
                                                  });
                                                }),
                                  ),
                                ),
                              ),
                            ),
                            translateC.translationList()
                          ],
                        ),
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
                                  setState(() {
                                    translateC.switchLang();
                                  });
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
