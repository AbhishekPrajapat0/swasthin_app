import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../contants/Constants.dart';
import '../../screens/UserDetails/WeightScreen.dart';

import '../../GlobalWidget/CustomButton.dart';
import '../../GlobalWidget/customAppBars.dart';
import '../../contants/colors.dart';
import '../../contants/images.dart';

class SelectGender extends StatefulWidget {
  const SelectGender({Key? key}) : super(key: key);

  @override
  State<SelectGender> createState() => _SelectGenderState();
}

class _SelectGenderState extends State<SelectGender> {
  List<bool> selected = [true, false, false, false];
  List<String> gendersOptions = [
    "Male",
    "Female",
    "Other",
    "Prefer Not to Say"
  ];

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: bottomNavigationButton(context),
      appBar: appBarWithBack(
        context,
        showBack: false,
        title: "Gender",
      ),
      body: SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.all(10),
            width: w * 1,
            // color: Colors.red,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Please, Select your Gender",
                  style: TextStyle(color: textMuted),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    getGendersBox(
                      context,
                      maleIcon,
                    ),
                  ],
                )
              ],
            )),
      ),
    );
  }

  getGendersBox(
    BuildContext context,
    String icon,
  ) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return SizedBox(
      // color: Colors.red,
      width: w * 0.9,
      height: h * 0.5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              //Male
              InkWell(
                onTap: () {
                  setState(() {
                    selected = [true, false, false, false];
                  });
                },
                child: Container(
                  height: h * 0.20,
                  width: w * 0.4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.grey[100],
                    border: Border.all(
                      color: selected[0] ? mainColor : Colors.grey.shade500,
                      width: selected[0] ? 1.0 : 0.1,
                    ),
                  ),
                  child: Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 28.0),
                        child: Text("Male"),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            selected = [true, false, false, false];
                          });
                        },
                        child: Image.asset(
                          maleIcon,
                          height: h * 0.12,
                          width: h * 0.10,
                        ),
                      ),
                    ],
                  )), // your child widget here
                ),
              ),
              InkWell(
                onTap: () {
                  print("IN WOEMN");
                  setState(() {
                    selected = [false, true, false, false];
                  });
                },
                child: Container(
                  height: h * 0.20,
                  width: w * 0.4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.grey[100],
                    border: Border.all(
                      color: selected[1] ? mainColor : Colors.grey.shade500,
                      width: selected[1] ? 1.0 : 0.1,
                    ),
                  ),
                  child: Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 28.0),
                        child: Text("Female"),
                      ),
                      InkWell(
                        onTap: () {
                          print("IN WOEMN ${selected[1]}");
                          setState(() {
                            selected = [false, true, false, false];
                          });
                        },
                        child: Image.asset(
                          femaleIcon,
                          height: h * 0.12,
                          width: h * 0.10,
                        ),
                      ),
                    ],
                  )), // your child widget here
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () {
                  print("IN WOEMN ${selected[2]}");
                  setState(() {
                    selected = [false, false, true, false];
                  });
                },
                child: Container(
                  height: h * 0.20,
                  width: w * 0.4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.grey[100],
                    border: Border.all(
                      color: selected[2] ? mainColor : Colors.grey.shade500,
                      width: selected[2] ? 1.0 : 0.1,
                    ),
                  ),
                  child: Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 28.0),
                        child: Text("Other"),
                      ),
                      Image.asset(
                        otherGenderIcon,
                        height: h * 0.12,
                        width: h * 0.10,
                      ),
                    ],
                  )), // your child widget here
                ),
              ),
              InkWell(
                onTap: () {
                  print("IN WOEMN ${selected[2]}");
                  setState(() {
                    selected = [false, false, false, true];
                  });
                },
                child: Container(
                  height: h * 0.20,
                  width: w * 0.4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.grey[100],
                    border: Border.all(
                      color: selected[3] ? mainColor : Colors.grey.shade500,
                      width: selected[3] ? 1.0 : 0.1,
                    ),
                  ),
                  child: Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 28.0),
                        child: Text(
                          "Prefer Not \nto Say",
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Image.asset(
                        noIcon,
                        height: h * 0.12,
                        width: h * 0.10,
                      ),
                    ],
                  )), // your child widget here
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  bottomNavigationButton(BuildContext context) {
    return CustomButton(
      text: "Next",
      onPressed: () async {
        GetStorage box = GetStorage();
        final prefs = await SharedPreferences.getInstance();
        var index = selected.indexOf(true);
        print("gender = ${gendersOptions[index]}");
        box.write(userGender, gendersOptions[index]);
        prefs.setString(userGender, gendersOptions[index]);
        Get.to(() => WeightScreen(), arguments: ["store"]);
      },
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 18),
    );
  }
}
