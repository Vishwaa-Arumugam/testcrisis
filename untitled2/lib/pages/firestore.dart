import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:untitled2/pages/posts.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> create(String uid, String username, String mobileNumber, String email, BuildContext context) async {
    try {
      await _firestore.collection("users").doc(uid).set({
        "name": username,
        "mobile_number": mobileNumber,
        "email": email,
      });
      log("User added successfully");

      // Navigate to the Posts screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => VolunteerPosts()), // Replace Posts() with the actual constructor for your Posts screen
      );
      
    } catch (e) {
      log("Failed to add user: $e");
    }
  }
}
