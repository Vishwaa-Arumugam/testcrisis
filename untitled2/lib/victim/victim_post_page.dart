import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:untitled2/components/post_component.dart';
// import 'package:untitled2/components/post_component.dart';
import 'package:untitled2/victim/victimpostcomponent.dart'; // Make sure the import path is correct

class VictimPosts extends StatelessWidget {
  const VictimPosts({super.key});

  @override
  Widget build(BuildContext context) {
    return VictimPostsPage();
  }
}

class VictimPostsPage extends StatefulWidget {
  const VictimPostsPage({super.key});

  @override
  State<VictimPostsPage> createState() => _VictimPostsPageState();
}

class _VictimPostsPageState extends State<VictimPostsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: StreamBuilder<QuerySnapshot>(
          stream: _firestore.collection('posts-volunteer').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text('No posts available'),
              );
            }

            // Flatten the array of posts
            List<Map<String, dynamic>> posts = [];
            for (var doc in snapshot.data!.docs) {
              List<dynamic> docPosts = doc['posts'];
              for (var post in docPosts) {
                posts.add(post as Map<String, dynamic>);
              }
            }

            return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                if(post['item'] == 'boat'){
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Content(
                      name: post['name'],
                      location: post['area'],
                      content: post['postcontent'],
                      priorityLevel: post['prioritylevel'],
                      mobilenumber: post['phonenumber'],
                      headcount: post['headcount'],
                      item: post['item'],
                      role: post['role'],
                      id: post['uid'],
                      // imageUrl: ,
                    ),
                  );
                } else if (post['item'] == 'food') {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Content(
                      name: post['name'],
                      location: post['area'],
                      content: post['postcontent'],
                      priorityLevel: post['prioritylevel'],
                      mobilenumber: post['phonenumber'],
                      headcount: post['headcount'],
                      item: post['item'],
                      role: post['role'],
                      id: post['uid'],
                      // imageUrl: ,
                    ),
                  );
                }  else if (post['item'] == 'can') {
                  print(post);
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Content(
                      name: post['name'],
                      location: post['area'],
                      content: post['postcontent'],
                      mobilenumber: post['phonenumber'],
                      item: post['item'],
                      role: post['role'],
                      id: post['uid'],
                      // imageUrl: ,
                    ),
                  );
                } else if (post['item'] == 'charge') {
                  print(post);
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Content(
                      name: post['name'],
                      location: post['area'],
                      landmark: post['landmark'],
                      content: post['postcontent'],
                      mobilenumber: post['phonenumber'],
                      item: post['item'],
                      role: post['role'],
                      id: post['uid'],
                      // imageUrl: ,
                    ),
                  );
                } else if (post['item'] == 'medical'){
                  print(post);
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Content(
                      name: post['name'],
                      location: post['area'],
                      medicalsupplies : post['medicalSupplies'],
                      content: post['postcontent'],
                      mobilenumber: post['phonenumber'],
                      item: post['item'],
                      role: post['role'],
                      id: post['uid'],
                      // imageUrl: ,
                    ),
                  );
                } else if (post['item'] == 'awareness'){
                  print(post);
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Content(
                      name: post['name'],
                      location: post['area'],
                      content: post['postcontent'],
                      item: post['item'],
                      role: post['role'],
                      id: post['uid'],
                      imageUrl: post['mediaUrl'],
                    ),
                  );
                }
                // } else if (post['item'] == 'meds') {
                //   return Padding(
                //     padding: const EdgeInsets.all(8.0),
                //     child: VictimContent(
                //         name: post['name'],
                //         mobilenumber: post['phonenumber'],
                //         item: post['item'],
                //         location: post['area'],
                //         priorityLevel: post['prioritylevel'],
                //         content: post['additionalnotes'],
                //         quantity: post['quantity'],
                //         medicineName: post['medicinename'],
                //         role: post['role'],
                //         id: post['uid']),
                //   );
                // }
              },
            );
          },
        ),
      ),
    );
  }
}
