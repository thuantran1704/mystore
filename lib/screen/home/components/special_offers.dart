import 'package:mystore/models/user.dart';
import 'package:mystore/screen/all_product/all_product_screen.dart';
import 'package:mystore/screen/home/components/section_title.dart';
import 'package:mystore/size_config.dart';
import 'package:flutter/material.dart';

class SpecialOffers extends StatelessWidget {
  const SpecialOffers({
    Key? key,
    required this.user,
  }) : super(key: key);
  final User user;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionTitle(
          text: "Special for you",
          press: () {},
        ),
        SizedBox(height: getProportionateScreenWidth(16)),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              SpecialOfferCard(
                image: "assets/images/keyboard-banner.jpg",
                category: "Keyboard",
                numOfBrands: 3,
                press: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AllProductScreen(
                                user: user,
                                cate: "6157e6270cb574369883ccc7",
                                cateName: "Keyboard",
                              )));
                },
              ),
              SpecialOfferCard(
                image: "assets/images/mouse-banner.jpg",
                category: "Mouse",
                numOfBrands: 3,
                press: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AllProductScreen(
                                user: user,
                                cate: "617bd495aa9200000487a051",
                                cateName: "Mouse",
                              )));
                },
              ),
              SpecialOfferCard(
                image: "assets/images/headphone-banner.jpg",
                category: "Headphone",
                numOfBrands: 2,
                press: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AllProductScreen(
                                user: user,
                                cate: "617bb9afa009443018c40782",
                                cateName: "Headphone",
                              )));
                },
              ),
              SpecialOfferCard(
                image: "assets/images/rtx-banner.jpg",
                category: "RTX",
                numOfBrands: 2,
                press: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AllProductScreen(
                                user: user,
                                cate: "617d0ba223b7820004f44c5f",
                                cateName: "RTX",
                              )));
                },
              ),
              SizedBox(
                width: getProportionateScreenWidth(20),
              )
            ],
          ),
        ),
      ],
    );
  }
}

class SpecialOfferCard extends StatelessWidget {
  const SpecialOfferCard({
    Key? key,
    required this.category,
    required this.image,
    required this.numOfBrands,
    required this.press,
  }) : super(key: key);
  final String category, image;
  final int numOfBrands;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Padding(
        padding: EdgeInsets.only(left: getProportionateScreenWidth(20)),
        child: SizedBox(
          width: getProportionateScreenWidth(240),
          height: getProportionateScreenHeight(108),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                Image.asset(
                  image,
                  fit: BoxFit.cover,
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        const Color(0xFF343434).withOpacity(0.4),
                        const Color(0xFF343434).withOpacity(0.15),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(15),
                    vertical: getProportionateScreenHeight(10),
                  ),
                  child: Text.rich(
                    TextSpan(
                      style: const TextStyle(color: Colors.white),
                      children: [
                        TextSpan(
                          text: "$category\n",
                          style: TextStyle(
                            fontSize: getProportionateScreenWidth(18),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(text: "$numOfBrands Brands")
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
