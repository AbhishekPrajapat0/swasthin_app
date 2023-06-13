import 'package:Swasthin/screens/SubscriptionScreen/ActivePlanScreen.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../GlobalWidget/ProfileTile.dart';
import '../../GlobalWidget/customAppBars.dart';
import '../../Utlis/globalFunctions.dart';
import '../../contants/colors.dart';
import '../../contants/images.dart';
import '../../controllers/MoreScreenController.dart';
import '../Profile/EditProfileScreen.dart';
import '../SubscriptionScreen/TranscationsList/TranscationList.dart';
import '../TermsAndPolicy/PrivacyPolicyScreen.dart';
import '../TermsAndPolicy/TermsScreen.dart';
import '../UploadedReportList/UploadedReportList.dart';

class MoreScreen extends GetView<MoreScreenController> {
  final MoreScreenController moreScreenController =
      Get.put(MoreScreenController());

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: kPrimaryWhite,
      appBar: appBarWithBack(context, showBack: true, title: "More"),
      bottomNavigationBar: GestureDetector(
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.only(bottom: 40),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.logout,
                color: Colors.red.withOpacity(0.8),
              ),
              SizedBox(
                width: w * 0.04,
              ),
              InkWell(
                onTap: () {
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.warning,
                    animType: AnimType.rightSlide,
                    title: 'Logging Out',
                    desc: 'Do you want to Log out?',
                    btnCancelText: "No",
                    btnOkText: "Yes",
                    btnCancelOnPress: () {},
                    btnOkOnPress: () {
                      SessionExpiredFun();
                    },
                  ).show();
                },
                child: Text(
                  "Log out",
                  style: TextStyle(
                      fontSize: 17,
                      color: Colors.red.withOpacity(0.8),
                      fontWeight: FontWeight.w600),
                ),
              )
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                ProfileTile(
                    icon: ImageIcon(AssetImage(profileIcon)),
                    text: Text("Edit Profile"),
                    onTap: () {
                      Get.to(() => EditProfileScreen());
                    }),
                Divider(),
                // ProfileTile(
                //     icon: ImageIcon(AssetImage(yogaIcon)),
                //     text: Text("Yoga Zoom Link"),
                //     onTap: (){}
                // ),
                // Divider(),
                // ProfileTile(
                //     icon: ImageIcon(AssetImage(dietIcon)),
                //     text: Text("Dietitian Appointments"),
                //     onTap: (){
                //       Get.to(()=>AppointmentListScreen());
                //     }
                // ),
                // Divider(),
                ProfileTile(
                    icon: ImageIcon(AssetImage(subscriptionIcon)),
                    text: Text("Active Plan"),
                    onTap: () {
                      Get.to(() => ActivePlanScreen());
                    }),
                Divider(),
                ProfileTile(
                    icon: Icon(Icons.history),
                    text: Text("Transaction History"),
                    onTap: () {
                      Get.to(() => TransactionListScreen());
                    }),
                Divider(),
                ProfileTile(
                    icon: ImageIcon(AssetImage(uploadIcon)),
                    text: Text("Uploaded Report"),
                    onTap: () {
                      Get.to(() => UploadedReportList());
                    }),
                Divider(),

                ProfileTile(
                    icon: ImageIcon(AssetImage(deleteIcon)),
                    text: Text("Delete Account"),
                    onTap: () {
                      moreScreenController.deleteAccount(context);
                    }),
                Divider(),
                ProfileTile(
                    icon: ImageIcon(AssetImage(termsIcon)),
                    text: Text("Terms & Conditions"),
                    onTap: () {
                      Get.to(() => TermsScreen());
                    }),
                Divider(),
                ProfileTile(
                    icon: ImageIcon(AssetImage(policyIcon)),
                    text: Text("Privacy Policy"),
                    onTap: () {
                      Get.to(() => PrivacyPolicyScreen());
                    }),
                Divider(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
