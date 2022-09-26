import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iconly/iconly.dart';
import 'package:platform_device_id/platform_device_id.dart';

import '../utils/call_api.dart';

import 'package:digital_jahai/models/user.dart';

class AuthController extends GetxController {
  var isLoggedIn = false.obs;
  var loginFailedMsg = '';

  var token = Rx<String?>(null);
  var user = Rx<User?>(null);

  late TextEditingController email;
  late TextEditingController password;

  var showPassword = true.obs;

  late GetStorage box;

  @override
  void onInit() async {
    super.onInit();

    await GetStorage.init();

    email = TextEditingController();
    password = TextEditingController();

    box = GetStorage();
    var localToken = box.read('token');

    if (localToken != null) {
      tryToken(localToken);
    }
  }

  @override
  void onClose() {
    email.dispose();
    password.dispose();
    super.onClose();
  }

  void login() async {
    try {
      final deviceId = await PlatformDeviceId.getDeviceId;

      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      };

      var payload = {
        'email': email.text,
        'password': password.text,
        'device_id': deviceId
      };

      final response = await CallApi().post('/sanctum/token', headers, payload);

      if (response.statusCode == 200) {
        token.value = json.decode(response.body);
        tryToken(token.value);
      } else {
        loginFailedMsg = json.decode(response.body)['message'];
        
        Get.snackbar('Login Failed', loginFailedMsg,
            icon: Icon(
              IconlyBold.shield_fail,
              color: Colors.white,
            ),
            shouldIconPulse: false,
            snackPosition: SnackPosition.BOTTOM,
            duration: Duration(milliseconds: 1500),
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
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
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

        final response = await CallApi().get('/user', headers);

        if (response.statusCode == 200) {
          isLoggedIn.value = true;
          box.write('token', val);
          token.value = val;
          user.value = User.fromJson(json.decode(response.body));
        }
      } catch (e) {
        if (kDebugMode) {
          print(e.toString());
        }
      }
    }
  }

  void logout() async {
    try {
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final response = await CallApi().get('/user/revoke', headers);

      if (response.statusCode == 200) {
        isLoggedIn.value = false;
        box.remove('token');
        token.value = null;
        user.value = null;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }
}
