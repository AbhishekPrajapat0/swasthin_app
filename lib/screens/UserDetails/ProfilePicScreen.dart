import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../GlobalWidget/CustomButton.dart';
import '../../GlobalWidget/customAppBars.dart';
import '../../contants/colors.dart';
import '../../contants/images.dart';
import '../../controllers/Profile/ProfilePicController.dart';
import '../SubscriptionScreen/ProgramListScreen.dart';
import 'SelectGender.dart';

class ProfilePicScreen extends GetView<ProfilePicController> {
  final ProfilePicController picController = Get.put(ProfilePicController());
  //
  //  var imageLink;
  // ProfilePicScreen(String imageLink);

  @override
  Widget build(BuildContext context) {
    var h = Get.height;
    var w = Get.width;
    return Obx(() => Scaffold(
          appBar:
              appBarWithBack(context, showBack: picController.showBack.value),
          backgroundColor: kPrimaryWhite,
          bottomNavigationBar: bottomButton(context),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: h*0.7,
                  width: w,
                  child: Stack(
                    children: [
                      Positioned(
                        top: 0,
                        right: 15,
                        child: InkWell(
                          onTap: () async {
                            Get.to(()=>SelectGender());
                            // await Navigator.push(
                            //     context,
                            //     CupertinoPageRoute(
                            //         builder: (context) => ProgramListScreen()));
                          },
                          child: Container(
                            height: h * 0.05,
                            width: w * 0.2  ,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.grey.shade100,
                                border:
                                Border.all(color: Colors.blue.withOpacity(0.5))),
                            child: Center(
                              child: Text(
                                "Skip",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: mainColor,
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ),
                      ),

                      Positioned(
                        top: h*0.1,
                        left: w*0.02,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            // boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black, spreadRadius: 5)],
                            border: Border.all(
                              color: Colors.grey.shade300,
                              width: w * 0.025,
                            ),
                          ),
                          child: Obx(() => CircleAvatar(
                                radius: w * 0.4,
                                backgroundColor: Colors.black87,
                                // backgroundImage:!picController.newUser.value ? picController.imagePresent.value ? NetworkImage(picController.imageUrl.value) :picController.imageFileNull.value ?  AssetImage(profilePic) :FileImage(File(picController.imageFile!.path)) as ImageProvider: AssetImage(profilePic),
                                backgroundImage: picController.imagePresent.value
                                    ? NetworkImage(picController.imageUrl.value)
                                    : picController.imageFileNull.value
                                        ? AssetImage(profilePic)
                                        : FileImage(File(
                                                picController.imageFile!.path))
                                            as ImageProvider,
                              )),
                        ),
                      ),

                      Positioned(
                        right:w*0.1,
                        height: w * 0.15,
                        width: w * 0.15,
                        top: h*0.4,
                        child: CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.black87,
                            child: Ink(
                              decoration: const ShapeDecoration(
                                  shape: CircleBorder(), color: Colors.purple),
                              child: IconButton(
                                icon: const Icon(Icons.camera_alt_outlined),
                                iconSize: 20,
                                color: Colors.white,
                                onPressed: () {
                                  showModalBottomSheet(
                                      context: context,
                                      builder: ((builder) =>
                                          bottomSheet(context)));
                                },
                              ),
                            )),
                      ),
                      Positioned(
                          bottom: h*0.15,
                          left: w*0.35,
                          child: Align(
                              alignment: Alignment.center,
                              child: Text("Upload Profile"))),
                    ],
                  ),
                ),

              ],
            ),
          ),
        ));
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
                          picController.takeImage(ImageSource.camera);
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
                          picController.takeImage(ImageSource.gallery);
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

  bottomButton(BuildContext context) {
    return CustomButton(
      onPressed: () {
        picController.checkProfilePic(context);
      },
      text: "Upload",
      padding: EdgeInsets.only(bottom: 25, left: 22, right: 22),
    );
  }
}
