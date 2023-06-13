import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../GlobalWidget/CustomButton.dart';
import '../../GlobalWidget/customAppBars.dart';
import '../../GlobalWidget/password_feild.dart';
import '../../contants/colors.dart';
import '../../controllers/ForgotPasswordController/AddNewPasswordController.dart';

class AddNewPasswordScreen extends GetView<AddNewPasswordController> {
  final AddNewPasswordController addNewPasswordController =
      Get.put(AddNewPasswordController());

  final number;
  AddNewPasswordScreen(this.number);

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: kPrimaryWhite,
      appBar: appBarWithBack(context, showBack: true, title: "Forgot Password"),
      bottomNavigationBar: bottomNavigator(context),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //    Image

            // Text
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
              child: Container(
                  width: w * 0.85,
                  child: Text(
                    "Please, enter a new Password below different from the previous Password",
                    textAlign: TextAlign.start,
                    style: TextStyle(color: textMuted),
                  )),
            ),
            SizedBox(
              height: h * 0.02,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 18.0, vertical: 0),
              child: PasswordField(
                showLabel: true,
                controller: addNewPasswordController.passwordCon,
                label: 'New Password',
                hintText: 'Enter New Password',
                inputType: TextInputType.visiblePassword,
                // controller:loginController.passwordCon ,
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 18.0, vertical: 0),
              child: PasswordField(
                label: "Confirm Password",
                showLabel: true,
                hintText: "Confirm Password ",
                inputType: TextInputType.visiblePassword,
                controller: addNewPasswordController.conFirmPassCon,
              ),
            ),
          ],
        ),
      ),
    );
  }

  bottomNavigator(BuildContext context) {
    return CustomButton(
      padding: EdgeInsets.only(bottom: 25, left: 15, right: 15),
      text: "Reset Password",
      onPressed: () {
        addNewPasswordController.resetPassword(context, number.toString());
      },
    );
  }
}
