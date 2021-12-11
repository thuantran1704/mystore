import 'package:flutter/material.dart';
import 'package:mystore/constants.dart';
import 'package:mystore/models/user.dart';

import 'package:mystore/size_config.dart';

class OrderItemCard extends StatelessWidget {
  const OrderItemCard({
    Key? key,
    required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: SizedBox(
            width: getProportionateScreenWidth(68),
            child: AspectRatio(
              aspectRatio: 1,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey.shade400,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Image.network(//product image here
                    cart.product.images[0].url),
              ),
            ),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                cart.product.name, // product name here
                style: const TextStyle(fontSize: 14, color: Colors.black),
                maxLines: 2,
              ),
              const SizedBox(height: 8),
              Text.rich(
                TextSpan(
                  text: "\$${cart.product.price.toString()}",
                  style: const TextStyle(fontWeight: FontWeight.w600),
                  children: [
                    TextSpan(
                      text: " x ${cart.qty}", //qty here
                      style: const TextStyle(color: kTextColor),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
