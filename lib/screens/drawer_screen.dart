import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconly/iconly.dart';

class DrawerScreen extends StatefulWidget {
  const DrawerScreen({Key? key}) : super(key: key);

  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return Container(
      padding: EdgeInsets.only(top: 50.h, left: 15.w, bottom: 30.h),
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Row(
                children: [
                  CircleAvatar(),
                  SizedBox(width: 20.w),
                  Column(
            crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Guest",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20.sp),
                      ),
              SizedBox(height: 2.0.h),
              Text(
                        "guest@gmail.com",
                        style: TextStyle(
                            color: Colors.white70, fontWeight: FontWeight.normal, fontSize: 13.sp),
                      )
                    ],
                  ),
                ],
              ),
          SizedBox(height: 80.0.h),
              Padding(
                padding: EdgeInsets.only(bottom: 25.0.h, left: 8.0.w),
                child: Row(
                  children: [
                    Icon(IconlyBold.profile, color: Colors.white54, size: 22),
                    SizedBox(width: 15.w),
                    Text("My Account",
                        style: TextStyle(
                            color: Colors.white54, fontWeight: FontWeight.w600))
                  ],
                ),
              ),
          Padding(
                padding: EdgeInsets.only(bottom: 25.0.h, left: 8.0.w),
                child: Row(
                  children: [
                    Icon(IconlyBold.category,
                        color: Colors.white54, size: 22),
                    SizedBox(width: 15.w),
                    Text("Manage",
                        style: TextStyle(
                            color: Colors.white54, fontWeight: FontWeight.w600))
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 25.0.h, left: 8.0.w),
                child: Row(
                  children: [
                    Icon(IconlyBold.info_square,
                        color: Colors.white54, size: 22),
                    SizedBox(width: 15.w),
                    Text("How to Use?",
                        style: TextStyle(
                            color: Colors.white54, fontWeight: FontWeight.w600))
                  ],
                ),
              )
            ],
          ),
          Row(
            children: [
              Icon(IconlyBold.setting, color: Colors.white54, size: 22),
              SizedBox(width: 15.w),
              Text("Settings",
                  style: TextStyle(
                      color: Colors.white54, fontWeight: FontWeight.w600)),
              Container(
                width: 2,
                height: 12,
                color: Colors.white54,
                margin: EdgeInsets.symmetric(horizontal: 10),
              ),
              Text("Login",
                  style: TextStyle(
                      color: Colors.white54, fontWeight: FontWeight.w600))
            ],
          )
        ],
      ),
    );
  }
}
