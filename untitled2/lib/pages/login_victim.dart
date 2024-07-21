import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:untitled2/components/my_textfield.dart';
import 'package:untitled2/components/square_tile.dart';
import 'package:untitled2/pages/dataservice.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled2/victim/victim_bottom_navbar.dart';

class LoginPageVictim extends StatefulWidget {
  const LoginPageVictim({super.key});

  @override
  _LoginPageVictimState createState() => _LoginPageVictimState();
}

class _LoginPageVictimState extends State<LoginPageVictim> {

  DataService db = DataService();



  // text editing controllers
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController mobilenumberController = TextEditingController(); // Corrected variable name
  final TextEditingController emailidController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    mobilenumberController.dispose();
    emailidController.dispose();
    super.dispose();
  }

  // Sign user in method
  void signUserIn(BuildContext context)async{
    await db.createVictim(usernameController.text.trim(), emailidController.text.trim(), mobilenumberController.text.trim(), passwordController.text.trim());
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', 'victim');
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => VictimBottomNavBar()),(Route<dynamic> route) => false);


  }
  _signInWithGoogle(BuildContext context) async{
    final GoogleSignIn _googleSignIn = GoogleSignIn();

    try{
      final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();

      if (googleSignInAccount!=null){
        final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(idToken: googleSignInAuthentication.idToken,accessToken: googleSignInAuthentication.accessToken);

        await FirebaseAuth.instance.signInWithCredential(credential);
        // await storeUserType('victim');
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => VictimBottomNavBar()),
                (Route<dynamic> route) => false
        );
      }
    }catch(e){
      print('some error occured');
    }


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0, right: 50),
            child: Text(
              "Crisis.",
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w900,
                color: Colors.black,
              ),
            ),
          ),
        ),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              // logo
              const Icon(
                Icons.lock,
                size: 100,
              ),

              const SizedBox(height: 20),

              // welcome back, you've been missed!
              Text(
                'Welcome back you\'ve been missed!',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 15),

              // username textfield
              MyTextField(
                controller: usernameController,
                hintText: 'Username',
                obscureText: false,
              ),

              const SizedBox(height: 10),

              MyTextField(
                controller: emailidController,
                hintText: 'Email ID',
                obscureText: false,
              ),

              const SizedBox(height: 10),

              MyTextField(
                controller: mobilenumberController,
                hintText: 'Mobile Number',
                obscureText: false,
              ),

              const SizedBox(height: 10),

              // password textfield
              MyTextField(
                controller: passwordController,
                hintText: 'Password',
                obscureText: true,
              ),

              const SizedBox(height: 10),

              // forgot password?
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                ),
              ),

              const SizedBox(height: 15),

              // sign in button
              ElevatedButton(
                onPressed: () => signUserIn(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  textStyle: TextStyle(
                    fontSize: 15,
                  ),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                  padding: const EdgeInsets.all(20.0),
                ),
                child: Text('Sign In'),
              ),
              const SizedBox(height: 20),

              // or continue with
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        'Or continue with',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // google + apple sign in buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:  [
                  // google button
                  GestureDetector(
                    onTap: ()=>_signInWithGoogle(context),
                    child: SquareTile(imagePath: 'lib/images/google.png'),
                  ),
                ],
              ),


              // not a member? register now
            ],
          ),
        ),
      ),
    );
  }
}
