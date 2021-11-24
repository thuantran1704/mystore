import 'package:flutter/material.dart';
import 'package:mystore/models/order.dart';
import 'package:mystore/screen/order_details/components/order_item_card.dart';
import 'package:mystore/size_config.dart';

class OrderItems extends StatefulWidget {
  const OrderItems({
    Key? key,
    required this.order,
  }) : super(key: key);

  final Order order;

  @override
  State<OrderItems> createState() => _OrderItemsState();
}

class _OrderItemsState extends State<OrderItems> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(
            color: Colors.grey.shade400,
            indent: 5,
            endIndent: 30,
          ),
          SizedBox(height: getProportionateScreenHeight(4)),
          Column(
            children: [
              ...List.generate(
                  widget.order.orderItems.length,
                  (index) => OrderItemCard(
                        item: widget.order.orderItems[index],
                        status: widget.order.status,
                      )),
            ],
          ),
        ],
      ),
    );
  }
}
