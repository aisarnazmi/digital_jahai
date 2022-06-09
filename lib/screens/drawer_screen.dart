import 'package:digital_jahai/controllers/screen_controller.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';

class DrawerScreen extends StatelessWidget {
  DrawerScreen({Key? key}) : super(key: key);

  final screenC = Get.put(ScreenController());

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 60.h, left: 25.w, bottom: 40.h),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xff181d5f),
            Color(0xff112043),
          ],
        ),
      ),
      child: Obx(
        () => AnimatedContainer(
          transform: Matrix4.translationValues(
              (screenC.isDrawerOpen.value
                  ? 0
                  : -MediaQuery.of(context).size.width),
              0,
              0),
          duration: Duration(milliseconds: 200),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Guest",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 32.sp),
                          ),
                          SizedBox(height: 5.0.h),
                          Text(
                            "guest@gmail.com",
                            style: TextStyle(
                                color: Colors.white70,
                                fontWeight: FontWeight.normal,
                                fontSize: 13.sp),
                          )
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 80.0.h),
                  Column(
                    children: menuItems
                        .map((element) => Padding(
                          padding: EdgeInsets.only(bottom: 30.0.h),
                          child: Row(children: [
                                Icon(element['icon'],
                                    color: Colors.white54, size: 24),
                                SizedBox(width: 15.w),
                                Text(element['label'],
                                    style: TextStyle(
                                        color: Colors.white54,
                                        fontWeight: FontWeight.w600))
                              ]),
                        ))
                        .toList(),
                  )
                ],
              ),
              Row(
                children: [
                  Icon(IconlyBold.login, color: Colors.white54, size: 24),
                  SizedBox(width: 15.w),
                  Text("Login",
                      style: TextStyle(
                          color: Colors.white54, fontWeight: FontWeight.w600))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

List<Map> menuItems = [
  {'icon': IconlyBold.profile, 'label': 'My Account', 'route': ''},
  {'icon': IconlyBold.category, 'label': 'Manage Terms', 'route': ''},
  {'icon': IconlyBold.setting, 'label': 'Setting', 'route': ''},
  {'icon': IconlyBold.info_square, 'label': 'How to Use?', 'route': ''}
];
