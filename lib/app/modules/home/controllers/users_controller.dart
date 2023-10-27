import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';

class UsersController extends GetxController {
  //TODO: Implement UsersController

  final contacts = [].obs;
  var isLoading = false.obs;
  var phoneNumbers = [].obs;
  var firebaseContacts = [].obs;
  @override
  void onInit() {
    getContacts();
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

  getFirebaseContacts() async {
    await FirebaseFirestore.instance
        .collection('users')
        .where(
          'uid',
          isNotEqualTo: FirebaseAuth.instance.currentUser!.uid,
        )
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        querySnapshot.docs.forEach((doc) {
          if (phoneNumbers.contains(doc['phoneNumber'])) {
            firebaseContacts.add(doc.data());
          }
        });
      }
    });
    print(firebaseContacts);
    isLoading.value = false;
  }

  Future getContacts() async {
    contacts.clear();
    phoneNumbers.clear();
    firebaseContacts.clear();
    isLoading.value = true;
    if (await FlutterContacts.requestPermission()) {
      final contacts = await FlutterContacts.getContacts(
          withProperties: true, withThumbnail: true);
      print(contacts);
      //add phone numbers to list
      for (var i = 0; i < contacts.length; i++) {
        if (contacts[i].phones.length > 0) {
          phoneNumbers.add(contacts[i].phones[0].normalizedNumber);
        }
      }
      print(phoneNumbers);
      this.contacts.value = contacts;
    }
    await getFirebaseContacts();
  }
}
