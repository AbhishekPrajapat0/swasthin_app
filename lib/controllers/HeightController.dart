import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../screens/UserDetails/ActivityLevel.dart';

import '../GlobalWidget/globalAlert.dart';
import '../GlobalWidget/loading_widget.dart';
import '../Utlis/ApiUtlis.dart';
import '../Utlis/globalFunctions.dart';
import '../contants/Constants.dart';

class HeightController extends GetxController {
  dynamic argumentData = Get.arguments;
  var selectedHeight = 80.obs;
  var heightUnit = 0.obs;

  var heightft = 0.obs;
  var heightInch = 0.obs;
  GetStorage box = GetStorage();
  var buttonText = "Next".obs;

  @override
  void onInit() {
    buttonText.value = argumentData[0].toString() == "edit" ? "Update" : "Next";
    super.onInit();
  }

  selectHeightStateChange(int index) {
    selectedHeight.value = index + 30;
  }

  int feetToCm(double feet) {
    var cm = feet * 30.48;
    return cm.floor();
  }

  double lbsToKg(double lbs) {
    var kg = lbs / 2.2046;
    var twoDigit = kg.toStringAsFixed(2);
    return double.parse(twoDigit);
  }

  goToNextScreen(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    var data = argumentData[0];
    bool update = argumentData[0].toString() == 'edit' ? true : false;
    print(" clicked ${data} $update");

    if (update) {
      int ft = heightft.value;
      int inch = heightInch.value;
      var ftInch = "$ft.$inch";
      double newHeight = double.parse(ftInch);
      var finalHeight =
          heightUnit == 0 ? selectedHeight.value : feetToCm(newHeight);
      box.write(userHeight, finalHeight.toString());
      prefs.setString(userHeight, finalHeight.toString());
      print("Go to height $selectedHeight , $heightUnit, $finalHeight");
      updateToAPI(finalHeight, context);
    } else {
      int ft = heightft.value;
      int inch = heightInch.value;
      var ftInch = "$ft.$inch";
      double newHeight = double.parse(ftInch);
      var finalHeight =
          heightUnit == 0 ? selectedHeight.value : feetToCm(newHeight);
      print("Go to height $selectedHeight , $heightUnit, $finalHeight");
      box.write(userHeight, finalHeight.toString());
      prefs.setString(userHeight, finalHeight.toString());
      Get.to(() => ActivityLevelScreen(), arguments: ["store"]);
    }
  }

  updateToAPI(Object finalHeight, BuildContext context) async {
    try {
      loadingWithText(context, "Please Wait, Loading...");
      var url = Uri.parse(base_url + profileUpdateUrl);
      var data = {
        "height": "$finalHeight",
      };
      var header = getHeader();
      final response = await post(url, body: data, headers: header);
      print(
          " Updating Height response ====>  ${response.statusCode} ${response.body}");
      if (response.statusCode == 200) {
        // response body
        var data = jsonDecode(response.body.toString());

        stopLoading(context);

        ///** Stop Loading919598
        // Get.to(()=>EditProfileScreen());
        Navigator.pop(context, true);

        /// go back screen
      } else if (response.statusCode == 422) {
        stopLoading(context);

        ///** Stop Loading
      } else if (response.statusCode == 500) {
        GlobalAlert(
            context,
            "Server Error",
            "The server has encountered an Error, Please Restart the App",
            DialogType.warning,
            onTap: () {});
      } else if (response.statusCode == 401 ||
          response.statusCode == 302 ||
          response.statusCode == 403) {
        SessionExpiredFun();
      } else {
        stopLoading(context);

        ///** Stop Loading
        throw Exception();
      }
    } catch (e) {
      stopLoading(context);

      ///** Stop Loading
      print("error is $e");
      throw Exception();
    }
  }
}
