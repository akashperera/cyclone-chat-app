import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../controllers/users_controller.dart';

class UsersView extends GetView<UsersController> {
  const UsersView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(top: 20),
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/chat.jpg'), fit: BoxFit.cover)),
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return RefreshIndicator(
            onRefresh: () async {
              await controller.getContacts();
            },
            child: ListView.builder(
              itemCount: controller.firebaseContacts.length,
              reverse: false,
              itemBuilder: (
                context,
                index,
              ) {
                var contact = controller.firebaseContacts[index];
                return ListTile(
                  onTap: () {
                    Get.toNamed(Routes.CHAT_PAGE, arguments: {
                      'uid': (contact)['uid'],
                      'name': (contact)['name'],
                      'propic': (contact)['propic'],
                    });
                  },
                  title: Text((contact['name'])),
                  subtitle: Text(contact['phoneNumber']),
                  leading: CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.grey.shade300,
                      backgroundImage: NetworkImage(
                        (contact['propic']),
                      )),
                );
              },
            ),
          );
        }),
      ),
    );
  }
}
