import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fundoo_notes/style/colors.dart';
import 'package:fundoo_notes/style/text_style.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Forgot Password"),
        centerTitle: true,
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: allRoutesBG,
      body: Padding(
        padding: const EdgeInsets.all(38.0),
        child: Column(
          children: [
            Icon(Icons.password_rounded, size: 130, color: buttonsColor),

            // email input
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: emailController,
                style: contentStyle,
                decoration: _resetPswdDecoration(
                  "Enter your registered email ID",
                ),
              ),
            ),

            //submit button
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: ElevatedButton(
                  onPressed: () {
                    FirebaseAuth.instance
                        .sendPasswordResetEmail(email: emailController.text);
                  },
                  style:
                      ElevatedButton.styleFrom(backgroundColor: buttonsColor),
                  child: const Text("Submit")),
            )
          ],
        ),
      ),
    );
  }

  _resetPswdDecoration(String message) => InputDecoration(
      focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black, width: 2),
          borderRadius: BorderRadius.circular(15.5)),
      border: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.black),
        borderRadius: BorderRadius.circular(15.5),
      ),
      labelText: message,
      labelStyle: const TextStyle(color: Colors.black));
}
