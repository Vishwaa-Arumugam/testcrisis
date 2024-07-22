import 'package:flutter/material.dart';
import 'package:untitled2/components/top_navbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Medicine extends StatelessWidget {
  const Medicine({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MedicineAskingPage(),
    );
  }
}

class MedicineAskingPage extends StatefulWidget {
  const MedicineAskingPage({super.key});

  @override
  State<MedicineAskingPage> createState() => _MedicineAskingPageState();
}

class _MedicineAskingPageState extends State<MedicineAskingPage> {
  User? user;
  String? userId;

  var _name;
  var _area;
  var _phonenumber;
  var _prioritylevel;
  var _medicinename;
  var _quantity;
  var _doctorNeed;
  var _additionalnotes;
  var meds = 'meds';
  var _role = 'victim';

  final _namecontroller = TextEditingController();
  final _areacontroller = TextEditingController();
  final _phonenumbercontroller = TextEditingController();
  final _prioritycontroller = TextEditingController();
  final _medicinenamecontroller = TextEditingController();
  final _quantitycontroller = TextEditingController();
  final _additionalnotescontroller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeUser();
    _namecontroller.addListener(_updateText);
    _areacontroller.addListener(_updateText);
    _phonenumbercontroller.addListener(_updateText);
    _prioritycontroller.addListener(_updateText);
    _medicinenamecontroller.addListener(_updateText);
    _quantitycontroller.addListener(_updateText);
    _additionalnotescontroller.addListener(_updateText);
  }

  Future<void> _initializeUser() async {
    user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        userId = user!.uid;
      });
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
      _medicinename = _medicinenamecontroller.text;
      _quantity = _quantitycontroller.text;
      _additionalnotes = _additionalnotescontroller.text;
    });
  }

  void _submitData() async {
    if (_name.isNotEmpty &&
        _area.isNotEmpty &&
        _phonenumber.isNotEmpty &&
        _prioritylevel.isNotEmpty &&
        _doctorNeed.isNotEmpty &&
        _medicinename.isNotEmpty &&
        _quantity.isNotEmpty &&
        _role.isNotEmpty) {
      Map<String, dynamic> newPost = {
        'uid': userId,
        'name': _name,
        'area': _area,
        'phonenumber': _phonenumber,
        'prioritylevel': _prioritylevel,
        'medicinename': _medicinename,
        'doctorNeed': _doctorNeed,
        'quantity': _quantity,
        'additionalnotes': _additionalnotes,
        'item': meds,
        'role': _role,
      };
      await FirebaseFirestore.instance.collection('posts').doc(userId).set(
        {
          'posts': FieldValue.arrayUnion([newPost]),
        },
        SetOptions(merge: true),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Request submitted successfully')),
      );

      _namecontroller.clear();
      _areacontroller.clear();
      _phonenumbercontroller.clear();
      _prioritycontroller.clear();
      _medicinenamecontroller.clear();
      _quantitycontroller.clear();
      _additionalnotescontroller.clear();
      setState(() {
        _doctorNeed = null;
      });
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
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Request Medicine',
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
                      labelText: 'Name of the recipient',
                      prefixIcon: Icon(Icons.person),
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
                      labelText: 'Delivery area',
                      prefixIcon: Icon(Icons.place),
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
                      labelText: 'Contact number',
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
                      labelText: 'Priority level',
                      prefixIcon: Icon(Icons.priority_high),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Medicine Name',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 10),
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 450),
                  child: TextFormField(
                    controller: _medicinenamecontroller,
                    decoration: InputDecoration(
                      labelText: 'Name of the medicine',
                      prefixIcon: Icon(Icons.medication),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Quantity',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 10),
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 450),
                  child: TextFormField(
                    controller: _quantitycontroller,
                    decoration: InputDecoration(
                      labelText: 'Quantity needed',
                      prefixIcon: Icon(Icons.confirmation_num),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Do You Need a Doctor',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 5),
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 450),
                  child: DropdownButtonFormField<String>(
                    value: _doctorNeed,
                    items: [
                      DropdownMenuItem(
                        value: 'Yes',
                        child: Text('Yes'),
                      ),
                      DropdownMenuItem(
                        value: 'No',
                        child: Text('No'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _doctorNeed = value!;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Yes/No',
                      prefixIcon: Icon(Icons.medical_information),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40)),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Additional Notes',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 10),
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 450),
                  child: TextFormField(
                    controller: _additionalnotescontroller,
                    decoration: InputDecoration(
                      labelText: 'Any additional instructions',
                      prefixIcon: Icon(Icons.notes),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(height: 25),
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
                SizedBox(height: 25,),
                Center(
                    child: Container(
                      width: 350,
                      child: Text('A volunteer will contact you as soon as they’re available for your area', style: TextStyle(fontSize: 18), textAlign: TextAlign.center,),
                    )
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}