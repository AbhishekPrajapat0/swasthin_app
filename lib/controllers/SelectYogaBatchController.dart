import 'dart:async';
import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart';
import '../../GlobalWidget/globalAlert.dart';
import '../../controllers/Batch/BacthModel.dart';
import '../../screens/Dashboard/DashboardScreen.dart';
import '../../screens/auth/LoginScreen.dart';

import '../Utlis/ApiUtlis.dart';
import '../Utlis/globalFunctions.dart';
import '../contants/Constants.dart';

class SelectYogaBatchController extends GetxController {
  GetStorage box = GetStorage();
  var batchesList = [].obs;
  var loadingData = true.obs;

  @override
  void onInit() {
    getBatchesList();
    super.onInit();
  }

  Future<void> getBatchesList() async {
    try {
      var header = getHeader();
      var uri = Uri.parse(base_url + getBatchListUrl);
      var response = await get(uri, headers: header);
      print("getting batches ${response.statusCode} ${response.body}");
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        var batchesData = data['data'];
        // var result = batchesData.substring(1, batchesData.length-1);
        print("getting batches 1$data ");
        print("getting batches  2${data['data']}");
        batchesList.value =
            batchesData.map<Batches>((obj) => Batches.fromJson(obj)).toList();
        print("getting batches 3${batchesList.value[0].name}");

        loadingData.value = !loadingData.value;
      } else if (response.statusCode == 500) {
      } else if (response.statusCode == 401 ||
          response.statusCode == 302 ||
          response.statusCode == 403) {
        SessionExpiredFun();
      }
    } catch (e) {
      print("error while getting batches list $e");
    }
  }

  selectYogaBatch(BuildContext context, String id) async {
    try {
      print("id id $id");
      var header = getHeader();
      var uri = Uri.parse(base_url + selectBatchUrl);
      var body = {"batch_id": id};
      var response = await post(uri, headers: header, body: body);
      print("selecting batches ${response.statusCode} ${response.body}");
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        box.write(batchSelected, true);
        GlobalAlert(context, "Congratulation!", "Your batch has been selected!",
            DialogType.success, onTap: () {
          Get.offAll(() => DashboardScreen());
        });

        Timer(Duration(seconds: 4), () {
          Get.to(() => DashboardScreen());
        });
      } else if (response.statusCode == 500) {
      } else if (response.statusCode == 401 ||
          response.statusCode == 302 ||
          response.statusCode == 403) {
        Get.offAll(() => LoginScreen());
      }
    } catch (e) {
      print("error while booking batches $e");
    }
  }
}
