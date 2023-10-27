import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cyclone/app/routes/app_pages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddPhoneController extends GetxController {
  final phoneController = TextEditingController().obs;
  var isLoading = false.obs;
  validate() {
    if (phoneController.value.text.length != 9) {
      Get.snackbar('Error', 'Please enter a valid phone number',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          margin: EdgeInsets.all(10));
    } else {
      addPhoneToFirebase();
    }
  }

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  addPhoneToFirebase() async {
    isLoading.value = true;
    await firestore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      'phoneNumber': '+94' + phoneController.value.text,
    }).then((value) {
      isLoading.value = false;
      Get.offAllNamed(Routes.HOME);
    });
  }
}
