// ignore_for_file: prefer_const_constructors_in_immutables, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mystore/components/rounded_icon_btn.dart';
import 'package:mystore/size_config.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double ratting;

  CustomAppBar(this.ratting);

  @override
  Size get preferredSize => const Size.fromHeight(140);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: getProportionateScreenWidth(10)),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RoundedIconBtn(
                iconData: Icons.arrow_back_ios,
                press: () => Navigator.pop(context),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(30)),
                child: Row(
                  children: [
                    Text(
                      ratting.toString(),
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(width: 5),
                    SvgPicture.asset("assets/icons/Star Icon.svg")
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
