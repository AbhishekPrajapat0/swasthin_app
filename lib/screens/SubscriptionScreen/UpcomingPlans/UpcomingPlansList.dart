import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/shimmer/gf_shimmer.dart';
import 'package:intl/intl.dart';
import '../../../GlobalWidget/customAppBars.dart';
import '../../../contants/colors.dart';
import '../../../controllers/Subscription%20Plans/UpcomingPlans/UpcomingPlansController.dart';

class UpcomingPlansListScreen extends GetView<UpcomingPlansController> {
  final UpcomingPlansController controller = Get.put(UpcomingPlansController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryWhite,
      appBar: appBarWithBack(context,
          showBack: true, title: "Subscription History"),
      body: Obx(() => controller.dataLoaded.value
          ? controller.noPlans.value
              ? Center(
                  child: Text("No Subscription History Found"),
                )
              : getList(context)
          : shimmerEffect(context)),
    );
  }

  getList(BuildContext context) {
    var h = Get.height;
    var w = Get.width;

    return ListView.builder(
      reverse: true,
      itemCount: controller.list!.length,
      shrinkWrap: true,
      padding: EdgeInsets.only(top: 10, bottom: 10),
      // physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        var data = controller.list![index];
        var name = data.name;
        var startDate = DateFormat.yMMMd('en_US').format(data.startsAt!);
        var endDate = data.endsAt!;
        var formatedEndDate = DateFormat.yMMMd('en_US').format(endDate);
        var now = DateTime.now();
        var status = now.isAfter(data.startsAt!) && now.isAfter(endDate)
            ? "Previous Plan"
            : now.isAfter(data.startsAt!) && now.isBefore(endDate)
                ? "Active Plan"
                : "Upcoming Plans";
        return Container(
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          // height: h*0.2,
          width: w * 0.9,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            gradient: LinearGradient(
                colors: [
                  mainColor,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(w),
                      color: status == "Active Plan"
                          ? kPrimaryGreen
                          : status == "Previous Plan"
                              ? kPrimaryRed
                              : kPrimaryBlue,
                      // border: Border.all(
                      //   color: plansBorderColor, // set border color
                      //   width: 0.50, // set border width
                      // ),
                    ),
                    child: Text(
                      status,
                      style:
                          TextStyle(fontSize: w * 0.028, color: kPrimaryWhite),
                    ),
                  ),
                  SizedBox(
                    height: w * 0.02,
                  ),
                  Text(
                    "$name",
                    style: TextStyle(color: Colors.white, fontSize: w * 0.05),
                  ),
                  SizedBox(
                    height: w * 0.01,
                  ),
                  Container(
                      width: w * 0.5,
                      child: Text(
                        "Start Date : $startDate",
                        overflow: TextOverflow.ellipsis,
                        style:
                            TextStyle(color: Colors.white, fontSize: w * 0.03),
                      )),
                  Container(
                      margin: EdgeInsets.only(top: 5),
                      width: w * 0.5,
                      child: Text(
                        "End Date : $formatedEndDate",
                        overflow: TextOverflow.ellipsis,
                        style:
                            TextStyle(color: Colors.white, fontSize: w * 0.03),
                      )),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget shimmerEffect(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: RefreshIndicator(
              onRefresh: refreshUpcomingPlans,
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

  Future refreshUpcomingPlans() async {
    controller.refreshPage();
  }
}
