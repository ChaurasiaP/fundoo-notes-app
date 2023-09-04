import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fundoo_notes/UI/main_screen.dart';
import 'package:fundoo_notes/UI/reset_password.dart';
import 'package:fundoo_notes/UI/sign_up_screen.dart';
import 'package:fundoo_notes/services/login_info.dart';
import 'package:fundoo_notes/style/colors.dart';
import 'package:fundoo_notes/style/text_style.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // controllers to handle user input email and password
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool stayLoggedIn = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userNameController.text = "pranshu1431@gmail.com";
    passwordController.text = "123456";
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // to avoid pixel overflow while opening the keyboard

      appBar: AppBar(
        title: const Text("Login Page"),
      ),
      body: _page(),
      backgroundColor: allRoutesBG,
    );
  }

  // function _page will contain icon, text-fields to take email and password and other buttons
  Widget _page() => Center(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Column (
        children: [
          Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.02), child: _icon()),
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: _loginField(),
          ),
          Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: _passwordField()),
          Padding(
              padding: const EdgeInsets.only(top: 15),
              child: _actionButtons())
        ],
      ),
    ),
  );

  Widget _icon() => Container(
    decoration: BoxDecoration(
      border: Border.all(
          width: 2, color: Colors.black, style: BorderStyle.solid),
      shape: BoxShape.circle,
    ),
    child: const Icon(
      Icons.person,
      size: 130,
      color: Colors.black,
    ),
  );



  Widget _loginField() => TextField(
    controller: userNameController,
    style: contentStyle,
    decoration: _loginPageDecoration("Username/Login ID") ,
  );
  Widget _passwordField() => TextField(
      controller: passwordController,
      obscureText: true,
      style: contentStyle,
      decoration: _loginPageDecoration("Enter your password")
  );
  Widget _actionButtons() => Column(
    children: [
      // sign in button
      Column(
        children: [
          const Row(
            children: [
              Text("Stay signed in"),
            ],
          ),
          ElevatedButton(
              onPressed: () => _checkCredentials(),
              style: ElevatedButton.styleFrom(backgroundColor: buttonsColor),
              child: const SizedBox(
                width: double.infinity,
                child: Text(
                  "Sign in",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
              )),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // forgot password button
          ElevatedButton(
              onPressed: () => {
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => const ResetPassword())
                )
              },
              style:
              ElevatedButton.styleFrom(backgroundColor: buttonsColor),
              child: const Text(
                "FORGOT PASSWORD",
                style: TextStyle(color: Colors.white, fontSize: 10),
              )),

          // create new account button
          ElevatedButton(
              onPressed: () => {
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => const SignUpScreen()))
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonsColor,
              ),
              child: const Text(
                "CREATE NEW ACCOUNT",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                ),
              )),
        ],
      ),
    ],
  );


  _loginPageDecoration(String message) =>
      InputDecoration(
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.black, width: 2),
              borderRadius: BorderRadius.circular(15.5)),
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black),
            borderRadius: BorderRadius.circular(15.5),
          ),
          hintText: message);

  _checkCredentials() async {
    String email = userNameController.text.trim();
    String password = passwordController.text.trim();

    debugPrint(email);
    debugPrint(password);
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      final User? currentUser = _auth.currentUser;
      //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MainRoute()));
      _signedIn(email, password);
      setState(() {
        LocalDataSaver.saveLogData(true);
        LocalDataSaver.saveEmail(currentUser!.email.toString());
      });


      _showSnackBar("Login Successful", Colors.green.shade400);

    }on FirebaseAuthException catch(ex){
      debugPrint(ex.code.toString());
      _showSnackBar(ex.code.toString(), Colors.lime.shade400);

    }
  }
  void _showSnackBar(String message, Color color){
    final snackBar = SnackBar(
        content: Text(message,
            style: const TextStyle(fontSize: 20)),
        padding: const EdgeInsets.all(20.0),
        backgroundColor: color);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
  void _signedIn(String email, String password){
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const MainRoute()));
  }
}