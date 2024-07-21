import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crisis App',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: CrisisPage(),
    );
  }
}

class CrisisPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crisis.',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25.0)),centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            // Handle menu button press
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.error_outline),
            onPressed: () {
              // Handle alert button press
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10.0,),
            Text(
              'Requests',
              style: TextStyle(fontSize: 15),
            ),
            SizedBox(height: 10),

            Row(
              children: [
                RequestButton(label: 'Boats', icon: Icons.directions_boat),
                SizedBox(width: 20),
                RequestButton(label: 'Water Cans', icon: Icons.local_drink),
              ],
            ),
            SizedBox(height:10.0),
            Row(
              children: [
                RequestButton(label: 'Medical Assistance', icon: Icons.medical_services),
                SizedBox(width: 20.0),
                RequestButton(label: 'Food & Groceries', icon: Icons.local_grocery_store),
              ],
            ),
            SizedBox(height: 10.0),

            RequestButton(label: 'Charging Stations', icon: Icons.battery_charging_full),
            SizedBox(height: 20),
            Text(
              'Announcements',
              style: TextStyle(fontSize: 15),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                RequestButton(label: 'Weather', icon: Icons.wb_cloudy),
                SizedBox(width: 20.0),
                RequestButton(label: 'Notices', icon: Icons.announcement),
              ],
            ),

            SizedBox(height: 20),
            Text(
              'Fundraisers',
              style: TextStyle(fontSize: 15),
            ),
            SizedBox(height: 10),
            RequestButton(label: 'Donate', icon: Icons.attach_money),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Requests',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Alerts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}

class RequestButton extends StatelessWidget {
  final String label;
  final IconData icon;

  const RequestButton({
    Key? key,
    required this.label,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: SizedBox(
        width: 175,
        height: 70, // Fixed height for the buttons
        child: ElevatedButton.icon(
          onPressed: () {
            // Handle button press
          },
          icon: Icon(icon, size: 28),
          label: Flexible(
            child: Text(
              label,
              textAlign: TextAlign.center,
            ),
          ),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            backgroundColor: Colors.white, // Background color
            foregroundColor: Colors.black, // Text color
            side: const BorderSide(color: Colors.black,width: 3),
          ),
        ),
      ),
    );
  }
}
