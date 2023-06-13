import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import '../../screens/Dashboard/DashboardScreen.dart';
import '../../screens/SplashScreen/SplashScreen.dart';

import '../screens/NoInternetScreen/NoInternetScreen.dart';

class InternetService {
  late StreamSubscription<ConnectivityResult> _subscription;

  start() async {
    // Set up a timer to check the internet connection every 10 seconds
    Timer.periodic(const Duration(seconds: 10), (timer) async {
      // Check the internet connection
      var result = await Connectivity().checkConnectivity();
      if (result != ConnectivityResult.none) {
        print('Internet connection is active');
        // Get.offAll(DashboardScreen());
      } else {
        Get.to(() => (NoInternetScreen()));
        print('Internet connection is inactive');
      }
    });

    // Subscribe to the connectivity stream to receive updates
    _subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result != ConnectivityResult.none) {
        // Console.log('Internet connection is active 1');
      } else {
        print('Internet connection is inactive 1');
        // Get.offAll(()=>SplashScreen());
      }
    });
  }

  stop() async {
    _subscription.cancel();
  }
}
