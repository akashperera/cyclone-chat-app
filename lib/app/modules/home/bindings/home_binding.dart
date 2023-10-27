import 'package:get/get.dart';

import '../controllers/chat_controller.dart';
import '../controllers/profile_controller.dart';
import '../controllers/home_controller.dart';
import '../controllers/users_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
    Get.lazyPut<ProfileController>(
      () => ProfileController(),
    );
    Get.lazyPut<UsersController>(
      () => UsersController(),
    );
    Get.lazyPut<ChatController>(
      () => ChatController(),
    );
  }
}
