import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart';

import '../../Models/CallLogModel/CallLogModel.dart';
import '../../Utlis/ApiUtlis.dart';
import '../../Utlis/globalFunctions.dart';
import '../../contants/Constants.dart';

class CallLogController extends GetxController {
  CallLogModel callLogModel = CallLogModel();
  var callLogsLoaded = false.obs;
  var callLogsNull = true.obs;
  @override
  void onInit() {
    getCallLogs();
    super.onInit();
  }

  Future refreshCallLogs() async {
    callLogsLoaded.value = false;
    callLogsNull.value = true;
    getCallLogs();
  }

  Future<void> getCallLogs() async {
    try {
      print("In Get Call logs Function");
      var urlIs = Uri.parse(base_url + callLogUrl);
      var header = getHeader();
      var response = await get(urlIs, headers: header);
      var responseData = await json.decode(response.body);
      print('\n');
      print(
          'getCallLogs is Token ${response.statusCode} and this is response data ${responseData}');

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());

        var callLogListData = data['data'];
        print('\n');
        print('\n');
        print('This is check callLogListData  $callLogListData');
        callLogModel = CallLogModel.fromJson(data);
        print('\n');
        print('\n');
        print('\n');
        print('This is Call Logs  data ======> ${callLogModel.data!.length}');

        callLogsLoaded.value = true;
        if (callLogModel.data!.length != 0) {
          callLogsNull.value = false;
        }
      } else if (response.statusCode == 500) {
      } else if (response.statusCode == 401 ||
          response.statusCode == 302 ||
          response.statusCode == 403) {
        SessionExpiredFun();
      } else {
        throw Exception("No Prescription Found");
      }
    } catch (e) {
      // if(e.toString() == failedToLoadError){
      //   goToNoInternetScreen(context);
      // }
      print("this is error $e");
    }
  }
}
