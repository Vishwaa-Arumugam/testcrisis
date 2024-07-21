import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:untitled2/components/top_navbar.dart';

class Charging extends StatelessWidget {
  const Charging({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ChargingPoint(),
    );
  }
}

class ChargingPoint extends StatefulWidget {
  const ChargingPoint({super.key});

  @override
  State<ChargingPoint> createState() => _ChargingPointState();
}

class _ChargingPointState extends State<ChargingPoint> {
  User? user;
  String? userId;

  var _name;
  var _address;
  var _landmark;
  var _phonenumber;
  var _postcontent;
  var _item = "charge";

  final _namecontroller = TextEditingController();
  final _addresscontroller = TextEditingController();
  final _landmarkcontroller = TextEditingController();
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
    _landmarkcontroller.addListener(_updateText);
    _phonenumbercontroller.addListener(_updateText);
    _postcontentcontroller.addListener(_updateText);
    _fetchUserData();
  }

  void _updateText() {
    setState(() {
      _name = _namecontroller.text;
      _address = _addresscontroller.text;
      _landmark = _landmarkcontroller.text;
      _phonenumber = _phonenumbercontroller.text;
      _postcontent = _postcontentcontroller.text;
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
        _landmark.isNotEmpty &&
        _phonenumber.isNotEmpty &&
        _postcontent.isNotEmpty &&
        _item.isNotEmpty) {
      Map<String, dynamic> newPost = {
        'name': _name,
        'area': _address,
        'landmark': _landmark,
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
      // _countcontroller.clear();
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
                  'Posting for Charging-Station availability',
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
                      labelText: 'Name of the volunteer',
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
                      labelText: 'Area of the charging place',
                      prefixIcon: Icon(Icons.place),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40)),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Landmark',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 5),
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 450),
                  child: TextFormField(
                    controller: _landmarkcontroller,
                    decoration: InputDecoration(
                      labelText: 'Landmark of the charging place',
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
                      labelText: 'Mobile number of the Boat owner',
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
                        labelText: 'A brief content of this request....',
                        prefixIcon: Icon(Icons.priority_high),
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
                    child: Text('Provide Assistance'),
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
