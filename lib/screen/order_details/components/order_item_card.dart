import 'package:flutter/material.dart';
import 'package:mystore/constants.dart';
import 'package:mystore/models/order.dart';

import 'package:mystore/size_config.dart';

class OrderItemCard extends StatefulWidget {
  const OrderItemCard({
    Key? key,
    required this.item,
    required this.status,
  }) : super(key: key);

  final OrderItem item;
  final int status;

  @override
  State<OrderItemCard> createState() => _OrderItemCardState();
}

class _OrderItemCardState extends State<OrderItemCard> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: SizedBox(
            width: getProportionateScreenWidth(72),
            child: AspectRatio(
              aspectRatio: 1,
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey.shade400,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Image.network(//product image here
                    widget.item.image),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.item.name, // product name here
                style: const TextStyle(fontSize: 15, color: Colors.black),
                maxLines: 2,
              ),
              const SizedBox(height: 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text.rich(
                    TextSpan(
                      text: "\$${widget.item.price.toString()}",
                      style: const TextStyle(fontWeight: FontWeight.w600),
                      children: [
                        TextSpan(
                          text: " x ${widget.item.qty}", //qty here
                          style:
                              const TextStyle(color: kTextColor, fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                  (widget.status == 3 || widget.status == 4)
                      ? Padding(
                          padding: EdgeInsets.only(
                            right: getProportionateScreenWidth(30),
                            // bottom: getProportionateScreenHeight(5),
                          ),
                          child: SafeArea(
                            child: SizedBox(
                              width: getProportionateScreenHeight(86),
                              height: getProportionateScreenHeight(38),
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                  primary: Colors.white,
                                  backgroundColor: kPrimaryColor,
                                ),
                                onPressed: () {},
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: const [
                                    Text(
                                      "review",
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      : const SizedBox()
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
