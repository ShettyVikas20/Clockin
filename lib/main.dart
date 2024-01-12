import 'package:attendanaceapp/AllEmployeesPhotosPage.dart';
import 'package:attendanaceapp/EmployeeHistoryPage.dart';
import 'package:attendanaceapp/add_employee.dart';
import 'package:attendanaceapp/admin_home_page.dart';

import 'package:attendanaceapp/emp_login.dart';

import 'package:attendanaceapp/google_sign_in_provider.dart';
import 'package:attendanaceapp/home_screen.dart';
import 'package:attendanaceapp/sign_in.dart';
import 'package:attendanaceapp/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GoogleSignInProvider(),
    child: 
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home:SplashScreen(),
    ),
    );
  }
}
 