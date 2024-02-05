// import 'package:attendanaceapp/screens/google_sign_in_provider.dart';
// import 'package:attendanaceapp/screens/splash_screen.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(const MyApp()); 
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//     create: (context) => GoogleSignInProvider(),
//     child: 
//     MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home:SplashScreen(),
//     ),
//     );
//   }
// }
import 'package:attendanaceapp/firebase_options.dart';
import 'package:attendanaceapp/screens/entirehistory_calender.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:provider/provider.dart';
import 'package:attendanaceapp/screens/google_sign_in_provider.dart';
import 'package:attendanaceapp/screens/splash_screen.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Title: ${message.notification?.title}');
  print('Body: ${message.notification?.body}');
  print('Payload: ${message.data}');
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  print('User granted permission: ${settings.authorizationStatus}');

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("Handling a foreground message: ${message.messageId}");
    _handleMessage(message);
  });

  runApp(const MyApp());
}

void _handleMessage(RemoteMessage message) {
  // Handle foreground messages here
  // You can use the message data or display a notification
  print("Foreground Message - Title: ${message.notification?.title}");
  print("Foreground Message - Body: ${message.notification?.body}");
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GoogleSignInProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home:  SplashScreen(),
      ),
    );
  }
}


















































































































