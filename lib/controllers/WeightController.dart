import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../contants/Constants.dart';

import '../GlobalWidget/globalAlert.dart';
import '../GlobalWidget/loading_widget.dart';
import '../Utlis/ApiUtlis.dart';
import '../Utlis/globalFunctions.dart';
import '../screens/UserDetails/HeightScreen.dart';

class WeightController extends GetxController {
  dynamic argumentData = Get.arguments;
  var selectedWeight = 20.0.obs;
  var weightUnit = 0.obs;
  var buttonText = "Next".obs;

  @override
  void onInit() {
    buttonText.value = argumentData[0].toString() == "edit" ? "Update" : "Next";
    super.onInit();
  }

  GetStorage box = GetStorage();

  selectWeightStateChange(int index) {
    selectedWeight.value = index + 30;
  }

  goToHeightFun(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    var data = argumentData[0];
    bool update = argumentData[0].toString() == 'edit' ? true : false;
    print(" clicked ${data} $update");
    if (update) {
      double newWeight = selectedWeight.value + 0.0;
      var finalWeight =
          weightUnit == 0 ? selectedWeight.value : lbsToKg(newWeight);
      print(" clicked ${data} $update $finalWeight");
      box.write(userWeight, finalWeight);
      prefs.setString(userWeight, finalWeight.toString());
      updateToAPI(finalWeight, context).then((val) {
        if (val != null) {
          return true;
        }
      });
    } else {
      double newWeight = selectedWeight.value + 0.0;
      var finalWeight =
          weightUnit == 0 ? selectedWeight.value : lbsToKg(newWeight);
      print("Go to Hefgt $selectedWeight , $weightUnit, $finalWeight");
      box.write(userWeight, finalWeight);
      prefs.setString(userWeight, finalWeight.toString());
      Get.to(() => HeightScreen(), arguments: ["store"]);
    }
  }

  double lbsToKg(double lbs) {
    var kg = lbs / 2.2046;
    var twoDigit = kg.toStringAsFixed(2);
    return double.parse(twoDigit);
  }

  updateToAPI(Object finalWeight, BuildContext context) async {
    try {
      loadingWithText(context, "Please Wait Loading..");
      var url = Uri.parse(base_url + profileUpdateUrl);
      var data = {
        "weight": "$finalWeight",
      };
      var header = getHeader();
      final response = await post(url, body: data, headers: header);
      print(
          " Updating Weight response ====>  ${response.statusCode} ${response.body}");
      if (response.statusCode == 200) {
        // response body
        var data = jsonDecode(response.body.toString());

        stopLoading(context);

        ///** Stop Loading919598
        // Get.to(()=>EditProfileScreen());
        Navigator.pop(context);
        return true;

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
