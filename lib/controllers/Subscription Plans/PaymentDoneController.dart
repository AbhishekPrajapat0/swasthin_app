import 'dart:async';

import 'package:get/get.dart';

import '../../screens/Dashboard/DashboardScreen.dart';

class PaymentDoneController extends GetxController {
  @override
  void onInit() {
    goToDashboard();
    super.onInit();
  }

  void goToDashboard() {
    Timer(Duration(seconds: 5), () {
      Get.offAll(() => DashboardScreen());
    });
  }
}
