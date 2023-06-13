import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart';

import '../../Models/SubscriptionPlans/ActivePlanModel.dart';
import '../../Utlis/ApiUtlis.dart';
import '../../Utlis/globalFunctions.dart';
import '../../contants/Constants.dart';
import '../../screens/SubscriptionScreen/Renew/RenewPayScreen.dart';

class ActivePlanController extends GetxController {
  GetStorage box = GetStorage();
  ActivePlanModel activePlanModel = ActivePlanModel();
  var daysRemain = 0.obs;

  var dataLoaded = false.obs;
  var planBought = false.obs;

  @override
  void onInit() {
    getActivePlan();
    super.onInit();
  }

  Future<void> getActivePlan() async {
    try {
      var header = getHeader();
      var uri = Uri.parse(base_url + currentActivePlanUrl);
      var response = await get(uri, headers: header);
      print(
          "getting active Packages =====> ${response.statusCode} ${response.body}");
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        var packageData = data[0];
        print("package data ===> $packageData");
        activePlanModel = ActivePlanModel.fromJson(packageData);
        print("package name ========> ${activePlanModel.name}");

        calculateDaysLeft();
        planBought.value = !planBought.value;
        dataLoaded.value = !dataLoaded.value;
      } else if (response.statusCode == 422) {
        daysRemain.value = 0;
        dataLoaded.value = !dataLoaded.value;
      } else if (response.statusCode == 500) {
      } else if (response.statusCode == 401 ||
          response.statusCode == 302 ||
          response.statusCode == 403) {
        SessionExpiredFun();
      }
    } catch (e) {
      print("error while getting actibve packages $e");
    }
  }

  void calculateDaysLeft() {
    var endDate = activePlanModel.endsAt!;
    var now = DateTime.now();
    var dateFromApi = DateTime(endDate.year, endDate.month, endDate.day);
    var todayDate = DateTime(now.year, now.month, now.day);
    print(
        "===================================================================== > $dateFromApi $todayDate");
    Duration dayLeft = dateFromApi.difference(todayDate);
    daysRemain.value = dayLeft.inDays;
    print("Days Left ======> ${dayLeft.inDays}   , ${DateTime.now()}");

    box.write(dayLeftFromExpiry, dayLeft.inDays.toString());
  }

  renewPackageBuy() {
    Get.to(() => RenewPayScreen(), arguments: [
      {"program_id": activePlanModel.id.toString()}
    ]);
  }
}
