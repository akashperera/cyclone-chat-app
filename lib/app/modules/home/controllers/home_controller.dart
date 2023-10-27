import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController

  final currentPage = 0.obs;
  final List<String> tabTitles = ['Chat', 'Contacts', 'Profile'];
  final List<BottomNavigationBarItem> bottomNavItems = [
    BottomNavigationBarItem(
      icon: Icon(Icons.chat),
      label: 'Chat',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.contacts),
      label: 'Contacts',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person),
      label: 'Profile',
    ),
  ];
  final PageController pageController = PageController();
  @override
  void onInit() {
    SystemChannels.lifecycle.setMessageHandler((msg) {
      if (msg == AppLifecycleState.resumed.toString()) {
        updateUserStatus(true); // App is in the foreground
      } else if (msg == AppLifecycleState.paused.toString()) {
        updateUserStatus(false); // App is in the background
      } else if (msg == AppLifecycleState.detached.toString()) {
        updateUserStatus(false); // App is closed
      } else if (msg == AppLifecycleState.inactive.toString()) {
        updateUserStatus(false); // App is in the background
      }
      return Future.value('');
    });
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  changePage(int index) {
    currentPage.value = index;
  }

  changeBottomPage(int index) {
    pageController.animateToPage(index,
        duration: Duration(milliseconds: 300), curve: Curves.easeIn);
  }
}

FirebaseFirestore firestore = FirebaseFirestore.instance;
void updateUserStatus(bool isOnline) async {
  print("User is online: $isOnline");
  if (FirebaseAuth.instance.currentUser != null) {
    await firestore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      'lastSeen': DateTime.now().toString(),
      'isOnline': isOnline,
    });
  }
}
