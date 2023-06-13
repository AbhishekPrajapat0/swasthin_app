import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../GlobalWidget/global_text_feild.dart';
import '../../../GlobalWidget/password_feild.dart';
import '../../../controllers/LoginController.dart';

class LoginWithPhone extends GetView<LoginController> {
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 1),
          // child: Column(
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: [
          //     Padding(
          //       padding: const EdgeInsets.only(left: 6.0),
          //       child: Text("Phone Number"),
          //     ),
          //     Row(
          //       children: [
          //         Container(
          //           margin: EdgeInsets.only(right: 10),
          //           width: w*0.25,
          //           child: InkWell(
          //             onTap: (){
          //               showCountryPicker(
          //                 context: context,
          //                 showPhoneCode: true, // optional. Shows phone code before the country name.
          //                 onSelect: (Country country) {
          //                   print('Select country: ${country.phoneCode}');
          //                   loginController.countryCodeCon.text = "+${country.phoneCode}";
          //                 },
          //               );
          //             },
          //             child: CustomTextFormField(
          //               enabled: false,
          //               hintText: 'Country Code',
          //               controller: loginController.countryCodeCon,
          //               inputType: TextInputType.number,
          //             ),
          //           ),
          //         ),
          //         Container(
          //           width: w*0.65,
          //           child: CustomTextFormField(
          //             maxLength: 10,
          //             showLabel: false,
          //             hintText: 'Enter Phone Number',
          //             controller: loginController.numberCon,
          //             inputType: TextInputType.number,
          //           ),
          //         ),
          //       ],
          //     ),
          //   ],
          // ),
          child: CustomTextFormField(
            maxLength: 10,
            showLabel: true,
            label: 'Phone Number',
            hintText: 'Enter Phone Number',
            controller: loginController.numberCon,
            inputType: TextInputType.number,
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
