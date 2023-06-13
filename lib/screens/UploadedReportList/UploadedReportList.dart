import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/shimmer/gf_shimmer.dart';
import 'package:intl/intl.dart';
import '../../GlobalWidget/customAppBars.dart';
import '../../contants/colors.dart';
import '../../screens/UploadedReportList/PdfViewer.dart';
import '../../screens/UserDetails/UploadReportScreen.dart';

import '../../GlobalWidget/CustomButton.dart';
import '../../contants/images.dart';
import '../../controllers/UploadReportController/UploadedReportListController.dart';

class UploadedReportList extends GetView<UploadedReportListController> {
  final UploadedReportListController controller =
      Get.put(UploadedReportListController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: bottomPart(context),
      backgroundColor: kPrimaryWhite,
      appBar:
          appBarWithBack(context, showBack: true, title: "Uploaded Reports"),
      body: Obx(() => controller.dataLoaded.value
          ? controller.dataEmpty.value
              ? noUploadedReports(context)
              : getList(context)
          : shimmerEffect(context)),
    );
  }

  Widget getList(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return Container(
      // color: Colors.red,
      child: ListView.builder(
          itemCount: controller.listModel.data!.length,
          itemBuilder: (BuildContext context, int index) {
            var data = controller.listModel.data![index];

            DateTime? date = data.date;
            print("GET LIST $date");
            final DateFormat formatter = DateFormat.yMMMd('en_US');
            var prescriptionDate = formatter.format(date!);
            return Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
              child: InkWell(
                onTap: () async {},
                child: Container(
                    height: h * 0.07,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        color: Colors.grey.shade100),
                    // color: Colors.grey.shade200,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            // color: Colors.red,
                            width: w * 0.45,
                            child: Text(
                              '${prescriptionDate}',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: w * 0.02,
                              ),
                              InkWell(
                                child: Container(
                                  height: w * 0.1,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                    // color: Colors.grey.shade300
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 12.0, vertical: 5.0),
                                    child: Center(
                                        child: Icon(
                                      Icons.picture_as_pdf,
                                      color: Colors.grey,
                                    )),
                                  ),
                                ),
                                onTap: () async {
                                  Get.to(() => PdfViewerScreen(),
                                      arguments: [data.file]);
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                    )),
              ),
            );
          }),
    );
  }

  noUploadedReports(BuildContext context) {
    return Center(
      child: Text('No Uploaded Reports'),
    );
  }

  Widget shimmerEffect(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.all(8),
              itemCount: 12,
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
                        height: 50,
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

  bottomPart(BuildContext context) {
    return CustomButton(
      text: "Upload",
      icon: ImageIcon(
        AssetImage(uploadIcon),
        color: kPrimaryWhite,
      ),
      onPressed: () {
        Get.to(() => UploadReportScreen(), arguments: ["reupload"]);
      },
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
    );
  }
}
