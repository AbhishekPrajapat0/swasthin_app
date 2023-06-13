import 'dart:async';
import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

import '../../GlobalWidget/customAppBars.dart';
import '../../GlobalWidget/customTimePicker.dart';
import '../../GlobalWidget/globalAlert.dart';
import '../../GlobalWidget/loading_widget.dart';
import '../../Models/DietModel/DietDateListModel.dart';
import '../../Models/DietModel/DietListModel.dart';
import '../../Utlis/ApiUtlis.dart';
import '../../Utlis/globalFunctions.dart';
import '../../contants/Constants.dart';
import '../../contants/colors.dart';
import 'DietFeedback.dart';
import 'DietSubmittedFeedback.dart';

class DietDateScreen extends StatefulWidget {
  const DietDateScreen({Key? key}) : super(key: key);

  @override
  State<DietDateScreen> createState() => _DietDateScreenState();
}

class _DietDateScreenState extends State<DietDateScreen> {
  var reload = false;

  DietDateListModel dateListModel = DietDateListModel();
  DietListModel listModel = DietListModel();

  var dateLoaded = false;
  var dietLoaded = false;

  Timer? timer;
  var noDietPlan = true;
  List<bool>? selected;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => getDateSlots());
    timer = Timer.periodic(Duration(seconds: 2), (Timer t) => refresh());
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: kPrimaryWhite,
      appBar: appBarWithBack(context, showBack: true, title: "Diet Plans"),
      body: noDietPlan
          ? Center(
              child: Text("You don't have any Diet Plan"),
            )
          : SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        // color: Colors.red,
                        width: w * 0.92,
                        child:
                            dateLoaded ? getListOfTimes(context) : Container(),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Icon(Icons.arrow_right),
                        ],
                      )
                    ],
                  ),
                  // total Calories
                  dietLoaded
                      ? Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(12),
                              margin: EdgeInsets.all(16),
                              // height: 50,
                              width: w,
                              decoration: BoxDecoration(
                                border: Border.all(width: 1, color: textMuted),
                                color: plansBgColor,
                                borderRadius: BorderRadius.circular(
                                    10.0), // set border radius
                              ),
                              child: Container(
                                  width: w * 0.8,
                                  child: Text(
                                    "Total Calories : ${listModel.totalCalories == null ? "0" : listModel.totalCalories!.totalCalories} kcals",
                                    style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: w * 0.04),
                                  )),
                            ),
                            Container(
                              height: h * 0.68,
                              // color: kPrimaryBase,
                              child: dietLoaded
                                  ? getDietList(context)
                                  : Container(
                                      child: Center(
                                        child: Text("No Data Available"),
                                      ),
                                    ),
                            )
                          ],
                        )
                      : Container(
                          height: h * 0.6,
                          child: Center(
                            child: Text("No Data Available"),
                          ),
                        ),
                  // Total Calories
                ],
              ),
            ),
    );
  }

  getListOfTimes(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    print(
        "=========================================================\n${dateListModel.dietDate!.length}\n============================================================= ${selected!.length}");
    return Container(
      margin: EdgeInsets.only(top: 20),
      height: h * 0.08,
      // color: Colors.grey,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: dateListModel.dietDate!.length,
          itemBuilder: (BuildContext context, int index) {
            var data = dateListModel.dietDate![index];
            var date = data.date;
            String formattedDate = DateFormat('dd MMM yyyy').format(date);
            var formatedate = DateFormat("yyyy-MM-dd").format(date);

            return CustomTimePicker(
              // width: w*0.2,
              onPressed: () {
                selected = List.generate(
                    dateListModel.dietDate!.length, (index) => false);
                setState(() {
                  selected![index] = true;
                  dietLoaded = false;
                });

                getDiets(formatedate);
              },
              selected: selected![index],
              text: "$formattedDate",
              available: true,
            );
          }),
    );
  }

  Future<void> getDateSlots() async {
    try {
      loadingWithText(context, "Please wait, Loading.....");
      var header = getHeader();
      var response =
          await get(Uri.parse(base_url + dietDateUrl), headers: header);

      print('This is Token ================> ${response.statusCode}');
      print('This is Token =====================> ${response.body}');
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        dateListModel = DietDateListModel.fromJson(data);
        if (dateListModel.dietDate!.length != 0) {
          var date = dateListModel.dietDate![0].date;
          var formatedate = DateFormat("yyyy-MM-dd").format(date);
          print("Date =========> $date ===============> $formatedate");
          getDiets(formatedate);
        }
        setState(() {
          dateLoaded = true;
          if (dateListModel.dietDate!.length != 0) {
            selected = List.generate(dateListModel.dietDate!.length,
                (index) => index == 0 ? true : false);
            noDietPlan = false;
          }
        });
        stopLoading(context);

        /// stops loading
      } else if (response.statusCode == 422) {
        Navigator.pop(context);
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
      stopLoading(context);

      /// stops loading
      throw Exception('get dates of diet $e');
    }
  }

  getDietList(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return ListView.builder(
        // reverse: true,
        scrollDirection: Axis.vertical,
        itemCount: listModel.dietData!.length,
        itemBuilder: (BuildContext context, int index) {
          var data = listModel.dietData![index];
          var totalCal = listModel.dietData![index].nutritionCalories ?? "0";
          var mealName = data.nutritionTime!;
          // var time = "${convertTo12HourFormat(data.startTime!)}"
          //     " - ${convertTo12HourFormat(data.endTime!)}";

          var time = "${convertTo12HourFormat(data.startTime!)}";
          var foods = data.foods;
          var consent = foods!.length == 0 ? null : foods[0].consent;
          print(
              "=============foods $index=============> ${listModel.dietData!.length}");
          return Container(
            margin: EdgeInsets.all(12),
            // height: 100,
            width: w,
            decoration: BoxDecoration(
              color: kPrimaryWhite,
              border: Border.all(
                color: plansBorderColor, // set border color
                width: 0.50, // set border width
              ),
              borderRadius: BorderRadius.circular(10.0), // set border radius
            ),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  // height: 50,
                  width: w,
                  decoration: BoxDecoration(
                    color: mainColor,
                    // border: Border.all(
                    //   color: plansBorderColor, // set border color
                    //   width: 0.50, // set border width
                    // ),
                    borderRadius:
                        BorderRadius.circular(10.0), // set border radius
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          width: w * 0.8,
                          child: Text(
                            "$mealName :- $time",
                            style: TextStyle(
                                color: Colors.white, fontSize: w * 0.04),
                          )),
                      Container(
                          padding: EdgeInsets.only(top: 5),
                          width: w * 0.8,
                          child: Text(
                            "Calories : $totalCal kcals",
                            style: TextStyle(
                                color: Colors.white, fontSize: w * 0.03),
                          )),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(12),
                  // margin: EdgeInsets.only(bottom: 112),
                  width: w,
                  child: Column(
                    children: [
                      getFoodName(data.foods!),
                      SizedBox(
                        height: h * 0.02,
                      ),
                      Divider(),
                      //show this only if food was given
                      foods!.length == 0
                          ? Text(
                              "No Foods in $mealName Meal",
                              style: TextStyle(fontSize: w * 0.03),
                            )
                          : InkWell(
                              onTap: () async {
                                print("=======clicked =============>");
                                if (consent == null) {
                                  final result = await Get.to(
                                      () => DietFeedback(),
                                      arguments: [
                                        {"dietData": listModel, "index": index}
                                      ]);
                                  print(
                                      ">>>>>>>>>>>>>>>>>>>>>>>>>>>>${result}");
                                  setState(() {
                                    reload = result;
                                  });
                                } else {
                                  Get.to(() => DietSubmittedFeedback(),
                                      arguments: [
                                        {"dietData": listModel, "index": index}
                                      ]);
                                }
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    consent == null
                                        ? "Did you Follow the Chart? Share with Dietitian"
                                        : "See submitted Feedback",
                                    style: TextStyle(fontSize: w * 0.03),
                                  ),
                                  Icon(Icons.arrow_right),
                                ],
                              ),
                            )
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }

  Future<void> getDiets(String formatedate) async {
    try {
      loadingWithText(context, "Please wait, Loading.....");
      var header = getHeader();
      var response = await get(
          Uri.parse(base_url + dietDateDetailUrl + formatedate),
          headers: header);

      print('This is Token ================> ${response.statusCode}');
      print('This is Token =====================> ${response.body}');
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        listModel = DietListModel.fromJson(data);
        if (listModel.dietData!.length != 0) {
          setState(() {
            dietLoaded = true;
          });
        }

        stopLoading(context);

        /// stops loading
      } else if (response.statusCode == 422) {
        Navigator.pop(context);
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
      throw Exception('Failed to get diet plans $e');
    }
  }

  getFoodName(List<Food> foods) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    print(
        "===================================================================>  ");
    return ListView.builder(
        // itemCount: foods.length,
        itemCount: foods.length,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          var foodName = foods[index].foodName;
          var quantity = foods[index].qty ?? "0";
          var calories = foods[index].calories! ?? "0";
          var carbs = foods[index].carbs! ?? "0";
          var fats = foods[index].fat! ?? "0";
          var protein = foods[index].proteins! ?? "0";
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      width: w * 0.6,
                      child: Text(
                        "$foodName",
                        style: TextStyle(fontSize: 15),
                      )),
                  Text(
                    "Quantity : $quantity",
                    style: TextStyle(color: textExtraMuted, fontSize: 12),
                  ),
                ],
              ),
              Container(
                  width: w * 0.6,
                  child: Text(
                    "Kcals : $calories | Carbs : $carbs g | Fats : $fats g | Proteins : $protein g",
                    style: TextStyle(color: textExtraMuted, fontSize: 12),
                  )),
              SizedBox(
                height: 10,
              ),
            ],
          );
        });
  }

  refresh() {
    if (reload) {
      setState(() {
        dateLoaded = false;
        dietLoaded = false;
        noDietPlan = true;
      });
      getDateSlots();
      setState(() {
        reload = false;
      });
    }
  }

  mutliplyData(double object, int qty) {
    var data = object * qty;
    return data.toStringAsFixed(1).toString();
  }
}
