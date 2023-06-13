import 'package:flutter/material.dart';
import 'package:getwidget/components/button/gf_button.dart';

import '../contants/colors.dart';

class CustomButton extends StatefulWidget {
  const CustomButton({
    Key? key,
  this.buttonColor,
  this.text,
  this.child,
  this.icon,
    this.onPressed,
    this.padding,
  })
      : super(key: key);

  final Function()? onPressed;
  final Color? buttonColor;
  final Widget? child;
  final Widget? icon;
  final String? text;
  final EdgeInsetsGeometry? padding;

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding == null ? const EdgeInsets.all(10):widget.padding! ,
      child: GFButton(
        child: widget.child,
        color: widget.buttonColor != null ? widget.buttonColor! : mainColor,
        size: 50,
        onPressed: widget.onPressed,
        text: widget.text,
        fullWidthButton: true,
        icon:widget.icon,
      ),
    );
  }
}
