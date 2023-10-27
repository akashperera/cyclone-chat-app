import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cyclone/app/data/timeAgo.dart';
import 'package:cyclone/app/routes/app_pages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:phish_detector/phish_detector.dart';

import '../controllers/chat_controller.dart';
import '../controllers/users_controller.dart';

class ChatsView extends GetView<ChatController> {
  const ChatsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(top: 20),
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/chat.jpg'), fit: BoxFit.cover)),
        child: FirestoreListView(
          reverse: false,
          query: FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection('chats')
              .orderBy('timestamp', descending: true),
          itemBuilder: (
            context,
            snapshot,
          ) {
            var data = snapshot.data() as Map<String, dynamic>;
            return Column(
              children: [
                ListTile(
                  onTap: () {
                    Get.toNamed(Routes.CHAT_PAGE, arguments: {
                      'uid': data['receiverUid'],
                      'name': data['receiverName'],
                      'propic': data['receiverPropic'],
                    });
                  },
                  trailing: Text(
                    dateTimeAgo(data['timestamp']),
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                  title: Text(
                    data['receiverName'],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(data['message'].toString()),
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(data['receiverPropic']),
                  ),
                ),
                const Divider(
                  height: 1,
                ),
                // Phish(
                //   isIcon: true,
                //   iconAlignRight: false,
                //   text: "your https://www.google.com here",
                //   child: Align(
                //     alignment: Alignment.centerLeft,
                //     child: Container(
                //         decoration: BoxDecoration(
                //           color: Colors.grey[300],
                //           borderRadius: BorderRadius.circular(10),
                //         ),
                //         padding: EdgeInsets.all(10),
                //         child: Text("Hello")),
                //   ),
                //   onTap: (url, status, percentage) {
                //     print("$url $status $percentage");
                //   },
                // ),
              ],
            );
          },
        ),
      ),
    );
  }
}
