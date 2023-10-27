import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_storage/get_storage.dart';
import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Cyclone App",
      defaultTransition: Transition.cupertino,
      initialRoute: FirebaseAuth.instance.currentUser != null
          ? Routes.HOME
          : Routes.WELCOME,
      getPages: AppPages.routes,
    ),
  );
}
