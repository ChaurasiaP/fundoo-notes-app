import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      body: Padding(
        padding: EdgeInsets.only(top:MediaQuery.of(context).size.height*0.4),
        child: const Center(
            child: Column(
              children: [
                Icon(Icons.note_add, size: 125, color: Colors.blue),
                Text("Fundoo\n Notes", style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w500
                ),)
              ],
            )
        ),
      ),
    );
  }
}
