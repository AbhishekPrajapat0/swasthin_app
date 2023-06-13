import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:getwidget/components/badge/gf_badge.dart';
import 'package:getwidget/components/badge/gf_icon_badge.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/components/carousel/gf_carousel.dart';
import 'package:getwidget/components/shimmer/gf_shimmer.dart';

import '../../GlobalWidget/loading_widget.dart';
import '../../contants/Constants.dart';
import '../../contants/colors.dart';
import '../../contants/images.dart';
import '../../controllers/DashboardController.dart';
import '../../routes/Routes.dart';
import '../Batches/MyClassScreen.dart';
import '../Batches/SelectBatch.dart';
import '../Chat/ChatWithScreen.dart';
import '../Consulting/DietitianConsulting.dart';
import '../DietPlans/DietDateScreen.dart';
import '../More/MoreScreen.dart';
import '../SubscriptionScreen/ProgramListScreen.dart';

class DashboardScreen extends GetView<DashboardController> {
  final DashboardController dashboardController =
      Get.put(DashboardController());

  GetStorage box = GetStorage();

  var choosenYogaBatch = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Obx(() => dashboardController.loadingDone.value
            ? dashboardUi(context)
            : shimmerEffect(context)),
      ),
    );
  }

  bannerShimmer(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
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
            height: w * 0.4,
            child: Container(),
          ),
        ));
  }

  getBanners(BuildContext context) {
    return GFCarousel(
      enlargeMainPage: true,
      autoPlay: true,
      aspectRatio: 16 / 7,
      items: dashboardController.bannersList.value.map(
        (url) {
          return InkWell(
            onTap: () {
              print("urlis $url");
            },
            child: Container(
              margin: EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                child: Image.network(
                  url,
                  fit: BoxFit.cover,
                  width: 1200.0,
                ),
              ),
            ),
          );
        },
      ).toList(),
      onPageChanged: (index) {},
    );
  }

  dashboardUi(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.all(14),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: h * 0.01),
            width: w,
            color: Colors.white,
            height: h * 0.07,
            child: Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Dashboard"),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // InkWell(
                    //   onTap: () {
                    //     print("clicked profile");
                    //   },
                    //   child: Image.asset(
                    //     profileIcon,
                    //     height: w * 0.08,
                    //     width: w * 0.08,
                    //   ),
                    // ),
                    // SizedBox(
                    //   width: 20,
                    // ),
                    dashboardController.featuresAvail.value != "Yoga"
                        ? InkWell(
                            onTap: () {
                              controller.getMessageCountFun();
                              Get.to(() => ChatPage());
                              print(
                                  "clicked bell ${box.read(userHeight)} ${box.read(userActivityLevel)}");
                            },
                            child: Stack(
                              children: [
                                Obx(() => Visibility(
                                      visible: controller.showMsgPop.value,
                                      child: Positioned(
                                        right: 0,
                                        top: 0,
                                        child: Container(
                                          width: w * 0.03,
                                          height: w * 0.03,
                                          decoration: BoxDecoration(
                                              color: mainColor,
                                              borderRadius:
                                                  BorderRadius.circular(500)),
                                        ),
                                      ),
                                    )),
                                Image.asset(
                                  chatIcon,
                                  height: w * 0.06,
                                  width: w * 0.06,
                                ),
                              ],
                            ),
                          )
                        : Container(),
                    SizedBox(
                      width: 20,
                    ),
                    InkWell(
                      onTap: () {
                        print(
                            "clicked bell ${box.read(userHeight)} ${box.read(userActivityLevel)}");
                        Get.to(
                          () => MoreScreen(),
                          transition: Transition.rightToLeft,
                          duration: Duration(milliseconds: 700),
                        );
                      },
                      child: Image.asset(
                        moreIcon,
                        height: w * 0.08,
                        width: w * 0.08,
                      ),
                    ),
                  ],
                )
              ],
            )),
          ),
          SizedBox(
            height: w * 0.035,
          ),
          Obx(() => dashboardController.bannersList.value.length < 1
              ? bannerShimmer(context)
              : getBanners(context)),

          SizedBox(
            height: w * 0.025,
          ),
          Divider(),
          SizedBox(
            height: w * 0.025,
          ),

          Container(
            // height: w * 0.45,
            width: w,
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
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() => Container(
                    width: w * 0.8,
                    child: Text(
                      "Hey! ${dashboardController.userNameToGreet.value}",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: w * 0.06),
                    ))),
                Text(
                  "Good to See you",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                      fontSize: w * 0.035),
                ),
                // InkWell(
                //   onLongPress: (){
                //     // dashboardController.bannersList.clear();
                //     // print("cleared");
                //   },
                //   onTap: (){
                //     GetStorage box = GetStorage();
                //     // box.write(loggedIn, false);
                //     Get.to(()=>SubscriptionScreen());
                //     // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                //     //     builder: (context) =>LoginScreen()), (Route route) => false);
                //     // dashboardController.getBannerList();
                //   },
                //   child: Container(
                //     padding: EdgeInsets.all(8),
                //     margin: EdgeInsets.only(top: w * 0.03),
                //       decoration: BoxDecoration(
                //         color: Colors.white,
                //           border: Border.all(
                //             color: Colors.white,
                //           ),
                //           borderRadius: BorderRadius.all(Radius.circular(5))
                //       ),
                //     child: Row(
                //       mainAxisSize: MainAxisSize.min,
                //       children: [
                //         Text("Explore All",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: w*0.035),),
                //         Icon(Icons.arrow_right_alt_outlined)
                //       ],
                //     ) ,
                //   ),
                // )
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),

          // allFeaturesUI(context),
          Obx(() => dashboardController.featuresAvail.value == "Yoga"
              ? onlyYogaUI(context)
              : dashboardController.featuresAvail.value == "Diet"
                  ? onlyDiet(context)
                  : allFeaturesUI(context)),
        ],
      ),
    );
  }

  Widget shimmerEffect(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          SizedBox(
            height: h * 0.04,
          ),
          GFShimmer(
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
                  height: h * 0.18,
                  child: Container(),
                ),
              )),
          SizedBox(
            height: h * 0.04,
          ),
          GFShimmer(
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
                  height: h * 0.13,
                  child: Container(),
                ),
              )),
          SizedBox(
            height: h * 0.04,
          ),
          GFShimmer(
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
                  height: h * 0.10,
                  child: Container(),
                ),
              )),
          SizedBox(
            height: h * 0.01,
          ),
          GFShimmer(
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
                  height: h * 0.10,
                  child: Container(),
                ),
              )),
          SizedBox(
            height: h * 0.01,
          ),
          GFShimmer(
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
                  height: h * 0.10,
                  child: Container(),
                ),
              )),
          SizedBox(
            height: h * 0.01,
          ),
          GFShimmer(
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
                  height: h * 0.10,
                  child: Container(),
                ),
              )),

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

  allFeaturesUI(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Container(
      height: h * 0.55,
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(
              height: 15,
            ),
            Text(
              "Yoga",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: "Poppins"),
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () {
                    yogaClickedEvent(context);
                  },
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        padding: EdgeInsets.all(10),
                        height: w * 0.28,
                        width: w * 0.4,
                        decoration: BoxDecoration(
                          color: plansBgColor,
                          border: Border.all(
                            color: plansBorderColor, // set border color
                            width: 0.50, // set border width
                          ),
                          borderRadius:
                              BorderRadius.circular(10.0), // set border radius
                        ),
                        child: Image.asset(
                          color_yoga_icon,
                          width: w * 0.20,
                        ),
                      ),
                      Text(
                        "Select Batches",
                        style: TextStyle(fontSize: w * 0.028, color: textMuted),
                      )
                    ],
                  ),
                ),
                InkWell(
                  onTap: () async {
                    yogaClassClickEvent(context);
                  },
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        padding: EdgeInsets.all(10),
                        height: w * 0.28,
                        width: w * 0.4,
                        decoration: BoxDecoration(
                          color: plansBgColor,
                          border: Border.all(
                            color: plansBorderColor, // set border color
                            width: 0.50, // set border width
                          ),
                          borderRadius:
                              BorderRadius.circular(10.0), // set border radius
                        ),
                        child: Image.asset(
                          yogaClassVector,
                          width: w * 0.25,
                        ),
                      ),
                      Text(
                        "My Batches",
                        style: TextStyle(fontSize: w * 0.028, color: textMuted),
                      )
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              "Diet",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: "Poppins"),
            ),
            SizedBox(
              height: 15,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              InkWell(
                onTap: () async {
                  loadingWithText(context, "Please wait, Loading");
                  var status = await controller.subscriptionStatus();
                  stopLoading(context);

                  /// stop loading
                  print("subscribed in dashboard =======> $status");
                  if (status) {
                    Get.to(() => DietitianConsulting());
                  }
                },
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      padding: EdgeInsets.all(10),
                      height: w * 0.28,
                      width: w * 0.4,
                      decoration: BoxDecoration(
                        color: plansBgColor,
                        border: Border.all(
                          color: plansBorderColor, // set border color
                          width: 0.50, // set border width
                        ),
                        borderRadius:
                            BorderRadius.circular(10.0), // set border radius
                      ),
                      child: Image.asset(
                        color_dietitian_icon,
                        width: w * 0.2,
                      ),
                    ),
                    Text(
                      "Dietitian",
                      style: TextStyle(fontSize: w * 0.028, color: textMuted),
                    )
                  ],
                ),
              ),
              InkWell(
                onTap: () async {
                  print(
                      " chat with ${box.read(currentStaffIdForChat)} ===================< ");
                  dashboardController.chatWithDietitian(context);
                },
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      padding: EdgeInsets.all(10),
                      height: w * 0.28,
                      width: w * 0.4,
                      decoration: BoxDecoration(
                        color: plansBgColor,
                        border: Border.all(
                          color: plansBorderColor, // set border color
                          width: 0.50, // set border width
                        ),
                        borderRadius:
                            BorderRadius.circular(10.0), // set border radius
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Image.asset(
                          colorChatIcon,
                          width: w * 0.2,
                        ),
                      ),
                    ),
                    Text(
                      "Ask Dietitian",
                      style: TextStyle(fontSize: w * 0.028, color: textMuted),
                    )
                  ],
                ),
              ),
            ]),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () async {
                    Get.to(() => DietDateScreen());
                  },
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        padding: EdgeInsets.all(10),
                        height: w * 0.28,
                        width: w * 0.4,
                        decoration: BoxDecoration(
                          color: plansBgColor,
                          border: Border.all(
                            color: plansBorderColor, // set border color
                            width: 0.50, // set border width
                          ),
                          borderRadius:
                              BorderRadius.circular(10.0), // set border radius
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Image.asset(
                            colorDietIcon,
                            width: w * 0.2,
                          ),
                        ),
                      ),
                      Text(
                        "Diet Plans",
                        style: TextStyle(fontSize: w * 0.028, color: textMuted),
                      )
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    // Get.to(() => AppointmentListScreen());
                    Get.toNamed(Routes.APPOINTMENT_LIST_SCREEN);
                  },
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        padding: EdgeInsets.all(20),
                        height: w * 0.28,
                        width: w * 0.4,
                        decoration: BoxDecoration(
                          color: plansBgColor,
                          border: Border.all(
                            color: plansBorderColor, // set border color
                            width: 0.50, // set border width
                          ),
                          borderRadius:
                              BorderRadius.circular(10.0), // set border radius
                        ),
                        child: Image.asset(
                          color_appointment_icon,
                          width: w * 0.2,
                        ),
                      ),
                      Text(
                        "Appointments",
                        style: TextStyle(fontSize: w * 0.028, color: mainColor),
                      )
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 50,
            )
          ],
        ),
      ),
    );
  }

  onlyYogaUI(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Container(
      height: h * 0.55,
      child: Column(
        children: [
          SizedBox(
            height: 15,
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            width: w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () {
                    yogaClickedEvent(context);
                  },
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        padding: EdgeInsets.all(10),
                        height: w * 0.28,
                        width: w * 0.4,
                        decoration: BoxDecoration(
                          color: plansBgColor,
                          border: Border.all(
                            color: plansBorderColor, // set border color
                            width: 0.50, // set border width
                          ),
                          borderRadius:
                              BorderRadius.circular(10.0), // set border radius
                        ),
                        child: Image.asset(
                          color_yoga_icon,
                          width: w * 0.20,
                        ),
                      ),
                      Text(
                        "Select Batches",
                        style: TextStyle(fontSize: w * 0.028, color: textMuted),
                      )
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    yogaClassClickEvent(context);
                  },
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        padding: EdgeInsets.all(10),
                        height: w * 0.28,
                        width: w * 0.4,
                        decoration: BoxDecoration(
                          color: plansBgColor,
                          border: Border.all(
                            color: plansBorderColor, // set border color
                            width: 0.50, // set border width
                          ),
                          borderRadius:
                              BorderRadius.circular(10.0), // set border radius
                        ),
                        child: Image.asset(
                          yogaClassVector,
                          width: w * 0.25,
                        ),
                      ),
                      Text(
                        "My Batch",
                        style: TextStyle(fontSize: w * 0.028, color: textMuted),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  padding: EdgeInsets.all(10),
                  height: w * 0.28,
                  width: w * 0.28,
                ),
              ],
            ),
          ),
          SizedBox(
            height: h * 0.025,
          ),
        ],
      ),
    );
  }

  onlyDiet(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Container(
      height: h * 0.55,
      child: Column(
        children: [
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () async {
                  loadingWithText(context, "Please wait, Loading");
                  var status = await controller.subscriptionStatus();
                  stopLoading(context);

                  /// stop loading
                  print("subscribed in dashboard =======> $status");
                  if (status) {
                    Get.to(() => DietitianConsulting());
                  }
                },
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      padding: EdgeInsets.all(10),
                      height: w * 0.28,
                      width: w * 0.4,
                      decoration: BoxDecoration(
                        color: plansBgColor,
                        border: Border.all(
                          color: plansBorderColor, // set border color
                          width: 0.50, // set border width
                        ),
                        borderRadius:
                            BorderRadius.circular(10.0), // set border radius
                      ),
                      child: Image.asset(
                        color_dietitian_icon,
                        width: w * 0.2,
                      ),
                    ),
                    Text(
                      "Dietitian",
                      style: TextStyle(fontSize: w * 0.028, color: textMuted),
                    )
                  ],
                ),
              ),
              InkWell(
                onTap: () async {
                  dashboardController.chatWithDietitian(context);
                },
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      padding: EdgeInsets.all(10),
                      height: w * 0.28,
                      width: w * 0.4,
                      decoration: BoxDecoration(
                        color: plansBgColor,
                        border: Border.all(
                          color: plansBorderColor, // set border color
                          width: 0.50, // set border width
                        ),
                        borderRadius:
                            BorderRadius.circular(10.0), // set border radius
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Image.asset(
                          colorChatIcon,
                          width: w * 0.2,
                        ),
                      ),
                    ),
                    Text(
                      "Ask Dietitian",
                      style: TextStyle(fontSize: w * 0.028, color: textMuted),
                    )
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () async {
                  Get.to(() => DietDateScreen());
                },
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      padding: EdgeInsets.all(10),
                      height: w * 0.28,
                      width: w * 0.4,
                      decoration: BoxDecoration(
                        color: plansBgColor,
                        border: Border.all(
                          color: plansBorderColor, // set border color
                          width: 0.50, // set border width
                        ),
                        borderRadius:
                            BorderRadius.circular(10.0), // set border radius
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Image.asset(
                          colorDietIcon,
                          width: w * 0.2,
                        ),
                      ),
                    ),
                    Text(
                      "Diet Plans",
                      style: TextStyle(fontSize: w * 0.028, color: textMuted),
                    )
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  // Get.to(() => AppointmentListScreen());
                  Get.toNamed(Routes.APPOINTMENT_LIST_SCREEN);
                },
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      padding: EdgeInsets.all(20),
                      height: w * 0.28,
                      width: w * 0.4,
                      decoration: BoxDecoration(
                        color: plansBgColor,
                        border: Border.all(
                          color: plansBorderColor, // set border color
                          width: 0.50, // set border width
                        ),
                        borderRadius:
                            BorderRadius.circular(10.0), // set border radius
                      ),
                      child: Image.asset(
                        color_appointment_icon,
                        width: w * 0.2,
                      ),
                    ),
                    Text(
                      "Appointments",
                      style: TextStyle(fontSize: w * 0.028, color: textMuted),
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> yogaClickedEvent(BuildContext context) async {
    // Get.to(()=>ProgramListScreen());
    loadingWithText(context, "Please wait, Loading");
    var status = await dashboardController.subscriptionStatus();
    stopLoading(context);

    /// stop loading
    print("subscribed in dashboard =======> $status");
    if (status) {
      dashboardController.selectBatch(context);
    }
  }

  void yogaClassClickEvent(BuildContext context) async {
    loadingWithText(context, "Please wait, Loading");
    var status = await dashboardController.subscriptionStatus();
    stopLoading(context);

    /// stop loading
    print("subscribed in dashboard =======> $status");
    if (status) {
      Get.to(() => MyClassScreen());
    }
  }
}
