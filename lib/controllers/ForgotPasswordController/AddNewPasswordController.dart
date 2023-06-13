import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';

import '../../GlobalWidget/globalAlert.dart';
import '../../GlobalWidget/loading_widget.dart';
import '../../contants/Constants.dart';
import '../../screens/auth/LoginScreen.dart';

class AddNewPasswordController extends GetxController {
  TextEditingController passwordCon = TextEditingController();
  TextEditingController conFirmPassCon = TextEditingController();

  resetPassword(BuildContext context, String number) {
    var message = validateData(context);
    if (message == "success") {
      sendDataToApi(context, number);
    } else {
      GlobalAlert(context, "Invalid Password!", "$message", DialogType.warning,
          onTap: () {});
    }
  }

  validateData(BuildContext context) {
    if (passwordCon.text.isEmpty) {
      return "Password cannot be Empty";
    } else if (passwordCon.text.length < 6) {
      return "Password should be at least 6 Character";
    } else if (conFirmPassCon.text.isEmpty) {
      return "Confirm Password cannot be Empty";
    } else if (conFirmPassCon.text.length < 6) {
      return "Confirm Password should be at least 6 Character";
    }
    if (passwordCon.text.trim() != conFirmPassCon.text.trim()) {
      return "Password does not match, Please Check Again";
    } else {
      return "success";
    }
  }

  Future<void> sendDataToApi(BuildContext context, String number) async {
    try {
      loadingWithText(context, "Please Wait Loading.. ");
      print("number ===> $number");
      var url = Uri.parse(base_url + resetPassUrl);
      var data = {
        "mobile": "$number",
        "password": "${passwordCon.text}",
        "confirm_password": "${conFirmPassCon.text}"
      };
      final response = await post(url, body: data);
      print(
          "reset Pass response ====> ${response.statusCode} ${response.body}");
      if (response.statusCode == 200) {
        stopLoading(context);

        ///** Stop Loading
        GlobalAlert(
            context,
            "Successful",
            "Your password was changed successfully, Please Login Now",
            DialogType.success,
            onTap: () {});
        Timer(Duration(seconds: 4), () {
          Get.offAll(() => LoginScreen());
        });
      } else if (response.statusCode == 422) {
        stopLoading(context);

        ///** Stop Loading
      } else {
        stopLoading(context);

        ///** Stop Loading
        throw Exception();
      }
    } catch (e) {
      stopLoading(context);

      ///** Stop Loading
      print("error in otp send is $e");
      throw Exception();
    }
  }
}
