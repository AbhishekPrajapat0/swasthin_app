import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart';
import 'package:info_popup/info_popup.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../contants/Constants.dart';
import '../../contants/colors.dart';
import '../../screens/UserDetails/UploadReportScreen.dart';

import '../../GlobalWidget/CustomButton.dart';
import '../../GlobalWidget/customAppBars.dart';
import '../../GlobalWidget/globalAlert.dart';
import '../../GlobalWidget/loading_widget.dart';
import '../../Utlis/ApiUtlis.dart';
import '../../Utlis/globalFunctions.dart';

class MedicalConditionsScreen extends StatefulWidget {
  const MedicalConditionsScreen({Key? key}) : super(key: key);

  @override
  State<MedicalConditionsScreen> createState() =>
      _MedicalConditionsScreenState();
}

class _MedicalConditionsScreenState extends State<MedicalConditionsScreen> {
  List<String> selected = [];
  List<int>? allergiesIDList = [];
  List<int>? finalSymptomsIds = [];
  List<String>? allergiesNameList = [];
  var allergiesLoaded = false;
  TextEditingController medicalConditions = TextEditingController();

  GetStorage box = GetStorage();

  @override
  void initState() {
    getAllergiesList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar:
          appBarWithBack(context, showBack: true, title: "Medical Conditions"),
      bottomNavigationBar: bottomNavigationButton(context),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8, top: 5.0, bottom: 12),
                child: const Text('Select Allergies you have',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 15)),
              ),
              Container(
                  height: h * 0.4,
                  width: w,
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    // boxShadow: [
                    //   BoxShadow(
                    //     color: Colors.grey.shade300,
                    //     blurRadius: 10.0,
                    //     spreadRadius: 2.0,
                    //     offset:
                    //         Offset(1.0, 1.0), // shadow direction: bottom right
                    //   )
                    // ],
                  ),
                  child: allergiesLoaded
                      ? getList()
                      : Center(child: const Text("Loading Please Wait.."))),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 8, top: 25.0, bottom: 2),
                    child: const Text('Medical Conditions',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 15)),
                  ),
                  getinfoIcon()
                ],
              ),
              getCommentWidget(),
              Padding(
                padding: const EdgeInsets.only(top: 28.0),
                child: InkWell(
                  onTap: () {},
                  child: RichText(
                    textAlign: TextAlign.start,
                    text: TextSpan(
                      text: 'Note: ',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                      children: const <TextSpan>[
                        TextSpan(
                            text:
                                'If you are suffering from multiple medical conditions, please mention all seprate them by comma',
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Colors.black,
                            )),
                        TextSpan(text: "  ( , )")
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> getAllergiesList() async {
    var response =
        await get(Uri.parse(base_url + allergiesListUrl), headers: getHeader());
    var data = jsonDecode(response.body);
    print(" getting AlergiesList} ${response.statusCode}==> ${response.body}");
    if (response.statusCode == 200) {
      var Symptoms = data['message'];
      print(" getting ====> $Symptoms");
      for (var i = 0; i < Symptoms.length; i++) {
        allergiesIDList?.add(Symptoms[i]['id']);
        allergiesNameList?.add(Symptoms[i]['name']);
        print("${Symptoms[i]['id']} in Loop ${allergiesIDList}");
      }
      print("${allergiesIDList!} after Loop ${allergiesNameList!}");
      setState(() {
        allergiesLoaded = true;
      });
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
    }
  }

  getList() {
    return ListView.builder(
      itemCount: allergiesNameList!.length,
      itemBuilder: (context, index) {
        return CheckboxListTile(
          title: Container(
            // color: Colors.grey.shade100,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                allergiesNameList![index],
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 14),
              ),
            ),
          ),
          value: selected.contains(allergiesNameList![index]),
          onChanged: (value) {
            setState(() {
              if (value!) {
                selected.add(allergiesNameList![index]);
              } else {
                selected.remove(allergiesNameList![index]);
              }
              print("selected $selected");
            });
          },
        );
      },
    );
  }

  getCommentWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 5),
      child: OutlinedButton(
        onPressed: null,
        style: ButtonStyle(
          shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0))),
        ),
        child: TextField(
          controller: medicalConditions,
          decoration: const InputDecoration(
              helperText: ' ',
              border: InputBorder.none,
              hintText: 'Please Mention your Medical Condition ',
              hintStyle: TextStyle(
                  color: textExtraMuted, fontWeight: FontWeight.w400)),
          keyboardType: TextInputType.multiline,
          minLines: 1,
          // <-- SEE HERE
          maxLines: 4, // <-- SEE HERE
        ),
      ),
    );
  }

  bottomNavigationButton(BuildContext context) {
    return CustomButton(
      text: "Submit",
      onPressed: () {
        // box.write(userDietPref,"$date");
        // Get.to(() => DashboardScreen());

        for (var i = 0; i < selected.length; i++) {
          var index = allergiesNameList!.indexOf(selected[i]);
          finalSymptomsIds!.add(allergiesIDList![index]);
        }
        print(" Submit $finalSymptomsIds");
        var medicalCondtion = medicalConditions.text.trim();
        if (medicalCondtion.length == 0) {
          GlobalAlert(
              context,
              "Medical Condition is Empty!",
              "Please Mention your Medical Condition If you Have any or Healthy if don't have any",
              DialogType.warning,
              onTap: () {},
              padding: EdgeInsets.all(12));
        } else {
          sendProfileDataToAPI(finalSymptomsIds!);
        }
      },
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
    );
  }

  getinfoIcon() {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return InfoPopupWidget(
      customContent: Container(
        width: w,
        decoration: BoxDecoration(
          color: Colors.blueGrey,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          children: const <Widget>[
            Text(
                "Please Mention your Medical Condition If you Have any or Healthy if don't have any",
                style: TextStyle(
                  color: Colors.white,
                ))
          ],
        ),
      ),
      arrowTheme: const InfoPopupArrowTheme(
        color: Colors.black54,
        arrowDirection: ArrowDirection.up,
      ),
      dismissTriggerBehavior: PopupDismissTriggerBehavior.anyWhere,
      areaBackgroundColor: Colors.transparent,
      indicatorOffset: Offset.zero,
      contentOffset: Offset.zero,
      onControllerCreated: (controller) {
        print('Info Popup Controller Created');
      },
      onAreaPressed: (InfoPopupController controller) {
        print('Area Pressed');
      },
      infoPopupDismissed: () {
        print('Info Popup Dismissed');
      },
      onLayoutMounted: (Size size) {
        print('Info Popup Layout Mounted');
      },
      child: Icon(
        Icons.info,
        color: Colors.black54,
      ),
    );
  }

  sendProfileDataToAPI(List<int> list) async {
    loadingWithText(context, "Please wait, Loading....");
    final prefs = await SharedPreferences.getInstance();
    var allergies = list.toString().substring(1, list.toString().length - 1);
    print(
        "alergies ==========================================================================================================>>>>>>>>>>>>>>>>>>>>>>> $allergies $list");
    var gender = box.read(userGender) ?? prefs.getString(userGender);
    var weight = box.read(userWeight) ?? prefs.getString(userWeight);
    var height = box.read(userHeight) ?? prefs.getString(userHeight);
    var activtyLevel =
        box.read(userActivityLevel) ?? prefs.getString(userActivityLevel);
    // var goal = box.read(userGoal) ?? prefs.getString(userGoal);
    var dietPref = box.read(userDietPref) ?? prefs.getString(userDietPref);
    var dob = box.read(userDOB) ?? prefs.getString(userDOB);
    var age = box.read(userAge) ?? prefs.getString(userAge);
    try {
      print(
          "sending data to API $gender $weight $height $activtyLevel $dietPref $dob $age");
      var url = Uri.parse(base_url + profileUpdateUrl);
      var data = {
        "dob": "$dob",
        "height": "$height",
        "weight": "$weight",
        "physical_activity_level": "$activtyLevel",
        "medical_conditions": medicalConditions.text,
        "allergy_id": allergies,
        "diet_preferences": "$dietPref",
        "gender": "$gender",
        // "goal":"$goal",
        "age": "$age"
      };
      var header = getHeader();
      final response = await post(url, body: data, headers: header);
      print(" Sumity response is ${response.statusCode} ${response.body}");
      if (response.statusCode == 200) {
        finalSymptomsIds!.clear();
        // response body
        var data = jsonDecode(response.body.toString());

        stopLoading(context);

        ///** Stop Loading919598
        await box.write(userProfileStatus, true);
        prefs.setBool(userProfileStatus, true);

        var subscribed = box.read(isSubscribed);
        print("profile complete ${box.read(userProfileStatus)} $subscribed");
        stopLoading(context);

        /// stops loading
        Get.offAll(() => UploadReportScreen());
      } else if (response.statusCode == 422) {
        stopLoading(context);

        ///** Stop Loading
      } else if (response.statusCode == 500) {
        GlobalAlert(
            context,
            "Server Error",
            "The server has encountered an Error, Please Restart the App",
            DialogType.warning);
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
