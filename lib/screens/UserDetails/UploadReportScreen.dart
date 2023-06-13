import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../GlobalWidget/customAppBars.dart';
import '../../GlobalWidget/globalAlert.dart';
import '../../contants/colors.dart';
import '../../controllers/UploadReportController/UploadReportController.dart';

import '../../GlobalWidget/CustomButton.dart';
import '../../contants/images.dart';

class UploadReportScreen extends GetView<UploadReportController> {
  final UploadReportController uploadReportController =
      Get.put(UploadReportController());

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: kPrimaryWhite,
      bottomNavigationBar: bottonButton(context),
      appBar: appBarWithBack(context,
          showBack: false,
          title: "Upload Report",
          actions: [
            Obx(() => uploadReportController.type.value == "reupload"
                ? SizedBox()
                : getSkipButton(context))
          ]),
      body: Obx(() => uploadReportController.fileEmpty.value
          ? uploadFileUI(context)
          : uploadedFileUI(context)),
    );
  }

  uploadFileUI(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return InkWell(
      onTap: () {
        print(
            "===========================================================================================================> clicked");
        uploadReportController.pickFile();
      },
      child: Container(
        width: w,
        height: h * 0.3,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(uploadFileVector),
          ),
        ),
      ),
    );
  }

  uploadedFileUI(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    var fileName = uploadReportController.fileName;
    return InkWell(
      child: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(10),
        height: w * 0.3,
        width: w,
        decoration: BoxDecoration(
          color: plansBgColor,
          border: Border.all(
            color: plansBorderColor, // set border color
            width: 0.50, // set border width
          ),
          borderRadius: BorderRadius.circular(10.0), // set border radius
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(
              fileIcon,
              width: w * 0.15,
            ),
            SizedBox(
              width: w * 0.02,
            ),
            Container(
                width: w * 0.5,
                child: Text(
                  "$fileName",
                  overflow: TextOverflow.ellipsis,
                )),
            IconButton(
                onPressed: () {
                  uploadReportController.cancelFile();
                },
                icon: Icon(Icons.cancel))
          ],
        ),
      ),
    );
  }

  bottonButton(BuildContext context) {
    return CustomButton(
      text: "Upload",
      onPressed: () {
        if (uploadReportController.fileTypePdf) {
          if (uploadReportController.file.size < 5000000) {
            uploadReportController.uploadFile(context);
          } else {
            GlobalAlert(context, "File is too Big",
                "Please upload a pdf of size bellow 5mb", DialogType.warning,
                onTap: () {});
          }
        } else {
          GlobalAlert(
              context,
              "File is not Pdf",
              "Only Pdf File is Accepted,\n Please Upload Pdf file",
              DialogType.warning,
              onTap: () {});
        }
      },
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
    );
  }

  getSkipButton(BuildContext context) {
    return skipButton(onTap: () {
      uploadReportController.skipFun();
    });
  }
}
