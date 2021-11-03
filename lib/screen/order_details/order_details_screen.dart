// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:mystore/components/default_button.dart';
import 'package:mystore/constants.dart';
import 'package:mystore/models/order.dart';
import 'package:http/http.dart' as http;
import 'package:mystore/models/user.dart';
import 'package:mystore/screen/order_details/components/order_items.dart';
import 'package:mystore/screen/order_details/components/order_status.dart';
import 'package:mystore/screen/order_details/components/shipping_info.dart';
import 'package:mystore/screen/orders_my/my_order_screen.dart';
import 'package:mystore/size_config.dart';
import 'package:flutter_braintree/flutter_braintree.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({
    Key? key,
    required this.orderId,
    required this.user,
  }) : super(key: key);

  final String orderId;
  final User user;

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  late Order order;
  var loading = false;
  final baseUrl = "https://mystore-backend.herokuapp.com";
  // final baseUrl = "http://localhost:5000";

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
        order = parseOrder(response.body);
        loading = false;
      });
    } else {
      throw Exception('Unable to fetch products from the REST API');
    }
  }

  Future<void> markAsPaid() async {
    setState(() {
      loading = true;
    });
    final response = await http
        .put(Uri.parse("$baseUrl/api/orders/${widget.orderId}/pay"), headers: {
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

  Future<void> cancelOrder() async {
    setState(() {
      loading = true;
    });
    final response = await http.put(
        Uri.parse("$baseUrl/api/orders/${widget.orderId}/cancel"),
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
    return Scaffold(
      appBar:
          // CustomAppBarOrder(),
          AppBar(
        centerTitle: true,
        title: const Text(
          "Order Infomation",
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MyOrders(user: widget.user)),
                  (Route<dynamic> route) => false,
                )),
      ),
      // ============================ body ===========================//
      body: Container(
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
                      padding: EdgeInsets.only(
                          left: getProportionateScreenWidth(20)),
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
      ),
      // ============================ bottom bar ===========================//
      bottomNavigationBar: Container(
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
                  padding:
                      EdgeInsets.only(top: getProportionateScreenHeight(10)),
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
                          child: (order.status == 1 &&
                                  order.paymentMethod.toLowerCase() == "paypal")
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      width: getProportionateScreenHeight(155),
                                      height: getProportionateScreenHeight(50),
                                      child: TextButton(
                                        style: TextButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          primary: Colors.white,
                                          backgroundColor: kPrimaryColor,
                                        ),
                                        onPressed: () async {
                                          final request =
                                              BraintreeDropInRequest(
                                            tokenizationKey:
                                                "sandbox_bnmjvh5d_9qzq2sh2s4ndqyfz",
                                            collectDeviceData: true,

                                            // googlePaymentRequest:
                                            //     BraintreeGooglePaymentRequest(
                                            //   totalPrice:
                                            //       order.totalPrice.toStringAsFixed(2),
                                            //   currencyCode: 'USD',
                                            //   billingAddressRequired: false,
                                            // ),
                                            paypalRequest:
                                                BraintreePayPalRequest(
                                              amount: "${order.totalPrice}",
                                              displayName: order.user.name,
                                            ),
                                            cardEnabled: true,
                                          );
                                          BraintreeDropInResult? result =
                                              await BraintreeDropIn.start(
                                                  request);
                                          if (result != null) {
                                            print(result.paymentMethodNonce
                                                .description);
                                            print(result
                                                .paymentMethodNonce.nonce);
                                            markAsPaid();
                                          } else {
                                            print('Selection was canceled.');
                                          }
                                        },
                                        child: Text(
                                          "Pay now",
                                          style: TextStyle(
                                            fontSize:
                                                getProportionateScreenWidth(18),
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 2,
                                    ),
                                    SizedBox(
                                      width: getProportionateScreenHeight(155),
                                      height: getProportionateScreenHeight(50),
                                      child: TextButton(
                                        style: TextButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          primary: Colors.white,
                                          backgroundColor: kPrimaryColor,
                                        ),
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  AlertDialog(
                                                    title:
                                                        const Text("Confirm"),
                                                    content: const Text(
                                                        "Are you sure to cancel this order?"),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                context, 'No'),
                                                        child: const Text('No'),
                                                      ),
                                                      TextButton(
                                                          child:
                                                              const Text('Yes'),
                                                          onPressed: () => {
                                                                Navigator.pop(
                                                                    context,
                                                                    'Yes'),
                                                                cancelOrder(),
                                                              }),
                                                    ],
                                                  ));
                                        },
                                        child: Text(
                                          "Cancel",
                                          style: TextStyle(
                                            fontSize:
                                                getProportionateScreenWidth(18),
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : (order.status == 1 &&
                                      order.paymentMethod.toLowerCase() ==
                                          "shipcod")
                                  ? DefaultButton(
                                      text: "Cancel",
                                      press: () => showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              AlertDialog(
                                                title: const Text("Confirm"),
                                                content: const Text(
                                                    "Are you sure to cancel this order?"),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                            context, 'No'),
                                                    child: const Text('No'),
                                                  ),
                                                  TextButton(
                                                      child: const Text('Yes'),
                                                      onPressed: () => {
                                                            Navigator.pop(
                                                                context, 'Yes'),
                                                            cancelOrder(),
                                                          }),
                                                ],
                                              )))
                                  : (order.status == 3)
                                      ? DefaultButton(
                                          text: "Mark as Received",
                                          press: () => showDialog(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  AlertDialog(
                                                    title:
                                                        const Text("Confirm"),
                                                    content: const Text(
                                                        "If you confirm received, this order will complete and can not refund !"),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                context,
                                                                'Cancel'),
                                                        child: const Text(
                                                            'Cancel'),
                                                      ),
                                                      TextButton(
                                                          child:
                                                              const Text('OK'),
                                                          onPressed: () => {
                                                                Navigator.pop(
                                                                    context,
                                                                    'OK'),
                                                                markAsReceived(),
                                                              }),
                                                    ],
                                                  )))
                                      : null,
                        ),
                      ],
                    ),
                  ],
                ),
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
