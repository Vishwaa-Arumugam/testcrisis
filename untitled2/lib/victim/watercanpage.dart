import 'package:flutter/material.dart';
import 'package:untitled2/components/top_navbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// void main() {
//   runApp(Watercan());
// }

class Watercan extends StatelessWidget {
  const Watercan({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WatercanAskingPage(),
    );
  }
}

class WatercanAskingPage extends StatefulWidget {
  const WatercanAskingPage({super.key});

  @override
  State<WatercanAskingPage> createState() => _WatercanAskingPageState();
}

class _WatercanAskingPageState extends State<WatercanAskingPage> {
  User? user;
  String? userId;

  var _name;
  var _area;
  var _phonenumber;
  var _prioritylevel;
  var _canquantity;
  var _deliverytime;

  final _namecontroller = TextEditingController();
  final _areacontroller = TextEditingController();
  final _phonenumbercontroller = TextEditingController();
  final _prioritycontroller = TextEditingController();
  final _canquantitycontroller = TextEditingController();
  final _deliverytimecontroller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _namecontroller.addListener(_updateText);
    _areacontroller.addListener(_updateText);
    _phonenumbercontroller.addListener(_updateText);
    _prioritycontroller.addListener(_updateText);
    _canquantitycontroller.addListener(_updateText);
    _deliverytimecontroller.addListener(_updateText);
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
      _area = _areacontroller.text;
      _phonenumber = _phonenumbercontroller.text;
      _prioritylevel = _prioritycontroller.text;
      _canquantity = _canquantitycontroller.text;
      _deliverytime = _deliverytimecontroller.text;
    });
  }

  void _submitData() async {
    if (_name.isNotEmpty &&
        _area.isNotEmpty &&
        _phonenumber.isNotEmpty &&
        _prioritylevel.isNotEmpty &&
        _canquantity.isNotEmpty &&
        _deliverytime.isNotEmpty) {
      Map<String, dynamic> newPost = {
        'uid': userId,
        'name': _name,
        'area': _area,
        'phonenumber': _phonenumber,
        'prioritylevel': _prioritylevel,
        'canquantity': _canquantity,
        'deliverytime': _deliverytime,
        'item': 'watercan',
        'role': 'victim',
      };
      await FirebaseFirestore.instance.collection('posts').doc(userId).set({
        'posts': FieldValue.arrayUnion([newPost]),
      }, SetOptions(merge: true));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Request submitted successfully')),
      );

      _namecontroller.clear();
      _areacontroller.clear();
      _phonenumbercontroller.clear();
      _prioritycontroller.clear();
      _canquantitycontroller.clear();
      _deliverytimecontroller.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all required fields')),
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
                  'Request Water Cans',
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
                    controller: _areacontroller,
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
                  'Priority Level',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 5),
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 450),
                  child: TextFormField(
                    controller: _prioritycontroller,
                    decoration: InputDecoration(
                      labelText: 'Priority level',
                      prefixIcon: Icon(Icons.priority_high),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40)),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Quantity of Water Cans',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 5),
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 450),
                  child: TextFormField(
                    controller: _canquantitycontroller,
                    decoration: InputDecoration(
                      labelText: 'Number of water cans',
                      prefixIcon: Icon(Icons.water),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40)),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Preferred Delivery Time',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 5),
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 450),
                  child: TextFormField(
                    controller: _deliverytimecontroller,
                    decoration: InputDecoration(
                      labelText: 'Preferred delivery time',
                      prefixIcon: Icon(Icons.access_time),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40)),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 0, 0, 0),
                      foregroundColor: Colors.white,
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
                    child: Container(
                      width: 350,
                      child: Text(
                        'A volunteer will contact you as soon as they’re available for your area',
                        style: TextStyle(fontSize: 14),
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