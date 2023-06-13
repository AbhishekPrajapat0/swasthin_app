import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../GlobalWidget/global_text_feild.dart';
import '../../../GlobalWidget/password_feild.dart';
import '../../../controllers/LoginController.dart';

class LoginWithEmail extends GetView<LoginController> {
  final LoginController loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return Column(
      children: [
        SizedBox(
          height: w * 0.1,
        ),
        //  Email
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 1),
          //Name
          child: CustomTextFormField(
            showLabel: true,
            label: 'Email',
            hintText: 'Enter Email',
            controller: loginController.emailCon,
            inputType: TextInputType.emailAddress,
          ),
        ),
        //  Password
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 1),
          child: PasswordField(
            showLabel: true,
            label: 'Password',
            hintText: 'Password',
            inputType: TextInputType.visiblePassword,
            controller: loginController.passwordCon,
          ),
        ),
      ],
    );
  }
}
