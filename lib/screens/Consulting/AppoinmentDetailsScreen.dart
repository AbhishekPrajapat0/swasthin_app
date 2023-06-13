import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/rating/gf_rating.dart';
import 'package:getwidget/components/shimmer/gf_shimmer.dart';

import '../../GlobalWidget/CustomButton.dart';
import '../../GlobalWidget/customAppBars.dart';
import '../../contants/colors.dart';
import '../../contants/images.dart';
import '../../controllers/DietitianControllers/AppointmentDetailsController.dart';

class AppointmentDetailsScreen extends GetView<AppointmentDetailsController> {
  final AppointmentDetailsController controller =
      Get.put(AppointmentDetailsController());

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: appBarWithBack(context, showBack: true),
      backgroundColor: kPrimaryWhite,
      body: SingleChildScrollView(
        child: Obx(() => controller.dataLoaded.value
            ? getDetails(context)
            : shimmerEffect(context)),
      ),
    );
  }

  getDetails(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    var data = controller.data;
    var name = data.staffs?.name ?? "Dietitian Not Assigned";
    var date = data.date;
    var time = "${data.startTime} - ${data.startEnd}";
    var status = data.status == 1
        ? "Upcoming"
        : data.status == 2
            ? "Ongoing"
            : data.status == 3
                ? "Completed"
                : data.status == 5
                    ? "Didn't Connect"
                    : data.status == 6
                        ? "Calling"
                        : "Cancelled";
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            width: w,
            child: RichText(
              textAlign: TextAlign.left,
              text: TextSpan(
                text: 'Connect with ',
                style: TextStyle(
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                    fontSize: 25),
                children: const <TextSpan>[
                  TextSpan(
                      text: 'Dietitian',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: mainColor,
                      )),
                ],
              ),
            ),
          ),
          Container(
              margin: EdgeInsets.only(top: 10, bottom: 40),
              width: w,
              child: Text(
                data.staffs?.name != null
                    ? "You have an Appointment with Dietitian $name on $date"
                    : "Dietitian has not been assigned to your meeting on $date",
                textAlign: TextAlign.left,
              )),
          Image.asset(
            dietVideoCallVector,
            width: w * 0.7,
          ),
          Container(
            margin: EdgeInsets.only(bottom: 10),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 3.0),
                  child: Container(
                      decoration: BoxDecoration(
                        color: data.status == 1 || data.status == 2
                            ? kPrimaryBlue
                            : data.status == 3
                                ? kPrimaryGreen
                                : kPrimaryRed,
                        borderRadius: BorderRadius.all(Radius.circular(500)),
                      ),
                      child: Container(
                        width: w * 0.23,
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "$status",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 10, color: Colors.white),
                        ),
                      )),
                ),
                SizedBox(
                  height: h * 0.01,
                ),
                Text(
                  "Dietitian Name :",
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: w * 0.028, color: textMuted),
                ),
                SizedBox(
                  height: h * 0.005,
                ),
                Text(
                  "$name",
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: w * 0.05, color: kPrimaryBlack),
                ),
                SizedBox(
                  height: h * 0.005,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Meeting Date :",
                          textAlign: TextAlign.left,
                          style:
                              TextStyle(fontSize: w * 0.028, color: textMuted),
                        ),
                        SizedBox(
                          height: h * 0.005,
                        ),
                        Container(
                            width: w * 0.4,
                            child: Text(
                              "$date",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: w * 0.035, color: kPrimaryBlack),
                            )),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Meeting Time :",
                          textAlign: TextAlign.left,
                          style:
                              TextStyle(fontSize: w * 0.028, color: textMuted),
                        ),
                        SizedBox(
                          height: h * 0.005,
                        ),
                        Container(
                            width: w * 0.4,
                            child: Text(
                              "$time",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: w * 0.035, color: kPrimaryBlack),
                            )),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: h * 0.03,
                ),
                // SizedBox(height: 20),
                data.status == 1 ? getLinkBox(context) : Container(),
                Divider(),
                SizedBox(
                  height: h * 0.03,
                ),
                data.status == 1
                    ? CustomButton(
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
                          controller.launchZoom();
                        },
                      )
                    : Obx(() => controller.showRatingOpt.value
                        ? CustomButton(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Give Feedback"),
                                SizedBox(
                                  width: w * 0.03,
                                ),
                                Icon(
                                  Icons.star,
                                  color: Colors.white,
                                )
                              ],
                            ),
                            onPressed: () {
                              controller.giveFeedback(context);
                            },
                          )
                        : Center(
                            child: Column(
                              children: [
                                Text(
                                  "Your rating for this meeting is",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w300),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                GFRating(
                                  value: controller.ratingShow.value,
                                  size: 50,
                                  color: mainColor,
                                  borderColor: mainColor,
                                  onChanged: (value) {},
                                ),
                              ],
                            ),
                          )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget shimmerEffect(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.all(1),
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
                        width: w * 0.8,
                        height: h,
                        child: Container(),
                      ),
                    ));
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
            ),
          ),
        ],
      ),
    );
  }

  getLinkBox(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Container(
      decoration: BoxDecoration(
          color: mutedColor,
          borderRadius: BorderRadius.all(Radius.circular(15))),
      height: h * 0.08,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 1),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
                onTap: () async {
                  await Clipboard.setData(
                      ClipboardData(text: controller.zoomLinkCon.text));
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: Icon(Icons.copy),
                )),
            Container(
              width: w * 0.70,
              decoration: BoxDecoration(
                color: Colors
                    .grey[200], // Set the background color of the container
                borderRadius: BorderRadius.circular(
                    5.0), // Set the border radius of the container
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: TextFormField(
                  enabled: false,
                  decoration: InputDecoration(
                    hintText: 'Zoom Link Not Available Yet',
                    border: InputBorder
                        .none, // Remove the border of the TextFormField
                  ),
                  controller: controller.zoomLinkCon,
                  maxLines: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
