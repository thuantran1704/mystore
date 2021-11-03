import 'package:mystore/size_config.dart';
import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  const SectionTitle({
    Key? key,
    required this.text,
    required this.press,
  }) : super(key: key);
  final String text;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(left: getProportionateScreenWidth(8)),
            child: Text(
              text,
              style: TextStyle(
                  fontSize: getProportionateScreenWidth(18),
                  color: Colors.black),
            ),
          ),
          GestureDetector(
            onTap: press,
            child: Text(
              "See More",
              style: TextStyle(fontSize: getProportionateScreenWidth(12)),
            ),
          ),
        ],
      ),
    );
  }
}
