import 'package:flutter/material.dart';
import 'package:untitled2/components/top_navbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Food extends StatelessWidget {
  const Food({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FoodAskingPage(),
    );
  }
}

class FoodAskingPage extends StatefulWidget {
  const FoodAskingPage({super.key});

  @override
  State<FoodAskingPage> createState() => _FoodAskingPageState();
}

class _FoodAskingPageState extends State<FoodAskingPage> {
  User? user;
  String? userId;

  var _name;
  var _area;
  var _phonenumber;
  var _prioritylevel;
  var _foodItems;
  var _quantity;
  var _specialInstructions;
  var _item = 'food';
  var _role = 'victim';

  final _namecontroller = TextEditingController();
  final _areacontroller = TextEditingController();
  final _phonenumbercontroller = TextEditingController();
  final _prioritycontroller = TextEditingController();
  final _foodItemsController = TextEditingController();
  final _quantityController = TextEditingController();
  final _specialInstructionsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeUser();
    _namecontroller.addListener(_updateText);
    _areacontroller.addListener(_updateText);
    _phonenumbercontroller.addListener(_updateText);
    _prioritycontroller.addListener(_updateText);
    _foodItemsController.addListener(_updateText);
    _quantityController.addListener(_updateText);
    _specialInstructionsController.addListener(_updateText);
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
      _foodItems = _foodItemsController.text;
      _quantity = _quantityController.text;
      _specialInstructions = _specialInstructionsController.text;
    });
  }

  void _submitData() async {
    if (_name.isNotEmpty &&
        _area.isNotEmpty &&
        _phonenumber.isNotEmpty &&
        _prioritylevel.isNotEmpty &&
        _foodItems.isNotEmpty &&
        _quantity.isNotEmpty &&
        _specialInstructions.isNotEmpty &&
        _item.isNotEmpty &&
        _role.isNotEmpty) {
      Map<String, dynamic> newPost = {
        'uid': userId,
        'name': _name,
        'area': _area,
        'phonenumber': _phonenumber,
        'prioritylevel': _prioritylevel,
        'foodItems': _foodItems,
        'quantity': _quantity,
        'specialInstructions': _specialInstructions,
        'item': _item,
        'role': _role,
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
      _foodItemsController.clear();
      _quantityController.clear();
      _specialInstructionsController.clear();
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
                  'Request Food & Groceries',
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
                  'Food Items Needed',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 10),
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 450),
                  child: TextFormField(
                    controller: _foodItemsController,
                    decoration: InputDecoration(
                      labelText: 'List of food items',
                      prefixIcon: Icon(Icons.shopping_cart),
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
                    controller: _quantityController,
                    decoration: InputDecoration(
                      labelText: 'Quantity needed',
                      prefixIcon: Icon(Icons.format_list_numbered),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Special Instructions',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 10),
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 450),
                  child: TextFormField(
                    controller: _specialInstructionsController,
                    decoration: InputDecoration(
                      labelText: 'Any special instructions',
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
                SizedBox(
                  height: 25,
                ),
                Center(
                  child: Container(
                    width: 350,
                    child: Text(
                      'A volunteer will contact you as soon as they’re available for your area',
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}