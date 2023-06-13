import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

import '../../GlobalWidget/CustomButton.dart';
import '../../GlobalWidget/customAppBars.dart';
import '../../contants/Dimentions.dart';
import '../../contants/colors.dart';
import '../../contants/images.dart';
import '../../controllers/VerifyOtpController.dart';

class OtpScreen extends GetView<VerifyOtpController> {
  final VerifyOtpController otpController = Get.put(VerifyOtpController());
  dynamic argumentData = Get.arguments;

  @override
  Widget build(BuildContext context) {
    var number = argumentData[0]['mobile'];
    var countryCode = argumentData[0]['country_code'];
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: appBarWithBack(context, showBack: true, title: "Verify Otp"),
      body: SingleChildScrollView(
        child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          //    Image
          Container(
            width: w,
            height: w,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(otpVector),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          // Text
          Container(
              width: w * 0.8,
              child: Text(
                "OTP has been Sent to ${countryCode + " " + number}, Please Enter the OTP Below",
                textAlign: TextAlign.center,
                style: TextStyle(color: textMuted),
              )),

          // Otp Pin put
          Container(
              margin: EdgeInsets.only(
                top: 50,
              ),
              width: w * 0.8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 5),
                    width: w * 0.75,
                    child: Text(
                      "Enter OTP",
                      textAlign: TextAlign.start,
                      style: TextStyle(color: textMuted),
                    ),
                  ),
                  defaultPinPut(context),
                ],
              )),

          //Resend Otp
          Obx(
            () => Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      otpController.countDownStarted.value = true;
                    },
                    child: Text(
                      'Resend OTP',
                      style: TextStyle(
                          color: otpController.countDownStarted.value == true
                              ? textExtraMuted
                              : kPrimaryBlack),
                    ),
                  ),
                  otpController.countDownStarted.value
                      ? startConutDown()
                      : Container(),
                ],
              ),
            ),
          ),

          //      Verify Otp Button
          CustomButton(
            text: "Verify OTP",
            onPressed: () {
              otpController.startVerifing(context);
            },
            padding: EdgeInsets.symmetric(horizontal: 30),
          )
        ]),
      ),
    );
  }

  Widget defaultPinPut(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return Pinput(
      length: 6,
      controller: otpController.otpCon,
      defaultPinTheme: PinTheme(
          textStyle: const TextStyle(
              fontSize: 30, fontWeight: FontWeight.w400, color: Colors.grey),
          decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.3),
              borderRadius:
                  BorderRadius.circular(Dimensions.paddingUltraSmall)),
          width: w * 0.15,
          height: w * 0.13),
      focusedPinTheme: PinTheme(
          textStyle: const TextStyle(
              fontSize: 30, fontWeight: FontWeight.w400, color: Colors.grey),
          decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.3),
              borderRadius:
                  BorderRadius.circular(Dimensions.paddingUltraSmall)),
          width: w * 0.15,
          height: w * 0.13),
    );
  }

  Widget startConutDown() {
    var resendEnable = false;
    return TweenAnimationBuilder<Duration>(
        duration: Duration(minutes: 2),
        tween: Tween(begin: Duration(minutes: 2), end: Duration.zero),
        onEnd: () {
          otpController.countDownStarted.value = false;
        },
        builder: (BuildContext context, Duration value, Widget? child) {
          final minutes = value.inMinutes;
          final seconds = value.inSeconds % 60;

          return Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Text('$minutes:$seconds',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                      fontSize: 16)));
        });
  }
}
