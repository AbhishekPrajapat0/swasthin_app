import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/rating/gf_rating.dart';
import 'package:http/http.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../GlobalWidget/globalAlert.dart';
import '../../Utlis/ApiUtlis.dart';
import '../../Utlis/globalFunctions.dart';
import '../../contants/Constants.dart';
import '../../contants/colors.dart';
import '../../screens/Dashboard/DashboardScreen.dart';

class AppointmentDetailsController extends GetxController {
  var dataLoaded = false.obs;
  dynamic arguments = Get.arguments;
  var _rating = 0.0.obs;
  var ratingShow = 0.0.obs;
  var data;
  var showRatingOpt = true.obs;

  TextEditingController zoomLinkCon = TextEditingController();

  Future<void> launchZoom() async {
    String url = zoomLinkCon.text;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  giveFeedback(BuildContext context) {
    Future.delayed(Duration.zero, () {
      Get.defaultDialog(
        barrierDismissible: true,
        titlePadding: EdgeInsets.only(top: 20),
        title: "Give Feedback",
        content: Container(
          width: Get.width,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 12, right: 12, bottom: 12),
                child: Divider(),
              ),
              Center(
                child: Wrap(
                  spacing: 8,
                  children: [
                    Center(
                      child: Obx(() => GFRating(
                            value: _rating.value,
                            size: 50,
                            color: mainColor,
                            borderColor: mainColor,
                            onChanged: (value) {
                              _rating.value = value;
                            },
                          )),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 18.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(5)),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text(
                              'Please Share your Valuable Feedback',
                              style: TextStyle(fontSize: 13),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: InkWell(
                          onTap: () {
                            submitFeedbackApi(context);
                          },
                          child: Container(
                            margin: EdgeInsets.all(12),
                            child: Center(
                                child: Text(
                              "Submit",
                              style: TextStyle(color: Colors.white),
                            )),
                            color: mainColor,
                            height: 50,
                            width: Get.width,
                          )),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  @override
  void onInit() {
    getDetails();
    super.onInit();
  }

  void getDetails() {
    data = arguments[0]["data"];
    zoomLinkCon.text = data.meetingLink ?? 'No meeting Link Available';
    print("==================================================${data}");
    if (data.staffrating != null) {
      showRatingOpt.value = false;
      if (data.staffrating.rating != null) {
        ratingShow.value = double.parse(data.staffrating.rating);
        showRatingOpt.value = false;
      }
    }
    dataLoaded.value = true;
  }

  Future<void> submitFeedbackApi(BuildContext context) async {
    try {
      var header = getHeader();
      var body = {
        "staff_id": data.staffId.toString(),
        "appointment_id": data.id.toString(),
        // "comment":"Good",
        "rating": "${_rating.value}"
      };
      var uri = Uri.parse(base_url + feedbackUrl);
      var response = await post(uri, headers: header, body: body);
      print(
          "submitting feedback =====> ${response.statusCode} ${response.body}");
      if (response.statusCode == 200) {
        print("Feedback is submitted >>>>>>>>>>>>>>>");
        Navigator.pop(context); // pop Dialog
        GlobalAlert(context, "Feedback Submitted",
            "Thank for Giving your Valuable Feedback", DialogType.success,
            onTap: () {});
        Timer(Duration(seconds: 3), () {
          Get.offAll(() => DashboardScreen());
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
    } catch (e) {
      print("Submitting Feedback $e");
    }
  }
}
