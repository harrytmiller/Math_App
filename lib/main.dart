import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'pages/question/question.dart';
import 'pages/profile.dart';
import 'pages/about.dart';
import 'pages/faq.dart';
import 'pages/authentication/login.dart';
import 'pages/authentication/register.dart';
import 'pages/intro.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyCsw_MZxDN-gDjvCmJIRUCeOss0rhySeGg", 
      authDomain: "project-db1d8.firebaseapp.com", 
      projectId: "project-db1d8", 
      storageBucket: "project-db1d8.firebasestorage.app", 
      messagingSenderId: "527238670793", 
      appId: "1:527238670793:web:00029c87fa79b86eb86018", 
    ),
  );
  runApp(const MainApp());
}


class MainApp extends StatelessWidget {
  const MainApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Project',
      initialRoute: '/Intro', 
      routes: {
        '/Intro': (context) => IntroPage(), 
        '/Login': (context) => LoginPage(),
        '/Register': (context) => RegisterPage(),
        '/': (context) => Question(),
        '/Profile': (context) => ProfilePage(),
        '/About Us': (context) => AboutPage(),
        '/FAQ': (context) => FAQPage(),
      },

    );
  }
}