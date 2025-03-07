// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDPo-DwrYBrglBPCzNnQPmLH52hY3H-_94',
    appId: '1:23579168359:web:143d5b5fda3e46ff1a8ec2',
    messagingSenderId: '23579168359',
    projectId: 'attendance-manager-44cf8',
    authDomain: 'attendance-manager-44cf8.firebaseapp.com',
    storageBucket: 'attendance-manager-44cf8.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBqyk7LtlZOKl_iSdZTJTtgV19RPyzcR2c',
    appId: '1:23579168359:android:14cafc1de553fa3b1a8ec2',
    messagingSenderId: '23579168359',
    projectId: 'attendance-manager-44cf8',
    storageBucket: 'attendance-manager-44cf8.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA_8dLdh_H4v3NjV5qQfDz7GX9jbSOHe78',
    appId: '1:23579168359:ios:728c648b95c1c9ed1a8ec2',
    messagingSenderId: '23579168359',
    projectId: 'attendance-manager-44cf8',
    storageBucket: 'attendance-manager-44cf8.appspot.com',
    androidClientId: '23579168359-63ftk1h0vbusb6m71gab0bfanb3p50a2.apps.googleusercontent.com',
    iosClientId: '23579168359-q8g628bfckgepkspdo17knn83dkqtgfp.apps.googleusercontent.com',
    iosBundleId: 'com.example.attendanaceapp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyA_8dLdh_H4v3NjV5qQfDz7GX9jbSOHe78',
    appId: '1:23579168359:ios:434251a87d5369b61a8ec2',
    messagingSenderId: '23579168359',
    projectId: 'attendance-manager-44cf8',
    storageBucket: 'attendance-manager-44cf8.appspot.com',
    androidClientId: '23579168359-63ftk1h0vbusb6m71gab0bfanb3p50a2.apps.googleusercontent.com',
    iosClientId: '23579168359-th4iqh5d5be09qf1c68g8pklcn0lor88.apps.googleusercontent.com',
    iosBundleId: 'com.example.attendanaceapp.RunnerTests',
  );
}
