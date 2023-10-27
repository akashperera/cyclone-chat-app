import 'package:cyclone/app/modules/welcome/controllers/addphone_controller.dart';
import 'package:get/get.dart';

import '../controllers/welcome_controller.dart';

class WelcomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WelcomeController>(
      () => WelcomeController(),
    );
    Get.lazyPut<AddPhoneController>(
      () => AddPhoneController(),
    );
  }
}
