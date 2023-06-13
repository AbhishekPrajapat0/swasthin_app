import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/shape/gf_button_shape.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Utlis/ApiUtlis.dart';
import '../../contants/Constants.dart';
import '../../contants/colors.dart';
import '../../contants/images.dart';
import '../../screens/UserDetails/UserDOB.dart';
import '../../screens/UserDetails/UserGoal.dart';

import '../../GlobalWidget/CustomButton.dart';
import '../../GlobalWidget/customAppBars.dart';
import '../../GlobalWidget/globalAlert.dart';
import '../../GlobalWidget/loading_widget.dart';
import '../../Utlis/globalFunctions.dart';
import '../Profile/EditProfileScreen.dart';

class DietPrefScreen extends StatefulWidget {
  const DietPrefScreen({Key? key}) : super(key: key);

  @override
  State<DietPrefScreen> createState() => _DietPrefScreenState();
}

class _DietPrefScreenState extends State<DietPrefScreen> {
  dynamic argumentData = Get.arguments;
  List<bool> selected = [true, false, false];
  List<String> dietOptions = [
    "Vegetarian",
    "Non-Vegetarian",
    "Vegan",
  ];
  GetStorage box = GetStorage();
  var buttonText = "Next";

  @override
  void initState() {
    buttonText = argumentData[0].toString() == "edit" ? "Update" : "Next";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBarWithBack(
        context,
        showBack: true,
      ),
      bottomNavigationBar: bottomNavigationButton(context),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            // color: Colors.red,
            padding: EdgeInsets.all(14),
            child: Column(
              children: [
                //heading text
                Container(
                  width: w * 0.7,
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: 'What is your ',
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                          fontSize: 25),
                      children: const <TextSpan>[
                        TextSpan(
                            text: 'Diet Preferences?',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, color: mainColor)),
                      ],
                    ),
                  ),
                ),
                Container(
                    margin: EdgeInsets.only(top: 18, bottom: 40),
                    width: w * 0.6,
                    child: Text(
                      "We will use this data to give you a better diet type for you",
                      textAlign: TextAlign.center,
                    )),
                listOfOptions(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bottomNavigationButton(BuildContext context) {
    return CustomButton(
      text: buttonText,
      onPressed: () {
        startUpdate();
      },
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 18),
    );
  }

  listOfOptions(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return Column(
      children: [
        InkWell(
          onTap: () {
            setState(() {
              selected = [true, false, false];
            });
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            decoration: BoxDecoration(
                color: selected[0] ? selectedColor : mutedColor,
                border: Border.all(
                    color: selected[0] ? selectedColor : mutedColor,
                    width: 0.00),
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Container(
              padding: EdgeInsets.all(18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 18.0),
                    child: Text(
                      dietOptions[0],
                      style: TextStyle(
                          fontSize: w * 0.04,
                          fontWeight: FontWeight.w400,
                          color: selected[0] ? Colors.black : textMuted),
                    ),
                  ),
                  Image.asset(
                    vegFoodIcon,
                    height: h * 0.11,
                  )
                ],
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () {
            setState(() {
              selected = [false, true, false];
            });
          },
          child: Container(
            height: h * 0.15,
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            decoration: BoxDecoration(
                color: selected[1] ? selectedColor : mutedColor,
                border: Border.all(
                    color: selected[1] ? selectedColor : mutedColor,
                    width: 0.00),
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Container(
              padding: EdgeInsets.all(18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 18.0),
                    child: Text(
                      dietOptions[1],
                      style: TextStyle(
                          fontSize: w * 0.04,
                          fontWeight: FontWeight.w400,
                          color: selected[1] ? Colors.black : textMuted),
                    ),
                  ),
                  Image.asset(
                    nonVegFoodIcon,
                    height: h * 0.10,
                  )
                ],
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () {
            print(" now ${selected[2]}");
            setState(() {
              selected = [false, false, true];
            });
          },
          child: Container(
            height: h * 0.15,
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            decoration: BoxDecoration(
                color: selected[2] ? selectedColor : mutedColor,
                border: Border.all(
                    color: selected[2] ? selectedColor : mutedColor,
                    width: 0.00),
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Container(
              padding: EdgeInsets.all(18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 18.0),
                    child: Text(
                      dietOptions[2],
                      style: TextStyle(
                          fontSize: w * 0.04,
                          fontWeight: FontWeight.w400,
                          color: selected[2] ? Colors.black : textMuted),
                    ),
                  ),
                  Image.asset(
                    veganFoodIcon,
                    height: h * 0.10,
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> startUpdate() async {
    final prefs = await SharedPreferences.getInstance();
    var data = argumentData[0];
    bool update = argumentData[0].toString() == 'edit' ? true : false;
    print(" clicked ${data} $update");

    if (update) {
      var index = selected.indexOf(true);
      print("gender = ${dietOptions[index]}");
      box.write(userDietPref, dietOptions[index]);
      prefs.setString(userDietPref, dietOptions[index]);
      updateToAPI(dietOptions[index], context);
    } else {
      var index = selected.indexOf(true);
      print("gender = ${dietOptions[index]}");
      box.write(userDietPref, dietOptions[index]);
      prefs.setString(userDietPref, dietOptions[index]);
      Get.to(() => UserDOB(), arguments: ["store"]);
    }
  }

  updateToAPI(String diet_preferences, BuildContext context) async {
    try {
      loadingWithText(context, "Please Wait Loading..");
      var url = Uri.parse(base_url + profileUpdateUrl);
      var data = {
        "diet_preferences": "$diet_preferences",
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
        Navigator.pop(context);

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
