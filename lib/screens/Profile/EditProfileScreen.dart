import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/shimmer/gf_shimmer.dart';
import 'package:image_picker/image_picker.dart';

import '../../GlobalWidget/CustomButton.dart';
import '../../GlobalWidget/CustomTextFormFieldProfileUpdate.dart';
import '../../GlobalWidget/customAppBars.dart';
import '../../contants/colors.dart';
import '../../contants/images.dart';
import '../../controllers/Profile/EditProfileController.dart';
import '../UserDetails/ActivityLevel.dart';
import '../UserDetails/DietPrefScreen.dart';
import '../UserDetails/HeightScreen.dart';
import '../UserDetails/ProfilePicScreen.dart';
import '../UserDetails/WeightScreen.dart';
import 'EditMedicalCondition.dart';

class EditProfileScreen extends GetView<EditProfileController> {
  final EditProfileController editProfileController =
      Get.put(EditProfileController());

  @override
  Widget build(BuildContext context) {
    refreshProfile();
    return Scaffold(
      backgroundColor: kPrimaryWhite,
      appBar: appBarWithBack(context, showBack: true, title: "Edit Profile"),
      bottomNavigationBar: bottonButton(),
      body: RefreshIndicator(
        onRefresh: refreshProfile,
        child: SingleChildScrollView(
            child: Container(
          padding: EdgeInsets.all(12),
          child: Obx(() => editProfileController.detailsLoaded.value
              ? getList(context)
              : ShimmerEffect(context)),
        )),
      ),
    );
  }

  bottonButton() {
    return CustomButton(
      text: "Update All",
      onPressed: () {
        Get.to(() => WeightScreen(), arguments: ["store"]);
      },
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
    );
  }

  goToEditScreen(String screenName) {
    if (screenName.toLowerCase() == "activity") {
      Get.to(() => ActivityLevelScreen(), arguments: ["edit"]);
      refreshProfile();
    } else if (screenName.toLowerCase() == "diet pref") {
      Get.to(() => DietPrefScreen(), arguments: ["edit"]);
      refreshProfile();
    } else if (screenName.toLowerCase() == "medical") {
      Get.to(() => EditMedicalCondtionsScreen(),
          arguments: [editProfileController.updatedMedicalCondition.text]);
      refreshProfile();
    } else if (screenName.toLowerCase() == "height") {
      Get.to(() => HeightScreen(), arguments: ["edit"]);
      refreshProfile();
    } else if (screenName.toLowerCase() == "weight") {
      Get.to(() => WeightScreen(), arguments: ["edit"]);
      refreshProfile();
    } else if (screenName.toLowerCase() == "allergies") {
      Get.to(() => WeightScreen(),
          arguments: [editProfileController.updatedMAllergies.text]);
      refreshProfile();
    }
  }

  getList(BuildContext context) {
    var h = Get.height;
    var w = Get.width;
    var imageLink = editProfileController.imageLink.value;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Stack(
                children: [
                  Obx(() => CircleAvatar(
                        radius: 80,
                        backgroundColor: Colors.black87,
                        backgroundImage: editProfileController
                                .profileImagePresent.value
                            ? NetworkImage(
                                editProfileController.imageLink.value)
                            : editProfileController.imageFileNotNull.value
                                ? FileImage(File(
                                        editProfileController.imageFile!.path))
                                    as ImageProvider
                                : AssetImage(profilePic),
                      )),
                  Positioned(
                    height: 40,
                    width: 40,
                    bottom: 10,
                    right: 10,
                    child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.black87,
                        child: Ink(
                          decoration: const ShapeDecoration(
                              shape: CircleBorder(), color: Colors.purple),
                          child: IconButton(
                            icon: const Icon(Icons.edit),
                            iconSize: 20,
                            color: Colors.white,
                            onPressed: () {
                              // editProfileController.editProfilePic(context);
                              Get.to(() => ProfilePicScreen(),
                                  arguments: ["$imageLink"]);
                            },
                          ),
                        )),
                  )
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Text("Upload Profile")
            ],
          ),
        ),
        CustomTextFormFieldProfileUpdate(
          showLabel: true,
          label: "Full Name",
          label2: " *",
          labelColor: Colors.black87,
          enabled: false,
          hintText: '${editProfileController.name.value}',
          inputType: TextInputType.text,
          controller: editProfileController.updatedName,
          textHintColor: false,
          showLabel2: true,
          // text: fullName,
        ),
        CustomTextFormFieldProfileUpdate(
          showLabel: true,
          label: "Mobile Number",
          label2: " *",
          labelColor: Colors.black87,
          enabled: false,
          hintText: '${editProfileController.mobileNum.value}',
          inputType: TextInputType.text,
          controller: editProfileController.updatedMobileNum,
          textHintColor: false,
          showLabel2: true,
          // text: fullName,
        ),
        CustomTextFormFieldProfileUpdate(
          showLabel: true,
          label: "Email",
          label2: " *",
          labelColor: Colors.black87,
          enabled: false,
          hintText: '${editProfileController.mobileNum.value}',
          inputType: TextInputType.text,
          controller: editProfileController.updatedEmail,
          textHintColor: false,
          showLabel2: true,
          // text: fullName,
        ),
        CustomTextFormFieldProfileUpdate(
          showLabel: true,
          label: "Date of Birth",
          label2: " *",
          labelColor: Colors.black87,
          enabled: false,
          hintText: '${editProfileController.dob.value}',
          inputType: TextInputType.text,
          controller: editProfileController.updatedDob,
          textHintColor: false,
          showLabel2: true,
          // text: fullName,
        ),
        CustomTextFormFieldProfileUpdate(
          showLabel: true,
          label: "Gender",
          label2: " *",
          labelColor: Colors.black87,
          enabled: false,
          hintText: '${editProfileController.gender.value}',
          inputType: TextInputType.text,
          controller: editProfileController.updatedGender,
          textHintColor: false,
          showLabel2: true,
          // text: fullName,
        ),
        CustomTextFormFieldProfileUpdate(
          showLabel: true,
          label: "Weight (in kg)",
          label2: " *",
          labelColor: Colors.black87,
          enabled: false,
          showEditIcon: true,
          onTapEdit: () async {
            await goToEditScreen("weight");
            await refreshProfile();
          },
          hintText: '${editProfileController.weight.value}',
          inputType: TextInputType.text,
          controller: editProfileController.updatedWeight,
          textHintColor: false,
          showLabel2: true,
          // text: fullName,
        ),
        CustomTextFormFieldProfileUpdate(
          showLabel: true,
          label: "Height (in cm)",
          label2: " *",
          labelColor: Colors.black87,
          enabled: false,
          showEditIcon: true,
          onTapEdit: () async {
            goToEditScreen("height");
            await refreshProfile();
          },
          hintText: '${editProfileController.height.value}',
          inputType: TextInputType.text,
          controller: editProfileController.updatedHeight,
          textHintColor: false,
          showLabel2: true,
          // text: fullName,
        ),
        CustomTextFormFieldProfileUpdate(
          showLabel: true,
          label: "Activity Level",
          label2: " *",
          labelColor: Colors.black87,
          enabled: false,
          showEditIcon: true,
          onTapEdit: () async {
            await goToEditScreen("activity");
            await refreshProfile();
          },
          hintText: '${editProfileController.activityLvl.value}',
          inputType: TextInputType.text,
          controller: editProfileController.updatedActivityLvl,
          textHintColor: false,
          showLabel2: true,
          // text: fullName,
        ),
        CustomTextFormFieldProfileUpdate(
          showLabel: true,
          label: "Diet Preference",
          label2: " *",
          labelColor: Colors.black87,
          enabled: false,
          showEditIcon: true,
          onTapEdit: () async {
            await goToEditScreen("diet pref");
            await refreshProfile();
          },
          hintText: '${editProfileController.dietPref.value}',
          inputType: TextInputType.text,
          controller: editProfileController.updatedDietPref,
          textHintColor: false,
          showLabel2: true,
          // text: fullName,
        ),
        CustomTextFormFieldProfileUpdate(
          showLabel: true,
          label: "Medical Condition",
          label2: " *",
          labelColor: Colors.black87,
          enabled: false,
          showEditIcon: true,
          onTapEdit: () async {
            await goToEditScreen("medical");
            await refreshProfile();
          },
          hintText: '${editProfileController.medicalCondition.value}',
          inputType: TextInputType.text,
          controller: editProfileController.updatedMedicalCondition,
          textHintColor: false,
          showLabel2: true,
          // text: fullName,
        ),
        //  CustomTextFormFieldProfileUpdate(
        //   showLabel: true,
        //   label: "Allergies",
        //   label2: " *",
        //   labelColor: Colors.black87,
        //   enabled: false,
        //   showEditIcon: false,
        //    onTapEdit: (){goToEditScreen("allergies");},
        //   hintText:  '${editProfileController.allergies.value}',
        //   inputType: TextInputType.multiline,
        //   controller: editProfileController.updatedMAllergies,
        //   textHintColor: false,
        //   showLabel2: true,
        //   // text: fullName,
        // ),
        Column(
          children: [
            Container(
              width: w,
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
              child: RichText(
                text: TextSpan(
                  text: "Allergies",
                  style: TextStyle(
                      fontSize: 12,
                      color: textMuted,
                      fontWeight: FontWeight.w400),
                  children: <TextSpan>[
                    TextSpan(
                        text: "*",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.red))
                  ],
                ),
              ),
            ),
            Container(
              width: w,
              margin: const EdgeInsets.symmetric(vertical: 5),
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
              decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10)),
              child: Text(editProfileController.updatedMAllergies.text),
            ),
          ],
        )
      ],
    );
  }

  Widget ShimmerEffect(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Stack(
                children: [
                  GFShimmer(
                      mainColor: Colors.grey.shade300,
                      secondaryColor: Colors.grey.shade50,
                      child: CircleAvatar(
                        radius: 80,
                      )),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 18.0),
              child: GFShimmer(
                  mainColor: Colors.grey.shade300,
                  secondaryColor: Colors.grey.shade50,
                  child: Container(
                    height: h * 0.07,
                    width: w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    // text: fullName,
                  )),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 18.0),
              child: GFShimmer(
                  mainColor: Colors.grey.shade300,
                  secondaryColor: Colors.grey.shade50,
                  child: Container(
                    height: h * 0.07,
                    width: w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    // text: fullName,
                  )),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 18.0),
              child: GFShimmer(
                  mainColor: Colors.grey.shade300,
                  secondaryColor: Colors.grey.shade50,
                  child: Container(
                    height: h * 0.07,
                    width: w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    // text: fullName,
                  )),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 18.0),
              child: GFShimmer(
                  mainColor: Colors.grey.shade300,
                  secondaryColor: Colors.grey.shade50,
                  child: Container(
                    height: h * 0.07,
                    width: w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    // text: fullName,
                  )),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 18.0),
              child: GFShimmer(
                  mainColor: Colors.grey.shade300,
                  secondaryColor: Colors.grey.shade50,
                  child: Container(
                    height: h * 0.07,
                    width: w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    // text: fullName,
                  )),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 18.0),
              child: GFShimmer(
                  mainColor: Colors.grey.shade300,
                  secondaryColor: Colors.grey.shade50,
                  child: Container(
                    height: h * 0.07,
                    width: w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    // text: fullName,
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Future refreshProfile() async {
    editProfileController.refreshProfile();
  }
}
