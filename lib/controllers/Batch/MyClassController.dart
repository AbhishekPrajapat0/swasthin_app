import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart';

import '../../Models/BatchesModel/MyBatchesModel.dart';
import '../../Utlis/ApiUtlis.dart';
import '../../Utlis/globalFunctions.dart';
import '../../contants/Constants.dart';

class MyClassController extends GetxController {
  MyBatchesListModel myBatchesList = MyBatchesListModel();

  var dataLoaded = false.obs;
  var noData = true.obs;
  String? dates = " ";
  List<DateTime> datesArray = [];
  var dateTimeArray;

  var nextClassNotAvailable = true.obs;
  DateTime? dateToShow;

  @override
  void onInit() {
    getClassList();
    super.onInit();
  }

  void getClassList() async {
    try {
      var header = getHeader();
      var response =
          await get(Uri.parse(base_url + myClassesListUrl), headers: header);

      print('This is code ${response.statusCode}');
      print('This is body ===> ${response.body}');
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        // var timeSlotData = data['data'];
        // myBatchesList = data.map<MyBatchesListModel>((obj) => MyBatchesListModel.fromJson(obj)).toList();
        myBatchesList = MyBatchesListModel.fromJson(data);
        print("=============> ${myBatchesList.batch!.length}");
        if (myBatchesList.batch!.length > 0) {
          dates = myBatchesList.batch![0].batch!.dates;
          print("==============> $dates");
          if (dates != null) {
            mapDates();
          }
          noData.value = !noData.value;
        }
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

  void mapDates() {
    var datesList = dates!.split(",");
    for (var i = 0; i < datesList.length; i++) {
      DateTime dateTime = DateTime.parse(datesList[i]);
      datesArray.add(dateTime);
    }
    print(
        "===============================================================================================\n$datesArray");
    // Sort the list of dates in ascending order
    datesArray.sort((a, b) => a.compareTo(b));
    print(
        "===============================================================================================\n$datesArray");

    var nowt = DateTime.now();
    var now = DateTime(nowt.year, nowt.month, nowt.day);
    for (var i = 0; i < datesArray.length; i++) {
      print(">>>>>>>>>>>>>${datesArray[i] == now} ${datesArray[i]} $now");
      if (datesArray[i] == now) {
        dateToShow = datesArray[i];
        break;
      } else if (datesArray[i].isAfter(now)) {
        dateToShow = datesArray[i];
        break;
      }
    }
    print(
        "===============================================================================================\n$dateToShow");
    if (dateToShow != null) {
      nextClassNotAvailable.value = false;
    }
  }
}
