import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';

class FirebaseMessagingAPI {
  final _messaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async{
    await _messaging.requestPermission();
    final _fCMtoken = _messaging.getToken();
    _fCMtoken.then((value) => debugPrint(" token: $value, $_fCMtoken"));
     /*
     token for virtual device:
     cLKMwnosTg-ZkqULZURCGG:APA91bF6NiuOYYsPp8VHurh9GhH1rzh9Fvti8eVwTZrvrKjwKVdkeCDa5iJeMnTcDFGONtMgF_EG4_R9RKsC8TskriX0UUFDfrOXY9PmLjHmCaQoLfGBlLLOolBgDZ1td3XUWZnFrY01
      */
  }
}