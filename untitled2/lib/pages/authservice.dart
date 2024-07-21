import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> createUserWithEmailandPassword(String email, String password, String username, String mobileNumber) async {
    try {
      // Create user with email and password
      final cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);

      // Check if user is created successfully
      if (cred.user != null) {
        // Save additional user info to Firestore
        await _firestore.collection('users').doc(cred.user!.uid).set({
          'username': username,
          'mobileNumber': mobileNumber,
          'email': email,
        });

        return cred.user;
      }
    } catch (e) {
      log("Something went wrong: $e");
    }
    return null;
  }
}
