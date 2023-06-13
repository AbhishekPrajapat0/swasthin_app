import 'dart:async';
import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:getwidget/components/rating/gf_rating.dart';
import 'package:http/http.dart';

import '../../GlobalWidget/CustomButton.dart';
import '../../GlobalWidget/customAppBars.dart';
import '../../GlobalWidget/globalAlert.dart';
import '../../Utlis/globalFunctions.dart';
import '../../contants/Constants.dart';
import '../../contants/colors.dart';
import '../../contants/images.dart';
import '../Dashboard/DashboardScreen.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({Key? key}) : super(key: key);

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  double _rating = 0;

  TextEditingController feedBackComment = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return new WillPopScope(
      onWillPop: () async => true,
      child: new Scaffold(
        backgroundColor: Colors.white,
        appBar: appBarWithBack(context, showBack: true, title: "Feedback"),
        body: Padding(
          padding: EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image(
                  image: AssetImage(logo),
                  width: w / 1.5,
                ),
                SizedBox(
                  height: h * 0.03,
                ),
                Center(
                  child: GFRating(
                    value: _rating,
                    size: 50,
                    color: mainColor,
                    borderColor: mainColor,
                    onChanged: (value) {
                      setState(() {
                        _rating = value;
                      });
                    },
                  ),
                ),
                Padding(
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
                Padding(
                  padding:
                      const EdgeInsets.only(top: 18.0, bottom: 10, left: 8),
                  child: Align(
                    alignment: Alignment.topLeft,
                    // child: Text( 'How was your experience with the doctor?' ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25.0),
                  child: CustomButton(
                    text: "Submit",
                    onPressed: () {
                      var feedback = feedBackComment.text;
                      // if(feedback.isEmpty || feedback.length < 15){
                      //   GlobalAlertWarning(context, "Feedback Too Short", "Please Give Feedback in More Detail");
                      // } else{
                      print("in the submit eedback");
                      submitFeedBack(_rating, feedback, context);
                      // }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> submitFeedBack(
      double rating, String feedback, BuildContext context) async {
    try {
      GetStorage box = new GetStorage();
      var token = box.read('token');
      var doctorId = "SearchingDoctors.doctorId";
      var body;
      if (feedback.isEmpty || feedback == null) {
        body = {"doctor_id": doctorId, "ratings": rating.toString()};
      } else {
        body = {
          "doctor_id": doctorId,
          "comment": feedback,
          "ratings": rating.toString()
        };
      }

      print('This is Token $token $body');
      var response = await post(Uri.parse(base_url + feedbackUrl),
          body: body,
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json'
          });
      var responseData = await json.decode(response.body);

      print('response code is : ${response.statusCode} ${response.body}');
      if (response.statusCode == 200) {
        GlobalAlert(context, "Success", "Your Feedback has been submited",
            DialogType.success,
            onTap: () {});
        print('response code is done');
        Timer(Duration(seconds: 2), () {
          // Navigator.of(context).pop();
          // Navigator.of(context).pop();
          // go to next screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => DashboardScreen()),
          );
        });
      } else if (response.statusCode == 500) {
        GlobalAlert(
            context,
            "Server Error",
            "The server has encountered an Error, Please Restart the App",
            DialogType.warning,
            onTap: () {});
      } else if (response.statusCode == 401 || response.statusCode == 302) {
        SessionExpiredFun();
      }
    } catch (e) {
      print("this is exception" + e.toString());
    }
  }
}
