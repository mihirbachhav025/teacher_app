import 'package:get/get.dart';
import 'package:teacher_app/controllers/DetailsController.dart';
import 'package:teacher_app/controllers/HomeContoller.dart';

import '../LoginController.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // Register the LoginController
    Get.lazyPut(() => LoginController());
    Get.lazyPut(() => HomeController());
    Get.lazyPut(() => DetailsController());
  }
}
