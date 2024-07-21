import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:untitled2/components/top_navbar.dart';
import 'package:untitled2/victim/request.dart';
// import 'package:untitled2/victim/victim_notification.dart';
import 'package:untitled2/victim/victim_post_page.dart';
import 'package:untitled2/victim/inbox_page.dart';

void main(){
  runApp(Bottom());
}

class Bottom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: VictimBottomNavBar(),
    );
  }
}

class VictimBottomNavBar extends StatefulWidget {
  @override
  _VictimBottomNavBarState createState() => _VictimBottomNavBarState();
}

class _VictimBottomNavBarState extends State<VictimBottomNavBar> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    VictimPosts(),
    InboxPage(),
    Requestscreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: 0.0), // Adjust top padding as needed
        child: _pages[_currentIndex],
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(top: 20.0), // Adjust top padding as needed
        child: CurvedNavigationBar(
          backgroundColor: Colors.white,
          color: Colors.black,
          buttonBackgroundColor: Colors.black,
          height: 75,
          items: <Widget>[
            Center(child: Icon(Icons.home, size: 30, color: Colors.white)),
            Center(child: Icon(Icons.notifications, size: 30, color: Colors.white)),
            Center(child: Icon(Icons.person, size: 30, color: Colors.white)),
          ],
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          animationDuration: Duration(milliseconds: 400), // Adjust animation duration if needed
          animationCurve: Curves.easeInOut,
        ),
      ),
    );
  }
}

class VictimPosts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      backgroundColor: Colors.white,
      body: VictimPostsPage(),
    );
  }
}




class Requestscreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      backgroundColor: Colors.white,
      body: RequestsPage(), // Embed AccountsPage directly here
    );
  }
}