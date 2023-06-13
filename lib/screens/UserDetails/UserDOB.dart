import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/shape/gf_button_shape.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Utlis/ApiUtlis.dart';
import '../../contants/Constants.dart';
import '../../contants/colors.dart';
import '../../contants/images.dart';
import '../../screens/UserDetails/MedicalConditionsScreen.dart';
import '../../screens/UserDetails/UserDOB.dart';
import '../../screens/UserDetails/UserGoal.dart';

import '../../GlobalWidget/CustomButton.dart';
import '../../GlobalWidget/customAppBars.dart';
import '../../GlobalWidget/loading_widget.dart';

class UserDOB extends StatefulWidget {
  const UserDOB({Key? key}) : super(key: key);

  @override
  State<UserDOB> createState() => _UserDOBState();
}

class _UserDOBState extends State<UserDOB> {
  GetStorage box = GetStorage();

  var date = DateTime.now();
  var formatedDate;

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
        physics: NeverScrollableScrollPhysics(),
        child: Center(
          child: Container(
            // color: Colors.red,
            padding: EdgeInsets.all(14),
            child: Column(
              children: [
                //heading text
                Container(
                  width: w * 0.8,
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      text: 'What is your ',
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                          fontSize: 25),
                      children: <TextSpan>[
                        TextSpan(
                            text: 'Date of Birth?',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, color: mainColor)),
                      ],
                    ),
                  ),
                ),
                Container(
                    margin: EdgeInsets.only(top: 18, bottom: 20),
                    width: w * 0.7,
                    child: Text(
                      "Scroll it to select your Date of Birth",
                      textAlign: TextAlign.center,
                    )),

                Container(
                  padding: EdgeInsets.only(top: 30),
                  height: h * 0.7,
                  // color: Colors.red,
                  child: Column(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: w * 0.3,
                          width: w,
                          child: CupertinoDatePicker(
                            maximumDate: DateTime.now(),
                            minimumYear: 1900,
                            initialDateTime: date,
                            mode: CupertinoDatePickerMode.date,
                            use24hFormat: true,
                            // This is called when the user changes the date.
                            onDateTimeChanged: (DateTime newDate) {
                              setState(() => date = newDate);
                              print(
                                  "date is ==============================>$date");
                            },
                          ),
                        )
                      ]),
                )
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
      onPressed: () async {
        final prefs = await SharedPreferences.getInstance();
        var age = calculateAge(date);
        print("age is $age");
        formatedDate = DateFormat('dd/MM/yyyy').format(date);
        box.write(userAge, "$age");
        box.write(userDOB, "$formatedDate");
        prefs.setString(userDOB, "$formatedDate");
        prefs.setString(userAge, "$age");
        Get.to(() => MedicalConditionsScreen(), arguments: ["store"]);
        // sendProfileDataToAPI();
      },
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 18),
    );
  }

  int calculateAge(DateTime date) {
    DateTime birthDate = DateTime(date.year, date.month,
        date.day); // replace with the person's actual birth date
    DateTime today = DateTime.now();

    int age = today.year - birthDate.year;

    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age;
    print('The person is $age years old.');
  }
}
