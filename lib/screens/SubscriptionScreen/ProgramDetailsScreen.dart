import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart';
import '../../GlobalWidget/customAppBars.dart';
import '../../Models/SubscriptionPlans/ProgramListModel.dart';
import '../../contants/colors.dart';
import '../../controllers/Subscription%20Plans/Program/ProgramController.dart';
import '../../screens/SubscriptionScreen/SubscriptionScreen.dart';

import '../../GlobalWidget/CustomButton.dart';

class ProgramDetailsScreen extends GetView<ProgramController> {
  final ProgramController programController = Get.put(ProgramController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: bottomNavigationButton(context),
      appBar: appBarWithBack(context, showBack: true, title: "Program Details"),
      body: Obx(() => programController.dataLoaded.value
          ? showDetails(context)
          : Center(
              child: CircularProgressIndicator(),
            )),
    );
  }

  bottomNavigationButton(BuildContext context) {
    return CustomButton(
      text: "Next",
      onPressed: () async {
        Get.offAll(() => SubscriptionScreen());
      },
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 18),
    );
  }

  showDetails(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return ListView.builder(
      itemCount: programController.selectedOnes.length,
      itemBuilder: (BuildContext context, int index) {
        var data = programController.selectedOnes[index];
        var image = data.image;
        var program = data.program;
        var desc = data.description;
        return Container(
          padding: EdgeInsets.all(15),
          margin: EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: plansBgColor,
            border: Border.all(
              color: plansBorderColor, // set border color
              width: 0.50, // set border width
            ),
            borderRadius: BorderRadius.circular(10.0), // set border radius
          ),
          // height: h,
          width: w,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: w * 0.85,
                child: Image.network("$image"),
              ),
              Divider(),
              Container(
                  width: w * 0.85,
                  margin: EdgeInsets.only(bottom: 10),
                  child: Text(
                    '$program',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                  )),
              Container(
                  width: w * 0.95,
                  // color: kPrimaryRed,
                  child: HtmlWidget(desc)),
            ],
          ),
        );
      },
    );
  }
}
