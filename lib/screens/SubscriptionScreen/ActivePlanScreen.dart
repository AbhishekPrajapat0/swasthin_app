import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/shimmer/gf_shimmer.dart';
import 'package:intl/intl.dart';
import 'package:Swasthin/GlobalWidget/customAppBars.dart';
import 'package:Swasthin/contants/colors.dart';
import 'package:Swasthin/controllers/Subscription%20Plans/ActivePlanController.dart';
import 'package:Swasthin/screens/SubscriptionScreen/SubscriptionScreen.dart';
import 'package:Swasthin/screens/SubscriptionScreen/UpcomingPlans/UpcomingPlansList.dart';

class ActivePlanScreen extends GetView<ActivePlanController> {
  final ActivePlanController activePlanController =
      Get.put(ActivePlanController());

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: kPrimaryWhite,
      appBar: appBarWithBack(context, showBack: true, title: "My Active Plan"),
      body: Container(
          // color: kPrimaryBase,
          height: h * 0.9,
          child: Obx(() => activePlanController.dataLoaded.value
              ? activePlanController.planBought.value
                  ? showDetails(context)
                  : noPackage(context)
              : shimmerEffect(context))),
    );
  }

  daysLeft(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    var days = activePlanController.daysRemain.value;
    return Container(
      height: w * 0.45,
      width: w,
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(20),
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: h * 0.02,
          ),
          Container(
              // color:  Colors.white,
              width: w * 0.8,
              child: Center(
                child: Text(
                  "${days} Days",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: w * 0.09),
                ),
              )),
          Text(
            "Remaining",
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w300,
                fontSize: w * 0.045),
          ),
        ],
      ),
    );
  }

  detailsUI(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    var data = activePlanController.activePlanModel;
    var name = data.name != null ? data.name.toString() : "No Active Plans";
    var desc = data.description != null
        ? data.description.toString()
        : "Please Buy a Plan to Get Our App Benefits";
    var exDate = data.endsAt != null ? getFormatedDate(data.endsAt!) : "N.A";
    return Center(
      child: Container(
        margin: EdgeInsets.all(16),
        padding: EdgeInsets.only(top: 30, left: 16, right: 16, bottom: 50),
        width: w * 0.917,
        decoration: BoxDecoration(
          color: kPrimaryWhite,
          border: Border.all(
            color: plansBorderColor, // set border color
            width: 0.50, // set border width
          ),
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 60,
              offset: Offset(0, 12), // changes position of shadow
            ),
          ], // set border radius
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(w),
                color: plansBgColor,
                border: Border.all(
                  color: plansBorderColor, // set border color
                  width: 0.50, // set border width
                ),
              ),
              child: Text(
                "Active Plan",
                style: TextStyle(fontSize: w * 0.028),
              ),
            ),
            Container(
                width: w * 0.8,
                margin: EdgeInsets.only(top: 10),
                child: Text(
                  "${name}",
                  style: TextStyle(
                      fontSize: w * 0.05, fontWeight: FontWeight.w500),
                )),
            Container(
                // color: kPrimaryRed,
                width: w * 0.8,
                margin: EdgeInsets.only(top: 10, bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Description : ",
                      style: TextStyle(
                          fontSize: w * 0.04, fontWeight: FontWeight.w300),
                    ),
                    Container(
                      width: w,
                      child: HtmlWidget(desc),
                    ),
                  ],
                )
                // child: Text("${desc}",style: TextStyle(fontSize: w*0.04,fontWeight: FontWeight.w300),)
                ),
            Container(
                width: w * 0.8,
                margin: EdgeInsets.only(top: 5),
                child: Text(
                  "Expires on : ${exDate}",
                  style: TextStyle(
                      fontSize: w * 0.04, fontWeight: FontWeight.w400),
                )),
            activePlanController.daysRemain.value < 7
                ? renewButton(context)
                : Container(),
            SizedBox(
              height: h * 0.025,
            ),
            Center(
              child: upcomingButton(context),
            )
          ],
        ),
      ),
    );
  }

  getFormatedDate(DateTime date) {
    final DateFormat formatter = DateFormat.yMMMd('en_US');
    var formatedDate = formatter.format(date);
    return formatedDate;
  }

  Widget shimmerEffect(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
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
                        width: w,
                        height: h * 0.5,
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

  showDetails(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Container(
        height: activePlanController.activePlanModel.description!.length > 1000
            ? h * 2
            : activePlanController.activePlanModel.description!.length > 750
                ? h * 1
                : activePlanController.activePlanModel.description!.length > 600
                    ? h * 0.90
                    : h * 0.9,
        child: Stack(
          children: [
            daysLeft(context),
            Positioned(
              child: detailsUI(context),
              top: h * 0.15,
            ),
          ],
        ),
      ),
    );
  }

  noPackage(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        Container(
          height: w * 0.45,
          width: w,
          margin: EdgeInsets.all(16),
          padding: EdgeInsets.all(20),
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: h * 0.02,
              ),
              Container(
                  // color:  Colors.white,
                  width: w * 0.8,
                  child: Center(
                    child: Text(
                      "0 Days",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: w * 0.09),
                    ),
                  )),
              Text(
                "Remaining",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w300,
                    fontSize: w * 0.045),
              ),
            ],
          ),
        ),
        Positioned(
          top: h * 0.15,
          child: Center(
            child: Container(
              margin: EdgeInsets.all(16),
              padding:
                  EdgeInsets.only(top: 30, left: 16, right: 16, bottom: 50),
              width: w * 0.917,
              decoration: BoxDecoration(
                color: kPrimaryWhite,
                border: Border.all(
                  color: plansBorderColor, // set border color
                  width: 0.50, // set border width
                ),
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 60,
                    offset: Offset(0, 12), // changes position of shadow
                  ),
                ], // set border radius
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(w),
                      color: plansBgColor,
                      border: Border.all(
                        color: plansBorderColor, // set border color
                        width: 0.50, // set border width
                      ),
                    ),
                    child: Text(
                      "No Active Plan",
                      style: TextStyle(fontSize: w * 0.028),
                    ),
                  ),
                  Container(
                      width: w * 0.8,
                      margin: EdgeInsets.only(top: 10),
                      child: Text(
                        "No Active Plan",
                        style: TextStyle(
                            fontSize: w * 0.05, fontWeight: FontWeight.w500),
                      )),
                  Container(
                      width: w * 0.8,
                      margin: EdgeInsets.only(top: 5),
                      child: Text(
                        "Please buy a Plan",
                        style: TextStyle(
                            fontSize: w * 0.04, fontWeight: FontWeight.w300),
                      )),
                  Container(
                      width: w * 0.8,
                      margin: EdgeInsets.only(top: 5),
                      child: Text(
                        "Expires on : ----",
                        style: TextStyle(
                            fontSize: w * 0.04, fontWeight: FontWeight.w400),
                      )),
                  renewButton(context),
                  SizedBox(
                    height: h * 0.025,
                  ),
                  Center(
                    child: upcomingButton(context),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  renewButton(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.only(top: 38.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              activePlanController.planBought.value
                  ? OutlinedButton(
                      onPressed: () {
                        controller.renewPackageBuy();
                      },
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0))),
                      ),
                      child: const Text(
                        "Renew Plan",
                        style: TextStyle(color: Colors.blue),
                      ),
                    )
                  : Container(),
              SizedBox(
                width: w * 0.05,
              ),
              OutlinedButton(
                onPressed: () {
                  Get.to(() => SubscriptionScreen());
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0))),
                ),
                child: const Text(
                  "Explore Plans",
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  upcomingButton(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return InkWell(
      onTap: () {
        Get.to(() => UpcomingPlansListScreen());
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(w),
          color: plansBgColor,
          border: Border.all(
            color: plansBorderColor, // set border color
            width: 0.50, // set border width
          ),
        ),
        child: Text(
          "Subscription History >>",
          style: TextStyle(fontSize: w * 0.028),
        ),
      ),
    );
  }
}
