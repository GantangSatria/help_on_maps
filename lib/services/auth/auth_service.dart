import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  
  Future<User?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      var auth = FirebaseAuth.instance;
      final credential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (credential.user != null) {
        return credential.user;
      }
      throw Exception();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        debugPrint('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        debugPrint('Wrong password provided for that user.');
      }
      // rethrow;
    }
    return null;
  }

Future<User?> registerWithEmailAndPassword({
  required String email,
  required String password,
  required String name,
  required List<String> roles,
}) async {
  try {
    var auth = FirebaseAuth.instance;
    final credential = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (credential.user != null) {
      final user = credential.user!;
      final firestore = FirebaseFirestore.instance;

      await firestore.collection('users').doc(user.uid).set({
        'name': name,
        'email': email,
        'roles': roles,
        'createdAt': FieldValue.serverTimestamp(),
        'location': {
          'latitude': 0.0,
          'longitude': 0.0,
        },
      });

      return user;
    }

    throw Exception("User registration failed.");
  } on FirebaseAuthException catch (e) {
    if (e.code == 'email-already-in-use') {
      debugPrint('The account already exists for that email.');
    } else if (e.code == 'weak-password') {
      debugPrint('The password provided is too weak.');
    }
    throw Exception(e.message);
  }
}
}
