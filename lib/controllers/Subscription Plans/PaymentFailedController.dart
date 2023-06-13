import 'dart:async';

import 'package:get/get.dart';

import '../../cashfree/paymentStatus.dart';

class PaymentFailedController extends GetxController {
  dynamic arguments = Get.arguments;
  @override
  void onInit() {
    goToDashboard();
    super.onInit();
  }

  void goToDashboard() {
    Timer(Duration(seconds: 5), () {
      // Get.offAll(()=>DashboardScreen());
    });
  }

  tryAgain(package, orderID) {
    // var type = arguments[0];
    var type = "not a renew";
    if (type == "renew") {
      Get.back();
    } else {
      try {
        Get.offAll(
            () => CashFreePaymentStatus(package: package, orderid: orderID));
      } catch (e) {
        print("Errro  :$e");
      }
      // Get.offAll(()=>SubscriptionScreen());
    }
  }
}
