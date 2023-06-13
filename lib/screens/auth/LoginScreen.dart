import 'package:Swasthin/screens/SubscriptionScreen/ProgramListScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../GlobalWidget/CustomButton.dart';
import '../../contants/colors.dart';
import '../../contants/images.dart';
import '../../controllers/LoginController.dart';
import '../ForgotPassword/ForgotPasswordScreen.dart';
import 'SignUp.dart';
import 'login/LoginWithEmail.dart';
import 'login/LoginWithPhone.dart';

class LoginScreen extends GetView<LoginController> {
  final LoginController loginController = Get.put(LoginController());

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.blue;
    }
    return kPrimaryGreen;
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
                    //   text:TextSpan(
                    //       text: "Swas",
                    //       style: TextStyle(color: Colors.green,fontSize: 25,fontWeight: FontWeight.bold),
                    //       children:[TextSpan(text: "thin",style: TextStyle(color: Colors.green,fontSize: 25,fontWeight: FontWeight.w200))]
                    //   ),
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
                      "Log In",
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                )),
            SizedBox(
              height: w * 0.08,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: () {
                    loginController.loginWithEmail.value = true;
                    loginController.numberCon.clear();
                    loginController.passwordCon.clear();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                    // color: Colors.red,
                    child: Column(
                      children: [
                        Text("With Email"),
                        Obx(() => loginController.loginWithEmail.value
                            ? underLine(context)
                            : Container())
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    loginController.loginWithEmail.value = false;
                    loginController.emailCon.clear();
                    loginController.passwordCon.clear();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                    // color: Colors.red,
                    child: Column(
                      children: [
                        Text("With Number"),
                        Obx(() => !loginController.loginWithEmail.value
                            ? underLine(context)
                            : Container())
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // User select is user will login with email or mobile number
            Obx(() => loginController.loginWithEmail.value
                ? LoginWithEmail()
                : LoginWithPhone()),

            //Terms and Conditions
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.start,
            //   children:  [
            //     Obx(() =>
            //         Checkbox(
            //           checkColor: Colors.white,
            //           fillColor: MaterialStateProperty.resolveWith(getColor),
            //           value: loginController.isChecked.value,
            //           onChanged: (bool? value) {
            //             loginController.isChecked.value = value!;
            //           },
            //         ),
            //     ),
            //     SizedBox(
            //       width: 3,
            //     ),
            //     Container(
            //       width: MediaQuery.of(context).size.width*0.7,
            //       child: RichText(
            //         text: TextSpan(
            //
            //           text: 'I Agree to  ',
            //           style: TextStyle(overflow: TextOverflow.ellipsis,color: Colors.black),
            //           children:  <TextSpan>[
            //             TextSpan(
            //                 recognizer: TapGestureRecognizer()..onTap =(){
            //
            //                 },
            //                 text: 'Terms of Use', style: TextStyle(fontWeight: FontWeight.normal,color: Colors.blue)),
            //             TextSpan(text: ' and '),
            //             TextSpan(
            //                 recognizer: TapGestureRecognizer()..onTap =(){
            //
            //                 },
            //                 text: 'Privacy Policy', style: TextStyle(fontWeight: FontWeight.normal,color: Colors.blue)),
            //           ],
            //         ),
            //       ),
            //     )
            //   ],
            // ),

            Row(
              children: [
                SizedBox(
                  width: w * 0.05,
                ),
                InkWell(
                  onTap: () {
                    print("clicked");
                    Get.to(() => ForgotPasswordScreen());
                  },
                  child: Text('Forgot Password?',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontWeight: FontWeight.normal, color: Colors.blue)),
                ),
              ],
            ),
            //Button

            CustomButton(
              onPressed: () {
                print("logined");
                // if(loginController.is
                // Checked.value){
                loginController.logInUser(context);
                // }else{
                //   GlobalAlert(context, "Warning", "Please check Terms & Condition", DialogType.warning,onTap: (){});
                // }
              },
              text: "Log In",
            ),
            SizedBox(
              height: h * 0.02,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account? ",
                    style: TextStyle(color: Colors.black, fontSize: 13.0)),
                InkWell(
                  onTap: () {
                    loginController.clearAllControlers();
                    Get.to(() => SignUpScreen());
                  },
                  child: const Text("Sign Up",
                      style: TextStyle(color: Colors.red, fontSize: 13.0)),
                ),
              ],
            ),
            SizedBox(height: h * 0.08),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
                child: InkWell(
                  onTap: () async {
                    await Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => ProgramListScreen()));
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
            )
          ],
        ),
      ),
    );
  }

  underLine(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.only(top: 10),
      height: 1,
      width: w * 0.3,
      color: kPrimaryGreen,
    );
  }
}
