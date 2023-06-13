import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Models/BatchesModel/MyClassDetailModel.dart';
import '../../Utlis/ApiUtlis.dart';
import '../../Utlis/globalFunctions.dart';
import '../../contants/Constants.dart';

class MyClassDetailsController extends GetxController {
  dynamic argumentData = Get.arguments;
  MyClassDetailModel myClassDetail = MyClassDetailModel();
  TextEditingController zoomLinkCon = TextEditingController();

  var dataLoaded = false.obs;

  @override
  void onInit() {
    var batchId = argumentData[0]["batch_id"].toString();
    print("batch id =======> $batchId");
    getDetails(batchId);
    super.onInit();
  }

  Future<void> getDetails(String batchId) async {
    try {
      var body = {"batch_id": batchId};
      var header = getHeader();
      var response = await post(Uri.parse(base_url + myClassDetailUrl),
          headers: header, body: body);

      print('This is code ${response.statusCode}');
      print('This is body ===> ${response.body}');
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        // var timeSlotData = data['data'];
        // myBatchesList = data.map<MyBatchesListModel>((obj) => MyBatchesListModel.fromJson(obj)).toList();
        myClassDetail = MyClassDetailModel.fromJson(data);
        print("=============> ${myClassDetail.batch!.link}");
        dataLoaded.value = !dataLoaded.value;
      } else if (response.statusCode == 500) {
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

  Future<void> launchZoom() async {
    String url = zoomLinkCon.text;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
