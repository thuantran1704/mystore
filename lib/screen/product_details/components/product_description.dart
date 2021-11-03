import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mystore/constants.dart';
import 'package:mystore/models/product.dart';
import 'package:mystore/size_config.dart';

class ProductDescription extends StatefulWidget {
  const ProductDescription({
    Key? key,
    required this.product,
    // required this.pressOnSeeMore,
  }) : super(key: key);

  final Product product;

  @override
  State<ProductDescription> createState() => _ProductDescriptionState();
}

class _ProductDescriptionState extends State<ProductDescription> {
  int maxLine = 3;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(20),
          ),
          child: Text(
            widget.product.name,
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        const SizedBox(height: 5),
        Padding(
          padding: EdgeInsets.only(
            left: getProportionateScreenWidth(20),
            right: getProportionateScreenWidth(30),
          ),
          child: Text(
            widget.product.description,
            maxLines: maxLine,
            style: const TextStyle(color: Colors.black54),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(20),
            vertical: 10,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  if (maxLine == 3) {
                    setState(() {
                      maxLine = 10;
                    });
                  } else {
                    setState(() {
                      maxLine = 3;
                    });
                  }
                },
                child: Row(
                  children: [
                    (maxLine == 3)
                        ? const Text(
                            "More Detail ...",
                            style: TextStyle(
                              color: kPrimaryColor,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        : const Text(
                            "... Less",
                            style: TextStyle(
                              color: kPrimaryColor,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                    const SizedBox(width: 5),
                    const Icon(Icons.arrow_forward_ios,
                        size: 12, color: kPrimaryColor)
                  ],
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.only(right: getProportionateScreenHeight(30)),
                child: (widget.product.countInStock == 0)
                    ? const Text(
                        "Out of Stock ",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      )
                    : Text(
                        "In stock : ${widget.product.countInStock.toString()}",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
