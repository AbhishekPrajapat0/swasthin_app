import 'package:flutter/material.dart';

import '../../contants/colors.dart';

class SubscriptionCarousel extends StatefulWidget {
  const SubscriptionCarousel({Key? key}) : super(key: key);

  @override
  State<SubscriptionCarousel> createState() => _SubscriptionCarouselState();
}

class _SubscriptionCarouselState extends State<SubscriptionCarousel> {
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return  Container(
      height: w * 1,
      width: w,
      padding: EdgeInsets.all(20),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        gradient: LinearGradient(
            colors: [
              kPrimaryGreenDark,
              kPrimaryGreen,
            ],
            begin: FractionalOffset(0.0, 0.0),
            end: FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp),
      ),
      child: getDetails(),
    );
  }

  getDetails() {
    return Column(
      children: [
        Text("Standard Plan",style: TextStyle(color: Colors.white,fontSize: 19,fontWeight: FontWeight.w400),)
      ],
    );
  }
}
