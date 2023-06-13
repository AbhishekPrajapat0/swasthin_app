import 'dart:async';

import 'package:Swasthin/contants/images.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import '../../GlobalWidget/CustomButton.dart';
import '../../contants/Constants.dart';
import '../Dashboard/DashboardScreen.dart';
import '../SplashScreen/SplashScreen.dart';
import '../SubscriptionScreen/SubscriptionScreen.dart';
import '../UserDetails/ProfilePicScreen.dart';
import '../auth/LoginScreen.dart';

class NoInternetScreen extends StatefulWidget {
  const NoInternetScreen({Key? key}) : super(key: key);

  @override
  State<NoInternetScreen> createState() => _NoInternetScreenState();
}

class _NoInternetScreenState extends State<NoInternetScreen> {
  Timer? timer;
  @override
  void initState() {
    // InternetService().stop();
    // timer = Timer.periodic(Duration(seconds:6), (Timer t) => checkForInternetConection());

    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: w,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(noInternetVector), scale: 0.01),
                // border: Border.all(color: Colors.blueAccent)
              ),
            ),

            // Text("Whoops!",style: TextStyle(fontSize: w/15, fontWeight: FontWeight.w500),),
            Text(
              "Slow or no internet connections. \nPlease check your internet settings",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: w / 25,
                fontWeight: FontWeight.w300,
              ),
            ),
            CustomButton(
              padding: EdgeInsets.all(20),
              text: "Try Again",
              onPressed: () async {
                GetStorage box = new GetStorage();
                var isLoggedIn = box.read(loggedIn) ?? false;
                var profileCompleted = box.read(userProfileStatus) ?? false;
                var subscribed = box.read(isSubscribed) ?? false;
                bool result = await InternetConnectionChecker().hasConnection;
                print("internet is connected $result");
                if (result) {
                  print("internet is connected $result inside");
                  Get.to(
                      () => isLoggedIn
                          ? profileCompleted
                              ? subscribed
                                  ? DashboardScreen()
                                  : SubscriptionScreen()
                              : ProfilePicScreen()
                          : LoginScreen(),
                      arguments: ["store"]);
                }
                // Get.back();
              },
            )
          ],
        ),
      ),
    );
  }

  void checkForInternetConection() async {
    bool result = await InternetConnectionChecker().hasConnection;
    print('YAY! ${InternetConnectionChecker().hasConnection}');
    if (result == true) {
      // GetStorage box = new GetStorage();
      // var isLoggedIn = box.read(loggedIn);
      // Get.to(()=>NavbarMainScreen());
      // Get.offAll(DashboardScreen());
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => SplashScreen()),
          (Route route) => false);
    } else if (result == false) {
      print('No internet :( Reason:');
      print(InternetConnectionChecker().hasConnection);
    }
  }
}
