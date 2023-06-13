import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

import '../../GlobalWidget/CustomButton.dart';
import '../../GlobalWidget/customAppBars.dart';
import '../../GlobalWidget/global_text_feild.dart';
import '../../contants/Dimentions.dart';
import '../../contants/colors.dart';
import '../../contants/images.dart';
import '../../controllers/ForgotPasswordController/ForgotPassController.dart';

class ForgotPasswordScreen extends GetView<ForgotPassController> {
  final ForgotPassController forgotPassController =
      Get.put(ForgotPassController());

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
              height: h * 0.085,
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
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: CustomTextFormField(
            maxLength: 10,
            showLabel: true,
            label: "Phone Number",
            hintText: 'Enter Phone Number',
            inputType: TextInputType.number,
            controller: forgotPassController.numberCon,
          ),
        ),
        CustomButton(
          padding: EdgeInsets.only(bottom: 18, left: 15, right: 15),
          text: "Send OTP",
          onPressed: () {
            forgotPassController.verify(context);
          },
        )
      ],
    );
  }
}
