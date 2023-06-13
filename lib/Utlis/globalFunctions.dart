import 'dart:convert';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Utlis/ApiUtlis.dart';
import '../../screens/auth/LoginScreen.dart';

import '../contants/Constants.dart';

SessionExpiredFun() async {
  GetStorage box = GetStorage();
  await DefaultCacheManager().emptyCache();
  clearAllStorageData();
  // Clear the cache

  Get.offAll(() => LoginScreen());
}

Future<bool> checkSubscriptionStatus() async {
  try {
    var header = getHeader();
    var url = Uri.parse(base_url + subscriptionStatusUrl);
    final response = await get(url, headers: header);
    print("subscription status  ===> ${response.statusCode}");
    print("subscription status ================> ${response.body}");
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());
      var status = data['status'];
      print("===> |$status|${status == 1}");
      if (status == 1) {
        print("===> returning true |$status|");
        return true;
      } else {
        print("===> returning false |$status|");
        return false;
      }
    } else {
      return false;
    }
  } catch (e) {
    print("subscription status error $e");
    throw Exception();
  }
}

clearAllStorageData() async {
  GetStorage box = GetStorage();
  final prefs = await SharedPreferences.getInstance();
  box.remove(loggedIn);
  box.remove(loginToken);
  box.remove(userProfileStatus);
  box.remove(batchSelected);
  box.remove(isSubscribed);
  box.remove(userName);
  prefs.remove(userProfileStatus);
}

String convertTo12HourFormat(String time24) {
  var dateFormat = DateFormat("HH:mm");
  var dateTime = dateFormat.parse(time24);
  var formattedTime = DateFormat("hh:mm a").format(dateTime);
  return formattedTime;
}

Future<String> usersFeaturesAvail() async {
  try {
    var header = getHeader();
    var url = Uri.parse(base_url + subscriptionStatusUrl);
    final response = await get(url, headers: header);
    print("user features avail  ===> ${response.statusCode}");
    print("user features avail ===> ${response.body}");
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());
      var pack = data['pack'];
      print(" data ===> $data}");
      // GetStorage box = GetStorage();
      // box.write(featuresAvail, pack);
      return pack;
    } else if (response.statusCode == 401 ||
        response.statusCode == 302 ||
        response.statusCode == 403) {
      SessionExpiredFun();
      return "expired";
    } else {
      return "expired";
    }
  } catch (e) {
    print("usersFeaturesAvail error $e");
    throw Exception();
  }
}
