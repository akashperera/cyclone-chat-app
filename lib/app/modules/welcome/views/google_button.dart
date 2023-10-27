import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cyclone/app/modules/home/controllers/home_controller.dart';
import 'package:cyclone/app/modules/welcome/views/add_phone.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../routes/app_pages.dart';

class GoogleButton extends StatefulWidget {
  @override
  State<GoogleButton> createState() => _GoogleButtonState();
}

class _GoogleButtonState extends State<GoogleButton> {
  bool isLoading = false;
  Future googleSignIn() async {
    try {
      setState(() {
        isLoading = true;
      });
      final googleSignIn = GoogleSignIn();
      final googleUser = await googleSignIn.signIn();
      if (googleUser != null) {
        final googleAuth = await googleUser.authentication;
        if (googleAuth.idToken != null && googleAuth.accessToken != null) {
          try {
            final userCredential =
                await FirebaseAuth.instance.signInWithCredential(
              GoogleAuthProvider.credential(
                idToken: googleAuth.idToken,
                accessToken: googleAuth.accessToken,
              ),
            );
            print(userCredential);
            saveData();
            setState(() {
              isLoading = false;
            });
            Get.off(() => const AddPhoneScreen());
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Logged in successfully'),
              ),
            );
          } on FirebaseAuthException catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(e.message!),
              ),
            );
            setState(() {
              isLoading = false;
            });
          }
        }
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message!),
        ),
      );
    }
  }

  CollectionReference users = FirebaseFirestore.instance.collection('users');
  saveData() async {
    final timestamp = DateTime.now().toString();
    final status =
        await users.doc(FirebaseAuth.instance.currentUser!.uid).get();
    if (status.exists) {
      print('user already exists');
    } else {
      users.doc(FirebaseAuth.instance.currentUser!.uid).set({
        'name': FirebaseAuth.instance.currentUser!.displayName,
        'email': FirebaseAuth.instance.currentUser!.email,
        'propic': FirebaseAuth.instance.currentUser!.photoURL,
        'uid': FirebaseAuth.instance.currentUser!.uid,
        'phoneNumber': '',
        'createdOn': timestamp,
        'language': 'English',
        'token': '',
        'lastSeen': timestamp,
        'isOnline': true,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        googleSignIn();
      },
      child: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : Container(
                width: 200,
                height: 50,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/google.png',
                        width: 25,
                        height: 25,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text(
                        'Get Started',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

logout() async {
  final googleSignIn = GoogleSignIn();
  updateUserStatus(false);
  await googleSignIn.signOut();
  await FirebaseAuth.instance.signOut();

  Get.offAndToNamed(Routes.WELCOME);
}
