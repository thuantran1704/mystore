import 'package:flutter/material.dart';
import 'package:mystore/constants.dart';
import 'package:mystore/models/user.dart';
import 'package:mystore/screen/all_product/all_product_screen.dart';
import 'package:mystore/screen/cart/cart_screen.dart';
import 'package:mystore/screen/home/components/icon_btn_with_counter.dart';
import 'package:mystore/size_config.dart';

class HomeHeader extends StatefulWidget {
  const HomeHeader({
    Key? key,
    required this.user,
  }) : super(key: key);

  final User user;

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  TextEditingController keywordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: SizeConfig.screenWidth * 0.75, //60% of width
            // height: 50,
            decoration: BoxDecoration(
              color: kSecondaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: TextField(
              controller: keywordController,
              onEditingComplete: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AllProductScreen(
                              user: widget.user,
                              keyword: keywordController.text.trim(),
                            )));
              },
              decoration: InputDecoration(
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                hintText: "Search product ...",
                prefixIcon: const Icon(Icons.support_agent_rounded),
                suffixIcon: const Icon(Icons.search),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(10),
                  vertical: getProportionateScreenHeight(10),
                ),
              ),
            ),
          ),
          IconBtnWithCounter(
              svgSrc: "assets/icons/Cart Icon.svg",
              numOfItems: 0,
              press: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CartScreen(
                            user: widget.user,
                          )))),
          // IconBtnWithCounter(
          //   svgSrc: "assets/icons/Bell.svg",
          //   numOfItems: 3,
          //   press: () {},
          // ),
        ],
      ),
    );
  }
}
