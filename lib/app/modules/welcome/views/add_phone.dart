import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/addphone_controller.dart';

class AddPhoneScreen extends GetView<AddPhoneController> {
  const AddPhoneScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/bg.jpg'), fit: BoxFit.cover)),
            padding: const EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade200, width: 2),
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: [
                      const Text(
                        'Set your phone number',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              style: const TextStyle(color: Colors.white),
                              keyboardType: TextInputType.phone,
                              controller: controller.phoneController.value,
                              decoration: InputDecoration(
                                  isDense: true,
                                  hintText: 'Phone Number',
                                  hintStyle:
                                      const TextStyle(color: Colors.grey),
                                  prefixIcon: const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.phone,
                                          color: Colors.grey,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          '+94',
                                          style: TextStyle(color: Colors.grey),
                                        )
                                      ],
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                          color: Colors.grey.shade200)),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                          color: Colors.blue.shade200)),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10))),
                            ),
                          ),
                        ], // children)
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Obx(() => ElevatedButton(
                          onPressed: () {
                            controller.validate();
                          },
                          child: controller.isLoading.value
                              ? CircularProgressIndicator(
                                  color: Colors.blue.shade100,
                                )
                              : const Text('Continue',
                                  style: TextStyle(fontSize: 18)),
                          style: ElevatedButton.styleFrom(
                              primary: Colors.blueAccent,
                              minimumSize: const Size(double.infinity, 50)))),
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
