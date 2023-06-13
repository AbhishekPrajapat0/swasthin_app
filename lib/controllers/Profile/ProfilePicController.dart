import 'dart:convert';
import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../../GlobalWidget/globalAlert.dart';
import '../../GlobalWidget/loading_widget.dart';
import '../../Utlis/globalFunctions.dart';
import '../../contants/Constants.dart';
import '../../screens/UserDetails/SelectGender.dart';

class ProfilePicController extends GetxController {
  var imagePresent = false.obs;
  var showBack = false.obs;
  var newUser = true.obs;
  dynamic arguments = Get.arguments;
  final ImagePicker picker = ImagePicker();
  XFile? imageFile;
  var imageFileNull = true.obs;
  var imageUrl = ''.obs;
  var profileImagePresent = false.obs;

  GetStorage box = new GetStorage();

  Future<void> takeImage(ImageSource source) async {
    imageFileNull.value = true;
    final XFile? image = await picker.pickImage(source: source);

    imagePresent.value = false;
    imageFile = image;
    imageFileNull.value = imageFile == null ? true : false;
    newUser.value = false;
  }

  void checkProfilePic(BuildContext context) async {
    if (imageFile == null) {
      GlobalAlert(
          context,
          "Image not Found",
          " Please Upload Image First, Then Click On Upload Button",
          DialogType.warning,
          onTap: () {});
    } else {
      // Compress the file
      var compressedFile = await compressImage(File(imageFile!.path));
      // saveFileToDownloadsFolder(compressedFile);
      print("File Saved ==============>");
      uploadProfilePic(context, compressedFile);
      // await saveCompressedFile(compressedFile!);
      // Send the compressed file to the API endpoint
      // await sendFile(compressedFile!,context);
    }
  }

  uploadProfilePic(BuildContext context, File compressedFile) async {
    try {
      loadingWithText(context, "Please wait, Loading....");

      var token = box.read('token');

      var stream;
      var lenght;
      var imagePath;
      String fileName;
      var mutliport;
      stream = new http.ByteStream(compressedFile.openRead());
      stream.cast();
      lenght = await compressedFile.length();
      imagePath = compressedFile.path;
      fileName = imagePath.split('/').last;
      mutliport =
          http.MultipartFile('image', stream, lenght, filename: fileName);

      var uri = Uri.parse(base_url + profileUpdateUrl);
      var request = http.MultipartRequest('POST', uri);
      request.headers['Authorization'] = 'Bearer $token';
      request.files.add(mutliport);

      var response = await request.send();

      print('200 Ok outside and status is ${response.statusCode}');
      // var responseData = await json.decode(response.body);
      response.stream.transform(utf8.decoder).listen((value) {
        print('200 Ok outside and status is $value');
      });

      if (response.statusCode == 200) {
        stopLoading(context);

        /// stop loading
        goToNextScreen();
      } else if (response.statusCode == 500) {
        stopLoading(context);

        /// stop loading
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
        stopLoading(context);

        /// stop loading
        print("in Else ${response.statusCode}");
      }
    } catch (e) {}
  }

  void goToNextScreen() {
    var type = arguments[0].toString();
    // Get.offAll(()=> SelectGender());
    type == "store" ? Get.offAll(() => SelectGender()) : Get.back();
  }

  @override
  void onInit() {
    print("profilr pic ===============> ${arguments[0]}");
    checkType();
    super.onInit();
  }

  void checkType() {
    var type = arguments[0].toString();
    if (type != "store") {
      imageUrl.value = type;
      imagePresent.value = true;
      showBack.value = !showBack.value;
    }
  }

  // Function to compress the file
  Future<File> compressImage(File file) async {
    try {
      final filePath = file.absolute.path;
      final lastIndex = filePath.lastIndexOf(RegExp(r'.jp'));
      final split = filePath.substring(0, (lastIndex));
      final outPath = "${split}_out${filePath.substring(lastIndex)}";
      var result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        outPath,
        quality: 20,
      );
      return result!;
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

// Function to send the compressed file to the API endpoint
  Future<void> sendFile(List<int> file, BuildContext context) async {
    loadingWithText(context, "Please wait, Loading.... ${imageFile!.name}");
    // Replace the URL with your API endpoint
    var token = box.read('token');
    var url = Uri.parse(base_url + profileUpdateUrl);
    var request = new http.MultipartRequest('POST', url);
    request.headers['Authorization'] = 'Bearer $token';
    request.files.add(
      http.MultipartFile.fromBytes(
        'image',
        file,
        filename: '${imageFile!.name}',
      ),
    );
    var response = await request.send();
    print('sending compressed image${response.statusCode}');
    // var responseData = await json.decode(response.body);
    response.stream.transform(utf8.decoder).listen((value) {
      print('sending compressed image ====> $value');
    });

    if (response.statusCode == 200) {
      stopLoading(context);

      /// stop loading
      goToNextScreen();
    } else if (response.statusCode == 500) {
      stopLoading(context);

      /// stop loading
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
      stopLoading(context);

      /// stop loading
      print("in Else ${response.statusCode}");
    }
  }

// // Function to save the file to the device's downloads folder
//   Future<void> saveFileToDownloadsFolder(File file) async {
//     print("saving file");
//     final directory = await getExternalStorageDirectory();
//     final savedFile = File('${directory!.path}/Download/${imageFile!.name}');
//     await savedFile.create(recursive: true);
//     print("saving file  ${savedFile}");
//     await savedFile.writeAsBytes(await file.readAsBytes());
//   }
}
