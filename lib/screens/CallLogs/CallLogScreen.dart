import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/shimmer/gf_shimmer.dart';

import '../../GlobalWidget/customAppBars.dart';
import '../../contants/colors.dart';
import '../../controllers/CallLogs/CallLogController.dart';

class CallLogScreen extends GetView<CallLogController> {
  final CallLogController controller = Get.put(CallLogController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarWithBack(context, showBack: true),
        backgroundColor: kPrimaryWhite,
        body: Obx(() => controller.callLogsLoaded.value
            ? controller.callLogsNull.value
                ? Container(
                    child: Center(
                      child: Text('No Call'),
                    ),
                  )
                : getList(context)
            : shimmerEffect(context)));
  }

  Widget getList(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return ListView.builder(
        itemCount: 20,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () {},
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
              child: Container(
                  height: h * 0.10,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      color: Colors.grey.shade100),
                  // color: Colors.grey.shade200,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              height: h / 18,
                              width: h / 18,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(1000)),
                                color: kCallMissedRed,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0, vertical: 5.0),
                                child: Icon(
                                  Icons.call_made_rounded,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Container(
                              width: w * 0.6,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 18.0),
                                child: Text(
                                  '{date}, {timeNew}',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: h * 0.019),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )),
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
                        height: h * 0.10,
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
}
