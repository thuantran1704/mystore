import 'package:flutter/material.dart';
import 'package:mystore/size_config.dart';

class RoundedIconBtn extends StatelessWidget {
  const RoundedIconBtn({
    Key? key,
    required this.iconData,
    required this.press,
  }) : super(key: key);
  final IconData iconData;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: getProportionateScreenHeight(40),
      width: getProportionateScreenWidth(40),
      // ignore: deprecated_member_use
      child: FlatButton(
        padding: EdgeInsets.only(
          left: getProportionateScreenHeight(10),
          right: getProportionateScreenHeight(10),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        color: Colors.grey.shade200,
        onPressed: press,
        child: Icon(iconData),
      ),
    );
  }
}
