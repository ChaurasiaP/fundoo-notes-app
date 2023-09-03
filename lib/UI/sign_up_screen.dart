
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fundoo_notes/UI/login_screen.dart';
import 'package:fundoo_notes/style/colors.dart';


class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  void _createAccount() async {
    String uName = usernameController.text.trim();
    String password = passwordController.text.trim();
    String cnfPassword = confirmPasswordController.text.trim();

    if (uName == "" || password == "" || cnfPassword == "") {
      debugPrint("Please fill all the details");
      _showSnackBar("Please fill all the details", Colors.red.shade400);
    } else if (cnfPassword != password) {
      debugPrint("Password and Confirm Password do not match");
      _showSnackBar("Password and Confirm Password do not match", Colors.redAccent);
    } else {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: uName, password: password);
        debugPrint("User Created");
        _showSnackBar(
            "You are Successfully Registered with us!", Colors.green.shade400);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()));
      } on FirebaseAuthException catch (ex) {
        _showSnackBar(ex.code.toString(), Colors.red.shade400);
      }
    }
  }

  void _showSnackBar(String message, Color color) {
    final snackBar = SnackBar(
        content: Text(message,
            style: const TextStyle(fontSize: 20)),
        padding: const EdgeInsets.all(30.0),
        backgroundColor: color);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  _signUpPageDecoration(String label, String hint) =>
      InputDecoration(
          labelStyle: const TextStyle(
              color: Colors.black54
          ),
          labelText: label,
          hintText: hint,
          focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black)
          )
      );



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Create New Account"),
        centerTitle: true,
      ),
      backgroundColor: allRoutesBG,
      body: SafeArea(
        child: Container(
          margin:  EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.02),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Column(
              children: [

                // add user icon
                const Icon(Icons.person_add_rounded, size: 130),
                // add user icon ends

                // email input text field
                TextField(
                  controller: usernameController,
                  decoration: _signUpPageDecoration("Email", "Enter Your Email") ,
                ),
                // email input text field ends

                // password input text field
                TextField(
                  controller: passwordController,
                  decoration: _signUpPageDecoration("Password", "enter new password"),
                ),
                // password input text field ends

                // confirm password input text field
                TextField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  decoration: _signUpPageDecoration("Confirm Password", "re-enter your password"),
                ),
                // confirm password input text field ends


                Padding(
                  padding: const EdgeInsets.all(38.0),

                  // submit button
                  child: ElevatedButton(
                      onPressed: () => {
                        _createAccount()
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonsColor,
                      ),
                      child: const SizedBox(
                        width: double.infinity,
                        child: Text("Create new account",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18
                          ),),
                      )),
                  // submit button ends

                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
