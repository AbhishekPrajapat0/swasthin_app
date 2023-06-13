import 'dart:convert';

import 'package:Swasthin/routes/Pages.dart';
import 'package:Swasthin/routes/Routes.dart';
import 'package:Swasthin/screens/SplashScreen/SplashScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart';
import 'package:flutter/services.dart';

import 'Utlis/InternetService.dart';
import 'Utlis/LocalNotificationService.dart';
import 'contants/Constants.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();
  LocalNotificationService.initialize();
  // Stripe.publishableKey = "pk_test_51MuWQhSBKr45iDh5SBlXcL7myXSazPsrAK41UBhYhJsg5Mnx6cirkdPF1hce0zoF5hELRJLzXDnSZ0ZAVgWSX8bu00arHe4sUB";
  Stripe.publishableKey = await getStripKey();
  Stripe.merchantIdentifier = "any thing";
  await Stripe.instance.applySettings();
  InternetService().start();
  //force app portrait orientation
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) => runApp(MyApp()));
  runApp(MyApp());
}

Future<String> getStripKey() async {
  try {
    var uri = Uri.parse(base_url + getStripeKeyUrl);
    final response = await get(uri);
    print("getting stripe key  ===> ${response.statusCode}");
    print("getting stripe key ================> ${response.body}");
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data["data"]["stripe_public_key"];
    } else {
      return "no key";
    }
  } catch (e) {
    print("error on getting stripe key >>>>> $e");
    throw Exception();
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var firebaseMessaging = FirebaseMessaging.instance;

  @override
  void initState() {
    registerNotification();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    print("start getting location");
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      getPages: Pages.routes,
      builder: EasyLoading.init(),
    );
  }

  Future<void> registerNotification() async {
    firebaseMessaging.requestPermission();
    await firebaseMessaging.getInitialMessage().then((message) {
      print("FirebaseMessaging.getInitialMessage ${message}");
      if (message != null) {
        navigate(message);
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print(
          "FirebaseMessaging.onMessageOpenedApp ${message.notification?.body}");
      navigate(message);
    });
    FirebaseMessaging.onMessage.listen((message) async {
      print("FirebaseMessaging.onMessage ${message.notification?.body}");
      LocalNotificationService.display(message);
    });
  }

  navigate(RemoteMessage message) {
    print("navigate(RemoteMessage ${message.data}");
    Get.toNamed(Routes.CHAT_SCREEN);
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  LocalNotificationService.initialize();
  LocalNotificationService.display(message);
}
