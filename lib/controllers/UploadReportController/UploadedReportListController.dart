import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart';
import '../../Models/UploadedReportList/UploadedReportListModel.dart';

import '../../Utlis/ApiUtlis.dart';
import '../../contants/Constants.dart';

class UploadedReportListController extends GetxController {
  var dataLoaded = false.obs;
  var dataEmpty = true.obs;
  UploadedReportListModel listModel = UploadedReportListModel();

  @override
  void onInit() {
    getList();
    super.onInit();
  }

  Future<void> getList() async {
    try {
      var header = getHeader();
      var uri = Uri.parse(base_url + getReportUploadedListUrl);
      var response = await get(uri, headers: header);
      print("getting Packages ${response.statusCode} ${response.body}");
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        var packageData = data['package'];
        print("uploaded reports list ===================== $data");
        print("uploaded reports list ===================== $packageData");
        listModel = UploadedReportListModel.fromJson(data);

        if (listModel.data!.length != 0) {
          dataEmpty.value = !dataEmpty.value;
        }
        dataLoaded.value = !dataLoaded.value;
      } else if (response.statusCode == 500) {
        // GlobalAlert(context, "Server Error", "The server has encountered an Error, Please Restart the App",DialogType.warning,onTap: (){});
      } else if (response.statusCode == 401 ||
          response.statusCode == 302 ||
          response.statusCode == 403) {
        // SessionExpiredFun();
      }
    } catch (e) {
      print("error while getting packages list $e");
    }
  }
}
