import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../GlobalWidget/customAppBars.dart';
import '../../contants/colors.dart';
import '../../controllers/DietDetailsControllers/DietSubmittedFeedbackController.dart';

class DietSubmittedFeedback extends GetView<DietSubmittedFeedbackController> {
  final DietSubmittedFeedbackController controller =
      Get.put(DietSubmittedFeedbackController());

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: kPrimaryWhite,
      appBar: appBarWithBack(
        context,
        showBack: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Container(
                width: w * 0.9,
                margin: EdgeInsets.only(top: 20, bottom: 4),
                // color: kPrimaryGreen,
                child: Text(
                  "Did you Follow the Diet Plan?",
                  style: TextStyle(
                      color: kPrimaryBlack,
                      fontWeight: FontWeight.w400,
                      fontSize: w * 0.055),
                ),
              ),
              Container(
                width: w * 0.9,
                margin: EdgeInsets.only(top: 4, bottom: 20),
                // color: kPrimaryGreen,
                child: Text(
                  "This is the data that you have submitted",
                  style: TextStyle(
                      color: textMuted,
                      fontWeight: FontWeight.w400,
                      fontSize: w * 0.035),
                ),
              ),
              Container(
                // height: h*0.5,
                child: getListfoodList(context),
              ),
              SizedBox(
                height: h * 0.015,
              ),
              Divider(),
              Container(
                  margin: EdgeInsets.only(top: h * 0.015, left: w * 0.012),
                  width: w,
                  // color: mainColor,
                  child: Text(
                    "Comment",
                    style: TextStyle(color: textMuted),
                  )),
              Container(
                // margin: EdgeInsets.all(10),
                child: getCommentWidget(context),
              )
            ],
          ),
        ),
      ),
    );
  }

  getListfoodList(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount:
            controller.listModel.dietData![controller.index].foods!.length,
        itemBuilder: (BuildContext context, int i) {
          var data = controller.listModel.dietData![controller.index].foods![i];
          return Container(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 12),
            margin: EdgeInsets.symmetric(vertical: 5),
            width: w,
            height: 50,
            decoration: BoxDecoration(
              color: plansBgColor,
              border: Border.all(
                color: plansBorderColor, // set border color
                width: 0.50, // set border width
              ),
              borderRadius: BorderRadius.circular(10.0), // set border radius
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    width: w * 0.6,
                    // color: mainColor,
                    child: Text("${data.foodName}")),
                Container(
                  width: w * 0.2,
                  // color: mainColor,
                  child: Text(
                    "${data.consent}",
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
          );
        });
  }

  getCommentWidget(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 5),
      child: Container(
        width: w * 09,
        // height: h/5,
        margin: const EdgeInsets.symmetric(vertical: 2),
        padding: const EdgeInsets.symmetric(vertical: 2),
        decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(10)),

        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
          child: TextField(
            enabled: false,
            controller: controller.feedbackCon,
            decoration: InputDecoration(
                helperText: ' ',
                border: InputBorder.none,
                hintText: 'If No, Please Mention why?',
                hintStyle:
                    TextStyle(color: kHintText, fontWeight: FontWeight.w400)),
            keyboardType: TextInputType.multiline,
            minLines: 1, // <-- SEE HERE
            maxLines: 6, // <-- SEE HERE
          ),
        ),
      ),
    );
  }
}
