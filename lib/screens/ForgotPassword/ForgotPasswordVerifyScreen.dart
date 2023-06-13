import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:pinput/pinput.dart';

import '../../GlobalWidget/CustomButton.dart';
import '../../GlobalWidget/customAppBars.dart';
import '../../GlobalWidget/globalAlert.dart';
import '../../contants/Constants.dart';
import '../../contants/Dimentions.dart';
import '../../contants/colors.dart';
import '../../contants/images.dart';
import 'AddNewPassword.dart';

class ForgotPassVerifyScreen extends StatelessWidget {
  ForgotPassVerifyScreen({Key? key}) : super(key: key);

  TextEditingController otpCon = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: kPrimaryWhite,
      appBar: appBarWithBack(context, showBack: true, title: "Forgot Password"),
      // bottomNavigationBar: bottomNavigator(context),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: h * 0.1,
            ),
            //    Image
            Container(
              width: w,
              height: w,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(forgotPassVector),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            // Text
            Container(
                width: w * 0.8,
                child: Text(
                  "Forgot your Password? Don’t Worry Please Enter your Phone Number To reset password",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: textMuted),
                )),
            SizedBox(
              height: h * 0.08,
            ),
            bottomNavigator(context),
          ],
        ),
      ),
    );
  }

  bottomNavigator(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
            padding: EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 5),
                      // width:w*0.95,
                      child: Text(
                        "Enter OTP",
                        textAlign: TextAlign.start,
                        style: TextStyle(color: textMuted),
                      ),
                    ),
                  ],
                ),
                defaultPinPut(context),
              ],
            )),
        SizedBox(
          height: h * 0.01,
        ),
        CustomButton(
          padding: EdgeInsets.only(bottom: 18, left: 15, right: 15),
          text: "Verify OTP",
          onPressed: () {
            verifyOtp(context);
          },
        )
      ],
    );
  }

  Widget defaultPinPut(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return Pinput(
      length: 6,
      controller: otpCon,
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

  //  function to verify Otp from Api
  verifyOtpApi(BuildContext context) async {
    try {
      dynamic argumentData = Get.arguments;
      var number = argumentData[0]['mobile'];
      print("number ===> $number");
      var url = Uri.parse(base_url + verifyOtpUrl);
      var data = {"mobile": "$number", "otp": "${otpCon.text}"};
      final response = await post(url, body: data);
      print(" Otp Verify response is ${response.statusCode} ${response.body}");
      if (response.statusCode == 200) {
        // response body
        var data = jsonDecode(response.body.toString());
        //  Otp is Correct
        Get.to(
          () => AddNewPasswordScreen(number),
        );
      } else if (response.statusCode == 422) {
        var data = jsonDecode(response.body.toString());
        var message = data['message'];
        GlobalAlert(context, "OTP Invalid", "$message", DialogType.warning,
            onTap: () {});
      } else {
        throw Exception();
      }
    } catch (e) {
      print("error is $e");
      throw Exception();
    }
  }

  void verifyOtp(BuildContext context) {
    if (otpCon.text.length == 0) {
      GlobalAlert(
          context, "OTP Empty", "OTP cannot be Empty", DialogType.warning,
          onTap: () {});
    } else if (otpCon.text.length < 6) {
      GlobalAlert(
          context, "Invalid OTP", "OTP Should be 6 Digit", DialogType.warning,
          onTap: () {});
    } else {
      verifyOtpApi(context);
    }
  }
}
