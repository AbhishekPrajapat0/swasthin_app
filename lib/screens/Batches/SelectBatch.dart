import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/components/shimmer/gf_shimmer.dart';

import '../../GlobalWidget/customAppBars.dart';
import '../../GlobalWidget/globalAlert.dart';
import '../../contants/colors.dart';
import '../../controllers/SelectYogaBatchController.dart';

class SelectYogaBatch extends GetView<SelectYogaBatchController> {
  final SelectYogaBatchController selectBatchController =
      Get.put(SelectYogaBatchController());

  // List<String> batchesName = ["Morning Batch 1","Morning Batch 2","Evening Batch 1","Evening Batch 2"];
  // List<String> batchesTiming = ["7:00 Am to 8:00 Am","8:00 Am to 9:00 Am","6:00 Pm to 7:00 Pm","7:00 Pm to 8:00 Pm"];

  List<Color> colors = [
    mainColor,
    secondaryColor,
    kPrimaryBlue,
    kPrimaryRed,
    kPrimaryGreen
  ];
  List<Color> colorTwo = [
    kPrimaryGreen,
    mainColor,
    secondaryColor,
    kPrimaryBlue,
    kPrimaryRed
  ];

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: kPrimaryWhite,
      appBar: appBarWithBack(context, showBack: true, title: "Select Batch"),
      bottomSheet: Container(
          height: h * 0.03,
          child: Center(
              child: Text("Note : You can only change batch after 7 days.",
                  maxLines: 2))),
      body: Container(
        height: h - kToolbarHeight + 15,
        child: Obx(() => selectBatchController.loadingData.value
            ? shimmerEffect(context)
            : getList()),
      ),
    );
  }

  //shimmer
  Widget shimmerEffect(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.all(1),
                itemCount: 5,
                itemBuilder: (BuildContext context, int index) {
                  return GFShimmer(
                      mainColor: Colors.grey.shade200,
                      secondaryColor: Colors.grey.shade300,
                      child: Card(
                        elevation: 0,
                        color: const Color(0xFFF9F9F9),
                        shape: const RoundedRectangleBorder(
                          side: BorderSide(
                            color: Colors.white54,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        child: SizedBox(
                          width: w,
                          height: h * 0.15,
                          child: Container(),
                        ),
                      ));
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(),
              ),
            ),

            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 10),
            //   child: Text(
            //     'Loading... Please Wait '
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  getList() {
    return ListView.builder(
      itemCount: selectBatchController.batchesList.value.length,
      physics: BouncingScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        double w = MediaQuery.of(context).size.width;
        double h = MediaQuery.of(context).size.height;
        var batches = selectBatchController.batchesList.value[index];
        return SingleChildScrollView(
          child: Container(
            // height: w * 0.25,
            width: w,
            padding: EdgeInsets.all(20),
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              gradient: LinearGradient(
                  colors: [
                    kTextRed,
                    secondaryColor,
                  ],
                  begin: FractionalOffset(0.0, 0.0),
                  end: FractionalOffset(1.0, 0.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        width: w * 0.53,
                        child: Text(
                          "${batches.name}",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: w * 0.048),
                        )),
                    Text(
                      "Timing :- ${batches.startTime} - ${batches.endTime}",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w300,
                          fontSize: w * 0.035),
                    ),
                  ],
                ),
                GFButton(
                  color: kPrimaryWhite,
                  text: "Select",
                  textColor: kPrimaryBlack,
                  onPressed: () {
                    GlobalAlertQuestion(
                        context,
                        "Please Confirm !",
                        " Are you sure you want ${batches.name} ?  ",
                        // "Note : You can only change batch on Saturdays or Sundays.",
                        DialogType.question, onTap: () {
                      selectBatchController.selectYogaBatch(
                          context, batches.id.toString());
                    }, btnOkText: "Yes", btnCancelText: "No");
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
