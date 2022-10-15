// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iconly/iconly.dart';
import 'package:lottie/lottie.dart';
import 'package:platform_device_id/platform_device_id.dart';

// Project imports:
import '../models/user.dart';
import '../utils/debouncer.dart';
import '../utils/http_service.dart';

class AuthController extends GetxController {
  List<String> errors = [];
  String loginFailedMsg = '';

  var isLogin = false.obs;
  var isLoggedIn = false.obs;
  var showPassword = true.obs;
  var token = Rx<String?>(null);
  var user = Rx<User?>(null);

  final successDebouncer = Debouncer(milliseconds: 2500);
  final errorDebouncer = Debouncer(milliseconds: 1300);

  late TextEditingController emailController;
  late TextEditingController passwordController;
  late GetStorage box;

  @override
  void onInit() async {
    super.onInit();

    emailController = TextEditingController();
    passwordController = TextEditingController();

    await GetStorage.init();
    box = GetStorage();
    if (box.read('token') != null) {
      var localToken = box.read('token');

      if (localToken != null) {
        tryToken(localToken);
      }
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  bool validate() {
    errors = [];

    errors.addIf(emailController.text == "", "email");
    errors.addIf(passwordController.text == "", "password");

    if (errors.isNotEmpty) {
      return false;
    }

    return true;
  }

  void login() async {
    isLogin.value = true;

    update();

    try {
      final deviceId = await PlatformDeviceId.getDeviceId;

      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      };

      var payload = {
        'email': emailController.text,
        'password': passwordController.text,
        'device_id': deviceId
      };

      final response = await HttpService().post('/login', headers, payload);

      if (response.statusCode == 200) {
        token.value = json.decode(response.body);

        tryToken(token.value);
      } else {
        loginFailedMsg = json.decode(response.body)['message'];
        loginFailedDialog(loginFailedMsg);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }

    update();
  }

  void tryToken(val) async {
    if (val == null) {
      return;
    } else {
      try {
        final headers = {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $val',
        };

        final response = await HttpService().get('/user', headers);

        if (response.statusCode == 200) {
          isLoggedIn.value = true;
          box.write('token', val);
          token.value = val;
          user.value = User.fromJson(json.decode(response.body));
        } else if (response.statusCode == 401) {
          loginFailedMsg = json.decode(response.body)['message'];
          loginFailedDialog(loginFailedMsg);
          clearAuth();
        }

        errorDebouncer.run(() {
          isLogin.value = false;
          update();
        });
      } catch (e) {
        if (kDebugMode) {
          print(e.toString());
        }
      }
    }

    update();
  }

  void logout() async {
    try {
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final response = await HttpService().get('/logout', headers);

      if (response.statusCode == 200) {
        clearAuth();
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  void clearAuth() {
    isLoggedIn.value = false;
    box.remove('token');
    token.value = null;
    user.value = null;

    update();
  }

  void onLoginSuccess() {
    successDebouncer.run(() {
      Get.back();
    });
  }

  void loginFailedDialog(message) {
    Get.snackbar('Login Failed', message,
        icon: Icon(
          IconlyBold.shield_fail,
          color: Colors.white,
        ),
        shouldIconPulse: false,
        snackPosition: SnackPosition.TOP,
        duration: Duration(milliseconds: 2500),
        isDismissible: true,
        backgroundColor: Color(0xffec6882),
        backgroundGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: const [
              Color(0xffeb7c91),
              Color(0xffec6882),
            ]),
        boxShadows: [
          BoxShadow(
            offset: Offset(5, 10),
            blurRadius: 20.0,
            color: const Color(0xffec6882).withOpacity(0.4),
          )
        ],
        colorText: Colors.white);

    loginFailedMsg = '';
    errorDebouncer.run(() {
      isLogin.value = false;
      update();
    });
  }

  Widget loginModal() {
    once(
        isLoggedIn,
        (value) => {
              if (isLoggedIn.isTrue) {onLoginSuccess()}
            });
    return GetBuilder<AuthController>(
        init: AuthController(),
        builder: (context) {
          return Material(
              child: SafeArea(
            top: false,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0.h),
                child: Column(
                  children: <Widget>[
                    if (isLoggedIn.isTrue) ...[
                      Center(
                        child: Column(
                          children: [
                            SizedBox(
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top: 40, bottom: 20, left: 100, right: 100),
                                child: Lottie.asset(
                                    'assets/lottie/loading-success.json',
                                    repeat: false),
                              ),
                            ),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Admin Login",
                                      style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.w600)),
                                  IconButton(
                                      onPressed: () {
                                        Get.back();
                                      },
                                      icon: Icon(Icons.close)),
                                ],
                              ),
                              SizedBox(
                                height: 30.0,
                              ),
                              Form(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          offset: Offset(0, 2),
                                          blurRadius: 3.0,
                                          color: Color(0xFF8B8DA3)
                                              .withOpacity(0.3),
                                        )
                                      ],
                                    ),
                                    child: TextFormField(
                                      controller: emailController,
                                      decoration: InputDecoration(
                                        labelText: 'Jahai Term',
                                        labelStyle: TextStyle(
                                          color: Colors.grey,
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0)),
                                            borderSide: BorderSide(
                                                color:
                                                    !!errors.contains("email")
                                                        ? Colors.red.shade500
                                                        : Colors.transparent)),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0)),
                                            borderSide:
                                                BorderSide(color: Colors.grey)),
                                        suffixIcon: !!errors.contains("email")
                                            ? Icon(Icons.error,
                                                color: const Color(0xffec6882))
                                            : null,
                                      ),
                                    ),
                                  ),
                                  if (!!errors.contains("email")) ...[
                                    validationError("email"),
                                    SizedBox(height: 10.0),
                                  ] else ...[
                                    SizedBox(height: 20.0),
                                  ],
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          offset: Offset(0, 2),
                                          blurRadius: 3.0,
                                          color: Color(0xFF8B8DA3)
                                              .withOpacity(0.3),
                                        )
                                      ],
                                    ),
                                    child: TextFormField(
                                      controller: passwordController,
                                      obscureText: showPassword.value,
                                      onChanged: (_) {
                                        update();
                                      },
                                      decoration: InputDecoration(
                                        labelText: 'Password',
                                        labelStyle: TextStyle(
                                          color: Colors.grey,
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0)),
                                            borderSide: BorderSide(
                                                color: !!errors
                                                        .contains("password")
                                                    ? Colors.red.shade500
                                                    : Colors.transparent)),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0)),
                                            borderSide:
                                                BorderSide(color: Colors.grey)),
                                        suffixIcon: !!errors
                                                    .contains("password") &&
                                                passwordController.text == ""
                                            ? Icon(Icons.error,
                                                color: const Color(0xffec6882))
                                            : (IconButton(
                                                onPressed: () {
                                                  showPassword.value =
                                                      !showPassword.value;

                                                  update();
                                                },
                                                icon: Icon(
                                                  showPassword.value
                                                      ? IconlyBold.show
                                                      : IconlyBold.hide,
                                                  color: Colors.grey.shade400,
                                                ))),
                                      ),
                                    ),
                                  ),
                                  if (!!errors.contains("password")) ...[
                                    validationError("password")
                                  ],
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
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0))),
                                    child: TextButton(
                                      onPressed: () {
                                        if (isLogin.isTrue) {
                                          return;
                                        }

                                        if (validate()) {
                                          login();
                                        } else {
                                          update();
                                        }
                                      },
                                      child: isLogin.isFalse
                                          ? Text("Login",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                              ))
                                          : SizedBox(
                                              height: 18,
                                              width: 18,
                                              child:
                                                  const CircularProgressIndicator(
                                                color: Colors.white,
                                                strokeWidth: 3.0,
                                              ),
                                            ),
                                    ),
                                  ),
                                ],
                              ))
                            ],
                          ))
                    ],
                  ],
                ),
              ),
            ),
          ));
        });
  }

  Widget validationError(field) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
        child: Text(
          'Please input $field.',
          style: TextStyle(color: Colors.red.shade500, fontSize: 12.sp),
        ));
  }
}
