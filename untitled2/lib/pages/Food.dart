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
      home: FoodProvider(),
    );
  }
}

class FoodProvider extends StatefulWidget {
  const FoodProvider({super.key});

  @override
  State<FoodProvider> createState() => _FoodProviderState();
}

class _FoodProviderState extends State<FoodProvider> {
  User? user;
  String? userId;

  var _name;
  var _address;
  var _count;
  var _phonenumber;
  var _postcontent;
  var _item = "food";

  final _namecontroller = TextEditingController();
  final _addresscontroller = TextEditingController();
  final _countcontroller = TextEditingController();
  final _phonenumbercontroller = TextEditingController();
  final _postcontentcontroller = TextEditingController();

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      userId = user!.uid;
    } else {
      print('user is not logged in');
    }
    _namecontroller.addListener(_updateText);
    _addresscontroller.addListener(_updateText);
    _countcontroller.addListener(_updateText);
    _phonenumbercontroller.addListener(_updateText);
    _postcontentcontroller.addListener(_updateText);
    _fetchUserData();
  }

  void _updateText() {
    setState(() {
      _name = _namecontroller.text;
      _address = _addresscontroller.text;
      _count = _countcontroller.text;
      _phonenumber = _phonenumbercontroller.text;
      _postcontent = _postcontentcontroller.text;
    });
  }

  void _fetchUserData() async {
    try {
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
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  void _submitData() async {
    if (_name.isNotEmpty &&
        _address.isNotEmpty &&
        _count.isNotEmpty &&
        _phonenumber.isNotEmpty &&
        _postcontent.isNotEmpty &&
        _item.isNotEmpty) {
      Map<String, dynamic> newPost = {
        'name': _name,
        'area': _address,
        'headcount': _count,
        'phonenumber': _phonenumber,
        'postcontent': _postcontent,
        'item': _item,
        'uid': userId,
        'role' : 'volunteer',
      };
      await FirebaseFirestore.instance
          .collection('posts-volunteer')
          .doc(userId)
          .set({
        'posts': FieldValue.arrayUnion([newPost])
      }, SetOptions(merge: true));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Request submitted successfully')),
      );
      _namecontroller.clear();
      _addresscontroller.clear();
      _countcontroller.clear();
      _phonenumbercontroller.clear();
      _postcontentcontroller.clear();
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
        padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Request Food Packets',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  'Name',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 5),
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
                  'Headcount',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 5),
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 450),
                  child: TextFormField(
                    controller: _countcontroller,
                    decoration: InputDecoration(
                      labelText: 'Number of Parcels Needed',
                      prefixIcon: Icon(Icons.groups_2),
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
                  'Food Preference',
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
                        labelText:
                            '(Veg/Non-Veg) + Extra Instructions (if any)',
                        prefixIcon: Icon(Icons.fastfood_outlined),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40)),
                      ),
                      maxLines:
                          null, // Allows the text field to grow with input
                    ),
                  ),
                ),
                SizedBox(height: 10),
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
