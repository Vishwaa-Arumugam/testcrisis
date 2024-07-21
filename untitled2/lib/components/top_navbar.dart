import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled2/pages/role_selection.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(60.0);

  Future<void> signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => RoleSelection()));
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(
          Icons.menu,
          color: const Color.fromARGB(255, 0, 0, 0),
          size: 30,
        ),
        onPressed: () {
          // Handle menu button press
        },
      ),
      title: Text(
        'Crisis.',
        style: TextStyle(
          fontFamily: 'Inter',
          color: const Color.fromARGB(255, 0, 0, 0),
          fontWeight: FontWeight.bold,
          fontSize: 25,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(
            Icons.warning_rounded,
            color: const Color.fromARGB(255, 0, 0, 0),
            size: 30,
          ),
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString('user', 'illai');
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => RoleSelection()));
          },
        ),
      ],
      backgroundColor: Colors.white,
      elevation: 0, // Remove shadow/elevation
    );
  }
}
