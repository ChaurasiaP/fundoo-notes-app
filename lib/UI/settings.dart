import 'package:flutter/material.dart';
import 'package:fundoo_notes/UI/login_screen.dart';
import 'package:fundoo_notes/services/login_info.dart';
import 'package:fundoo_notes/style/button_style.dart';
import 'package:fundoo_notes/style/colors.dart';
import 'package:fundoo_notes/style/text_style.dart';


class SettingsRoute extends StatelessWidget {
  const SettingsRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      backgroundColor: allRoutesBG,

      body: Column(
        children: [
          Container(
            decoration: tabsDecoration,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                    onTap: () {},
                    splashColor: activeTab,
                    child: Row(
                        children: [
                          _tabName("Feedback"),
                          SizedBox(width: MediaQuery.of(context).size.width*0.5),
                          ElevatedButton(onPressed: (){}, child: const Icon(Icons.feedback_outlined, size: 30)),
                        ])),
              ],
            ),
          ),
          Container(
            decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.black))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                    onTap: (){
                      LocalDataSaver.saveLogData(false);
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const LoginPage()));
                    },
                    splashColor: activeTab,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _tabName("Sign Out"),
                          SizedBox(width: MediaQuery.of(context).size.width*0.5),
                          ElevatedButton(onPressed: (){
                            LocalDataSaver.saveLogData(false);
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const LoginPage()));
                            debugPrint("USER LOGGED OUT");
                          }, child: const Icon(Icons.logout_rounded, size: 30)),
                        ])),
              ],
            ),
          )
        ],
      ),
    );
  }
  Widget _tabName(String tabName) =>
      Text(tabName, style: tabsTextStyle);
}
