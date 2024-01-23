import 'package:attendanaceapp/screens/google_sign_in_provider.dart';
import 'package:attendanaceapp/screens/splash_screen.dart';
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
 