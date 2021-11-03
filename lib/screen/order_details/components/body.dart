import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mystore/constants.dart';
import 'package:mystore/models/order.dart';
import 'package:mystore/screen/order_details/components/order_items.dart';
import 'package:mystore/screen/order_details/components/order_status.dart';
import 'package:mystore/screen/order_details/components/shipping_info.dart';
import 'package:mystore/size_config.dart';

class Body extends StatefulWidget {
  const Body({
    Key? key,
    required this.orderId,
    required this.token,
  }) : super(key: key);

  final String token;
  final String orderId;

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  late Order order;
  var loading = false;
  final baseUrl = "https://mystore-backend.herokuapp.com";

  Future<void> getOrderDetails() async {
    setState(() {
      loading = true;
    });
    final response = await http
        .get(Uri.parse("$baseUrl/api/orders/${widget.orderId}"), headers: {
      'Authorization': 'Bearer ${widget.token}',
      "Accept": "application/json"
    });

    if (response.statusCode == 200) {
      setState(() {
        order = parseOrder(response.body);
        loading = false;
      });
    } else {
      throw Exception('Unable to fetch products from the REST API');
    }
  }

  @override
  void initState() {
    getOrderDetails();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: loading
          ? Padding(
              padding: EdgeInsets.only(top: getProportionateScreenHeight(10)),
              child: const Center(
                  child: CircularProgressIndicator(
                color: kPrimaryColor,
                // backgroundColor: Colors.black,
              )),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: getProportionateScreenHeight(3)),
                  const Divider(color: Colors.black),
                  OrderStatusRow(order: order),
                  SizedBox(height: getProportionateScreenHeight(6)),
                  ShippingInfo(order: order),
                  SizedBox(height: getProportionateScreenHeight(6)),
                  OrderItems(order: order),
                  Divider(
                    color: Colors.black54,
                    height: getProportionateScreenHeight(20),
                  ),
                  SizedBox(height: getProportionateScreenHeight(6)),
                  Padding(
                    padding:
                        EdgeInsets.only(left: getProportionateScreenWidth(20)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Order ID :    ${order.id}",
                          style: TextStyle(
                            fontSize: getProportionateScreenWidth(15),
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: getProportionateScreenHeight(6)),
                        PriceRow(
                            title: "Items price :",
                            price: order.totalPrice -
                                order.shippingPrice -
                                order.taxPrice),
                        SizedBox(height: getProportionateScreenHeight(6)),
                        PriceRow(title: "Tax price :", price: order.taxPrice),
                        SizedBox(height: getProportionateScreenHeight(6)),
                        PriceRow(
                            title: "Shipping price :",
                            price: order.shippingPrice.toDouble()),
                        SizedBox(height: getProportionateScreenHeight(6)),
                        PriceRow(
                            title: "Total price :", price: order.totalPrice),
                      ],
                    ),
                  ),
                  SizedBox(height: getProportionateScreenHeight(20)),
                ],
              ),
            ),
    );
  }
}

class PriceRow extends StatelessWidget {
  const PriceRow({
    Key? key,
    required this.title,
    required this.price,
  }) : super(key: key);

  final String title;
  final double price;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: getProportionateScreenWidth(15),
                color: Colors.black,
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(right: getProportionateScreenWidth(55)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "\$${(price).toStringAsFixed(2)}",
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(15),
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
