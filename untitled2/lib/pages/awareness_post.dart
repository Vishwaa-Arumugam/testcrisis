import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class PostContentPage extends StatefulWidget {
  @override
  _PostContentPageState createState() => _PostContentPageState();
}

class _PostContentPageState extends State<PostContentPage> {
  final TextEditingController _contentController = TextEditingController();
  File? _mediaFile;
  bool isLoading = false;
  User? user;
  String? userId;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickMedia() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _mediaFile = File(pickedFile.path);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    if (user!=null){
      userId = user!.uid;
    }
    else{
      print('user is not logged in');
    }
  }

  Future<void> _postContent() async {
    if (_contentController.text.isEmpty && _mediaFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please add some content or select a media file.')));
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      String? mediaUrl;
      if (_mediaFile != null) {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('posts')
            .child('${DateTime.now().millisecondsSinceEpoch}');
        final uploadTask = storageRef.putFile(_mediaFile!);
        final snapshot = await uploadTask;
        mediaUrl = await snapshot.ref.getDownloadURL();
      }

      await FirebaseFirestore.instance.collection('posts-volunteer').doc(userId).set({
        'posts':FieldValue.arrayUnion([{
          'name':'🚨⚠️ALERT⚠️🚨',
          'area':'Chennai',
           'role':'volunteer',
          'postcontent': _contentController.text,
          'mediaUrl': mediaUrl,
          'item' : 'awareness',
          'uid': FirebaseAuth.instance.currentUser?.uid,
        }])
      }, SetOptions(merge: true));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Content Posted Successfully')),
      );
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error posting content: $e')));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.white,
        title: Text('New Post'),
        actions: [
          IconButton(
            icon: Icon(Icons.send),
            onPressed: _postContent,
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Image.asset(
                  'assets/images/caution.png',
                  width: 50, // Adjust image size as needed
                  height: 40,
                  fit: BoxFit.contain, // Adjust image fit
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _contentController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: 'Here you can write an awareness post...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            if (_mediaFile != null)
              Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: Image.file(
                      _mediaFile!,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: Icon(Icons.photo_library),
                onPressed: _pickMedia,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
