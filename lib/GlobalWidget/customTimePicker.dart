import 'package:flutter/material.dart';

import '../contants/colors.dart';

class CustomTimePicker extends StatefulWidget {
  const CustomTimePicker({Key? key,
    required this.selected,
    required this.available,
    this.activeColor,
    this.nonActiveColor,
    required this.text,
     this.textSize,
     this.width,
    this.onPressed,
    this.padding}) : super(key: key);

  final bool selected;
  final bool available;
  final Function()? onPressed;
  final Color? activeColor;
  final Color? nonActiveColor;
  final String text;
  final double? textSize;
  final double? width;
  final EdgeInsetsGeometry? padding;

  @override
  State<CustomTimePicker> createState() => _CustomTimePickerState();
}

class _CustomTimePickerState extends State<CustomTimePicker> {
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return InkWell(
      onTap: widget.onPressed,
      child: Container(
        // height: w,
        width: widget.width == null ?null : widget.width,
        padding: EdgeInsets.all(12),
        margin: EdgeInsets.symmetric(horizontal: 8,vertical: 8),
        decoration: BoxDecoration(
          color: widget.selected ?mainColor:kPrimaryWhite,
            border: Border.all(
              color: widget.available ?mainColor:textMuted, // set border color
              width: 0.50, // set border width
            ),
            borderRadius: BorderRadius.circular(10.0)
        ),
          child: Center(child: Text(widget.text ,style: TextStyle(color: widget.selected ?kPrimaryWhite:kPrimaryBlack,fontSize: widget.textSize ?? 12),),),
      ),
    );
  }
}
