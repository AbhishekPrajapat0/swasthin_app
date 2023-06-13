import 'package:flutter/material.dart';
import 'package:get/get.dart';


class ProfileTile extends StatelessWidget {
  final Widget icon;
  final Widget text;
  final Function() onTap;

  const ProfileTile({
    Key? key,
    required this.icon,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 10),
        child: Column(
          children: [
            Row(
              children: [
                icon,
                SizedBox(
                  width: width * 0.05,
                ),
                Expanded(
                  child: text,
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 12,
                  color: Colors.grey.withOpacity(0.9),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
