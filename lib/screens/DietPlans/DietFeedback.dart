import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/checkbox_list_tile/gf_checkbox_list_tile.dart';
import 'package:getwidget/types/gf_checkbox_type.dart';
import 'package:http/http.dart';

import '../../GlobalWidget/CustomButton.dart';
import '../../GlobalWidget/customAppBars.dart';
import '../../GlobalWidget/globalAlert.dart';
import '../../GlobalWidget/loading_widget.dart';
import '../../Models/DietModel/DietListModel.dart';
import '../../Utlis/ApiUtlis.dart';
import '../../Utlis/globalFunctions.dart';
import '../../contants/Constants.dart';
import '../../contants/colors.dart';

class DietFeedback extends StatefulWidget {
  DietFeedback({Key? key}) : super(key: key);

  @override
  State<DietFeedback> createState() => _DietFeedbackState();
}

class _DietFeedbackState extends State<DietFeedback> {
  List<bool> selected = [];
  List<int> idList = [];
  var sendFoodData = [];
  List<String> foodNameList = [];
  int groupValue = 0;
  bool isChecked = false;
  var index;
  dynamic arguments = Get.arguments;
  DietListModel listModel = DietListModel();
  TextEditingController feedbackCon = TextEditingController();

  @override
  void initState() {
    asyncTask();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: kPrimaryWhite,
      bottomNavigationBar: bottomNavigationButton(context),
      appBar: appBarWithBack(context, showBack: true, title: "Follow Up"),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Container(
                width: w * 0.9,
                margin: EdgeInsets.only(top: 20, bottom: 4),
                // color: kPrimaryGreen,
                child: Text(
                  "Did you Follow the Diet Plan?",
                  style: TextStyle(
                      color: kPrimaryBlack,
                      fontWeight: FontWeight.w400,
                      fontSize: w * 0.048),
                ),
              ),
              Container(
                width: w * 0.9,
                margin: EdgeInsets.only(top: 4, bottom: 20),
                // color: kPrimaryGreen,
                child: Text(
                  "Tick on each food you ate, that was in your diet chart",
                  style: TextStyle(
                      color: textMuted,
                      fontWeight: FontWeight.w400,
                      fontSize: w * 0.035),
                ),
              ),
              Divider(
                indent: 20,
                endIndent: 20,
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                // height: h*0.5,
                child: getListfoodList(context),
              ),
              Container(
                margin: EdgeInsets.all(15),
                child: getCommentWidget(),
              )
            ],
          ),
        ),
      ),
    );
  }

  getCommentWidget() {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 5),
      child: Container(
        width: w / 1.1,
        height: h / 5,
        margin: const EdgeInsets.symmetric(vertical: 2),
        padding: const EdgeInsets.symmetric(vertical: 2),
        decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
          child: TextField(
            maxLength: 120,
            controller: feedbackCon,
            decoration: InputDecoration(
                counterText: "",
                helperText: ' ',
                border: InputBorder.none,
                hintText: 'If No, Please Mention why?',
                hintStyle:
                    TextStyle(color: kHintText, fontWeight: FontWeight.w400)),
            keyboardType: TextInputType.multiline,
            minLines: 1, // <-- SEE HERE
            maxLines: 3, // <-- SEE HERE
          ),
        ),
      ),
    );
  }

  bottomNavigationButton(BuildContext context) {
    return CustomButton(
      text: "Submit",
      onPressed: () async {
        await mapData();
        var userId = listModel.dietData![index].userId.toString();
        var staffId = listModel.dietData![index].staffId.toString();
        var nutritionDataId =
            listModel.dietData![index].foods![0].nutritionDataId.toString();
        var nutritionTime = listModel.dietData![index].nutritionTime.toString();
        var date = listModel.dietData![index].date.toString();
        print(
            "dietData ======================================================================================> $date");

        if (feedbackCon.text.length < 1) {
          GlobalAlert(context, "Please Add Comment", "Comment cannot be empty!",
              DialogType.warning,
              onTap: () {});
        } else {
          submitToApi(userId, staffId, nutritionDataId, nutritionTime, date);
        }

        sendFoodData.clear();
      },
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
    );
  }

  Future<void> submitToApi(String userId, String staffId,
      String nutritionDataId, String nutritionTime, String date) async {
    // try{
    loadingWithText(context, "Please Wait, Loading ....");
    print("==============> ${json.encode(sendFoodData)}");
    var url = Uri.parse(base_url + dietFollowedFeedbackUrl);
    var data = {
      "user_id": userId,
      "staff_id": staffId,
      "nutrition_data_id": nutritionDataId,
      "nutrition_time": nutritionTime,
      "date": date,
      "foods": json.encode(sendFoodData),
      "comment": feedbackCon.text.toString()
    };
    var header = getHeader();
    final response = await post(url, body: data, headers: header);
    print(" Sumity response is ${response.statusCode} ${response.body}");
    if (response.statusCode == 200) {
      // response body
      var data = jsonDecode(response.body.toString());

      stopLoading(context);

      ///** Stop Loading
      ///
      Get.back(result: true);
    } else if (response.statusCode == 422) {
      stopLoading(context);

      ///** Stop Loading
    } else if (response.statusCode == 500) {
      stopLoading(context);

      ///** Stop Loading
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
      stopLoading(context);

      ///** Stop Loading
      throw Exception();
    }
    // }catch(e){
    //   stopLoading(context); ///** Stop Loading
    //   print("error is $e" );
    //   throw Exception();
    // }
  }

  getListfoodList(BuildContext context) {
    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: listModel.dietData![index].foods!.length,
        itemBuilder: (BuildContext context, int i) {
          var data = listModel.dietData![index].foods![i];
          return GFCheckboxListTile(
            titleText: data.foodName,
            size: 25,
            activeBgColor: Colors.green,
            type: GFCheckboxType.circle,
            activeIcon: Icon(
              Icons.check,
              size: 15,
              color: Colors.white,
            ),
            onChanged: (value) {
              setState(() {
                selected[i] = value;
              });
            },
            value: selected[i],
            inactiveIcon: null,
          );
        });
  }

  void asyncTask() {
    print("in feedback ===================== ${arguments[0]["dietData"]}");
    listModel = arguments[0]["dietData"];
    index = arguments[0]["index"];
    selected = List.generate(
        listModel.dietData![index].foods!.length, (index) => false);
    var data = listModel.dietData![index].foods!;
    for (var i = 0; i < listModel.dietData![index].foods!.length; i++) {
      idList.add(data[i].id!);
      foodNameList.add(data[i].foodName!);
    }
    print("ids ===============> $idList");
    print("ids ===============> $foodNameList");
  }

  Future<void> mapData() async {
    for (var i = 0; i < idList.length; i++) {
      Map<String, dynamic> data = {
        "food_id": idList[i].toString(),
        "consent": selected[i] ? "Yes" : "No",
      };
      String jsonData = json.encode(data);
      sendFoodData.add(data);
    }

    print("==============> $sendFoodData");
  }
}
