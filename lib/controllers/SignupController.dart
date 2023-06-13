import 'dart:convert';
import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart';
import '../../GlobalWidget/globalAlert.dart';
import 'package:dio/dio.dart';
import '../../GlobalWidget/loading_widget.dart';
import '../../contants/Constants.dart';
import '../../screens/auth/LoginScreen.dart';
import '../../screens/auth/OtpScreen.dart';

class SignUpController extends GetxController {
  var isChecked = false.obs; // terms and condition checkbox

  var userCheckMsg = "";
  var type = "";
  final dio = Dio();
  GetStorage box = GetStorage();

  TextEditingController nameCon = TextEditingController();
  TextEditingController emailCon = TextEditingController();
  TextEditingController countryCodeCon = TextEditingController();
  TextEditingController numberCon = TextEditingController();
  TextEditingController passwordCon = TextEditingController();
  TextEditingController confirmPasswordCon = TextEditingController();

  @override
  void onInit() {
    // TODO: implement onInit
    countryCodeCon.text = "+91";
    super.onInit();
  }

  clearAllControlers() {
    nameCon.clear();
    emailCon.clear();
    numberCon.clear();
    passwordCon.clear();
    confirmPasswordCon.clear();
  }

  signUpUser(BuildContext context) async {
    loadingWithText(context, "Loading Please Wait..");

    ///** Start Loading
    var message = validateEnteredData();
    if (message != "success") {
      stopLoading(context);

      ///** Stop Loading
      GlobalAlert(context, "Warning", message, DialogType.warning, onTap: () {
        print(" HHHHHH $message");
      });
    } else {
      var userExist = await checkUserExist(numberCon.text);
      var emailExist = await checkUserExist(emailCon.text);
      print("user exist is $userExist");
      if (userExist) {
        stopLoading(context);

        ///** Stop Loading
        GlobalAlert(
            context,
            "Mobile Number Exist",
            "User Already Exist with this number, \nPlease Login",
            DialogType.warning, onTap: () {
          clearAllControlers();
          // Get.to(() => LoginScreen());
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => LoginScreen()),
              (Route route) => false);
        });
      } else if (emailExist) {
        stopLoading(context);

        ///** Stop Loading
        GlobalAlert(context, "Email is Taken", "Email is already in Use",
            DialogType.warning,
            onTap: () {});
      } else {
        box.write(userName, nameCon.text);
        box.write(userMobileNum, numberCon.text);
        box.write(userEmail, emailCon.text);
        sendOtp(context);
      }
    }
  }

  //check if data proper
  String validateEnteredData() {
    final bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(emailCon.text);
    var name = nameCon.text.trim();
    var number = numberCon.text;
    if (name.isEmpty || name.split(" ").toList().length < 2) {
      return "Please Enter Your Full Name";
    } else if (emailCon.text.isEmpty) {
      return "Email Cannot be Empty";
    } else if (!emailValid) {
      return "Please Check, Email is Invalid";
    } else if (number.isEmpty) {
      return "Mobile Number Cannot be Empty";
    } else if (number.startsWith("1")) {
      return "Please Check, Number \nCannot start with 1";
    } else if (number.startsWith("2")) {
      return "Please Check, Number \nCannot start with 2";
    } else if (number.startsWith("3")) {
      return "Please Check, Number \nCannot start with 3";
    } else if (number.startsWith("4")) {
      return "Please Check, Number \nCannot start with 4";
    } else if (number.startsWith("5")) {
      return "Please Check, Number \nCannot start with 5";
    } else if (number.length < 10) {
      return "Number should be 10 Digit";
    } else if (passwordCon.text.isEmpty) {
      return "Password Cannot be Empty";
    } else if (passwordCon.text.length < 6) {
      return "Password should be atleast 6 character";
    } else if (confirmPasswordCon.text.isEmpty) {
      return "Confirm Password Cannot be Empty";
    } else if (confirmPasswordCon.text.length < 6) {
      return "Confirm Password should be atleast 6 character";
    } else if (confirmPasswordCon.text != passwordCon.text) {
      return "Password Does Not Match";
    } else {
      return "success";
    }
  }

  Future<bool> checkUserExist(String text) async {
    try {
      var url = Uri.parse(base_url + checkUserPresenceUrl);
      var body = {"email_phone": "${text}"};
      final response = await post(url, body: body);
      print(" response is ${response.statusCode} ${response.body}");

      var data = jsonDecode(response.body.toString());
      if (response.statusCode == 200) {
        userCheckMsg = data["message"];
        type = data["type"];
        return true;
      } else if (response.statusCode == 422) {
        type = data["type"];
        userCheckMsg = data["message"];
        return false;
      } else {
        throw Exception();
      }
    } catch (e) {
      print("error is $e");
      throw Exception();
    }
  }

  Future<void> sendOtp(BuildContext context) async {
    try {
      var url = Uri.parse(base_url + sendOtpUrl);
      var data = {
        "mobile": "${numberCon.text}",
      };
      final response = await post(url, body: data);
      print("Otp send response is ${response.statusCode} ${response.body}");
      if (response.statusCode == 200) {
        stopLoading(context);

        ///** Stop Loading
        Get.to(() => OtpScreen(), arguments: [
          {
            "email": emailCon.text,
            "mobile": numberCon.text,
            "country_code": countryCodeCon.text,
            "name": nameCon.text,
            "password": passwordCon.text,
          }
        ]);
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
