// Package imports:
import 'package:get/get.dart';

// Project imports:
import '../controllers/auth_controller.dart';
import '../controllers/menu_controller.dart';
import '../controllers/translate_controller.dart';

class InitialBinding implements Bindings {
// default dependency
 @override
 void dependencies() {
   Get.lazyPut(() => AuthController(), fenix: true);
   Get.lazyPut(() => MenuController(), fenix: true);
   Get.lazyPut(() => TranslateController(), fenix: true);
 }
}
