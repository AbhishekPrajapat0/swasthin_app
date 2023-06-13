import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../GlobalWidget/CustomButton.dart';
import '../../GlobalWidget/globalAlert.dart';
import '../../GlobalWidget/global_text_feild.dart';
import '../../GlobalWidget/loading_widget.dart';
import '../../GlobalWidget/password_feild.dart';
import '../../contants/colors.dart';
import '../../contants/images.dart';
import '../../controllers/SignupController.dart';
import '../TermsAndPolicy/PrivacyPolicyScreen.dart';
import '../TermsAndPolicy/TermsScreen.dart';
import 'LoginScreen.dart';

class SignUpScreen extends GetView<SignUpController> {
  final SignUpController signUpController = Get.put(SignUpController());

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return mainColor;
    }
    return mainColor;
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //Logo and sign up test
            Padding(
                padding: EdgeInsets.only(top: h * 0.08),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    // RichText(
                    //     text:TextSpan(
                    //       text: "Swas",
                    //       style: TextStyle(color: Colors.green,fontSize: 25,fontWeight: FontWeight.bold),
                    //       children:[TextSpan(text: "thin",style: TextStyle(color: Colors.green,fontSize: 25,fontWeight: FontWeight.w200))]
                    //     ),
                    // ),
                    Image.asset(
                      logo,
                      height: w * 0.11,
                    ),
                    SizedBox(
                      width: w * 0.05,
                    ),
                    Container(
                      color: Colors.grey,
                      width: w * 0.005,
                      height: w * 0.08,
                    ),
                    SizedBox(
                      width: w * 0.05,
                    ),
                    Text(
                      "Sign Up",
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                )),
            SizedBox(
              height: w * 0.08,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 1),
              //Name
              child: CustomTextFormField(
                showLabel: true,
                label: 'Full Name *',
                hintText: 'Enter Full Name',
                controller: signUpController.nameCon,
                inputType: TextInputType.text,
              ),
            ),

            //  Email
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 1),
              //Name
              child: CustomTextFormField(
                  showLabel: true,
                  label: 'Email *',
                  hintText: 'Enter Email',
                  controller: signUpController.emailCon,
                  inputType: TextInputType.emailAddress,
                  onEditingComplete: (text) async {
                    final bool emailValid = RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(signUpController.emailCon.text);
                    if (emailValid) {
                      loadingWithText(context, "Please wait, Loading");
                      var status;

                      if (signUpController.emailCon.text.contains(".com")) {
                        status = await signUpController
                            .checkUserExist(signUpController.emailCon.text);
                      }
                      stopLoading(context);

                      /// stop loading
                      print(
                          "email available ==========> $status ${signUpController.type}");
                      if (status) {
                        signUpController.emailCon.clear();
                        GlobalAlert(context, "Email Not Available",
                            "${controller.userCheckMsg}", DialogType.warning,
                            onTap: () {});
                      }

                      if (signUpController.type == "ban") {
                        signUpController.emailCon.clear();
                        signUpController.type = "";
                        GlobalAlert(context, "Email Not Available",
                            "${controller.userCheckMsg}", DialogType.warning,
                            onTap: () {});
                      }
                    }
                  }),
            ),
            //  Phone Number
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
              //           //  Container(
              //           //   margin: EdgeInsets.only(right: 10),
              //           //   width: w*0.25,
              //           //   child: InkWell(
              //           //     onTap: (){
              //           //       showCountryPicker(
              //           //         context: context,
              //           //         showPhoneCode: true, // optional. Shows phone code before the country name.
              //           //         onSelect: (Country country) {
              //           //           print('Select country: ${country.phoneCode}');
              //           //           signUpController.countryCodeCon.text = "+${country.phoneCode}";
              //           //         },
              //           //       );
              //           //     },
              //           //     child: CustomTextFormField(
              //           //       enabled: false,
              //           //       hintText: 'Country Code',
              //           //       controller: signUpController.countryCodeCon,
              //           //       inputType: TextInputType.number,
              //           //     ),
              //           //   ),
              //           // ),
              //         Container(
              //           // width: w*0.65,
              //           child: CustomTextFormField(
              //             maxLength: 10,
              //             showLabel: false,
              //             hintText: 'Enter Phone Number',
              //             controller: signUpController.numberCon,
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
                label: 'Phone Number *',
                hintText: 'Enter Phone Number',
                controller: signUpController.numberCon,
                inputType: TextInputType.number,
                onEditingComplete: (text) async {
                  if (text.length > 9) {
                    loadingWithText(context, "Please wait, Loading");
                    var status = await signUpController
                        .checkUserExist(signUpController.numberCon.text);
                    stopLoading(context);

                    /// stop loading
                    print("nuber available ==========> $status");
                    if (status) {
                      signUpController.numberCon.clear();
                      GlobalAlert(context, "Number Not Available",
                          "${controller.userCheckMsg}", DialogType.warning,
                          onTap: () {});
                    }

                    if (signUpController.type == "ban") {
                      signUpController.numberCon.clear();
                      signUpController.type = "";
                      GlobalAlert(context, "Number Not Available",
                          "${controller.userCheckMsg}", DialogType.warning,
                          onTap: () {});
                    }
                  }
                },
              ),
            ),
            //  Password
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 1),
              child: PasswordField(
                showLabel: true,
                label: 'Password *',
                hintText: 'Password',
                inputType: TextInputType.visiblePassword,
                controller: signUpController.passwordCon,
              ),
            ),

            //  Confirm Password
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 1),
              child: PasswordField(
                showLabel: true,
                label: 'Confirm Password *',
                hintText: 'Confirm Password',
                inputType: TextInputType.visiblePassword,
                controller: signUpController.confirmPasswordCon,
              ),
            ),

            //Terms and Conditions
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Obx(
                  () => Checkbox(
                    checkColor: Colors.white,
                    fillColor: MaterialStateProperty.resolveWith(getColor),
                    value: signUpController.isChecked.value,
                    onChanged: (bool? value) {
                      signUpController.isChecked.value = value!;
                    },
                  ),
                ),
                SizedBox(
                  width: 3,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: RichText(
                    text: TextSpan(
                      text: 'I Agree to  ',
                      style: TextStyle(
                          overflow: TextOverflow.ellipsis, color: Colors.black),
                      children: <TextSpan>[
                        TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Get.to(() => TermsScreen());
                              },
                            text: 'Terms of Use',
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Colors.blue)),
                        TextSpan(text: ' and '),
                        TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Get.to(() => PrivacyPolicyScreen());
                              },
                            text: 'Privacy Policy',
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Colors.blue)),
                      ],
                    ),
                  ),
                )
              ],
            ),
            //Button
            CustomButton(
              onPressed: () {
                // Get.to(()=>OtpScreen());
                if (signUpController.isChecked.value) {
                  signUpController.signUpUser(context);
                } else {
                  GlobalAlert(context, "Warning",
                      "Please check Terms & Condition", DialogType.warning,
                      onTap: () {});
                }
              },
              text: "Sign Up",
            ),
            SizedBox(
              height: h * 0.02,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already have an account? ",
                    style: TextStyle(color: Colors.black, fontSize: 13.0)),
                InkWell(
                  onTap: () {
                    signUpController.clearAllControlers();
                    Get.to(() => LoginScreen());
                  },
                  child: const Text("Login",
                      style: TextStyle(color: Colors.red, fontSize: 13.0)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
