import 'package:digital_jahai/controllers/auth_controller.dart';
import 'package:digital_jahai/controllers/menu_controller.dart';
import 'package:digital_jahai/controllers/translate_controller.dart';
import 'package:get/get.dart';

class ControllerBinding implements Bindings {
// default dependency
 @override
 void dependencies() {
   Get.lazyPut(() => AuthController());
   Get.lazyPut(() => MenuController());
   Get.lazyPut(() => TranslateController());
 }
}