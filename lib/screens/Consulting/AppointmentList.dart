import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/shimmer/gf_shimmer.dart';

import '../../GlobalWidget/customAppBars.dart';
import '../../contants/colors.dart';
import '../../contants/images.dart';
import '../../controllers/DietitianControllers/AppointmentListController.dart';
import '../../routes/Routes.dart';

class AppointmentListScreen extends GetView<AppointmentListController> {
  final AppointmentListController appointmentListController =
      Get.put(AppointmentListController());

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: kPrimaryWhite,
      appBar: appBarWithBack(context,
          showBack: true, title: "Dietitian Appointments"),
      body: Obx(() => appointmentListController.loadingIsOn.value
          ? ShimmerEffect(context)
          : appointmentListController.noAppointments.value
              ? noAppointmentsUi(context)
              : getListOfAppointments(context)),
    );
  }

  noAppointmentsUi(BuildContext context) {
    return Center(
      child: Text("You have No Appointment"),
    );
  }

  Widget getListOfAppointments(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    var data = appointmentListController.appointmentListModel.list!;
    return RefreshIndicator(
      onRefresh: refereshAppoinments,
      child: ListView.builder(
          itemCount: data.length,
          itemBuilder: (BuildContext context, int index) {
            var name = data[index].staffs?.name ?? "Dietitian not Assigned";
            var time = "${data[index].startTime} - ${data[index].startEnd}";
            var date = data[index].date;
            var status = data[index].status == 1
                ? "Upcoming"
                : data[index].status == 2
                    ? "Ongoing"
                    : data[index].status == 3
                        ? "Completed"
                        : data[index].status == 5
                            ? "Didn't Connect"
                            : data[index].status == 6
                                ? "Calling"
                                : "Cancelled";
            return InkWell(
              onTap: () {
                // Get.to(()=>AppointmentDetailsScreen(),arguments: [{"data":data[index]}]);
                Get.toNamed(Routes.APPOINTMENT_DETAIL_SCREEN, arguments: [
                  {"data": data[index]}
                ]);
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                child: Container(
                  height: h * 0.19,
                  decoration: BoxDecoration(
                    color: plansBgColor,
                    border: Border.all(
                      color: plansBorderColor, // set border color
                      width: 0.50, // set border width
                    ),
                    borderRadius:
                        BorderRadius.circular(10.0), // set border radius
                  ),
                  // color: Colors.grey.shade200,
                  child: Card(
                    elevation: 0,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 12.0),
                                    child: CircleAvatar(
                                      radius: h * 0.025,
                                      backgroundColor: Colors.grey.shade200,
                                      child: Padding(
                                        padding: const EdgeInsets.all(
                                            8), // Border radius
                                        child: ClipOval(
                                            child: Image.asset(
                                                color_dietitian_icon)),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: w * 0.5,
                                          child: Text(
                                            "$name",
                                            style: const TextStyle(
                                                fontSize: 14,
                                                overflow: TextOverflow.ellipsis,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsets.symmetric(vertical: 2),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.calendar_today,
                                                color: Colors.grey,
                                                size: h * 0.018,
                                              ),
                                              SizedBox(
                                                width: 4,
                                              ),
                                              Container(
                                                  width: w * 0.45,
                                                  child: Text(
                                                    "$date",
                                                    style: TextStyle(
                                                        fontSize: w * 0.03,
                                                        color: textMuted),
                                                  ))
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              data[index].status != 1
                                  ? Container()
                                  : Padding(
                                      padding: EdgeInsets.only(right: 12.0),
                                      child: InkWell(
                                        onTap: () {
                                          appointmentListController
                                              .cancelAppointment(
                                                  context, data[index].id!);
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.all(5.0),
                                          child: Icon(Icons.cancel_outlined),
                                        ),
                                      ),
                                    )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 28.0, vertical: 10),
                            child: Divider(),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.av_timer_rounded,
                                      color: Colors.grey,
                                      size: h / 45,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Container(
                                        width: w * 0.4,
                                        child: Text(
                                          "$time",
                                          style: TextStyle(fontSize: w * 0.03),
                                        ))
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 3.0),
                                  child: Container(
                                      decoration: BoxDecoration(
                                        color: data[index].status == 1 ||
                                                data[index].status == 2
                                            ? kPrimaryBlue
                                            : data[index].status == 3
                                                ? kPrimaryGreen
                                                : kPrimaryRed,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(500)),
                                      ),
                                      child: Container(
                                        width: w * 0.23,
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "$status",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.white),
                                        ),
                                      )),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }

  Widget ShimmerEffect(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return ListView.builder(
        itemCount: 3,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
            child: GFShimmer(
              mainColor: Colors.grey.shade200,
              secondaryColor: Colors.grey.shade300,
              child: Container(
                height: h * 0.19,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    color: Colors.white),
                // color: Colors.grey.shade200,
                child: Card(
                  elevation: 15.5,
                ),
              ),
            ),
          );
        });
  }

  Future<void> refereshAppoinments() async {
    controller.refresh();
  }
}
