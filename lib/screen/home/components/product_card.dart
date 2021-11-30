import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mystore/constants.dart';
import 'package:mystore/models/product.dart';
import 'package:mystore/size_config.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    Key? key,
    this.width = 6,
    this.aspectRetion = 1.1,
    required this.product,
    required this.press,
  }) : super(key: key);

  final double width, aspectRetion;
  final Product product;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: getProportionateScreenWidth(20),
        top: getProportionateScreenHeight(15),
      ),
      child: GestureDetector(
        onTap: press,
        child: SizedBox(
          width: getProportionateScreenWidth(140),
          child: Column(
            children: [
              AspectRatio(
                aspectRatio: aspectRetion,
                child: Container(
                  padding: EdgeInsets.all(getProportionateScreenWidth(width)),
                  decoration: BoxDecoration(
                      color: Colors.white60,
                      borderRadius: BorderRadius.circular(20),
                      border:
                          Border.all(color: kSecondaryColor.withOpacity(0.4))),
                  child: Image.network(product.images[0].url),
                ),
              ),
              const SizedBox(height: 5),
              Padding(
                padding: EdgeInsets.only(left: getProportionateScreenHeight(5)),
                child: Text(
                  product.name,
                  style: TextStyle(
                    fontSize: getProportionateScreenWidth(14),
                    color: Colors.black,
                  ),
                  maxLines: 2,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: getProportionateScreenHeight(5),
                  right: getProportionateScreenHeight(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "\$${product.price}",
                      style: TextStyle(
                        fontSize: getProportionateScreenWidth(15),
                        fontWeight: FontWeight.w600,
                        color: kPrimaryColor,
                      ),
                    ),
                    Row(
                      children: [
                        SvgPicture.asset("assets/icons/Star Icon.svg"),
                        const SizedBox(width: 5),
                        Text(product.rating.toStringAsFixed(1),
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                            )),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
