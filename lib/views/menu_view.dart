// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

// Project imports:
import '../controllers/auth_controller.dart';
import '../controllers/menu_controller.dart';

class MenuView extends StatelessWidget {
  MenuView({Key? key}) : super(key: key);

  final authC = Get.find<AuthController>();
  final menuC = Get.find<MenuController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    margin: EdgeInsets.fromLTRB(0, 1, 15, 0),
                    child: Icon(IconlyBold.profile,
                        color: Colors.white60, size: 30)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      authC.isLoggedIn.isTrue
                          ? authC.user.value!.name
                          : 'Guest',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 22.sp),
                    ),
                    SizedBox(height: 5.0.h),
                    Text(
                      authC.isLoggedIn.isTrue ? authC.user.value!.email : '',
                      style: TextStyle(
                          color: Colors.white70,
                          fontWeight: FontWeight.w600,
                          fontSize: 13.sp),
                    )
                  ],
                ),
              ],
            ),
            SizedBox(height: 45.0.h),
            if (authC.isLoggedIn.isTrue) ...[
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 5.0.h),
                    child: TextButton(
                      onPressed: () => {Get.toNamed('/manage-term')},
                      child: Row(children: [
                        Icon(IconlyBold.category,
                            color: Colors.white54, size: 24),
                        SizedBox(width: 15.w),
                        Text('Manage Terms',
                            style: TextStyle(
                                color: Colors.white54,
                                fontWeight: FontWeight.w600))
                      ]),
                    ),
                  )
                ],
              )
            ],
            Column(
              children: [
                // Padding(
                //   padding: EdgeInsets.only(bottom: 5.0.h),
                //   child: TextButton(
                //     onPressed: () => {},
                //     child: Row(children: [
                //       Icon(IconlyBold.setting, color: Colors.white54, size: 24),
                //       SizedBox(width: 15.w),
                //       Text('Setting',
                //           style: TextStyle(
                //               color: Colors.white54,
                //               fontWeight: FontWeight.w600))
                //     ]),
                //   ),
                // ),
                Padding(
                  padding: EdgeInsets.only(bottom: 5.0.h),
                  child: TextButton(
                    onPressed: () {
                      showCupertinoModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.white,
                          builder: (context) => menuC.keyboardDialogModal());
                    },
                    child: Row(children: [
                      Icon(IconlyBold.info_square,
                          color: Colors.white54, size: 24),
                      SizedBox(width: 15.w),
                      Text('How to Use?',
                          style: TextStyle(
                              color: Colors.white54,
                              fontWeight: FontWeight.w600))
                    ]),
                  ),
                )
              ],
            )
          ],
        ),
        if (authC.isLoggedIn.isTrue) ...[
          TextButton(
            onPressed: () {
              authC.logout();
              menuC.closeDrawer();
            },
            child: Row(
              children: [
                Icon(IconlyBold.logout, color: Colors.white54, size: 24),
                SizedBox(width: 15.w),
                Text("Logout",
                    style: TextStyle(
                        color: Colors.white54, fontWeight: FontWeight.w600))
              ],
            ),
          )
        ] else ...[
          TextButton(
            onPressed: () {
              menuC.closeDrawer();

              showCupertinoModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.white,
                  builder: (context) {
                    return authC.loginModal();
                  });
            },
            child: Row(
              children: [
                Icon(IconlyBold.login, color: Colors.white54, size: 24),
                SizedBox(width: 15.w),
                Text("Admin",
                    style: TextStyle(
                        color: Colors.white54, fontWeight: FontWeight.w600))
              ],
            ),
          )
        ]
      ],
    );
  }
}
