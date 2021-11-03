import 'package:flutter/material.dart';
import 'package:mystore/models/user.dart';
import 'package:mystore/screen/cart/cart_screen.dart';
import 'package:mystore/screen/home/components/icon_btn_with_counter.dart';
import 'package:mystore/screen/home/components/search_field.dart';
import 'package:mystore/screen/home/home_screen.dart';
import 'package:mystore/size_config.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    Key? key,
    required this.user,
  }) : super(key: key);

  final User user;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SearchField(),
          IconBtnWithCounter(
              svgSrc: "assets/icons/Cart Icon.svg",
              numOfItems: 0,
              press: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CartScreen(
                            user: user,
                          )))),
          IconBtnWithCounter(
            svgSrc: "assets/icons/Bell.svg",
            numOfItems: 3,
            press: () {},
          ),
        ],
      ),
    );
  }
}
