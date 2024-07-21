import 'package:flutter/material.dart';
import 'package:untitled2/components/top_navbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// void main() {
//   runApp(Chargingstation());
// }

class Chargingstation extends StatelessWidget {
  const Chargingstation({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ChargingstationPage(),
    );
  }
}

class ChargingstationPage extends StatefulWidget {
  const ChargingstationPage({super.key});

  @override
  State<ChargingstationPage> createState() => _ChargingstationPageState();
}

class _ChargingstationPageState extends State<ChargingstationPage> {
  var _name;
  var _area;
  var _phonenumber;
  var _prioritylevel;
  var _deviceType;
  var _numberOfDevices;
  var _chargingDuration;
  // var _item = 'chargingstation';
  // var _role = 'victim';

  final _namecontroller = TextEditingController();
  final _areacontroller = TextEditingController();
  final _phonenumbercontroller = TextEditingController();
  final _prioritycontroller = TextEditingController();
  final _deviceTypeController = TextEditingController();
  final _numberOfDevicesController = TextEditingController();
  final _chargingDurationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _namecontroller.addListener(_updateText);
    _areacontroller.addListener(_updateText);
    _phonenumbercontroller.addListener(_updateText);
    _prioritycontroller.addListener(_updateText);
    _deviceTypeController.addListener(_updateText);
    _numberOfDevicesController.addListener(_updateText);
    _chargingDurationController.addListener(_updateText);
  }

  void _updateText() {
    setState(() {
      _name = _namecontroller.text;
      _area = _areacontroller.text;
      _phonenumber = _phonenumbercontroller.text;
      _prioritylevel = _prioritycontroller.text;
      _deviceType = _deviceTypeController.text;
      _numberOfDevices = _numberOfDevicesController.text;
      _chargingDuration = _chargingDurationController.text;
    });
  }

  void _submitData() async {
    if (_name.isNotEmpty &&
        _area.isNotEmpty &&
        _phonenumber.isNotEmpty &&
        _prioritylevel.isNotEmpty &&
        _deviceType.isNotEmpty &&
        _numberOfDevices.isNotEmpty &&
        _chargingDuration.isNotEmpty
        // _item.isNotEmpty &&
        // _role.isNotEmpty
        ) {
      await FirebaseFirestore.instance.collection('posts').add({
        'name': _name,
        'area': _area,
        'phonenumber': _phonenumber,
        'prioritylevel': _prioritylevel,
        'deviceType': _deviceType,
        'numberOfDevices': _numberOfDevices,
        'chargingDuration': _chargingDuration,
        'item' : 'chargingstation',
        'role' : 'victim',
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Request submitted successfully')),
      );
      
      _namecontroller.clear();
      _areacontroller.clear();
      _phonenumbercontroller.clear();
      _prioritycontroller.clear();
      _deviceTypeController.clear();
      _numberOfDevicesController.clear();
      _chargingDurationController.clear();
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
                  'Request Charging Station',
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
                  'Device Type',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 10),
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 450),
                  child: TextFormField(
                    controller: _deviceTypeController,
                    decoration: InputDecoration(
                      labelText: 'Type of device to charge',
                      prefixIcon: Icon(Icons.devices),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Number of Devices',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 10),
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 450),
                  child: TextFormField(
                    controller: _numberOfDevicesController,
                    decoration: InputDecoration(
                      labelText: 'Number of devices',
                      prefixIcon: Icon(Icons.devices_other),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Charging Duration',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 10),
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 450),
                  child: TextFormField(
                    controller: _chargingDurationController,
                    decoration: InputDecoration(
                      labelText: 'Estimated charging duration',
                      prefixIcon: Icon(Icons.timer),
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
