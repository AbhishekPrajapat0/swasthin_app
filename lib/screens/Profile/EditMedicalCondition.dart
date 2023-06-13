import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:info_popup/info_popup.dart';

import '../../GlobalWidget/CustomButton.dart';
import '../../GlobalWidget/customAppBars.dart';
import '../../contants/colors.dart';
import '../../controllers/Profile/EditController/EditMedicalConditionController.dart';

class EditMedicalCondtionsScreen
    extends GetView<EditMedicalConditionController> {
  final EditMedicalConditionController controller =
      Get.put(EditMedicalConditionController());

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return Scaffold(
      bottomNavigationBar: bottomNavigationButton(context),
      backgroundColor: kPrimaryWhite,
      appBar: appBarWithBack(context,
          showBack: true, title: "Update Medical Condition"),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              // color: Colors.red,
              padding: EdgeInsets.all(16),
              width: w * 0.99,
              child: Text(
                "If You have Multiple Health Issue You can Specify by separating them by comma ',' ",
                style: TextStyle(color: textMuted),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 18, top: 25.0, bottom: 2),
                child: const Text('Medical Conditions',
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                        fontSize: 13)),
              ),
              getinfoIcon(context)
            ],
          ),
          Container(
            width: w / 0.9,
            height: h / 5,
            margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            padding: const EdgeInsets.symmetric(vertical: 2),
            decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
              child: TextField(
                controller: controller.updatedMedicalCon,
                decoration: InputDecoration(
                    helperText: ' ',
                    border: InputBorder.none,
                    hintText:
                        "Please Mention your Medical Condition If you Have any or Healthy if don't have any",
                    hintStyle: TextStyle(
                        color: textExtraMuted, fontWeight: FontWeight.w400)),
                keyboardType: TextInputType.multiline,
                minLines: 1, // <-- SEE HERE
                maxLines: 6, // <-- SEE HERE
              ),
            ),
          ),
          // bottomNavigationButton(context),
        ],
      ),
    );
  }

  bottomNavigationButton(BuildContext context) {
    return CustomButton(
      text: "Update",
      onPressed: () {
        controller.updateToAPI(context);
      },
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 18),
    );
  }

  getinfoIcon(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return InfoPopupWidget(
      customContent: Container(
        width: w,
        decoration: BoxDecoration(
          color: Colors.blueGrey,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          children: const <Widget>[
            Text(
                "Please Mention your Medical Condition If you Have any or Healthy if don't have any",
                style: TextStyle(
                  color: Colors.white,
                ))
          ],
        ),
      ),
      arrowTheme: const InfoPopupArrowTheme(
        color: Colors.black54,
        arrowDirection: ArrowDirection.up,
      ),
      dismissTriggerBehavior: PopupDismissTriggerBehavior.anyWhere,
      areaBackgroundColor: Colors.transparent,
      indicatorOffset: Offset.zero,
      contentOffset: Offset.zero,
      onControllerCreated: (controller) {
        print('Info Popup Controller Created');
      },
      onAreaPressed: (InfoPopupController controller) {
        print('Area Pressed');
      },
      infoPopupDismissed: () {
        print('Info Popup Dismissed');
      },
      onLayoutMounted: (Size size) {
        print('Info Popup Layout Mounted');
      },
      child: Icon(
        Icons.info,
        color: Colors.black54,
      ),
    );
  }
}
