import 'package:digital_jahai/controllers/auth_controller.dart';
import 'package:digital_jahai/controllers/screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';

final authC = Get.put(AuthController());
final screenC = Get.put(ScreenController());

class DrawerScreen extends StatelessWidget {
  const DrawerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 75.h, left: 25.w, bottom: 40.h),
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
                  if (authC.isLoggedIn.value) ...[
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              authC.user.value!.name,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22.sp),
                            ),
                            SizedBox(height: 5.0.h),
                            Text(
                              authC.user.value!.email,
                              style: TextStyle(
                                  color: Colors.white70,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 13.sp),
                            )
                          ],
                        ),
                      ],
                    )
                  ] else ...[
                    SizedBox(
                      height: 50.0.h,
                    )
                  ],
                  SizedBox(height: 45.0.h),
                  if (authC.isLoggedIn.value) ...[
                    Column(
                      children: menuLogged
                          .map((element) => Padding(
                                padding: EdgeInsets.only(bottom: 5.0.h),
                                child: TextButton(
                                  onPressed: () {
                                    // Respond to button press
                                  },
                                  child: Row(children: [
                                    Icon(element['icon'],
                                        color: Colors.white54, size: 24),
                                    SizedBox(width: 15.w),
                                    Text(element['label'],
                                        style: TextStyle(
                                            color: Colors.white54,
                                            fontWeight: FontWeight.w600))
                                  ]),
                                ),
                              ))
                          .toList(),
                    )
                  ],
                  Column(
                    children: menuStatic
                        .map((element) => Padding(
                              padding: EdgeInsets.only(bottom: 5.0.h),
                              child: TextButton(
                                onPressed: () => {},
                                child: Row(children: [
                                  Icon(element['icon'],
                                      color: Colors.white54, size: 24),
                                  SizedBox(width: 15.w),
                                  Text(element['label'],
                                      style: TextStyle(
                                          color: Colors.white54,
                                          fontWeight: FontWeight.w600))
                                ]),
                              ),
                            ))
                        .toList(),
                  )
                ],
              ),
              if (authC.isLoggedIn.value == true) ...[
                TextButton(
                  onPressed: () {
                    authC.logout();
                  },
                  child: Row(
                    children: [
                      Icon(IconlyBold.logout, color: Colors.white54, size: 24),
                      SizedBox(width: 15.w),
                      Text("Logout",
                          style: TextStyle(
                              color: Colors.white54,
                              fontWeight: FontWeight.w600))
                    ],
                  ),
                )
              ] else ...[
                TextButton(
                  onPressed: () {
                    screenC.closeDrawer();

                    showCupertinoModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.white,
                        builder: (context) {
                          return LoginModal();
                        });
                  },
                  child: Row(
                    children: [
                      Icon(IconlyBold.login, color: Colors.white54, size: 24),
                      SizedBox(width: 15.w),
                      Text("Admin Login",
                          style: TextStyle(
                              color: Colors.white54,
                              fontWeight: FontWeight.w600))
                    ],
                  ),
                )
              ]
            ],
          ),
        ),
      ),
    );
  }
}

class LoginModal extends StatelessWidget {
  const LoginModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
        child: SafeArea(
      top: false,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0.h),
          child: Obx(() => Column(
                children: <Widget>[
                  if (authC.isLoggedIn.value) ...[
                    Center(
                      child: Lottie.network(
                          'https://raw.githubusercontent.com/xvrh/lottie-flutter/master/example/assets/Mobilo/A.json'),
                    ),
                  ] else ...[
                    Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0.h, horizontal: 25.0.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Admin Login",
                                    style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.w600)),
                                IconButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    icon: Icon(Icons.close)),
                              ],
                            ),
                            SizedBox(
                              height: 30.0,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    offset: Offset(0, 2),
                                    blurRadius: 3.0,
                                    color: Color(0xFF8B8DA3).withOpacity(0.3),
                                  )
                                ],
                              ),
                              child: TextFormField(
                                controller: authC.email,
                                decoration: InputDecoration(
                                    labelText: 'Email',
                                    labelStyle: TextStyle(
                                      color: Colors.grey,
                                      // backgroundColor: Colors.white,
                                    ),
                                    // errorText: 'Error message',
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0)),
                                        borderSide:
                                            BorderSide(color: Colors.white)),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0)),
                                        borderSide:
                                            BorderSide(color: Colors.grey))
                                    // suffixIcon: Icon(
                                    //   Icons.error,
                                    // ),
                                    ),
                              ),
                            ),
                            SizedBox(height: 20.0),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    offset: Offset(0, 2),
                                    blurRadius: 3.0,
                                    color: Color(0xFF8B8DA3).withOpacity(0.3),
                                  )
                                ],
                              ),
                              child: TextFormField(
                                controller: authC.password,
                                obscureText: authC.showPassword.value,
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  labelStyle: TextStyle(
                                    color: Colors.grey,
                                    // backgroundColor: Colors.white,
                                  ),
                                  // errorText: 'Error message',
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                      borderSide:
                                          BorderSide(color: Colors.white)),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                      borderSide:
                                          BorderSide(color: Colors.grey)),
                                  suffixIcon: IconButton(
                                      onPressed: () {
                                        authC.showPassword.value =
                                            !authC.showPassword.value;
                                      },
                                      icon: Icon(
                                        authC.showPassword.value
                                            ? IconlyBold.show
                                            : IconlyBold.hide,
                                        color: Colors.grey.shade400,
                                      )),
                                ),
                              ),
                            ),
                            Divider(
                              height: 50.0,
                              thickness: 0.3,
                              indent: 5,
                              endIndent: 5,
                              color: Colors.grey,
                            ),
                            Container(
                              width: double.infinity,
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
                                      BorderRadius.all(Radius.circular(10.0))),
                              child: TextButton(
                                onPressed: () {
                                  authC.login();
                                },
                                child: Text("Login",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    )),
                              ),
                            ),
                          ],
                        ))
                  ]
                ],
              )),
        ),
      ),
    ));
  }
}

List<Map> menuLogged = [
  {'icon': IconlyBold.profile, 'label': 'My Account', 'route': ''},
  {'icon': IconlyBold.category, 'label': 'Manage Terms', 'route': ''}
];

List<Map> menuStatic = [
  {'icon': IconlyBold.setting, 'label': 'Setting', 'route': ''},
  {'icon': IconlyBold.info_square, 'label': 'How to Use?', 'route': ''}
];
