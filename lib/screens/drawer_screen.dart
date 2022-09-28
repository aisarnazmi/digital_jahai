import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controllers/auth_controller.dart';
import '../controllers/menu_controller.dart';

class DrawerScreen extends StatelessWidget {
  DrawerScreen({Key? key}) : super(key: key);

  final authC = Get.find<AuthController>();
  final menuC = Get.find<MenuController>();

  @override
  Widget build(BuildContext context) {
    // Future.delayed(Duration(milliseconds: 700),
    //     () => {KeyboardDialogModal._openKeyboardDialog(context)});
    return Obx(() => Container(
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
          child: AnimatedContainer(
            transform: Matrix4.translationValues(
                (menuC.isDrawerOpen.value
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
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 5.0.h),
                          child: TextButton(
                            onPressed: () => {},
                            child: Row(children: [
                              Icon(IconlyBold.setting,
                                  color: Colors.white54, size: 24),
                              SizedBox(width: 15.w),
                              Text('Setting',
                                  style: TextStyle(
                                      color: Colors.white54,
                                      fontWeight: FontWeight.w600))
                            ]),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 5.0.h),
                          child: TextButton(
                            onPressed: () => {
                              KeyboardDialogModal._openKeyboardDialog(context)
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
                if (authC.isLoggedIn.value == true) ...[
                  TextButton(
                    onPressed: () {
                      authC.logout();

                      menuC.closeDrawer();
                    },
                    child: Row(
                      children: [
                        Icon(IconlyBold.logout,
                            color: Colors.white54, size: 24),
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
                      menuC.closeDrawer();

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
        ));
  }
}

class LoginModal extends StatefulWidget {
  const LoginModal({Key? key}) : super(key: key);

  @override
  State<LoginModal> createState() => _LoginModalState();
}

class _LoginModalState extends State<LoginModal> {
  final authC = Get.find<AuthController>();

  Timer? _debounce;

  void _onLoginSuccess(context) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(Duration(milliseconds: 2000), () {
      Navigator.of(context).pop();
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    once(
        authC.isLoggedIn,
        (value) => {
              if (authC.isLoggedIn.value == true) {_onLoginSuccess(context)}
            });
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
                      child: Column(
                        children: [
                          Lottie.asset(
                              'assets/lottie/bluewallet-success-animation.json',
                              repeat: false,
                              height: 260.h),
                          Text('Login Success',
                              style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w500))
                        ],
                      ),
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
                  ],
                ],
              )),
        ),
      ),
    ));
  }
}

class KeyboardDialogModal extends StatelessWidget {
  const KeyboardDialogModal({Key? key}) : super(key: key);

  static Future<void> _onOpenUrl(LinkableElement link) async {
    if (await canLaunch(link.url)) {
      await launch(link.url);
    } else {
      throw 'Could not launch $link';
    }
  }

  static void _openKeyboardDialog(context) {
    showCupertinoModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        builder: (context) => KeyboardDialogModal());
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: SafeArea(
      top: false,
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(25.0.w, 10.0.h, 25.0.w, 20.0.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("How to Use?",
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
                height: 25.0.h,
              ),
              Text(
                  "Digital Jahai application required International Phonetic Alphabet (IPA) Keyboard to be used with Jahai terms."),
              SizedBox(
                height: 20.0.h,
              ),
              Text(
                  "Please install IPA keyboard using link below and, follow the installation steps: ",
                  style: TextStyle(fontWeight: FontWeight.w600)),
              SizedBox(
                height: 15.0.h,
              ),
              Linkify(
                onOpen: KeyboardDialogModal._onOpenUrl,
                options: LinkifyOptions(humanize: false),
                text:
                    "Android Platform: https://play.google.com/store/apps/details?id=com.google.android.inputmethod.latin",
              ),
              Text(
                  "\nStep to add IPA language on Gboard:-\n\n1. Open the Settings app.\n2. System > Languages & input > Keyboard > Virtual keyboard\n3. Tap Gboard and then Languages\n4. Pick International Phonetic Alphabet (IPA) language."),
              SizedBox(
                height: 15.0.h,
              ),
              Linkify(
                  onOpen: KeyboardDialogModal._onOpenUrl,
                  options: LinkifyOptions(humanize: false),
                  text:
                      "IOS Platform: https://apps.apple.com/my/app/ipa-phonetic-keyboard/id1440241497"),
              Text(
                  "\nStep to add IPA language on IOS Keyboard:-\n\n1. Open the Settings app\n2. Go to General > Keyboard > Keyboards\n3. Tap on 'Add New Keyboard'.\n4. Add 'IPA Keyboard' from the 'Third-Party Keyboards list'."),
              SizedBox(
                height: 15.0.h,
              ),
              Text(
                  "* Now you can use IPA language while typing by switching keyboard language to IPA.")
            ],
          ),
        ),
      ),
    ));
  }
}

List<Map> menuLogged = [
  {'icon': IconlyBold.profile, 'label': 'My Account', 'route': ''},
  {'icon': IconlyBold.category, 'label': 'Manage Terms', 'route': ''}
];
