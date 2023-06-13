import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';
import 'package:getwidget/components/checkbox_list_tile/gf_checkbox_list_tile.dart';
import 'package:getwidget/types/gf_checkbox_type.dart';
import 'package:http/http.dart';
import '../../GlobalWidget/customAppBars.dart';
import '../../contants/colors.dart';
import '../../screens/SubscriptionScreen/ProgramDetailsScreen.dart';

import '../../GlobalWidget/CustomButton.dart';
import '../../GlobalWidget/globalAlert.dart';
import '../../Models/SubscriptionPlans/ProgramListModel.dart';
import '../../Utlis/ApiUtlis.dart';
import '../../Utlis/globalFunctions.dart';
import '../../contants/Constants.dart';
import '../auth/LoginScreen.dart';
import 'SubscriptionScreen.dart';

class ProgramListScreen extends StatefulWidget {
  ProgramListScreen({Key? key}) : super(key: key);

  @override
  State<ProgramListScreen> createState() => _ProgramListScreenState();
}

class _ProgramListScreenState extends State<ProgramListScreen> {
  ProgramListModel programListModel = ProgramListModel();
  List<int> _selectedItems = [];
  var _selectedPref = [];
  var dataLoaded = false;

  @override
  void initState() {
    getProgramData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: kPrimaryWhite,
      appBar:
          appBarWithBack(context, showBack: false, title: "Program We Offer"),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                // color: Colors.red,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                width: w * 0.95,
                child: Text(
                  "These are some of the Programs we Offer,Please Select Any Three that you are interested in",
                  style: TextStyle(
                    color: mainColor,
                  ),
                ),
              ),
            ),
            Container(
              width: w,
              height: h * 0.8,
              child: Stack(
                children: [
                  dataLoaded ? getList(context) : Container(),
                  dataLoaded
                      ? Align(
                          alignment: Alignment.bottomCenter,
                          child: bottomNavigationButton(context))
                      : Container(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  getList(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Container(
      height: h * 0.72,
      child: ListView.builder(
        itemCount:
            programListModel.list!.length, // Replace with your own list length
        itemBuilder: (BuildContext context, int index) {
          var data = programListModel.list![index];
          var image = data.image;
          var name = data.program;

          return GFCheckboxListTile(
            titleText: '$name',
            avatar: GFAvatar(
              backgroundImage: NetworkImage('$image'),
            ),
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
                if (value) {
                  if (_selectedItems.length < 3) {
                    _selectedItems.add(data.id);
                    _selectedPref.add(data);
                  } else {
                    // Limit selection to 3 items
                    value = false;
                  }
                } else {
                  _selectedItems.remove(data.id);
                  _selectedPref.remove(data);
                }
              });
            },
            value: _selectedItems.contains(data.id),
            inactiveIcon: null,
          );
        },
      ),
    );
  }

  bottomNavigationButton(BuildContext context) {
    return CustomButton(
      text: "Next",
      onPressed: () async {
        print("selected ===> items ===> $_selectedItems  $_selectedPref");
        _selectedItems.length < 1
            ? Get.to(() => SubscriptionScreen())
            : sendProgramPref(context);
        // Get.to(()=>ProgramDetailsScreen(),arguments: [{"selected" : _selectedItems}]);
      },
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 18),
    );
  }

  Future<void> getProgramData() async {
    try {
      var header = {'Accept': 'application/json'};
      var uri = Uri.parse(base_url + getProgramsUrl);
      var response = await get(uri, headers: header);
      print("getting Packages ${response.statusCode} ${response.body}");
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        var packageData = data['package'];
        print("package data $data");
        print("package data $packageData");
        programListModel = ProgramListModel.fromJson(data);
        print("package data ${programListModel.list![0].image}");
        setState(() {
          dataLoaded = true;
        });
      } else if (response.statusCode == 500) {
        Get.back();
      } else if (response.statusCode == 401 ||
          response.statusCode == 302 ||
          response.statusCode == 403) {
        clearAllStorageData();
        Get.offAll(() => LoginScreen());
      }
    } catch (e) {
      print("error while getting packages list");
    }
  }

  Future<void> sendProgramPref(BuildContext context) async {
    try {
      // convert the array to a JSON string
      String jsonString = jsonEncode(_selectedItems);
      var header = {'Accept': 'application/json'};
      var body = {"explorepack": jsonString};
      print("=====> $jsonString $_selectedItems $body");
      var uri = Uri.parse(base_url + sendProgramsPrefUrl);
      var response = await post(uri, headers: header, body: body);
      print("getting Packages ${response.statusCode} ${response.body}");
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        print("data ======> $data");
        Get.to(() => ProgramDetailsScreen(), arguments: [
          {"selected": _selectedPref}
        ]);
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
        // SessionExpiredFun();
        Get.to(() => ProgramDetailsScreen(), arguments: [
          {"selected": _selectedPref}
        ]);
      }
    } catch (e) {
      print("error sending pref =====> $e");
    }
  }
}
