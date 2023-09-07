import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fundoo_notes/UI/login_screen.dart';
import 'package:fundoo_notes/UI/main_screen.dart';
import 'package:fundoo_notes/firebase_options.dart';
import 'package:fundoo_notes/services/login_info.dart';
import 'package:fundoo_notes/style/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late bool isLogin = false;

  getLoggedInState() async {
    var getState = await LocalDataSaver.getLogData();
    getState! ? isLogin = true : isLogin = false;
  }

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), ()=> Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context)=>
    isLogin ? const MainRoute() : const LoginPage())));
    getLoggedInState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: SplashScreen());
  }
}
