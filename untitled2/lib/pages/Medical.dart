import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:untitled2/components/top_navbar.dart';

class Boat extends StatelessWidget {
  const Boat({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MedicalAssistance(),
    );
  }
}

class MedicalAssistance extends StatefulWidget {
  const MedicalAssistance({super.key});

  @override
  State<MedicalAssistance> createState() => _MedicalAssistanceState();
}

class _MedicalAssistanceState extends State<MedicalAssistance> {
  User? user;
  String? userId;
  var _name;
  var _address;
  var _phonenumber;
  var _postcontent;
  var _medicalSupplies;
  var _item = "medical";

  final _namecontroller = TextEditingController();
  final _addresscontroller = TextEditingController();
  final _phonenumbercontroller = TextEditingController();
  final _postcontentcontroller = TextEditingController();
  final _medicalSuppliesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _namecontroller.addListener(_updateText);
    _addresscontroller.addListener(_updateText);
    _phonenumbercontroller.addListener(_updateText);
    _postcontentcontroller.addListener(_updateText);
    _medicalSuppliesController.addListener(_updateText);
    _initializeUser();
  }

  Future<void> _initializeUser() async {
    user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        userId = user!.uid;
      });
      print(userId);
    } else {
      print('User is not logged in');
    }
  }

  void _updateText() {
    setState(() {
      _name = _namecontroller.text;
      _address = _addresscontroller.text;
      _phonenumber = _phonenumbercontroller.text;
      _postcontent = _postcontentcontroller.text;
      _medicalSupplies = _medicalSuppliesController.text;
    });
  }

  void _fetchUserData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        var userId = user.uid;
        var userData = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .get();
        if (userData.exists) {
          setState(() {
            _namecontroller.text = userData.data()?['name'] ?? '';
            _phonenumbercontroller.text = userData.data()?['pno'] ?? '';
          });
        }
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  void _submitData() async {
    if (_name.isNotEmpty &&
        _address.isNotEmpty &&
        _phonenumber.isNotEmpty &&
        _postcontent.isNotEmpty &&
        _item.isNotEmpty &&
        _medicalSupplies.isNotEmpty) {
      Map<String, dynamic> newPost = {
        'name': _name,
        'area': _address,
        'phonenumber': _phonenumber,
        'postcontent': _postcontent,
        'medicalSupplies': _medicalSupplies,
        'role' : 'volunteer',
        'item': _item,
        'uid': userId,
      };
      await FirebaseFirestore.instance.collection('posts-volunteer').doc(userId).set({
        'posts': FieldValue.arrayUnion([newPost]),
      }, SetOptions(merge: true));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Request submitted successfully')),
      );
      _namecontroller.clear();
      _addresscontroller.clear();
      _phonenumbercontroller.clear();
      _postcontentcontroller.clear();
      _medicalSuppliesController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Posting For Medical Assistance',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                  'Name',
                  style: TextStyle(fontSize: 18),
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 450),
                  child: TextFormField(
                    controller: _namecontroller,
                    decoration: InputDecoration(
                      labelText: 'Enter Your Name',
                      prefixIcon: Icon(Icons.man),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40)),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Area',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 5),
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 450),
                  child: TextFormField(
                    controller: _addresscontroller,
                    decoration: InputDecoration(
                      labelText: 'Enter Your Area',
                      prefixIcon: Icon(Icons.place),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40)),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Phone Number',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 5),
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 450),
                  child: TextFormField(
                    controller: _phonenumbercontroller,
                    decoration: InputDecoration(
                      labelText: 'Enter Your Phone Number',
                      prefixIcon: Icon(Icons.phone),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40)),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Details',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 5),
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 450),
                  child: Container(
                    height: 70, // Specify the desired height here
                    child: TextFormField(
                      controller: _postcontentcontroller,
                      decoration: InputDecoration(
                        labelText: 'Details of what you can assist with',
                        prefixIcon: Icon(Icons.priority_high),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40)),
                      ),
                      maxLines: null, // Allows the text field to grow with input
                    ),
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Medical Supplies Needed',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 5),
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 450),
                  child: Container(
                    height: 70, // Specify the desired height here
                    child: TextFormField(
                      controller: _medicalSuppliesController,
                      decoration: InputDecoration(
                        labelText: 'Details of the medical supplies you have',
                        prefixIcon: Icon(Icons.local_hospital),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40)),
                      ),
                      maxLines: null,
                      // Allows the text field to grow with input
                    ),
                  ),
                ),
                SizedBox(height: 5),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 255, 208, 0),
                      foregroundColor: Colors.black,
                      textStyle: TextStyle(
                        fontSize: 15,
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                      padding: const EdgeInsets.only(
                          top: 15.0, bottom: 15.0, left: 20.0, right: 20.0),
                    ),
                    onPressed: _submitData,
                    child: Text('Place Request'),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Center(
                    child: Text(
                        "A volunteer will contact you as soon as possible",
                        style: TextStyle(fontSize: 12)))
              ],
            ),
          ),
        ),
      ),
    );
  }
}