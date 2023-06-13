import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../GlobalWidget/loading_widget.dart';
import '../../contants/Constants.dart';
import '../../screens/SubscriptionScreen/SubscriptionScreen.dart';

import '../../screens/Dashboard/DashboardScreen.dart';
import '../../screens/SubscriptionScreen/ProgramListScreen.dart';
import '../../screens/UserDetails/UploadReportScreen.dart';

class UploadReportController extends GetxController {
  dynamic arguments = Get.arguments;
  var fileEmpty = true.obs;
  var type = "".obs;
  var fileTypePdf = false;
  FilePickerResult? result;
  late PlatformFile file;
  GetStorage box = new GetStorage();
  var fileName;
  var filePath;

  @override
  Future<void> onInit() async {
    type.value = arguments[0].toString();
    print(
        "===========================================================================================================> type");
    print("type ========================== ${type.value}");
    super.onInit();
  }

  pickFile() async {
    result = await FilePicker.platform.pickFiles();

    if (result != null) {
      file = result!.files.first;

      print(file.name);
      print(file.bytes);
      print(file.size);
      print(file.extension);
      print(file.path);
      if (file.extension.toString() == "pdf") {
        fileTypePdf = true;
      }

      fileName = file.name;
      filePath = file.path;
      fileEmpty.value = false;
    } else {
      // User canceled the picker
    }
  }

  cancelFile() {
    fileEmpty.value = true;
  }

  void uploadFile(BuildContext context) async {
    loadingWithText(context, "Please Wait Loading.....");

    var token = box.read('token');
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(base_url + profileUpdateUrl),
    );
    request.headers['Authorization'] = 'Bearer $token';

    request.files.add(
      await http.MultipartFile.fromPath(
        'report',
        file.path!,
      ),
    );
    var response = await request.send();
    print(
        'response ==========================================================================> ${response.statusCode}, ${response}');
    print('sending compressed image${response.statusCode}');
    // var responseData = await json.decode(response.body);
    response.stream.transform(utf8.decoder).listen((value) {
      print('sending compressed image ====> $value');
    });

    if (response.statusCode == 200) {
      var subscribed = box.read(isSubscribed);
      print("profile complete ${box.read(userProfileStatus)} $subscribed");
      stopLoading(context);

      /// stops loading
      if (type == "reupload") {
        Get.offAll(() => DashboardScreen());
      } else {
        Get.offAll(() => subscribed ? DashboardScreen() : ProgramListScreen());
      }
      print('File uploaded!');
    } else {
      stopLoading(context);

      /// stop Loading
      print('Upload failed with status ${response.statusCode}');
    }
  }

  skipFun() {
    var subscribed = box.read(isSubscribed);
    Get.offAll(() => subscribed ? DashboardScreen() : ProgramListScreen());
  }
}
