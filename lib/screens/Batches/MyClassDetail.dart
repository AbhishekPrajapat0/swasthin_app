import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/shimmer/gf_shimmer.dart';

import '../../GlobalWidget/CustomButton.dart';
import '../../GlobalWidget/customAppBars.dart';
import '../../Models/BatchesModel/MyClassDetailModel.dart';
import '../../contants/colors.dart';
import '../../contants/images.dart';
import '../../controllers/Batch/MyClassDetailController.dart';

class MyClassDetail extends GetView<MyClassDetailModel> {
  final MyClassDetailsController classController =
      Get.put(MyClassDetailsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryWhite,
      appBar: appBarWithBack(context, showBack: true, title: "Class Details"),
      body: Obx(() => classController.dataLoaded.value
          ? getList(context)
          : shimmerEffect(context)),
    );
  }

  getList(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    var data = classController.myClassDetail.batch!;
    classController.zoomLinkCon.text =
        data.link != null ? data.link! : "Link has not been Generated Yet";
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        padding: EdgeInsets.all(10),
        width: w,
        decoration: BoxDecoration(
          color: plansBgColor,
          border: Border.all(
            color: plansBorderColor, // set border color
            width: 0.50, // set border width
          ),
          borderRadius: BorderRadius.circular(10.0), // set border radius
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: plansBgColor,
                // border: Border.all(
                //   color: plansBorderColor, // set border color
                //   width: 0.50, // set border width
                // ),
                borderRadius: BorderRadius.circular(10.0), // set border radius
              ),
              child: Image(
                image: NetworkImage("${data.image}"),
                height: w * 0.5,
              ),
            ),
            Divider(),
            Container(
                width: w * 0.8,
                // color: kCallMissedRed,
                child: Text(
                  "${data.name}",
                  style: TextStyle(
                      fontSize: w * 0.06, fontWeight: FontWeight.w500),
                )),
            SizedBox(
              height: h * 0.02,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    width: w * 0.5,
                    // color: kCallMissedRed,
                    child: Text(
                      "Class Starts at : ",
                      style: TextStyle(
                          fontSize: w * 0.04, fontWeight: FontWeight.w400),
                    )),
                Container(
                    width: w * 0.3,
                    // color: kCallMissedRed,
                    child: Text(
                      "${data.startTime}",
                      textAlign: TextAlign.end,
                      style: TextStyle(
                          fontSize: w * 0.04, fontWeight: FontWeight.w400),
                    )),
              ],
            ),
            SizedBox(
              height: h * 0.005,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    width: w * 0.5,
                    // color: kCallMissedRed,
                    child: Text(
                      "Class Ends at : ",
                      style: TextStyle(
                          fontSize: w * 0.04, fontWeight: FontWeight.w400),
                    )),
                Container(
                    width: w * 0.3,
                    // color: kCallMissedRed,
                    child: Text(
                      "${data.endTime}",
                      textAlign: TextAlign.end,
                      style: TextStyle(
                          fontSize: w * 0.04, fontWeight: FontWeight.w400),
                    )),
              ],
            ),
            SizedBox(
              height: h * 0.03,
            ),
            // SizedBox(height: 20),
            SizedBox(
              height: h * 0.08,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                        onTap: () async {
                          await Clipboard.setData(ClipboardData(
                              text: classController.zoomLinkCon.text));
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5.0),
                          child: Icon(Icons.copy),
                        )),
                    Container(
                      width: w * 0.70,
                      decoration: BoxDecoration(
                        color: Colors.grey[
                            200], // Set the background color of the container
                        borderRadius: BorderRadius.circular(
                            5.0), // Set the border radius of the container
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        child: TextFormField(
                          enabled: false,
                          decoration: InputDecoration(
                            hintText: 'Enter Zoom Link Here',
                            border: InputBorder
                                .none, // Remove the border of the TextFormField
                          ),
                          controller: classController.zoomLinkCon,
                          maxLines: 1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: h * 0.03,
            ),
            CustomButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Go To Zoom App"),
                  SizedBox(
                    width: w * 0.03,
                  ),
                  Icon(
                    Icons.video_call_outlined,
                    color: Colors.white,
                  )
                ],
              ),
              onPressed: () {
                classController.launchZoom();
              },
            )
          ],
        ),
      ),
    );
  }

  Widget shimmerEffect(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.all(8),
              itemCount: 1,
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
                        width: 300,
                        height: h * 0.7,
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
    );
  }
}
