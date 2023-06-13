import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import '../../controllers/Subscription%20Plans/StripePaymentController.dart';

class StripePaymentScreen extends GetView<StripePaymentController> {
  final StripePaymentController stripePaymentController =
      Get.put(StripePaymentController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: Container(
        color: Colors.purple,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: RoundedLoadingButton(
            elevation: 0,
            borderRadius: 10,
            width: Get.width,
            onPressed: () async {
              // if (controller.selected.value == true) {
              //   var cardPayment = await stripePaymentController.makePayment(amount: 100, currency: "IND");
              //   if(cardPayment == true){
              //    print("card $cardPayment");
              //   }
              // }
              // else{
              //   print("card false");
              // }
            },
            color: Colors.purple,
            controller: controller.btnCartController,
            child: Text(
              "Confirm Order",
              style: TextStyle(
                  color: Colors.white, fontSize: 22, fontFamily: "RobotoBold"),
            ),
          ),
        ),
      ),
    );
  }
}
