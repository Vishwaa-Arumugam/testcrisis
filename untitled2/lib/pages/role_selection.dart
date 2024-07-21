import 'package:flutter/material.dart';
import 'login_page.dart';
import 'login_victim.dart';

class RoleSelection extends StatelessWidget {
  const RoleSelection({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start, // Align children to the start vertically
            crossAxisAlignment: CrossAxisAlignment.center, // Center horizontally
            children: [
              Text(
                "Welcome To Crisis",
                style: TextStyle(
                  fontSize: 20.0,  // Larger font size
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 10), // Add some spacing between the texts
              Text(
                "Choose your role",
                style: TextStyle(
                  fontSize: 28.0,  // Larger font size
                  fontWeight: FontWeight.w900,  // Bold text
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 30), // Add some spacing between the texts and cards
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: RoleCard(
                        title: "Victim",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => LoginPageVictim()),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 20), // Add spacing between cards
                    Expanded(
                      child: RoleCard(
                        title: "Volunteer",
                        onTap: () {
                          // Navigate to VolunteerPage
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => LoginPage()),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 20), // Add spacing between cards
                    Expanded(
                      child: RoleCard(
                        title: "Admin",
                        onTap: () {
                          // Navigate to AdminPage
                          // Navigator.push(context, MaterialPageRoute(builder: (context) => AdminPage()));
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RoleCard extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;

  const RoleCard({required this.title, this.onTap, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: Colors.black,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class VolunteerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Volunteer Page"),
      ),
      body: Center(
        child: Text(
          "Welcome to Volunteer Page",
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
