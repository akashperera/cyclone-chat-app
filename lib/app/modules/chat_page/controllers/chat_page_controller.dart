import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_ml_vision/google_ml_vision.dart';
import 'package:image_picker/image_picker.dart' as picker;
import 'package:url_launcher/url_launcher.dart';

import '../views/image_view.dart';

class ChatPageController extends GetxController {
  @override
  void onInit() {
    print('onInit');
    userData = Get.arguments;
    getSecondUserOnlineStatus();
    super.onInit();
  }

  var userData;
  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  var txtController = TextEditingController().obs;
  validate() {
    if (txtController.value.text.isEmpty) {
      Get.snackbar('Error', 'Please enter some text',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          margin: const EdgeInsets.all(10));
    } else {
      sendToFirebase();
    }
  }

  sendToFirebase({String imgUrl = ''}) async {
    log('Get arguments: ${userData}');
    var timestamp = DateTime.now().toString();
    var msg = txtController.value.text;
    txtController.value.text = '';
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('chats')
        .doc(userData['uid'])
        .collection('messages')
        .doc(timestamp)
        .set({
      'message': imgUrl == '' ? msg : '',
      'uid': FirebaseAuth.instance.currentUser!.uid,
      'name': FirebaseAuth.instance.currentUser!.displayName,
      'propic': FirebaseAuth.instance.currentUser!.photoURL,
      'timestamp': timestamp,
      'links': [],
      'isScanning': false,
      'imgUrl': imgUrl,
      'vText': vText.value,
      'status': ''
    });
    if (imgUrl != '') {
      Get.back();
    }
    var receiverData = await FirebaseFirestore.instance
        .collection('users')
        .doc(userData['uid'])
        .get();
    print(receiverData.data());
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('chats')
        .doc(userData['uid'])
        .set({
      'message': imgUrl == '' ? msg : 'Image',
      'timestamp': timestamp,
      'receiverUid': userData['uid'],
      'receiverName': receiverData['name'],
      'receiverPropic': receiverData['propic'],
    });

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userData['uid'])
        .collection('chats')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({
      'message': imgUrl == '' ? msg : 'Image',
      'timestamp': timestamp,
      'receiverUid': FirebaseAuth.instance.currentUser!.uid,
      'receiverName': FirebaseAuth.instance.currentUser!.displayName,
      'receiverPropic': FirebaseAuth.instance.currentUser!.photoURL,
    });

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userData['uid'])
        .collection('chats')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('messages')
        .doc(timestamp)
        .set({
      'message': imgUrl == '' ? msg : '',
      'uid': FirebaseAuth.instance.currentUser!.uid,
      'name': FirebaseAuth.instance.currentUser!.displayName,
      'propic': FirebaseAuth.instance.currentUser!.photoURL,
      'timestamp': timestamp,
      'links': [],
      'isScanning': false,
      'status': '',
      'imgUrl': imgUrl,
      'vText': vText.value,
    });
  }

  var lastSeen = ''.obs;
  var isOnline = false.obs;

  getSecondUserOnlineStatus() async {
    FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: userData['uid'])
        .snapshots()
        .listen((event) {
      print(event.docs[0]['isOnline']);
      isOnline.value = event.docs[0]['isOnline'];
      lastSeen.value = event.docs[0]['lastSeen'];
    });
  }

  var vText = ''.obs;
  pickImage() async {
    final pickedFile = await picker.ImagePicker()
        .pickImage(source: picker.ImageSource.gallery);
    if (pickedFile != null) {
      final file = File(pickedFile.path);
      Get.to(() => ImageView(
            imageFile: file,
          ));
      final GoogleVisionImage visionImage = GoogleVisionImage.fromFile(file);
      final TextRecognizer textRecognizer =
          GoogleVision.instance.textRecognizer();
      final VisionText visionText =
          await textRecognizer.processImage(visionImage);
      print(visionText.text!.trim());
      vText.value = visionText.text!.trim();
    }
  }

  var isUploading = false.obs;

  uploadToFirebaseStorage({File? file}) async {
    try {
      isUploading.value = true;

      //Upload to Firebase
      var snapshot = await FirebaseStorage.instance
          .ref()
          .child('images/imageName')
          .putFile(file!)
          .whenComplete(() => null);
      var downloadUrl = await snapshot.ref.getDownloadURL();

      print(downloadUrl);
      isUploading.value = false;
      await sendToFirebase(imgUrl: downloadUrl);
    } on Exception catch (e) {
      isUploading.value = false;
      print(e);
    }
  }

  // phishing detected popup
  showPhishingPopup(status, url) {
    print(status);
    var list = status.toString().split(' ');
    Get.defaultDialog(
      title: '',
      content: Column(
        children: [
          Text(
              list[4].trim() == 'unsafe'
                  ? 'Phishing Link Detected'
                  : 'Safe Link Detected',
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Icon(list[4].trim() == 'unsafe' ? Icons.warning : Icons.check_circle,
              color: list[4].trim() == 'unsafe' ? Colors.red : Colors.green,
              size: 50),
          const SizedBox(height: 20),
          Text(
            list[4].trim() == 'unsafe'
                ? 'This message contains a link to a website that may try to steal your personal information or harm your computer.'
                : 'This message contains a link to a website that is safe to visit.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
                color: list[4].trim() == 'unsafe' ? Colors.red : Colors.green,
                borderRadius: BorderRadius.circular(5)),
            child: Text(
              '${double.parse(list[2].trim().toString()).toStringAsFixed(2)}% ${list[4].trim().capitalizeFirst}',
              style: const TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(height: 20),
          const Text('Powered by AI Phishing Detector',
              style: TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 20),
          if (list[4].trim() == 'unsafe')
            const Text(
              'Do you still want to open this link?',
            ),
        ],
      ),
      actions: [
        MaterialButton(
            color: list[4].trim() == 'unsafe' ? Colors.red : Colors.green,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            onPressed: () {
              Get.back();
              launchUrl(Uri.parse(url.trim()));
            },
            child: Text(
                (list[4].trim() == 'unsafe') ? 'Yes, Open' : 'Open Link',
                style: const TextStyle(color: Colors.white))),
        MaterialButton(
            color: Colors.grey,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            onPressed: () {
              Get.back();
            },
            child: Text((list[4].trim() == 'unsafe') ? 'No' : 'Cancel',
                style: const TextStyle(color: Colors.white))),
      ],
    );
  }
}
