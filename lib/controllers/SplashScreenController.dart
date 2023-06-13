import 'dart:async';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../screens/Dashboard/DashboardScreen.dart';
import '../../screens/SubscriptionScreen/ProgramListScreen.dart';
import '../../screens/UserDetails/ProfilePicScreen.dart';
import '../../screens/auth/LoginScreen.dart';

import '../contants/Constants.dart';

class SplashScreenController extends GetxController {
  GetStorage box = GetStorage();

  @override
  void onInit() {
    startAsyncTask();
    super.onInit();
  }

  startAsyncTask() async {
    final prefs = await SharedPreferences.getInstance();

    var isLoggedIn = await box.read(loggedIn) ?? false;
    var profileStatus = await prefs.getBool(userProfileStatus) ?? false;
    var subScriptionStatus = await box.read(isSubscribed) ?? false;
    print(
        "is user logined ====> $isLoggedIn $profileStatus $subScriptionStatus ${box.read(userProfileStatus)}");
    Timer(Duration(seconds: 5), () {
      Get.to(
          () => isLoggedIn
              ? profileStatus
                  ? subScriptionStatus
                      ? DashboardScreen()
                      : ProgramListScreen()
                  : ProfilePicScreen()
              : LoginScreen(),
          arguments: ["store"]);
    });
  }
}
