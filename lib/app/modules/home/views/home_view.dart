import 'package:cyclone/app/modules/home/views/chats_view.dart';
import 'package:cyclone/app/modules/home/views/users_view.dart';
import 'package:cyclone/app/modules/welcome/views/google_button.dart';
import 'package:cyclone/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'profile_view.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() {
          return Text(controller.currentPage.value == 0
              ? 'Chats'
              : controller.currentPage.value == 1
                  ? 'Contacts'
                  : 'Profile');
        }),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.blueAccent,
        toolbarHeight: MediaQuery.of(context).size.height * 0.1,
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
                child: Container(
              child: PageView(
                // physics: NeverScrollableScrollPhysics(),
                controller: controller.pageController,
                onPageChanged: (index) {
                  controller.changePage(index);
                },
                children: [ChatsView(), UsersView(), ProfileView()],
              ),
            )),
            Obx(() => BottomNavigationBar(
                  items: controller.bottomNavItems,
                  onTap: (index) {
                    controller.changeBottomPage(index);
                  },
                  currentIndex: controller.currentPage.value,
                  selectedItemColor: Colors.blueAccent,
                  unselectedItemColor: Colors.grey,
                ))
          ],
        ),
      ),
    );
  }
}
