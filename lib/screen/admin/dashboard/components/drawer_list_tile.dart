import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mystore/constants.dart';

class DrawerListTile extends StatelessWidget {
  const DrawerListTile(
      {Key? key,
      required this.title,
      required this.svgSrc,
      required this.tap,
      required this.style})
      : super(key: key);

  final String title, svgSrc;
  final VoidCallback tap;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: tap,
      horizontalTitleGap: 0.0,
      leading: SvgPicture.asset(
        svgSrc,
        color: style.color,
        height: 20,
      ),
      title: Text(
        title,
        style: style,
      ),
    );
  }
}
