import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class ProfileService {
 var user = Rxn<User>();
 var userData = Rxn<Map<String, dynamic>>();
 var isLoading = false.obs;

    Future<void> fetchUser() async {
    isLoading.value = true;
    user.value = FirebaseAuth.instance.currentUser;
    if (user.value != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.value!.uid)
          .get();
      userData.value = doc.data();
    }
    isLoading.value = false;
  }
}