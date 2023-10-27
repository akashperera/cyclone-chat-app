import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cyclone/app/data/timeAgo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../controllers/chat_page_controller.dart';
import 'image_view.dart';

class ChatPageView extends GetView<ChatPageController> {
  const ChatPageView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        titleSpacing: 0,
        elevation: 0,
        backgroundColor: Colors.blueAccent,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(
                Get.arguments['propic'],
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(Get.arguments['name']),
                Obx(() {
                  if (controller.lastSeen.value != '') {
                    if (controller.isOnline.value) {
                      return Row(
                        children: [
                          Icon(
                            Icons.circle,
                            color: Colors.green[300],
                            size: 10,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            'Online',
                            style: TextStyle(
                                fontSize: 10, color: Colors.green[300]),
                          ),
                        ],
                      );
                    } else {
                      return Row(
                        children: [
                          Icon(
                            Icons.circle,
                            color: Colors.grey[300],
                            size: 10,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            'Last seen ' +
                                dateTimeAgo(controller.lastSeen.value),
                            style: TextStyle(
                                fontSize: 10, color: Colors.grey[300]),
                          ),
                        ],
                      );
                    }
                  } else {
                    return const Text('');
                  }
                }),
              ],
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/chat.jpg'), fit: BoxFit.cover)),
        child: Column(
          children: [
            Expanded(
              child: FirestoreListView(
                reverse: true,
                query: FirebaseFirestore.instance
                    .collection('users')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .collection('chats')
                    .doc(Get.arguments['uid'])
                    .collection('messages')
                    .orderBy('timestamp', descending: true),
                itemBuilder: (
                  context,
                  snapshot,
                ) {
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment:
                          FirebaseAuth.instance.currentUser!.uid ==
                                  (snapshot.data() as Map)['uid']
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (FirebaseAuth.instance.currentUser!.uid !=
                            (snapshot.data() as Map)['uid'])
                          CircleAvatar(
                            backgroundImage: NetworkImage(
                                (snapshot.data() as Map)['propic']),
                          ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment:
                              FirebaseAuth.instance.currentUser!.uid ==
                                      (snapshot.data() as Map)['uid']
                                  ? CrossAxisAlignment.end
                                  : CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () {
                                if (!(snapshot.data() as Map)['isScanning']) {
                                  controller.showPhishingPopup(
                                      (snapshot.data() as Map)['status'],
                                      (snapshot.data() as Map)['links'][0]);
                                }
                              },
                              child: Container(
                                  constraints:
                                      BoxConstraints(maxWidth: Get.width * 0.7),
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: FirebaseAuth
                                                .instance.currentUser!.uid ==
                                            (snapshot.data() as Map)['uid']
                                        ? Colors.blueAccent
                                        : ((snapshot.data() as Map)['status']
                                                .toString()
                                                .contains('unsafe')
                                            ? Colors.red[100]
                                            : (snapshot.data() as Map)['status']
                                                    .toString()
                                                    .contains('safe')
                                                ? Colors.green[100]
                                                : Colors.grey[200]),
                                  ),
                                  child: (snapshot.data() as Map)['imgUrl'] !=
                                          ''
                                      ? Image.network(
                                          (snapshot.data() as Map)['imgUrl'],
                                          width: Get.width * 0.7,
                                        )
                                      : Text(
                                          (snapshot.data() as Map)['message'],
                                          style: TextStyle(
                                            color: FirebaseAuth.instance
                                                        .currentUser!.uid ==
                                                    (snapshot.data()
                                                        as Map)['uid']
                                                ? Colors.white
                                                : Colors.black,
                                          ))),
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                if ((snapshot.data() as Map)['isScanning'])
                                  Row(
                                    children: [
                                      SizedBox(
                                          height: 10,
                                          width: 10,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.blueAccent.shade700,
                                          )),
                                      const SizedBox(width: 5),
                                      Text('scanning...',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.blueAccent.shade700,
                                            fontWeight: FontWeight.bold,
                                          )),
                                    ],
                                  ),
                                ((snapshot.data() as Map)['status']
                                        .toString()
                                        .contains('unsafe'))
                                    ? const Icon(
                                        Icons.warning_amber_outlined,
                                        color: Colors.red,
                                        size: 15,
                                      )
                                    : ((snapshot.data() as Map)['status']
                                            .toString()
                                            .contains('safe'))
                                        ? const Icon(
                                            Icons.check_circle_outline,
                                            color: Colors.green,
                                            size: 15,
                                          )
                                        : Container(),
                                const SizedBox(width: 5),
                                Text(
                                  dateTimeAgo(
                                      (snapshot.data() as Map)['timestamp']),
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: controller.txtController.value,
                      decoration: InputDecoration(
                        hintText: 'Type a message',
                        contentPadding: const EdgeInsets.all(10),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(
                            color: Colors.transparent,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(
                            color: Colors.transparent,
                          ),
                        ),
                        fillColor: Colors.grey[100],
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  InkWell(
                    onTap: () async {
                      controller.pickImage();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromARGB(255, 7, 106, 58),
                      ),
                      child: const Icon(
                        Icons.image,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  InkWell(
                    onTap: () {
                      controller.validate();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blueAccent,
                      ),
                      child: const Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
