import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DataService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createUser(String name, String email, String pno, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        // Update the display name
        await user.updateDisplayName('volunteer');
        String userId = user.uid;
        await _firestore.collection("users").doc(userId).set({
          "name": name,
          "email": email,
          "pno": pno,
          // Remove password from the Firestore document
        });

        print('User created successfully with UID: $userId');
      } else {
        print('User creation failed');
      }
    } catch (e) {
      print('Error creating user: $e');
    }
  }

  Future<void> createVictim(String name, String email, String pno, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        // Update the display name
        await user.updateDisplayName('victim');
        String userId = user.uid;
        await _firestore.collection("users-victim").doc(userId).set({
          "name": name,
          "email": email,
          "pno": pno,
          // Remove password from the Firestore document
        });

        print('User created successfully with UID: $userId');
      } else {
        print('User creation failed');
      }
    } catch (e) {
      print('Error creating user: $e');
    }
  }
}
