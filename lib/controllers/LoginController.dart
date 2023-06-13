import 'dart:convert';
import 'dart:io' show Platform;
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Utlis/globalFunctions.dart';
import '../../screens/Dashboard/DashboardScreen.dart';
import '../../screens/SubscriptionScreen/ProgramListScreen.dart';
import '../../screens/UserDetails/ProfilePicScreen.dart';

import '../GlobalWidget/globalAlert.dart';
import '../GlobalWidget/loading_widget.dart';
import '../contants/Constants.dart';

class LoginController extends GetxController {
  var isChecked = false.obs; // terms and condition checkbox
  var loginWithEmail = true.obs; // loginWith
  var userCheckMsg = "";
  var type = "";
  GetStorage box = GetStorage();

  TextEditingController emailCon = TextEditingController();
  TextEditingController countryCodeCon = TextEditingController();
  TextEditingController numberCon = TextEditingController();
  TextEditingController passwordCon = TextEditingController();

  @override
  void onInit() {
    // TODO: implement onInit
    countryCodeCon.text = "+91";
    super.onInit();
  }

  clearAllControlers() {
    emailCon.clear();
    numberCon.clear();
    passwordCon.clear();
  }

  logInUser(BuildContext context) async {
    loadingWithText(context, "Loading Please Wait..");

    ///** Start Loading
    var message = loginWithEmail == true
        ? validateEnteredDataWithEmail()
        : validateEnteredDataWithNumber();
    if (message != "success") {
      stopLoading(context);

      ///** Stop Loading
      GlobalAlert(context, "Warning", message, DialogType.warning, onTap: () {
        print(" HHHHHH $message");
      });
    } else {
      var userExist = loginWithEmail == true
          ? await checkUserExist(emailCon.text, context)
          : await checkUserExist(numberCon.text, context);
      print("message $message $userExist");

      if (userExist) {
        loginWithEmail == true
            ? loginApi(emailCon.text, context)
            : loginApi(numberCon.text, context);
      } else {
        print(" HHHHHH $userCheckMsg ");
        stopLoading(context);

        ///** Stop Loading
        GlobalAlert(
            context, "Unable To Login", "$userCheckMsg", DialogType.warning,
            onTap: () {
          clearAllControlers();
          // Get.to(()=>SignUpScreen());
          print(" HHHHHH $userCheckMsg ");
        });
      }
    }
  }

  //check if data proper
  String validateEnteredDataWithEmail() {
    final bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(emailCon.text);
    if (emailCon.text.isEmpty) {
      return "Email Cannot be Empty";
    } else if (!emailValid) {
      return "Please Check, Email is Invalid";
    } else if (passwordCon.text.isEmpty) {
      return "Password Cannot be Empty";
    } else if (passwordCon.text.length < 6) {
      return "Password should be atleast 6 character";
    } else {
      return "success";
    }
  }

  //check if data proper
  String validateEnteredDataWithNumber() {
    var number = numberCon.text;
    if (number.isEmpty) {
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
    } else {
      return "success";
    }
  }

  Future<bool> checkUserExist(String text, BuildContext context) async {
    try {
      var url = Uri.parse(base_url + checkUserPresenceUrl);
      var body = {"email_phone": "${text}"};
      final response = await post(url, body: body);
      print(" response is ${response.statusCode} ${response.body}");
      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        userCheckMsg = data["message"];
        print(
            "============================================================> ${userCheckMsg} ${data["message"]}");
        type = data["type"];
        return true;
      } else if (response.statusCode == 422) {
        userCheckMsg = data["message"];
        type = data["type"];
        return false;
      } else {
        throw Exception();
      }
    } catch (e) {
      stopLoading(context);

      ///** Stop Loading
      print("error is $e");
      throw Exception();
    }
  }

  Future<void> loginApi(String text, BuildContext context) async {
    try {
      final fcmToken = await FirebaseMessaging.instance.getToken();
      var device_type = Platform.operatingSystem;
      final prefs = await SharedPreferences.getInstance();
      var url = Uri.parse(base_url + userLogInUrl);
      var dataRes = {
        "email_phone": "${text}",
        "password": "${passwordCon.text}",
        "device_type": "$device_type",
        "device_id": "$fcmToken"
      };
      final response = await post(url, body: dataRes);
      print(" Login response is ${response.statusCode} ${response.body}");
      var data = jsonDecode(response.body.toString());
      if (response.statusCode == 200) {
        // response body

        //token
        var token = data['user']['token'].toString();
        var gender = data['user']['gender'].toString();
        var name = data['user']['name'].toString();
        var email = data['user']['email'].toString();
        var number = data['user']['mobile'].toString();
        var height = data['user']['height'].toString();
        var weight = data['user']['weight'].toString();
        var activityLvl = data['user']['physical_activity_level'].toString();
        var getUserProfileStatus = data['user']['profile_status'];
        var userId = data['user']['id'].toString();

        print(
            "all data ======================...........................>>>>>>>>>>>>>>>$token ${gender + " " + name + " " + height + " " + activityLvl}");

        //saving token
        box.write(loginToken, token);
        box.write(loggedIn, true);
        var userSubscriptionStatus = await checkSubscriptionStatus();
        box.write(userName, name);
        box.write(userMobileNum, number);
        box.write(userEmail, email);
        box.write(userGender, gender);
        box.write(userID, userId);
        box.write(userWeight, weight);
        box.write(userHeight, height);
        box.write(userActivityLevel, activityLvl);
        box.write(isSubscribed, userSubscriptionStatus);
        box.write(msgCountDashboard, 0);

        getUserProfileStatus == 1
            ? box.write(userProfileStatus, true)
            : box.write(userProfileStatus, false);
        getUserProfileStatus == 1
            ? prefs.setBool(userProfileStatus, true)
            : prefs.setBool(userProfileStatus, false);
        var profileStatus = await box.read(userProfileStatus);

        print("token $token");
        stopLoading(context);

        ///** Stop Loading919598
        // Get.to(()=>userProfileStatus == 1 ?DashboardScreen() :SelectGender());
        emailCon.clear();
        passwordCon.clear();
        numberCon.clear();
        Get.offAll(
            () => getUserProfileStatus == 1
                ? userSubscriptionStatus
                    ? DashboardScreen()
                    : ProgramListScreen()
                : ProfilePicScreen(),
            arguments: ["store"]);
        // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
        //     builder: (context) =>getUserProfileStatus == 1 ? userSubscriptionStatus ? DashboardScreen() :SubscriptionScreen() : ProfilePicScreen()), (Route route) => false);
      } else if (response.statusCode == 422) {
        stopLoading(context);

        ///** Stop Loading

        var message = data['message'];
        GlobalAlert(context, "Oops!", "$message", DialogType.warning,
            onTap: () {});
      } else {
        stopLoading(context);

        ///** Stop Loading
        print(
            "in else --------------------------------> ${response.statusCode}");
      }
    } catch (e) {
      stopLoading(context);

      ///** Stop Loading
      print("error while login in -----------------------> $e");
    }
  }
}
