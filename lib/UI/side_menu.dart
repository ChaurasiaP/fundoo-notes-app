
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fundoo_notes/UI/main_screen.dart';
import 'package:fundoo_notes/UI/settings.dart';
import 'package:fundoo_notes/UI/view_archive_notes.dart';
import 'package:fundoo_notes/style/button_style.dart';
import 'package:fundoo_notes/style/colors.dart';


class SideMenu extends StatelessWidget {

  const SideMenu({super.key});


  @override

  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    return Drawer(
      backgroundColor: allRoutesBG,
      child: SafeArea(
        child: Column(
          children: <Widget>[
            // drawer header content
            DrawerHeader(
              // always shown on left side of the menu bar

              decoration: BoxDecoration(color: Colors.blue.shade900,
                  borderRadius: const BorderRadius.only(topRight: Radius.circular(100), bottomRight: Radius.circular(100))),
              child: Center(
                child: Column(
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height*0.05),
                    const Text (
                      "Fundoo Notes",
                      style: TextStyle(fontSize: 25, color: Colors.white70, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height*0.04),
                    Text("Signed in as:\n${_auth.currentUser!.email}", style: const TextStyle(
                        fontSize: 12, color: Colors.white54
                    ),),
                  ],
                ),
              ),
            ),
            // drawer header content ends
            const SizedBox(height: 14),
            // draw menu-bar items
            _myNotesSection(context),
            const SizedBox(height: 14),
            _myArchivesSection(context),
            const SizedBox(height: 14),
            TextButton(
                style: buttonStyle,
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>const SettingsRoute()));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(Icons.settings, size: 25,color: Colors.white,),
                    const SizedBox(width: 30),
                    _sideMenuText("Settings")
                  ],
                ))

            // drawer menu-bar items ends
          ],
        ),
      ),
    );
  }

  Widget _myNotesSection(BuildContext context) =>
      TextButton(
          style: buttonStyle,
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => const MainRoute()));
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(Icons.lightbulb, size: 25,color: Colors.yellow,),
              const SizedBox(width: 30),
              _sideMenuText("My Notes")
            ],
          ));

  Widget _myArchivesSection(BuildContext context) =>
      TextButton(
          style: buttonStyle,
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => const ViewArchivedNotes()));
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(Icons.archive_outlined, size: 25, color: Colors.white,),
              const SizedBox(width: 30),
              _sideMenuText("My Archives")
            ],
          )
      );

  Widget _sideMenuText(String tabName) =>
      Text(tabName, style: const TextStyle(fontSize: 16,
          color: Colors.white, fontStyle: FontStyle.italic));
}
