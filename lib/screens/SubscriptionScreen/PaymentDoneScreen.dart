import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../contants/colors.dart';
import '../../contants/images.dart';
import 'package:lottie/lottie.dart' as lottie;
import '../../controllers/Subscription%20Plans/PaymentDoneController.dart';

class PaymentDoneScreen extends GetView<PaymentDoneController> {
  final PaymentDoneController paymentDoneController =
      Get.put(PaymentDoneController());

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
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
                  image: AssetImage(paymentSuccessVector),
                  width: w,
                ),
                Text(
                  "Payment Successful",
                  style: TextStyle(
                    fontSize: w * 0.07,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  "Your Payment was successful!, wait we are redirecting you to Dashboard...  ",
                  style: TextStyle(
                    fontSize: w * 0.035,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                )
              ],
            ),
          ),
          SafeArea(
            child: Container(
              alignment: Alignment.bottomCenter,
              child: lottie.Lottie.asset(
                'assets/animation/congratulation.json',
                width: w * 2,
                height: h * 2,
                repeat: true,
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
