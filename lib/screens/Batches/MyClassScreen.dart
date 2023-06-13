import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/shimmer/gf_shimmer.dart';
import 'package:intl/intl.dart';

import '../../GlobalWidget/customAppBars.dart';
import '../../GlobalWidget/globalAlert.dart';
import '../../contants/colors.dart';
import '../../contants/images.dart';
import '../../controllers/Batch/MyClassController.dart';
import 'MyClassDetail.dart';

class MyClassScreen extends GetView<MyClassController> {
  final MyClassController myClassController = Get.put(MyClassController());

  var imageUrl =
      "https://png.pngtree.com/background/20211217/original/pngtree-outdoor-yoga-class-yoga-practitioner-picture-image_1593757.jpg";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryWhite,
      appBar: appBarWithBack(context, showBack: true, title: "My Batches"),
      body: SingleChildScrollView(
        child: Obx(() => myClassController.dataLoaded.value
            ? myClassController.noData.value
                ? noDataUi(context)
                : myClassController.nextClassNotAvailable.value
                    ? noClassAvailable()
                    : getList(context)
            : shimmerEffect(context)),
      ),
    );
  }

  getList(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return ListView.builder(
        itemCount: myClassController.myBatchesList.batch!.length,
        itemBuilder: (BuildContext context, int index) {
          var data = myClassController.myBatchesList.batch![index];
          var date =
              DateFormat.yMMMd('en_US').format(myClassController.dateToShow!);
          var startTime = data.batch!.startTime!;
          var endTime = data.batch!.endTime!;
          return InkWell(
            onTap: () {
              if (DateTime.now().isBefore(myClassController.dateToShow!)) {
                GlobalAlert(
                    context,
                    "Cannot Open Now",
                    "Please come back on $date,\n to see the details",
                    DialogType.warning,
                    onTap: () {});
              } else {
                Get.to(() => MyClassDetail(), arguments: [
                  {"batch_id": "${data.batchId}"}
                ]);
              }
            },
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              padding: EdgeInsets.all(15),
              // height: h*0.2,
              width: w * 0.9,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                gradient: LinearGradient(
                    colors: [
                      kTextRed,
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
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: kPrimaryWhite,
                        radius: w * 0.095,
                        backgroundImage: NetworkImage(data.batch!.image!),
                      ),
                      SizedBox(
                        width: w * 0.03,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: w * 0.45,
                            child: Text(
                              '${data.batch!.name}',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                  fontSize: w * 0.045),
                            ),
                          ),
                          SizedBox(
                            height: w * 0.01,
                          ),
                          Container(
                              width: w * 0.45,
                              child: Text(
                                ' Time : ${startTime} - ${endTime}',
                                style: TextStyle(
                                  fontSize: w * 0.025,
                                  color: Colors.white,
                                ),
                              )),
                          SizedBox(
                            height: w * 0.01,
                          ),
                          Container(
                              width: w * 0.45,
                              child: Text(
                                'Next Class : $date',
                                style: TextStyle(
                                  fontSize: w * 0.025,
                                  color: Colors.white,
                                ),
                              )),

                          // GFButton(
                          //   color: mainColor,
                          //   onPressed: (){
                          //     Get.to(()=>DietitianConsulting());
                          //   },
                          //   text: "Book Now",
                          //   padding: EdgeInsets.symmetric(horizontal: w*0.17),
                          // )
                        ],
                      ),
                    ],
                  ),
                  Icon(
                    Icons.arrow_right,
                    color: Colors.white,
                    size: 40,
                  ),
                ],
              ),
            ),
          );
        });
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
              itemCount: 9,
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
                        height: h * 0.12,
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

  noDataUi(BuildContext context) {
    return Container(
      child: Center(
        child: Text("Please Select A Batch First"),
      ),
    );
  }

  noClassAvailable() {
    return Container(
      child: Center(
        child: Text("No Further Classes Available"),
      ),
    );
  }
}
