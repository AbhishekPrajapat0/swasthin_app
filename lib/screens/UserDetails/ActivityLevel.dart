import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/shape/gf_button_shape.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../contants/Constants.dart';
import '../../contants/colors.dart';
import '../../contants/images.dart';
import '../../screens/UserDetails/DietPrefScreen.dart';
import '../../screens/UserDetails/UserGoal.dart';

import '../../GlobalWidget/CustomButton.dart';
import '../../GlobalWidget/customAppBars.dart';
import '../../GlobalWidget/globalAlert.dart';
import '../../GlobalWidget/loading_widget.dart';
import '../../Utlis/ApiUtlis.dart';
import '../../Utlis/globalFunctions.dart';
import '../Profile/EditProfileScreen.dart';

class ActivityLevelScreen extends StatefulWidget {
  const ActivityLevelScreen({Key? key}) : super(key: key);

  @override
  State<ActivityLevelScreen> createState() => _ActivityLevelScreenState();
}

class _ActivityLevelScreenState extends State<ActivityLevelScreen> {
  dynamic argumentData = Get.arguments;
  List<bool> selected = [true, false, false];
  List<String> activityOptions = [
    "Mild",
    "Moderate",
    "Highly Active",
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
                            text: 'Physical Activity Level?',
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
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Mild",
                          style: TextStyle(
                              fontSize: w * 0.055,
                              fontWeight: FontWeight.w400,
                              color: selected[0] ? Colors.black : textMuted),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                            width: w * 0.45,
                            child: Text(
                              "if you are spending most of time sitting and doing no exercise.",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize: w * 0.027,
                                  fontWeight: FontWeight.w400,
                                  color:
                                      selected[0] ? Colors.black : textMuted),
                            )),
                      ],
                    ),
                  ),
                  Image.asset(
                    activityLow,
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Moderate",
                          style: TextStyle(
                              fontSize: w * 0.055,
                              fontWeight: FontWeight.w400,
                              color: selected[1] ? Colors.black : textMuted),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                            width: w * 0.45,
                            child: Text(
                              "If you do some type of Physical Activity",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize: w * 0.027,
                                  fontWeight: FontWeight.w400,
                                  color:
                                      selected[1] ? Colors.black : textMuted),
                            )),
                      ],
                    ),
                  ),
                  Image.asset(
                    activityMedium,
                    height: h * 0.11,
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Highly Active",
                          style: TextStyle(
                              fontSize: w * 0.055,
                              fontWeight: FontWeight.w400,
                              color: selected[2] ? Colors.black : textMuted),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                            width: w * 0.45,
                            child: Text(
                              "If you do a lot of Physical Activity",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize: w * 0.027,
                                  fontWeight: FontWeight.w400,
                                  color:
                                      selected[2] ? Colors.black : textMuted),
                            )),
                      ],
                    ),
                  ),
                  Image.asset(
                    activityHigh,
                    height: h * 0.11,
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
      print("activity lvl = ${activityOptions[index]}");
      box.write(userActivityLevel, activityOptions[index]);
      prefs.setString(userActivityLevel, activityOptions[index]);
      updateToAPI(activityOptions[index], context);
    } else {
      var index = selected.indexOf(true);
      print("activity lvl = ${activityOptions[index]}");
      box.write(userActivityLevel, activityOptions[index]);
      prefs.setString(userActivityLevel, activityOptions[index]);
      Get.to(() => DietPrefScreen(), arguments: ["store"]);
    }
  }

  updateToAPI(String activityLvl, BuildContext context) async {
    try {
      loadingWithText(context, "Please Wait Loading..");
      var url = Uri.parse(base_url + profileUpdateUrl);
      var data = {
        "physical_activity_level": "$activityLvl",
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
