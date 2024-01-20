// import 'package:attendanaceapp/employee_home_page.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:lottie/lottie.dart';

// class LoginPage extends StatefulWidget {
//   @override
//   _LoginPageState createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: Text(
//           'Employee Login',
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             color: Color.fromARGB(255, 59, 58, 58),
//           ),
//         ),
//         elevation: 0,
//       shape: ContinuousRectangleBorder(
//         borderRadius: BorderRadius.circular(30.0),
//       ),
//       flexibleSpace: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [

//               Color.fromARGB(255, 233, 121, 46), Color.fromARGB(255, 247, 153, 14)
//               // Add more colors if you want a gradient effect
//             ],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//       ),
//     ),
//       body: SingleChildScrollView(
//      child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//              Padding(
//               padding: EdgeInsets.only(top: 45.0),
//             child: Lottie.asset(
//               'assets/images/login.json', // Replace with the correct path to your asset image
//               height: 250, // Adjust the height as needed
//               width:250,
//             ),
//              ),
//              SizedBox(height: 20),
//               TextField(
//                 controller: _nameController,
//                 decoration: InputDecoration(
//                   labelText: 'Name',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(15.0),
//                     borderSide: BorderSide(
//                       color: Colors.blue,
//                       width: 2.0,
//                     ),
//                   ),
//                 ),
//               ),

//             SizedBox(height: 16.0),
//             TextField(
//               controller: _passwordController,
//               obscureText: true,
//               decoration: InputDecoration(
//                   labelText: 'Password',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(15.0),
//                     borderSide: BorderSide(
//                       color: Colors.blue,
//                       width: 2.0,
//                     ),
//                   ),
//                 ),
//             ),
//             SizedBox(height: 32.0),
//             ElevatedButton(
//                style: ElevatedButton.styleFrom(
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(50),
//                   ),
//                   primary: Color.fromARGB(255, 247, 153, 14),
//                   elevation: 0,
//                   minimumSize: Size(70, 60),
//                 ),
//               onPressed: () {
//                 _login();
//               },
//               child: Text('Login',
//               style: TextStyle(
//                         fontSize: 19.0,
//                         fontWeight: FontWeight.bold,
//                         color: Color.fromARGB(255, 59, 58, 58))),
//             ),

//           ],

//         ),
//       ),
//       ),
//     );
//   }

//   void _login() {
//     // Validate the name and password (phone number)
//     if (_nameController.text.isEmpty || _passwordController.text.isEmpty) {
//       _showError('Please Enter Both Name and Password');
//       return;
//     }

//     // Perform backend authentication (fetch data from Firebase Firestore)
//     _performAuthentication(_nameController.text, _passwordController.text);
//   }

//  void _performAuthentication(String name, String password) {
//   // Fetch employee data from Firestore based on the provided name and phone number
//   FirebaseFirestore.instance.collection('Employees')
//     .where('name', isEqualTo: name)
//     .where('phone', isEqualTo: password)
//     .get()
//     .then((QuerySnapshot querySnapshot) {
//       if (querySnapshot.size > 0) {
//         // Authentication successful
//         var user = querySnapshot.docs[0].data() as Map<String, dynamic>?; // Assuming only one user is found
//         print('Authentication successful for employee: $name');
//         _showSuccess('Authentication successful for employee: $name');

//         // Check if user is not null before accessing its properties
//         if (user != null) {
//           // Navigate to the EmployeeHomePage with user details
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => EmployeeHomePage(
//                 name: user['name'] as String,
//                 email: user['email'] as String,
//                 phone: user['phone'] as String,
//                 imageUrl: user['photo_url'] as String,
//               ),
//             ),
//           );
//         } else {
//           // Handle the case when user is null
//           _showError('User details are null');
//         }
//       } else {
//         // No employee found with the provided name and phone number
//         print('Incorrect name or phone number for employee: $name');
//         _showError('Incorrect name or phone number for employee: $name');
//       }
//     })
//     .catchError((error) {
//       print('Error fetching employee data: $error');
//       _showError('Error fetching employee data: $error');
//     });
// }

// void _showError(String message) {
//   ScaffoldMessenger.of(context).showSnackBar(
//     SnackBar(
//       content: Container(
//         alignment: Alignment.center,
//         child: Text(
//           message,
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 16,
//             fontWeight: FontWeight.bold,
//           ),
//           textAlign: TextAlign.center,
//         ),
//       ),
//       backgroundColor: Colors.red,
//       behavior: SnackBarBehavior.floating,
//       margin: EdgeInsets.all(50),
//       elevation: 10,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(30),
//       ),
//       duration: Duration(seconds: 3),
//     ),
//   );
// }

// void _showSuccess(String message) {
//   ScaffoldMessenger.of(context).showSnackBar(
//     SnackBar(
//       content: Container(
//         alignment: Alignment.center,
//         child: Text(
//           message,
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 16,
//             fontWeight: FontWeight.bold,
//           ),
//           textAlign: TextAlign.center,
//         ),
//       ),
//       backgroundColor:  Colors.green,
//       behavior: SnackBarBehavior.floating,
//       margin: EdgeInsets.all(50),
//       elevation: 10,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(30),
//       ),
//       duration: Duration(seconds: 3),
//     ),
//   );
// }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'employee_home_page.dart';

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
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Employee Login',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 59, 58, 58),
          ),
        ),
        elevation: 0,
        shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 233, 121, 46),
                Color.fromARGB(255, 247, 153, 14),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
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
      _showError('Please Enter Both Name and Password');
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
          _showError('User details are null');
        }
      } else {
        _showError('Incorrect name or phone number for employee: $name');
      }
    }).catchError((error) {
      _showError('Error fetching employee data: $error');
    });
  }

  void _showError(String message) {
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
        backgroundColor: Colors.red,
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

  void _showSuccess(String message) {
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
}