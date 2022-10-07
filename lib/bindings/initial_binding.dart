// Package imports:
import 'package:get/get.dart';

// Project imports:
import '../controllers/auth_controller.dart';
import '../controllers/library_controller.dart';
import '../controllers/menu_controller.dart';
import '../controllers/translate_controller.dart';
import '../controllers/manage_term_controller.dart';

class InitialBinding implements Bindings {
// default dependency
  @override
  void dependencies() {
    Get.lazyPut(() => AuthController(), fenix: false);
    Get.lazyPut(() => MenuController(), fenix: false);
    Get.lazyPut(() => TranslateController(), fenix: false);
    Get.lazyPut(() => LibraryController(), fenix: false);
    Get.lazyPut(() => ManageTermController(), fenix: false);
  }
}
