import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart';
import '../../Utlis/globalFunctions.dart';
import '../../contants/colors.dart';
import '../../screens/Chat/ChatScreen.dart';
import '../../screens/SubscriptionScreen/ActivePlanScreen.dart';

import '../GlobalWidget/globalAlert.dart';
import '../GlobalWidget/loading_widget.dart';
import '../Utlis/ApiUtlis.dart';
import '../contants/Constants.dart';
import '../screens/Batches/SelectBatch.dart';

class DashboardController extends GetxController {
  GetStorage box = GetStorage();

  var loadingDone = false.obs;
  var bannersList = [].obs;
  var yogaBatchChosen = false.obs;
  var userNameToGreet = ''.obs;

  var showMsgPop = false.obs;
  var featuresAvail = "".obs;

  @override
  void onInit() {
    // TODO: implement onInit
    getBannerList();
    // getStaffIdForChat();
    subscriptionStatus();
    getFcmToken();

    super.onInit();
  }

  featuresAvailToUSer() async {
    var features = await usersFeaturesAvail();
    featuresAvail.value = features;
    print("============== > $features");
  }

  getBannerList() async {
    var url = Uri.parse(base_url + bannerListUrl);
    final response = await get(url);
    print("get banner lisnks ${response.statusCode} ${response.body}");
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());
      var imagesList = data["data"];
      var imagesListLength = data["data"].length;
      print("images List $bannersList");
      for (var i = 0; i < imagesList.length; i++) {
        bannersList.add(imagesList[i]['image']);
      }
      print("images List $bannersList ${box.read(userName)}");
    } // response body
    userNameToGreet.value = box.read(userName);
  }

  Future<bool> subscriptionStatus() async {
    print("subscription status check before =======> ");
    var subscribed = await checkSubscriptionStatus();
    await featuresAvailToUSer();
    await getMessageCountFun();
    print("subscription status after =======> $subscribed");
    box.write(isSubscribed, subscribed);
    loadingDone.value = true;
    if (!subscribed) {
      subscriptionExpired();
    }
    return subscribed;
    print("subscription status $subscribed");
  }

  chatWithDietitian(BuildContext context) async {
    loadingWithText(context, "Please wait, Loading");
    var status = await checkSubscriptionStatus();
    stopLoading(context);

    /// stop loading
    print("subscribed in dashboard =======> $status");
    if (status) {
      var staffId = await getStaffIdForChat();
      print("staff id start chat =============>$staffId");
      if (staffId == "422") {
        GlobalAlert(context, "No Appointments",
            "Please Book an Appointment First!", DialogType.warning,
            onTap: () {});
      } else if (staffId != "null") {
        // var stringDate = box.read(chatStartDate).toString();
        // DateTime dateTime = DateFormat('dd/MM/yyyy hh:mm a').parse(stringDate);
        // print("=========================================================================================> $dateTime");
        //
        // var now = DateTime.now();
        // var dontStartChat = now.isBefore(dateTime);
        // print("====================================================> $dontStartChat");
        // if(dontStartChat) {
        //   GlobalAlert(context, "Cannot Start Chat", "You cannot chat before \n$stringDate", DialogType.warning,onTap: (){});
        // }else{
        Get.to(() => ChatScreen(), arguments: [staffId]);
        // }
      } else {
        GlobalAlert(
            context,
            "Dietitian Not Assigned",
            "Please wait, you have not been assigned any Dietitian Yet",
            DialogType.warning,
            onTap: () {});
      }
    } else {
      subscriptionExpired();
    }
  }

  Future<void> selectBatch(BuildContext context) async {
    var now = DateTime.now();
    var dayIsSatSun = await now.weekday == DateTime.saturday ||
        now.weekday == DateTime.sunday;
    var bactchSelected = await getCurrentBatch();
    print("batches selctyed $bactchSelected $dayIsSatSun");
    if (bactchSelected) {
      if (dayIsSatSun) {
        Get.to(() => SelectYogaBatch());
      } else {
        GlobalAlert(context, "You have already Selected!",
            "You can change Batch on Saturdays or Sundays", DialogType.warning,
            onTap: () {});
      }
    } else {
      Get.to(() => SelectYogaBatch());
    }
  }

  subscriptionExpired() {
    Future.delayed(Duration.zero, () {
      Get.defaultDialog(
        barrierDismissible: false,
        titlePadding: EdgeInsets.only(top: 20),
        title: "Subscription Expired",
        content: Container(
          width: Get.width,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 12, right: 12, bottom: 12),
                child: Divider(),
              ),
              Center(
                child: Wrap(
                  spacing: 8,
                  children: [
                    Text(
                      'Your Subscription has Expired, Please Renew your Subscription',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: InkWell(
                          onTap: () {
                            Get.to(() => ActivePlanScreen());
                          },
                          child: Container(
                            margin: EdgeInsets.all(12),
                            child: Center(
                                child: Text(
                              "Renew Subscription",
                              style: TextStyle(color: Colors.white),
                            )),
                            color: mainColor,
                            height: 50,
                            width: Get.width,
                          )),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  getStaffIdForChat() async {
    try {
      var header = getHeader();
      var url = Uri.parse(base_url + getStaffIdForChatUrl);
      final response = await get(url, headers: header);
      print("staff id  >>>>>>>>>>>>>>>>>>> ===> ${response.statusCode}");
      print("staff id  ===> ${response.body}");
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        var id = data["staff_id"];
        var name = data['name'] ?? "Ask";
        var lastName = data['last_name'] ?? "Dietitian";

        box.write(dietitianName, '$name $lastName');

        if (id != null) {
          box.write(currentStaffIdForChat, id.toString());
        }
        print("staff id ======> $id");
        return id.toString();
      } else if (response.statusCode == 422) {
        return "422";
      } else {
        return "null";
      }
    } catch (e) {
      print("getting staff id error $e");
      throw Exception();
    }
  }

  Future<void> getFcmToken() async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    print("fcm ===========> $fcmToken");
  }

  getCurrentBatch() async {
    try {
      var header = getHeader();
      var url = Uri.parse(base_url + getCurrentBatchUrl);
      final response = await get(url, headers: header);
      print("batches selected  ===> ${response.statusCode}");
      print("batches selected ===> ${response.body}");
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        var batches = data["data"]["batches"].length;
        print("======================> $batches");
        if (batches == 0) {
          return false;
        } else {
          return true;
        }
      } else if (response.statusCode == 422) {
        return false;
      } else if (response.statusCode == 500) {
        return false;
      } else if (response.statusCode == 401 ||
          response.statusCode == 302 ||
          response.statusCode == 403) {
        SessionExpiredFun();
      } else {
        return "null";
      }
    } catch (e) {
      print("subscription status error $e");
      throw Exception();
    }
  }

  getMessageCountFun() async {
    showMsgPop.value = false;
    try {
      GetStorage box = GetStorage();
      var header = getHeader();
      var url = Uri.parse(base_url + chatWithListUrl);
      final response = await get(url, headers: header);
      print("message count status  ===> ${response.statusCode}");
      print("subscription status ===> ${response.body}");
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        // chatWithModel = ChatWithModel.fromJson(data);
        var count = box.read(msgCountDashboard);
        print("count----------- ===> | ${data.length > count} }");

        // for loop
        for (int i = 0; i < data.length; i++) {
          print("count----------- ===> | ${data[i]["readcount"]} }");
          if (data[i]["readcount"] > 0) {
            showMsgPop.value = true;
            break;
          }
        }
        // if(data.length > count){
        //   showMsgPop.value = true;
        // }
      } else {}
    } catch (e) {
      print("subscription status error $e");
      throw Exception();
    }
  }
}
