import 'package:flutter/material.dart';
import 'package:mystore/constants.dart';
import 'package:mystore/models/product.dart';
import 'package:mystore/size_config.dart';

class ProductImages extends StatefulWidget {
  const ProductImages({
    Key? key,
    required this.product,
  }) : super(key: key);

  final Product product;

  @override
  State<ProductImages> createState() => _ProductImagesState();
}

class _ProductImagesState extends State<ProductImages> {
  int selectedImage = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: getProportionateScreenWidth(248),
          child: AspectRatio(
            aspectRatio: 1,
            child: Image.network(widget.product.images[selectedImage].url),
          ),
        ),
        SizedBox(height: getProportionateScreenHeight(16)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ...List.generate(
              widget.product.images.length,
              (index) => buildSmallPreview(index),
            ),
          ],
        )
      ],
    );
  }

  GestureDetector buildSmallPreview(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedImage = index;
        });
      },
      child: Container(
        margin: EdgeInsets.only(right: getProportionateScreenWidth(15)),
        padding: EdgeInsets.all(getProportionateScreenHeight(4)),
        height: getProportionateScreenHeight(52),
        width: getProportionateScreenWidth(52),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color:
                  selectedImage == index ? kPrimaryColor : Colors.transparent),
        ),
        child: Image.network(widget.product.images[index].url),
      ),
    );
  }
}
