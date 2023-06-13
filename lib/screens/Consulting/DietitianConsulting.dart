import 'dart:async';
import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/shimmer/gf_shimmer.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

import '../../GlobalWidget/customAppBars.dart';
import '../../GlobalWidget/customTimePicker.dart';
import '../../GlobalWidget/globalAlert.dart';
import '../../GlobalWidget/loading_widget.dart';
import '../../Models/TimeSlotModel/TimeSlotModel.dart';
import '../../Utlis/ApiUtlis.dart';
import '../../Utlis/globalFunctions.dart';
import '../../contants/Constants.dart';
import '../../contants/colors.dart';
import '../../contants/images.dart';
import '../Dashboard/DashboardScreen.dart';

class DietitianConsulting extends StatefulWidget {
  @override
  State<DietitianConsulting> createState() => _DietitianConsultingState();
}

class _DietitianConsultingState extends State<DietitianConsulting> {
  List<bool> selected = List.generate(3, (index) => false);
  List<TimeSlotsModel>? timeSlotFromApi;
  List<String>? timeSlotsGlobal = [];

  var timeSlotsAvailble = true;
  var dayIsSunday = true;
  var timeSlotsLoaded = false;
  var selectedDate;

  DatePickerController _controller = DatePickerController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => stepOne());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: kPrimaryWhite,
      appBar:
          appBarWithBack(context, showBack: true, title: "Book Appointment"),
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            //date picker
            Container(
              height: h * 0.13,
              decoration: BoxDecoration(
                  border: Border.all(
                    color: plansBorderColor, // set border color
                    width: 0.50, // set border width
                  ),
                  borderRadius: BorderRadius.circular(10.0)),
              margin: EdgeInsets.all(15),
              child: DatePicker(
                DateTime.now().add(Duration(days: 3)),
                daysCount: 15,
                width: w / 5,
                height: h / 7,
                controller: _controller,
                initialSelectedDate: DateTime.now().add(Duration(days: 3)),
                selectionColor: mainColor,
                selectedTextColor: kPrimaryWhite,
                onDateChange: (date) {
                  if (date.weekday != DateTime.sunday) {
                    dateChanged(date);
                  } else {
                    setState(() {
                      dayIsSunday = true;
                    });
                  }
                },
              ),
            ),
            //  Time Picker
            //   Obx(()=> getListOfTimes(context),),
            timeSlotsLoaded
                ? dayIsSunday
                    ? bookNotAvailableImageWeekEnd()
                    : timeSlotsAvailble
                        ? getListOfTimes(context)
                        : bookNotAvailableImage()
                : shimmerEffect(context)
          ],
        ),
      ),
    );
  }

  getListOfTimes(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Container(
      margin: EdgeInsets.only(top: 20),
      height: h * 0.7,
      width: w * 0.95,
      // color: Colors.grey,
      child: ListView.builder(
          itemCount: timeSlotsGlobal!.length,
          itemBuilder: (BuildContext context, int index) {
            var time = timeSlotsGlobal![index];
            return CustomTimePicker(
              onPressed: () {
                selected = List.generate(selected.length, (index) => false);
                setState(() {
                  selected[index] = true;
                });

                var i = selected.indexOf(true);
                var selectedTime = timeSlotsGlobal![i];
                print(
                    "selected ====> $selectedTime  ${timeSlotFromApi![i].session}");
                final splitted = timeSlotsGlobal![index].split('-');
                print("Splitted is $splitted");
                var startTime = splitted[0].trim();
                var endTime = splitted[1].trim();
                // var startTime = timeSlotFromApi![i].slotStartTime;
                // var endTime = timeSlotFromApi![i].slotEndTime;
                var available = timeSlotFromApi![i].session;
                if (available.toLowerCase() == 'ongoing') {
                  GlobalAlertQuestion(
                      context,
                      "Please Confirm",
                      "Are you Sure you want to book, \nbetween ${timeSlotsGlobal![i]}, on $selectedDate?",
                      DialogType.question, onTap: () {
                    bookConsulting(selectedDate, i, startTime, endTime);
                  });
                } else if (available.toLowerCase() == 'Already Booked') {
                  GlobalAlert(context, "Booking Unavailable",
                      "You have already booked this slot", DialogType.warning,
                      onTap: () {});
                } else {
                  GlobalAlert(
                      context,
                      "Booking Unavailable",
                      "All slots are book for \n${timeSlotsGlobal![i]}, on $selectedDate",
                      DialogType.warning,
                      onTap: () {});
                }
              },
              selected: selected[index],
              text: "$time",
              available: true,
            );
          }),
    );
  }

  Future<void> getTimeSlots(String formatedDate) async {
    try {
      loadingWithText(context, "Please wait, Loading.....");
      var header = getHeader();
      var response = await get(
          Uri.parse(base_url + getTimeSlotsUrl + "$formatedDate"),
          headers: header);

      print('This is Token ++++++++++> ${response.statusCode}');
      print('This is Token ++++++++++> ${response.body}');
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        var timeSlotData = data['data'];
        timeSlotFromApi = timeSlotData
            .map<TimeSlotsModel>((obj) => TimeSlotsModel.fromJson(obj))
            .toList();

        print("DATETEST ====> ${timeSlotData} $timeSlotFromApi");
        for (var i = 0; i < timeSlotFromApi!.length; i++) {
          timeSlotsGlobal?.add(
              "${convertTo12HourFormat(timeSlotFromApi![i].slotStartTime)} - ${convertTo12HourFormat(timeSlotFromApi![i].slotEndTime)}");

          print("=======> time slots array ${timeSlotsGlobal} ");
        }
        selected = List.generate(timeSlotsGlobal!.length, (index) => false);

        stopLoading(context);

        /// stops loading
        setState(() {
          dayIsSunday = false;
          timeSlotsAvailble = true;
          timeSlotsLoaded = !timeSlotsLoaded;
        });
      } else if (response.statusCode == 422) {
        Navigator.pop(context);
        var data = jsonDecode(response.body.toString());
        print('This is Token ${response.body}');
        var msg = data['message'];
        setState(() {
          timeSlotsAvailble = false;
          dayIsSunday = false;
          timeSlotsLoaded = true;
        });
        GlobalAlert(context, "Cannot Book", "$msg", DialogType.warning,
            onTap: () {});
      } else if (response.statusCode == 500) {
        stopLoading(context);

        /// stops loading
        GlobalAlert(
            context,
            "Server Error",
            "The server has encountered an Error, Please Restart the App",
            DialogType.warning,
            onTap: () {});
      } else if (response.statusCode == 401 ||
          response.statusCode == 302 ||
          response.statusCode == 403) {
        SessionExpiredFun();
      }
    } catch (e) {
      print("this is error $e ");
      throw Exception('Failed to load Timeslots reason is $e');
    }
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
                        height: h * 0.04,
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

  void bookConsulting(
    date,
    int i,
    String startTime,
    String endTime,
  ) async {
    loadingWithText(context, "Loading.. Please Wait");
    try {
      print("In Booking Function ====> $startTime || $endTime");
      var urlIs = Uri.parse(base_url + bookSlotUrl); // Url

      var header = getHeader(); // headers
      var response = await post(urlIs, headers: header, body: {
        "date": date,
        "start_time": startTime,
        "start_end": endTime,
        "comment": "remove comment option"
      });
      print(
          "Appointment booking response ======> ${response.statusCode}  ${response.body}");

      if (response.statusCode == 200) {
        Navigator.pop(context); // Closing loading
        GlobalAlert(
            context, "Success", "Appointment is Booked", DialogType.success,
            onTap: () {});
        Timer(Duration(seconds: 2), () {
          Get.offAll(() => DashboardScreen());
        });
      } else if (response.statusCode == 500) {
        GlobalAlert(
            context,
            "Server Error",
            "The server has encountered an Error, Please Restart the App",
            DialogType.warning,
            onTap: () {});
      } else if (response.statusCode == 401 ||
          response.statusCode == 302 ||
          response.statusCode == 403) {
        SessionExpiredFun();
      } else {
        var data = jsonDecode(response.body.toString());
        var message = data['message'];
        Navigator.pop(context);
        GlobalAlert(context, "Failed", message, DialogType.warning,
            onTap: () {});
      }
    } catch (e) {
      Navigator.pop(context); // Closing Loading
      print("Appointment Error $e");
    }
  }

  bookNotAvailableImageWeekEnd() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 88.0),
          child: Container(
            height: MediaQuery.of(context).size.width * 0.5,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(calenderVector), scale: 0.01),
            ),
          ),
        ),
        Text("We don't accept Appointment on Sunday \n Please Change Date",
            textAlign: TextAlign.center),
      ],
    );
  }

  bookNotAvailableImage() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 88.0),
          child: Container(
            height: MediaQuery.of(context).size.width * 0.5,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(calenderVector), scale: 0.01),
            ),
          ),
        ),
        Text("No Booking Available", textAlign: TextAlign.center),
      ],
    );
  }

  void stepOne() {
    var newdate = DateTime.now().add(Duration(days: 3));
    var formatedDate = DateFormat('dd/MM/yyyy').format(newdate);
    print("new date  is $formatedDate");
    selectedDate = formatedDate;
    if (newdate.weekday != DateTime.sunday) {
      print("new date  is $formatedDate");
      getTimeSlots(formatedDate);
    } else {
      setState(() {
        timeSlotsLoaded = true;
      });
    }
  }

  void dateChanged(DateTime date) {
    timeSlotsGlobal?.clear();
    selected.clear();
    timeSlotFromApi?.clear();
    var formatedDate = DateFormat('dd/MM/yyyy').format(date);
    print("new date  is $formatedDate");
    setState(() {
      timeSlotsLoaded = false;
    });
    selectedDate = formatedDate;
    getTimeSlots(formatedDate);
  }
}
