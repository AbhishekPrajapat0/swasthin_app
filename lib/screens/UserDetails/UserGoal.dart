import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/shape/gf_button_shape.dart';
import '../../contants/Constants.dart';
import '../../contants/colors.dart';
import '../../contants/images.dart';
import '../../screens/UserDetails/DietPrefScreen.dart';

import '../../GlobalWidget/CustomButton.dart';
import '../../GlobalWidget/customAppBars.dart';

class UserGoalScreen extends StatefulWidget {
  const UserGoalScreen({Key? key}) : super(key: key);

  @override
  State<UserGoalScreen> createState() => _UserGoalScreenState();
}

class _UserGoalScreenState extends State<UserGoalScreen> {
  List<bool> selected = [true, false, false];
  List<String> goalsOptions = [
    "Lose Weight",
    "Gain Weight",
    "Stay Healthy",
  ];
  GetStorage box = GetStorage();

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
                      text: 'What is your',
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                          fontSize: 25),
                      children: const <TextSpan>[
                        TextSpan(
                            text: ' Goal?',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: kPrimaryGreen)),
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
      text: "Next",
      onPressed: () {
        var index = selected.indexOf(true);
        print("goal = ${goalsOptions[index]}");
        print("select is $index ");
        box.write(userGoal, goalsOptions[index]);
        Get.to(() => DietPrefScreen());
      },
      padding: EdgeInsets.symmetric(horizontal: 30),
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
                color: selected[0] ? kSelectedGreen : mutedColor,
                border: Border.all(
                    color: selected[0] ? kSelectedGreen : mutedColor,
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
                      goalsOptions[0],
                      style: TextStyle(
                          fontSize: w * 0.04,
                          fontWeight: FontWeight.w400,
                          color: selected[0] ? Colors.black : textMuted),
                    ),
                  ),
                  Image.asset(
                    goalLoseFat,
                    height: h * 0.08,
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
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            decoration: BoxDecoration(
                color: selected[1] ? kSelectedGreen : mutedColor,
                border: Border.all(
                    color: selected[1] ? kSelectedGreen : mutedColor,
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
                      goalsOptions[1],
                      style: TextStyle(
                          fontSize: w * 0.04,
                          fontWeight: FontWeight.w400,
                          color: selected[1] ? Colors.black : textMuted),
                    ),
                  ),
                  Image.asset(
                    goalGainWeight,
                    height: h * 0.08,
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
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            decoration: BoxDecoration(
                color: selected[2] ? kSelectedGreen : mutedColor,
                border: Border.all(
                    color: selected[2] ? kSelectedGreen : mutedColor,
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
                      goalsOptions[2],
                      style: TextStyle(
                          fontSize: w * 0.04,
                          fontWeight: FontWeight.w400,
                          color: selected[2] ? Colors.black : textMuted),
                    ),
                  ),
                  Image.asset(
                    goalStayHealthy,
                    height: h * 0.08,
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
