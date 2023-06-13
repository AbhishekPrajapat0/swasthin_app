import 'dart:convert';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart';
import '../../GlobalWidget/loading_widget.dart';
import '../../screens/UserDetails/ProfilePicScreen.dart';

import '../GlobalWidget/globalAlert.dart';
import '../contants/Constants.dart';

class VerifyOtpController extends GetxController {
  TextEditingController otpCon = TextEditingController();

  dynamic argumentData = Get.arguments;

  @override
  void onInit() {
    print("GOT DATA");
    print(argumentData[0]['email']);
    print(argumentData[0]['name']);
    super.onInit();
  }

  var countDownStarted = true.obs;
  GetStorage box = GetStorage();
  //Start Verification Process
  startVerifing(BuildContext context) async {
    var message = checkOtpProper();
    if (message == "success") {
      var otpCorrect = await verifyOtpApi();
      if (otpCorrect) {
        signUpApi(context);
      } else {
        GlobalAlert(context, "Wrong Otp",
            "Entered Otp Is Wrong, Please Check Again", DialogType.warning,
            onTap: () {});
      }
    } else {
      GlobalAlert(context, "Warning", message, DialogType.warning, onTap: () {
        print(" HHHHHH $message");
      });
    }
  }

  //function to check valid otp or not
  checkOtpProper() {
    if (otpCon.text.isEmpty) {
      return "OTP is Empty";
    } else if (otpCon.text.length < 6) {
      return "OTP Should be 6 Digit";
    } else {
      return "success";
    }
  }

//  function to verify Otp from Api
  verifyOtpApi() async {
    try {
      var number = argumentData[0]['mobile'];
      var url = Uri.parse(base_url + verifyOtpUrl);
      var data = {"mobile": "$number", "otp": "${otpCon.text}"};
      final response = await post(url, body: data);
      print(" Otp Verify response is ${response.statusCode} ${response.body}");
      if (response.statusCode == 200) {
        // response body
        var data = jsonDecode(response.body.toString());
        //  Otp is Correct Sign up User
        return true;
      } else if (response.statusCode == 422) {
        return false;
      } else {
        throw Exception();
      }
    } catch (e) {
      print("error is $e");
      throw Exception();
    }
  }

//  Signup Api

  Future<void> signUpApi(BuildContext context) async {
    var email = argumentData[0]['email'];
    var name = argumentData[0]['name'];
    var number = argumentData[0]['mobile'];
    var password = argumentData[0]['password'];
    var countryCode = argumentData[0]['country_code'];
    try {
      final fcmToken = await FirebaseMessaging.instance.getToken();
      print("fcm Login ========> $fcmToken");
      var device_type = Platform.operatingSystem;
      loadingWithText(context, "Please wait, Loading....");
      var url = Uri.parse(base_url + userSignUpUrl);
      var data = {
        "email": "$email",
        "mobile": "$number",
        "country_code": "+91",
        "name": "$name",
        "password": "$password",
        "device_type": "$device_type",
        "device_id": "$fcmToken"
      };
      final response = await post(url, body: data);
      print(" Sign Upresponse is ${response.statusCode} ${response.body}");
      if (response.statusCode == 200) {
        // response body
        var data = jsonDecode(response.body.toString());
        //token
        var token = data['data']['token'].toString();
        //saving token
        box.write(userName, name);
        box.write(loginToken, token);
        box.write(isSubscribed, false);
        box.write(loggedIn, true);
        box.write(userProfileStatus, false);
        print("token $token ${box.read(loggedIn)}");
        box.write(msgCountDashboard, 0);

        stopLoading(context);

        /// stops loading
        Get.off(() => ProfilePicScreen(), arguments: ["store"]);
      } else if (response.statusCode == 422) {
        stopLoading(context);

        /// stops loading
      } else {
        stopLoading(context);

        /// stops loading
        throw Exception();
      }
    } catch (e) {
      print("error is $e");
      throw Exception();
    }
  }
}
