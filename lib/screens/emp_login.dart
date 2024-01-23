import 'package:attendanaceapp/components/app_bar.dart';
import 'package:attendanaceapp/components/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'chekin_checkout.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppbarEmp('Emplyoee Login'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 45.0),
                child: Lottie.asset(
                  'assets/images/login.json',
                  height: 250,
                  width: 250,
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide(
                      color: Colors.blue,
                      width: 2.0,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide(
                      color: Colors.blue,
                      width: 2.0,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 32.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  primary: Color.fromARGB(255, 247, 153, 14),
                  elevation: 0,
                  minimumSize: Size(70, 60),
                ),
                onPressed: () {
                  _login();
                },
                child: Text(
                  'Login',
                  style: TextStyle(
                      fontSize: 19.0,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 59, 58, 58)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _login() {
    if (_nameController.text.isEmpty || _passwordController.text.isEmpty) {
      showError(context,'Please Enter Both Name and Password');
      return;
    }

    _performAuthentication(_nameController.text, _passwordController.text);
  }

  void _performAuthentication(String name, String password) {
    FirebaseFirestore.instance
        .collection('Employees')
        .where('name', isEqualTo: name)
        .where('phone', isEqualTo: password)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.size > 0) {
        var user = querySnapshot.docs[0].data() as Map<String, dynamic>?;

        if (user != null) {
          var currentDate = DateFormat('yyyy-MMM-dd').format(DateTime.now());
          var formattedDocumentId =
              '${user['name']}_${user['phone']}_$currentDate';

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EmployeeHomePage(
                 id: user['id'] as String,
                name: user['name'] as String,
                email: user['email'] as String,
                phone: user['phone'] as String,
                imageUrl: user['photo_url'] as String,
                documentId: formattedDocumentId,
              ),
            ),
          );
        } else {
          showError(context,'User details are null');
        }
      } else {
        showError(context,'Incorrect name or phone number for employee: $name');
      }
    }).catchError((error) {
      showError(context,'Error fetching employee data: $error');
    });
  }
}