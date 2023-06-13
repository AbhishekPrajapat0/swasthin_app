import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../contants/images.dart';
import '../../controllers/SplashScreenController.dart';

class SplashScreen extends GetView<SplashScreenController> {
  final SplashScreenController splashScreenController =
      Get.put(SplashScreenController());

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return Container(
      width: w,
      height: h,
      decoration: BoxDecoration(
          // gradient: LinearGradient(
          //   begin: Alignment.topLeft,
          //   end: Alignment.bottomRight,
          //   colors: [ kPrimaryGreen200,kAlertDarkGreen,],
          // ),
          color: Colors.white),
      child: Center(
        child: ImageFadeAnimation(),
      ),
    );
  }
}

class ImageFadeAnimation extends StatefulWidget {
  @override
  _ImageFadeAnimationState createState() => _ImageFadeAnimationState();
}

class _ImageFadeAnimationState extends State<ImageFadeAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return FadeTransition(
      opacity: _animation,
      child: Container(
        width: w * 0.5,
        height: w * 0.5,
        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white
            // border: Border.all(
            //   color: Colors.grey,
            //   width: 2.0,
            // ),
            // add a background color if desired
            // color: Colors.grey[200],
            ),
        child: ClipOval(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Image.asset(
              logo,
              width: w * 0.1,
              height: w * 0.1,
            ),
          ),
        ),
      ),
    );
  }
}
