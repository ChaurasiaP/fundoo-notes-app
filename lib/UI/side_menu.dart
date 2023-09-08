import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fundoo_notes/UI/login_screen.dart';
import 'package:fundoo_notes/UI/main_screen.dart';
import 'package:fundoo_notes/UI/view_archive_notes.dart';
import 'package:fundoo_notes/services/firestore_db.dart';
import 'package:fundoo_notes/services/login_info.dart';
import 'package:fundoo_notes/style/button_style.dart';
import 'package:fundoo_notes/style/colors.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({super.key});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  TextEditingController feedbackController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isActiveTab = false;
  bool onMainRoute = true;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: sideMenuBG,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              // drawer header content
              DrawerHeader(
                // always shown on left side of the menu bar

                decoration: BoxDecoration(color: sideMenuBG),
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05),
                      const Text(
                        "Fundoo Notes",
                        style: TextStyle(
                            fontSize: 25,
                            color: Colors.white70,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.04),
                    ],
                  ),
                ),
              ),
              // drawer header content ends
              _loggedInUser(context),
              const SizedBox(height: 14),
              // draw menu-bar items
              _myNotesSection(context),
              const SizedBox(height: 14),
              _myArchivesSection(context),
              //const SizedBox(height: 14),
              // _settings(context),
              const SizedBox(height: 14),
              _feedback(context),
              const SizedBox(height: 14),
              _signOut(context)
              // drawer menu-bar items ends
            ],
          ),
        ),
      ),
    );
  }

  // SIDE MENU TABS
  Widget _loggedInUser(BuildContext context) => TextButton(
        onPressed: () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Icon(Icons.person_pin_rounded, size: 25, color: Colors.black),
            const SizedBox(width: 30),
            Text("${_auth.currentUser!.email}",
                style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontStyle: FontStyle.italic))
          ],
        ),
      );

  Widget _myNotesSection(BuildContext context) => TextButton(
      style: buttonStyle,
      onPressed: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const MainRoute()));
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Icon(Icons.lightbulb, size: 25, color: Colors.yellow),
          const SizedBox(width: 30),
          _sideMenuText("My Notes")
        ],
      ));

  Widget _myArchivesSection(BuildContext context) => TextButton(
      style: buttonStyle,
      onPressed: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const ViewArchivedNotes()));
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Icon(
            Icons.archive_outlined,
            size: 25,
            color: Colors.white,
          ),
          const SizedBox(width: 30),
          _sideMenuText("My Archives")
        ],
      ));

  Widget _feedback(BuildContext context) => TextButton(
      style: buttonStyle,
      onPressed: () {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: const Text("Submit Feedback"),
                  content: TextField(
                    controller: feedbackController,
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Enter your message"),
                  ),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context, "Cancel"),
                        child: const Text("Cancel")),
                    TextButton(
                        onPressed: () async {
                          await FirestoreDB.userFeedBack(
                              feedbackController.text);
                          // ignore: use_build_context_synchronously
                          Navigator.pop(context, "Submit");

                          // ignore: use_build_context_synchronously
                          showDialog(
                              context: context,
                              builder: (context) => const AlertDialog(
                                    title: Text("THANK YOU!!"),
                                  ));
                        },
                        child: const Text("Submit"))
                  ],
                ));
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Icon(
            Icons.feedback_rounded,
            size: 25,
            color: Colors.white,
          ),
          const SizedBox(width: 30),
          _sideMenuText("Feedback")
        ],
      ));

  Widget _signOut(BuildContext context) => TextButton(
      style: buttonStyle,
      onPressed: (){
        LocalDataSaver.saveLogData(false);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const LoginPage()));
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Icon(
            Icons.logout_rounded,
            size: 25,
            color: Colors.white,
          ),
          const SizedBox(width: 30),
          _sideMenuText("Sign Out")
        ],
      ));

  Widget _sideMenuText(String tabName) => Text(tabName,
      style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.white,
          fontStyle: FontStyle.italic));
}
