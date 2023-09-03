// SHARED PREFERENCE TO REMEMBER USER THROUGHOUT THE LOGGED IN STATE AND STORE THE DATA

import 'package:shared_preferences/shared_preferences.dart';

class LocalDataSaver{
  static String emailKey = "EMAILKEY";
  static String logKey = "LOGKEY";

  static Future<bool?> saveEmail(String? email) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(emailKey, email!);
  }
  static Future<bool?> saveLogData(bool isUserLoggedIn) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setBool(logKey, isUserLoggedIn);
  }
  static Future<String?> getEmail() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(LocalDataSaver.emailKey);
  }
  static Future<bool?> getLogData() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool(logKey);
  }
}