import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../GlobalWidget/CustomButton.dart';
import '../../contants/colors.dart';
import '../../contants/images.dart';
import 'package:lottie/lottie.dart' as lottie;

import '../../Models/Packages/PackagesListModel.dart';
import '../../controllers/Subscription Plans/PaymentFailedController.dart';

class PaymentFailedScreen extends GetView<PaymentFailedController> {
  final package;
  final orderID;
  PaymentFailedScreen(this.package, this.orderID);

  final PaymentFailedController controller = Get.put(PaymentFailedController());

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      bottomNavigationBar: bottomButton(context, package),
      backgroundColor: kPrimaryWhite,
      body: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          gradient: LinearGradient(
              colors: [
                kPrimaryWhite,
                plansBgColor,
              ],
              begin: FractionalOffset(0.0, 0.0),
              end: FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp),
        ),
        child: Stack(children: [
          Container(
            height: h,
            width: w,
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image(
                  image: AssetImage(paymentFailedVector),
                  width: w,
                ),
                SizedBox(
                  height: h * 0.02,
                ),
                Text(
                  "Payment Failed",
                  style: TextStyle(
                    fontSize: w * 0.07,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(
                  height: h * 0.015,
                ),
                Container(
                    width: w * 0.8,
                    child: Text(
                      "Your Payment was unsuccessful!, Please Check Card Details or Try Again Later",
                      style: TextStyle(
                        fontSize: w * 0.035,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ))
              ],
            ),
          ),

          // SafeArea(
          //   child: Container(
          //     alignment: Alignment.bottomCenter,
          //     child: lottie.Lottie.asset(
          //       'assets/animation/congratulation.json',
          //       width: w*2,
          //       height: h*2,
          //       repeat: true,
          //     ),
          //   ),
          // ),
        ]),
      ),
    );
  }

  bottomButton(BuildContext context, Package package) {
    return CustomButton(
      padding: EdgeInsets.all(20),
      text: "Try Again",
      onPressed: () async {
        await controller.tryAgain(package, orderID);
      },
    );
  }
}
