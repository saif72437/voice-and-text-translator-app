import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:voice_and_text_translator/firebase_options.dart';
import 'package:voice_and_text_translator/pages/auth_wrapper.dart';
import 'package:voice_and_text_translator/pages/home_page.dart';
import 'package:voice_and_text_translator/pages/login_page.dart';
import 'package:voice_and_text_translator/pages/signup_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // if (kIsWeb) {
  //   await Firebase.initializeApp(
  //     options: FirebaseOptions(
  //         apiKey: "AIzaSyBk85wpR6spS5dtRyffiyGu72pOyqySsPI",
  //         authDomain: "voice-and-text-translato-a7a09.firebaseapp.com",
  //         databaseURL: "https://voice-and-text-translato-a7a09-default-rtdb.firebaseio.com",
  //         projectId: "voice-and-text-translato-a7a09",
  //         storageBucket: "voice-and-text-translato-a7a09.appspot.com",
  //         messagingSenderId: "726895934198",
  //         appId: "1:726895934198:web:6bf982f8c44708741a8ad7"
  //     ),
  //   );
  // } else {
  //   await Firebase.initializeApp(
  //     // options: DefaultFirebaseOptions.currentPlatform,
  //   );
  // }

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: LoginPage()
      // home: HomePage(),
      home: AuthWrapper(),
    );
  }
}
