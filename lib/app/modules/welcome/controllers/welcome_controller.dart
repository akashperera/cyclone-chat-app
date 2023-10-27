import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../routes/app_pages.dart';

class WelcomeController extends GetxController {
  //TODO: Implement WelcomeController

  final currentPosition = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  changePage(int index) {
    currentPosition.value = index;
  }
}
