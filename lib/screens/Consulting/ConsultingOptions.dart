import 'package:Swasthin/contants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../GlobalWidget/ProfileTile.dart';
import '../../GlobalWidget/customAppBars.dart';
import '../../GlobalWidget/loading_widget.dart';
import '../../contants/images.dart';
import '../../controllers/DashboardController.dart';
import 'AppointmentList.dart';
import 'DietitianConsulting.dart';

class ConsultingOptions extends StatelessWidget {
  ConsultingOptions({Key? key}) : super(key: key);

  final DashboardController controller = Get.put(DashboardController());

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: kPrimaryWhite,
      appBar: appBarWithBack(context, showBack: true, title: "Consulting"),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            ProfileTile(
                icon: Image.asset(
                  color_dietitian_icon,
                  width: w * 0.09,
                ),
                text: Text("Book Consulting"),
                onTap: () async {
                  loadingWithText(context, "Please wait, Loading");
                  var status = await controller.subscriptionStatus();
                  stopLoading(context);

                  /// stop loading
                  print("subscribed in dashboard =======> $status");
                  if (status) {
                    Get.to(() => DietitianConsulting());
                  }
                }),
            Divider(),
            ProfileTile(
                icon: ImageIcon(AssetImage(dietIcon)),
                text: Text("Appointments "),
                onTap: () {
                  Get.to(() => AppointmentListScreen());
                }),
            Divider(),
          ],
        ),
      ),
    );
  }
}
