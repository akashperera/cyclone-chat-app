import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  //TODO: Implement ProfileController

  var propic = ''.obs;
  var name = ''.obs;
  var email = ''.obs;
  var id = ''.obs;
  @override
  void onInit() {
    getData();
    super.onInit();
  }

  var user = FirebaseAuth.instance.currentUser;
  getData() {
    propic.value = user!.photoURL!;
    name.value = user!.displayName!;
    email.value = user!.email!;
    id.value = user!.uid;
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
