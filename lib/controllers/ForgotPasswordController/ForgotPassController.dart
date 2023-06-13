import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';

import '../../GlobalWidget/globalAlert.dart';
import '../../GlobalWidget/loading_widget.dart';
import '../../contants/Constants.dart';
import '../../contants/messages.dart';
import '../../screens/ForgotPassword/ForgotPasswordVerifyScreen.dart';

class ForgotPassController extends GetxController {
  TextEditingController countryCodeCon = TextEditingController();
  TextEditingController numberCon = TextEditingController();

  @override
  void onInit() {
    super.onInit();
  }

  verify(BuildContext context) async {
    loadingWithText(context, "Please Wait Loading");
    var msg = validateEnteredDataWithNumber();
    if (msg == "success") {
      var userExist = await checkUserExist(numberCon.text);
      if (userExist) {
        sendOtp(context);
      } else {
        stopLoading(context);

        ///** Stop Loading
        GlobalAlert(context, "No User Found", noUserMsg, DialogType.warning,
            onTap: () {});
      }
    } else {
      stopLoading(context);

      ///** Stop Loading
      GlobalAlert(context, "Invalid Number", msg, DialogType.warning,
          onTap: () {});
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
    } else {
      return "success";
    }
  }

  Future<bool> checkUserExist(String text) async {
    try {
      var url = Uri.parse(base_url + checkUserPresenceUrl);
      var data = {"email_phone": "${text}"};
      final response = await post(url, body: data);
      print(" response is ${response.statusCode} ${response.body}");

      if (response.statusCode == 200) {
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
        Get.to(() => ForgotPassVerifyScreen(), arguments: [
          {"mobile": numberCon.text}
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
