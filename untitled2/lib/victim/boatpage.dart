import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled2/components/top_navbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// void main() {
//   runApp(Boat());
// }

class Boat extends StatelessWidget {
  const Boat({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BoatAskingPage(),
    );
  }
}

class BoatAskingPage extends StatefulWidget {
  const BoatAskingPage({super.key});

  @override
  State<BoatAskingPage> createState() => _BoatAskingPageState();
}

class _BoatAskingPageState extends State<BoatAskingPage> {
  User? user;
  String? userId;

  var _name;
  var _area;
  var _headcount;
  var _phonenumber;
  var _prioritylevel;
  var _postcontent;
  var _item = "boat";
  var _role = 'victim';
  final _namecontroller = TextEditingController();
  final _areacontroller = TextEditingController();
  final _headcountcontroller = TextEditingController();
  final _phonenumbercontroller = TextEditingController();
  final _prioritycontroller = TextEditingController();
  final _postcontentcontroller = TextEditingController();

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
    _namecontroller.addListener(_updateText);
    _areacontroller.addListener(_updateText);
    _headcountcontroller.addListener(_updateText);
    _phonenumbercontroller.addListener(_updateText);
    _prioritycontroller.addListener(_updateText);
    _postcontentcontroller.addListener(_updateText);
  }

  void _updateText() {
    setState(() {
      _name = _namecontroller.text;
      _area = _areacontroller.text;
      _headcount = _headcountcontroller.text;
      _phonenumber = _phonenumbercontroller.text;
      _prioritylevel = _prioritycontroller.text;
      _postcontent = _postcontentcontroller.text;
    });
  }

  void _submitData() async {
    if (_name.isNotEmpty &&
        _area.isNotEmpty &&
        _headcount.isNotEmpty &&
        _phonenumber.isNotEmpty &&
        _prioritylevel.isNotEmpty &&
        _postcontent.isNotEmpty && 
        _item.isNotEmpty && 
        _role.isNotEmpty) {
      Map<String,dynamic> newPost = {
        'uid':userId,
        'name': _name,
        'area': _area,
        'headcount': _headcount,
        'phonenumber': _phonenumber,
        'prioritylevel': _prioritylevel,
        'postcontent': _postcontent,
        'item' : _item,
        'role' : _role,
      };
      await FirebaseFirestore.instance.collection('posts').doc(userId).set({
          'posts':FieldValue.arrayUnion([newPost]),
      },SetOptions(merge: true));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Request submitted successfully')),
      );
      // Clear the text fields
      _namecontroller.clear();
      _areacontroller.clear();
      _headcountcontroller.clear();
      _phonenumbercontroller.clear();
      _prioritycontroller.clear();
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
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Request Boats',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Text(
                  'Name',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 10),
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 450),
                  child: TextFormField(
                    controller: _namecontroller,
                    decoration: InputDecoration(
                      labelText: 'Name of the victim',
                      prefixIcon: Icon(Icons.man),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Area',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 10),
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 450),
                  child: TextFormField(
                    controller: _areacontroller,
                    decoration: InputDecoration(
                      labelText: 'Area of the victim',
                      prefixIcon: Icon(Icons.place),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Headcount',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 10),
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 450),
                  child: TextFormField(
                    controller: _headcountcontroller,
                    decoration: InputDecoration(
                      labelText: 'Number of people',
                      prefixIcon: Icon(Icons.groups_2),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Phone Number',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 10),
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 450),
                  child: TextFormField(
                    controller: _phonenumbercontroller,
                    decoration: InputDecoration(
                      labelText: 'Mobile number of the victim',
                      prefixIcon: Icon(Icons.phone),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Priority Level',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 10),
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 450),
                  child: TextFormField(
                    controller: _prioritycontroller,
                    decoration: InputDecoration(
                      labelText: 'within 2 hours....',
                      prefixIcon: Icon(Icons.priority_high),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Post-Content',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 10),
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 450),
                  child: Container(
                    height: 150, // Specify the desired height here
                    child: TextFormField(
                      controller: _postcontentcontroller,
                      decoration: InputDecoration(
                        labelText: 'A brief content of this post....',
                        prefixIcon: Icon(Icons.priority_high),
                        border: OutlineInputBorder(),
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
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      textStyle: TextStyle(
                        fontSize: 15,
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                      padding: const EdgeInsets.all(20.0),
                    ),
                    onPressed: _submitData,
                    child: Text('Place Request'),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Center(
                    child: Container(
                  width: 350,
                  child: Text(
                    'A volunteer will contact you as soon as they ‘re available for your area',
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
