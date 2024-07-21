import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
// import 'package:untitled2/components/post_component.dart';
import 'package:untitled2/components/top_navbar.dart';
import 'package:untitled2/pages/inbox_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:untitled2/pages/request_volunteer.dart';
import 'package:untitled2/pages/posts.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BottomNavBar(),
    );
  }
}

class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    PostsPage(),
    VolunteerPage(),
    InboxPage(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: 0.0), // Adjust top padding as needed
        child: _pages[_currentIndex],
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(top: 0.0), // Adjust top padding as needed
        child: CurvedNavigationBar(
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
          color: Colors.black,
          buttonBackgroundColor: Colors.black,
          height: 60,
          items: const <Widget>[
            Center(child: Icon(Icons.home, size: 22.5, color: Colors.white)),
            Center(
                child: Icon(
              Icons.home_repair_service_sharp,
              size: 22.5,
              color: Colors.white,
            )),
            Center(
                child:
                    Icon(Icons.notifications, size: 22.5, color: Colors.white)),
            Center(child: Icon(Icons.person, size: 22.5, color: Colors.white)),
          ],
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          animationDuration: Duration(
              milliseconds: 400), // Adjust animation duration if needed
          animationCurve: Curves.easeInOut,
        ),
      ),
    );
  }
}

class PostsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      backgroundColor: Colors.white,
      body: VolunteerPostsPage(),
    );
  }
}

class NotificationsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Notifications Screen"),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future<Map<String, dynamic>?> getUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return null;
    }

    String userId = user.uid;
    print(userId);

    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      if (userDoc.exists) {
        return userDoc.data() as Map<String, dynamic>;
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
    return null;
  }

  Future<void> _editDetails(Map<String, dynamic> userData) async {
    TextEditingController nameController =
        TextEditingController(text: userData['name']);
    TextEditingController emailController =
        TextEditingController(text: userData['email']);
    TextEditingController phoneController =
        TextEditingController(text: userData['pno']);

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Details'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                TextField(
                  controller: phoneController,
                  decoration: InputDecoration(labelText: 'Phone Number'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () async {
                // Update Firestore
                try {
                  User? user = FirebaseAuth.instance.currentUser;
                  if (user != null) {
                    String userId = user.uid;
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(userId)
                        .update({
                      'name': nameController.text,
                      'email': emailController.text,
                      'pno': phoneController.text,
                    });
                    // Refresh the state to show updated data
                    setState(() {});
                    Navigator.of(context).pop();
                  }
                } catch (e) {
                  print('Error updating user data: $e');
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      backgroundColor: Colors.white,
      body: FutureBuilder<Map<String, dynamic>?>(
        future: getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error fetching data'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('No user data found'));
          }

          var userData = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                  child: Center(
                    child: CircleAvatar(
                      backgroundImage: AssetImage('lib/images/profile.jpg'),
                      radius: 55.0,
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 0, 5),
                  child: Text(
                    'Name',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                      letterSpacing: 3.0,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 0, 15),
                  child: Text(
                    '${userData['name']}',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 4.0,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 0, 5),
                  child: Text(
                    'Email',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                      letterSpacing: 3.0,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 0, 15),
                  child: Text(
                    '${userData['email']}',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 4.0,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 0, 5),
                  child: Text(
                    'Mobile Number',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                      letterSpacing: 3.0,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 0, 15),
                  child: Text(
                    '${userData['pno']}',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(100, 40, 0, 0),
                  child: ElevatedButton(
                    onPressed: () {
                      _editDetails(userData);
                    },
                    child: Text(
                      'EDIT DETAILS',
                      style: TextStyle(fontSize: 18.0),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.black),
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                      minimumSize:
                          MaterialStateProperty.all<Size>(Size(40, 50)),
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

class VolunteerPage extends StatelessWidget {
  const VolunteerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: RequestsPage(),
    );
  }
}
