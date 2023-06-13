import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';

import '../../GlobalWidget/globalAlert.dart';
import '../../Models/DietitianConsulting/AppointmentListModel.dart';
import '../../Utlis/ApiUtlis.dart';
import '../../Utlis/globalFunctions.dart';
import '../../contants/Constants.dart';

class AppointmentListController extends GetxController {
  AppointmentListModel appointmentListModel = AppointmentListModel();

  List<ListElement>? appointmentList;
  var loadingIsOn = true.obs;
  var noAppointments = true.obs;

  @override
  void onInit() {
    getAppointmentList();
    super.onInit();
  }

  Future<void> getAppointmentList() async {
    try {
      var header = getHeader();
      var uri = Uri.parse(base_url + appointmentListUrl);
      var response = await get(uri, headers: header);
      print(
          "getting appointments =====> ${response.statusCode} ${response.body}");
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        var appointList = data['list'];
        print("package data $data");
        print("package data ${appointList}");
        appointmentListModel = AppointmentListModel.fromJson(data);
        if (appointList.length != 0) {
          appointmentList = appointList
              .map<ListElement>((obj) => ListElement.fromJson(obj))
              .toList();
        }

        print("===============>  ${appointmentListModel.list!.length}");

        if (appointmentListModel.list!.length > 0 ||
            appointmentListModel.list == null) {
          noAppointments.value = !noAppointments.value;
        }

        loadingIsOn.value = !loadingIsOn.value;
        print("============> ${loadingIsOn.value} \\ ${noAppointments.value}");
      } else if (response.statusCode == 422) {
        noAppointments.value = true;
        loadingIsOn.value = !loadingIsOn.value;
      } else if (response.statusCode == 401 ||
          response.statusCode == 302 ||
          response.statusCode == 403) {
        SessionExpiredFun();
      }
    } catch (e) {
      print("getting appointment list $e");
    }
  }

  cancelAppointment(BuildContext context, int id) {
    GlobalAlertQuestion(
        context,
        "Cancel Appointment?",
        "Are you sure you want to \ncancel the Appointment with Dietitian?",
        DialogType.warning, onTap: () {
      cancelAppointmentApi(id, context);
    });
  }

  Future<void> cancelAppointmentApi(int id, BuildContext context) async {
    try {
      print("cancel Appointment <====================");
      var urlIs = Uri.parse(base_url + appointmentCancelUrl);
      var header = getHeader();
      var body = {'appointment_id': id.toString()};

      var response = await post(urlIs, headers: header, body: body);
      print(
          '========> cancel App =========> ${response.statusCode} ======> ${response.body}');

      // var responseData = await json.decode(response.body);
      print('\n');
      if (response.statusCode == 200) {
        noAppointments.value = !noAppointments.value;
        loadingIsOn.value = !loadingIsOn.value;
        getAppointmentList();
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
        SessionExpiredFun();
      } else {
        print("reponse code is ${response.statusCode} ${response.body}");
      }
    } catch (e) {
      print("error cancel appoint $e");
    }
  }

  refresh() {
    noAppointments.value = !noAppointments.value;
    loadingIsOn.value = !loadingIsOn.value;
    getAppointmentList();
  }
}
