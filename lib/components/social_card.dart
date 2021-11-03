import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mystore/size_config.dart';

class SocialCard extends StatelessWidget {
  const SocialCard({
    Key? key,
    required this.asset,
    required this.press,
  }) : super(key: key);
  final String asset;
  final Function press;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(10)),
      padding: EdgeInsets.all(getProportionateScreenWidth(6)),
      height: getProportionateScreenHeight(40),
      width: getProportionateScreenWidth(40),
      decoration: const BoxDecoration(
        color: Color(0xFFF5F6F9),
        shape: BoxShape.circle,
      ),
      child: SvgPicture.asset(asset),
    );
  }
}
