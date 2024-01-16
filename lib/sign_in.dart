import 'package:attendanaceapp/AllEmployeesPhotosPage.dart';
import 'package:attendanaceapp/add_employee.dart';
import 'package:attendanaceapp/admin_home_page.dart';
import 'package:attendanaceapp/google_sign_in_provider.dart';
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
    showSnackbarError('Please enter both email and password.');
      return;
    }

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Authentication successful
      showSnackbar('User signed in: ${userCredential.user!.uid}');

      // Navigate to the next screen (you can customize this based on your app flow)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AllEmployeesPhotosPage()),
      );
    } catch (e) {
     showSnackbarError('Authentication failed: $e');
      String errorMessage =
          'Authentication failed. Please check your credentials.';
     showSnackbarError(errorMessage);
    }
  }

 void showSnackbar(String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Container(
        alignment: Alignment.center,
        child: Text(
          message,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      backgroundColor: Colors.green,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.all(50),
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      duration: Duration(seconds: 3),
    ),
  );
}

void showSnackbarError(String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Container(
        alignment: Alignment.center,
        child: Text(
          message,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      backgroundColor:Colors.red,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.all(50),
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      duration: Duration(seconds: 3),
    ),
  );
}
// ignore: must_be_immutable

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 9.9,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 182, 215, 247),
                  Color.fromARGB(255, 39, 179, 235),
                ],
                begin: Alignment.topRight,
                end: Alignment.topLeft,
              ),
            ),
            // color: const Color.fromARGB(255, 44, 44, 40),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.1,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    // boxShadow: [
                      // BoxShadow(
                      //   color: Color.fromARGB(255, 241, 110, 22).withOpacity(0.4),
                      //   blurRadius: 4,
                      //   spreadRadius: 6,
                      //   offset: const Offset(0, 2),
                      // ),
                    // ],
                  ),
                  width: MediaQuery.of(context).size.width * 1,
                  height: MediaQuery.of(context).size.height * 1,
                ),
              ],
            ),
          ),
           Center(
            child: Container(
              margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.150,
                left: MediaQuery.of(context).size.width * 0.09,
                 right: MediaQuery.of(context).size.width * 0.09,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Welcome To ClockIn',
                    style: TextStyle(
                      fontSize: 25,
                      fontFamily: 'Lemon',
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 59, 58, 58),
                    ),
                  ),
                  SizedBox(height: 7),
                  Text(
                    'Welcome to our app!!!',
                    style: TextStyle(
                      fontFamily: 'Lemon',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 59, 58, 58).withOpacity(0.5),
                    ),
                  ),
                  SizedBox(height: 105),
                  TextField(
                    controller: emailController,
                    decoration: 
                    InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder( borderRadius: BorderRadius.circular(25.0)),
                    ),
                    ),
             
                  SizedBox(height: 45),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(25.0)),
                    ),
                  ),
                ],
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
              child: Center(
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