// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:flutter/material.dart';
import 'package:mystore/components/default_button.dart';
import 'package:mystore/constants.dart';
import 'package:mystore/models/order.dart';
import 'package:mystore/models/user.dart';
import 'package:mystore/screen/order_details/order_details_screen.dart';
import 'package:mystore/size_config.dart';
import 'package:http/http.dart' as http;

class OrderDetailsNavigationBar extends StatefulWidget {
  const OrderDetailsNavigationBar({
    Key? key,
    required this.user,
    required this.orderId,
  }) : super(key: key);
  final User user;
  final String orderId;
  @override
  State<OrderDetailsNavigationBar> createState() =>
      _OrderDetailsNavigationBarState();
}

class _OrderDetailsNavigationBarState extends State<OrderDetailsNavigationBar> {
  late Order order;
  var loading = false;

  final baseUrl = "https://mystore-backend.herokuapp.com";

  Future<void> getOrderDetails() async {
    setState(() {
      loading = true;
    });
    final response = await http
        .get(Uri.parse("$baseUrl/api/orders/${widget.orderId}"), headers: {
      'Authorization': 'Bearer ${widget.user.token}',
      "Accept": "application/json"
    });

    if (response.statusCode == 200) {
      setState(() {
        loading = false;

        order = parseOrder(response.body);
      });
    } else {
      throw Exception('Unable to fetch products from the REST API');
    }
  }

  Future<void> markAsReceived() async {
    setState(() {
      loading = true;
    });
    final response = await http.put(
        Uri.parse("$baseUrl/api/orders/${widget.orderId}/receive"),
        headers: {
          'Authorization': 'Bearer ${widget.user.token}',
          "Accept": "application/json"
        });

    if (response.statusCode == 200) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  OrderScreen(orderId: widget.orderId, user: widget.user)));
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
      padding: EdgeInsets.symmetric(
        vertical: getProportionateScreenWidth(12),
      ),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -15),
            blurRadius: 20,
            color: const Color(0xFFDADADA).withOpacity(0.13),
          )
        ],
      ),
      child: SafeArea(
        child: loading
            ? Padding(
                padding: EdgeInsets.only(top: getProportionateScreenHeight(10)),
                child: const Center(
                    child: CircularProgressIndicator(color: kPrimaryColor)),
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: getProportionateScreenWidth(300),
                        child: (order.status == 3)
                            ? DefaultButton(
                                text: "Mark as Received",
                                press: () => {markAsReceived()},
                              )
                            : null,
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}
