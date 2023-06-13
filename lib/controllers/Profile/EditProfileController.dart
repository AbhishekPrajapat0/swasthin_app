import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';

import '../../Utlis/ApiUtlis.dart';
import '../../Utlis/globalFunctions.dart';
import '../../contants/Constants.dart';

class EditProfileController extends GetxController {
  var name = ''.obs;
  var mobileNum = ''.obs;
  var dob = ''.obs;
  var email = ''.obs;
  var gender = ''.obs;
  var weight = ''.obs;
  var height = ''.obs;
  var activityLvl = ''.obs;
  var dietPref = ''.obs;
  var imageLink = ''.obs;
  var medicalCondition = ''.obs;
  var allergies = ''.obs;

  var detailsLoaded = false.obs;
  var imageNull = true.obs;
  var imageFileNotNull = false.obs;

  var profileImagePresent = false.obs;

  TextEditingController updatedName = TextEditingController();
  TextEditingController updatedMobileNum = TextEditingController();
  TextEditingController updatedEmail = TextEditingController();
  TextEditingController updatedDob = TextEditingController();
  TextEditingController updatedGender = TextEditingController();
  TextEditingController updatedWeight = TextEditingController();
  TextEditingController updatedHeight = TextEditingController();
  TextEditingController updatedActivityLvl = TextEditingController();
  TextEditingController updatedDietPref = TextEditingController();
  TextEditingController updatedMedicalCondition = TextEditingController();
  TextEditingController updatedMAllergies = TextEditingController();
  final ImagePicker picker = ImagePicker();
  XFile? imageFile;

  @override
  void onInit() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getProfileDetails();
    });
    refreshProfile();
    super.onInit();
  }

  Future<void> takeImage(ImageSource source) async {
    final XFile? image = await picker.pickImage(source: source);
    imageFile = image;
    profileImagePresent.value = true;
  }

  refreshProfile() {
    detailsLoaded.value = false;
    print("refresh");
    getProfileDetails();
  }

  Future<void> getProfileDetails() async {
    try {
      var header = getHeader();
      var uri = Uri.parse(base_url + getProfileInfoUrl);
      var response = await get(uri, headers: header);
      print("getting Profile info ${response.statusCode} ${response.body}");
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        var profileDetails = data['data'];
        var allergy = data['allergy'];
        print("profile details ================> $profileDetails");
        print("allergy details ================> $allergy ${allergy}");

        var allergiesText = " ";
        if (allergy.length != 0) {
          if (allergy[0]["allergy_name"].toString() == "NA" ||
              allergy == null) {
            allergiesText = "No Allergies";
          } else {
            for (var i = 0; i < allergy.length; i++) {
              if (i == 0) {
                allergiesText += "${allergy[i]["allergy_name"]}";
              } else {
                allergiesText += ", ${allergy[i]["allergy_name"]}";
              }
            }
          }
        } else {
          allergiesText = "No Allergies";
        }

        var dobLocal = profileDetails["dob"].toString();
        var split = dobLocal.split(" ");
        var first = split[0];
        updatedName.text = profileDetails["name"];
        updatedEmail.text = profileDetails["email"].toString();
        updatedMobileNum.text = profileDetails["mobile"].toString();
        updatedDob.text = first.toString();
        updatedGender.text = profileDetails["gender"].toString();
        updatedWeight.text = profileDetails["weight"].toString();
        updatedHeight.text = profileDetails["height"].toString();
        updatedActivityLvl.text =
            profileDetails["physical_activity_level"].toString();
        updatedDietPref.text = profileDetails["diet_preferences"].toString();
        updatedMAllergies.text = allergiesText.toString();
        updatedMedicalCondition.text =
            profileDetails["medical_conditions"] == null
                ? "Healthy"
                : profileDetails["medical_conditions"].toString();

        name.value = "Enter Your Name";
        mobileNum.value = "Enter Your Mobile Number";
        dob.value = "Enter Your Mobile Number";
        gender.value = "Enter Your Gender";
        weight.value = "Enter Your Weight";
        height.value = "Enter Your Height";
        dietPref.value = "Enter Your Diet Preference";
        activityLvl.value = "Enter Your Activity Level";
        medicalCondition.value = "Enter Your Medical Conditions";
        allergies.value = "Enter Your Allergies if You have any";
        imageLink.value = profileDetails["image"].toString();

        if (profileDetails["image"] != null) {
          imageNull.value = !imageNull.value;
          profileImagePresent.value = true;
        }

        detailsLoaded.value = true;
      } else if (response.statusCode == 401 ||
          response.statusCode == 302 ||
          response.statusCode == 403) {
        SessionExpiredFun();
      }
    } catch (e) {
      printError(info: "error get profile ====> $e");
    }
  }

  editProfilePic(BuildContext context) {
    showModalBottomSheet(
        context: context, builder: ((builder) => bottomSheet(context)));
  }

  Widget bottomSheet(BuildContext context) {
    return Container(
      height: 80,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          Text('Choose Your Profile'),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Row(
                children: [
                  Container(
                    height: 40,
                    child: IconButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          takeImage(ImageSource.camera);
                        },
                        icon: Icon(
                          Icons.camera_alt_outlined,
                          size: 20,
                          color: Colors.black54,
                        )),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black54, width: 1),
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Text('Camera')
                ],
              ),
              SizedBox(
                width: 40,
              ),
              Row(
                children: [
                  Container(
                    height: 40,
                    child: IconButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          takeImage(ImageSource.gallery);
                        },
                        icon: Icon(
                          Icons.image_outlined,
                          size: 20,
                          color: Colors.black54,
                        )),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black54, width: 1),
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Text('Gallery')
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
