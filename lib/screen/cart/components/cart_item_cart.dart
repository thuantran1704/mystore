import 'package:flutter/material.dart';
import 'package:mystore/models/user.dart';

import 'package:mystore/size_config.dart';

class CartItemCard extends StatefulWidget {
  const CartItemCard({
    Key? key,
    required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  State<CartItemCard> createState() => _CartItemCardState();
}

class _CartItemCardState extends State<CartItemCard> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: getProportionateScreenWidth(88),
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
                  widget.cart.product.images[0].url),
            ),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.cart.product.name, // product name here
                style: const TextStyle(fontSize: 16, color: Colors.black),
                maxLines: 2,
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text.rich(
                    TextSpan(
                      text: "\$${widget.cart.product.price.toString()}",
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          IconButton(
                            iconSize: 18.0,
                            padding: const EdgeInsets.all(2.0),
                            icon: const Icon(Icons.remove),
                            onPressed: () {
                              setState(() {
                                widget.cart.qty -= 1;
                              });
                            },
                          ),
                          Text(
                            "${widget.cart.qty}",
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          IconButton(
                            iconSize: 18.0,
                            padding: const EdgeInsets.all(2.0),
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              setState(() {
                                widget.cart.qty += 1;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}
