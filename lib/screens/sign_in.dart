import 'package:attendanaceapp/screens/all_emp.dart';
import 'package:attendanaceapp/screens/admin_homepage.dart';
import 'package:attendanaceapp/components/snack_bar.dart';
import 'package:attendanaceapp/screens/google_sign_in_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class SignIn extends StatefulWidget {
  SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool isSignedIn = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
 
 void authenticateLogin() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
    showError(context,'Please Enter Both Email And Password.');
      return;
    }

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Authentication successful
     showSuccess(context,'User Signed in: ${userCredential.user!.uid}');
      // Navigate to the next screen (you can customize this based on your app flow)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AllEmployeesPhotosPage()),
      );
    } catch (e) {
      showError(context,'Authentication Failed: $e');
      String errorMessage =
          'Authentication Failed. Please Check Your Credentials.';
      showError(context,errorMessage);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
       Stack(
        children: <Widget>[
            Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 9.9,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 182, 215, 247),
                  Color.fromARGB(255, 39, 179, 235),
                ],
                begin: Alignment.topRight,
                end: Alignment.topLeft,
              ),
            ),
          ),         
          Positioned(
            top: MediaQuery.of(context).size.height * 0.3,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  width: MediaQuery.of(context).size.width * 1,
                  height: MediaQuery.of(context).size.height * 1,
                ),             
              ],
            ),
          ),
           Center(
            child:SingleChildScrollView(
       child: 
             Container(
              margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.100,
                left: MediaQuery.of(context).size.width * 0.09,
                 right: MediaQuery.of(context).size.width * 0.09,
              ),
              child:   Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    'Welcome To ClockIn',
                    style: TextStyle(
                      fontSize: 25,
                      fontFamily: 'Kanit-Bold',
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 59, 58, 58),
                    ),
                  ),
                   
                  SizedBox(height: 2),
                  Text(
                    'Welcome to our app!!!',
                    style: TextStyle(
                      fontFamily: 'Kanit-Bold',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 59, 58, 58).withOpacity(0.5),
                    ),
                  ),
              
                   SizedBox(height: 90),
                 TextField(
                    controller: emailController,
                    decoration: 
                    InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder( borderRadius: BorderRadius.circular(15.0)),
                    ),
                    ),
                    
                  SizedBox(height: 16),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
                    ),
                  ),
                 
                ],
              ),
              
              ),
            ),
            ),
          
          Positioned(
  top: MediaQuery.of(context).size.height * 0.75,
  left: MediaQuery.of(context).size.width * 0.1,
  child: Column(
    children: [
      SizedBox(height: 2),
      FilledButton.icon(
        onPressed: isSignedIn ? null : authenticateLogin,
        icon: const Icon(
          FontAwesomeIcons.lockOpen, // Replace with your desired icon
          color: Color.fromARGB(255, 216, 235, 241),
        ),
        label: const Text(
          'Login',
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 59, 58, 58),
          ),
        ),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          backgroundColor: Color.fromARGB(255, 39, 179, 235),
          minimumSize: Size(
            MediaQuery.of(context).size.width * 0.8,
            50,
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 7),
        child: Row(
          children: [
            Container(
              height: 1,
              width: MediaQuery.of(context).size.width * 0.3,
              color: Color.fromARGB(255, 59, 58, 58),
            ),
            Container(
              height: 20,
              width: MediaQuery.of(context).size.width * 0.1,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Color.fromARGB(255, 59, 58, 58)..withOpacity(0.5),
              ),
              child: const Center(
                child: Text(
                  'OR',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Container(
              height: 1,
              width: MediaQuery.of(context).size.width * 0.3,
              color: Color.fromARGB(255, 59, 58, 58),
            ),
          ],
        ),
      ),
      FilledButton.icon(
        onPressed: isSignedIn
            ? null
            : () {
                final provider = Provider.of<GoogleSignInProvider>(
                  context,
                  listen: false,
                );
                provider.googleLogin().then((_) {
                  setState(() {
                    isSignedIn = true;
                  });
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AdminHomePage(),
                    ),
                  );
                });
              },
        icon: const Icon(
          FontAwesomeIcons.google,
          color: Color.fromARGB(255, 216, 235, 241),
        ),
        label: const Text(
          'Sign In With Google',
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 59, 58, 58),
          ),
        ),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          backgroundColor: Color.fromARGB(255, 39, 179, 235),
          minimumSize: Size(
            MediaQuery.of(context).size.width * 0.8,
            50,
          ),
        ),
      ),
    ],
  ),
          ),
        ],
    ),
      
    );
  }
}