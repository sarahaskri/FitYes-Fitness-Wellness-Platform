import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart'; 
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fityes/firebaseNot.dart';
import 'package:fityes/firebase_options.dart';
import 'package:fityes/home.dart'; 
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding
      .ensureInitialized();
 if (kIsWeb) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.web,
    );
  } else {
    await Firebase.initializeApp();
  }

  FirebaseMessaging.instance.getToken().then((value) {
    print("Firebase Token: $value");
  });
  // if app is on background
  FirebaseMessaging.onMessageOpenedApp.listen(
    (RemoteMessage message) async {
      print("onMessageOpenedApp: $message");
      Navigator.pushNamed(navigatorKey.currentState!.context, '/push-page',
          arguments: {"message": json.encode(message.data)});
    },
  );
  //if app is close or terminated
  FirebaseMessaging.instance.getInitialMessage().then(
    (RemoteMessage? message) {
      if (message != null) {
        Navigator.pushNamed(navigatorKey.currentState!.context, '/push-page',
            arguments: {"message": json.encode(message.data)});
      }
    },
  );
  FirebaseMessaging.onBackgroundMessage(
    _firebaseMessagingBackgroundHandler,
  );
    const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'channel_id',
            'channel_name',
            importance: Importance.max,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
        ),
      );
    }
  });
  runApp(const MyApp()); 
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  FirebaseAuth.instance.setLanguageCode("fr");
  print("_firebaseMessagingBackgroundHandler: $message");
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:Home(),
  
      navigatorKey: navigatorKey,
      routes: {
    
        '/push-page': (context) => const Firebase_test(),
       
      },
    );
  }
}
