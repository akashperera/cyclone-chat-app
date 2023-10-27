import 'package:cyclone/app/modules/welcome/views/google_button.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/welcome_controller.dart';

class WelcomeView extends GetView<WelcomeController> {
  const WelcomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/bg.jpg'), fit: BoxFit.cover)),
      child: Stack(
        alignment: Alignment.center,
        children: [
          PageView(
            controller: PageController(
              initialPage: 0,
              keepPage: false,
              viewportFraction: 1,
            ),
            onPageChanged: (index) {
              controller.changePage(index);
            },
            physics: const ClampingScrollPhysics(),
            pageSnapping: true,
            children: [
              SafeArea(
                child: Column(children: [
                  const Spacer(),
                  Image.asset(
                    'assets/logo.png',
                    height: 200,
                    width: 200,
                    color: Colors.white,
                  ),
                  const Spacer(),
                  const Text(
                    'Welcome to Cyclone',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'Get connected with your friends and family',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.normal),
                  ),
                  const Spacer(),
                ]),
              ),
              SafeArea(
                child: Column(children: [
                  const Spacer(),
                  Image.asset('assets/chat.png', height: 200, width: 200),
                  const Spacer(),
                  const Text(
                    'Send Messages',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'Send messages to your friends and family',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.normal),
                  ),
                  const Spacer(),
                ]),
              ),
              SafeArea(
                child: Column(children: [
                  const Spacer(),
                  Image.asset('assets/security.png', height: 200, width: 200),
                  const Spacer(),
                  const Text(
                    'Highly Secure',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'Phishing Url Detection and Firebase Protection',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.normal),
                  ),
                  const Spacer(),
                  GoogleButton(),
                  const Spacer()
                ]),
              ),
            ],
          ),
          Positioned(
              bottom: 70,
              child: Obx(() => DotsIndicator(
                  position: controller.currentPosition.value,
                  dotsCount: 3,
                  reversed: false,
                  mainAxisAlignment: MainAxisAlignment.center,
                  decorator: DotsDecorator(
                      activeColor: Colors.blue,
                      size: const Size.square(9.0),
                      activeSize: const Size(18.0, 9.0),
                      activeShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0))))))
        ],
      ),
    ));
  }
}
