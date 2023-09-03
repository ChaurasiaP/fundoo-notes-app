
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fundoo_notes/UI/login_screen.dart';
import 'package:fundoo_notes/UI/main_screen.dart';
import 'package:fundoo_notes/firebase_options.dart';
import 'package:fundoo_notes/services/login_info.dart';

Future<void> main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MaterialApp(
      home: MyApp()
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late bool isLogin = false;

  getLoggedInState() async {
    await LocalDataSaver.getLogData().then((value) {
      setState(() {
        isLogin = value.toString() == "null";
      });
    });
  }

  @override
  void initState(){
    super.initState();
    getLoggedInState();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

        home: LoginPage());
  }
}
