// ignore_for_file: avoid_print, import_of_legacy_library_into_null_safe

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mystore/components/default_button.dart';
import 'package:mystore/constants.dart';
import 'package:mystore/models/order.dart';
import 'package:http/http.dart' as http;
import 'package:mystore/models/user.dart';
import 'package:mystore/screen/admin/order_list/order_list.dart';
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
      throw Exception('Unable to update order from the REST API');
    }
  }

  Future<void> markAsDelivery() async {
    setState(() {
      loading = true;
    });
    final response = await http.put(
        Uri.parse("$baseUrl/api/orders/${widget.orderId}/deliver"),
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
      throw Exception('Unable to update order from the REST API');
    }
  }

  Future<void> returnOrderByUser() async {
    setState(() {
      loading = true;
    });
    final response = await http.put(
        Uri.parse("$baseUrl/api/orders/${widget.orderId}/return"),
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
      throw Exception('Unable to update order from the REST API');
    }
  }

  Future<void> returnOrderByAdmin() async {
    setState(() {
      loading = true;
    });
    final response = await http.put(
        Uri.parse("$baseUrl/api/orders/${widget.orderId}/returned"),
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
      throw Exception('Unable to update order from the REST API');
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
      if (order.discountPrice == 0) {
        addVoucher(
            widget.user.token,
            (order.totalPrice -
                order.shippingPrice -
                order.taxPrice +
                order.discountPrice),
            0);
        Timer(const Duration(seconds: 4), () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      OrderScreen(orderId: widget.orderId, user: widget.user)));
        });
      } else {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    OrderScreen(orderId: widget.orderId, user: widget.user)));
      }
    } else {
      throw Exception('Unable to update order from the REST API');
    }
  }

  Future<void> addVoucher(
      String token, double itemPrice, double discountPrice) async {
    var id = "";
    if (discountPrice != 0) {
      if (itemPrice / discountPrice > 4 && itemPrice / discountPrice < 6) {
        id = "61a5b3fa386b752278e13407"; //XMASVOUCHER
      } else if (itemPrice / discountPrice > 6 &&
          itemPrice / discountPrice < 7) {
        id = "61a5b573dba9751ee8093113"; //DISCOUNT15
      } else if (itemPrice / discountPrice > 9 &&
          itemPrice / discountPrice < 11) {
        id = "61a5b36e386b752278e13400"; //DISCOUNT10
      }
    } else {
      if (itemPrice >= 500) {
        id = "61a5b3fa386b752278e13407"; //XMASVOUCHER

      } else if (itemPrice >= 350) {
        id = "61a5b573dba9751ee8093113"; //DISCOUNT15

      } else if (itemPrice >= 200) {
        id = "61a5b36e386b752278e13400"; //DISCOUNT10
      }
    }

    var response = await http.post(Uri.parse("$baseUrl/api/users/voucher/add"),
        headers: <String, String>{
          'Authorization': 'Bearer ${widget.user.token}',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({"id": id}));

    if (response.statusCode == 201) {
      //Add to voucher Successfully
      setState(() {
        widget.user.voucher = parseVoucher(response.body);
      });
    } else if (response.statusCode == 202) {
      // voucher already added to voucher list
    } else {
      throw Exception('Unable to add voucher from the REST API');
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
      if (order.discountPrice != 0) {
        addVoucher(
            widget.user.token,
            (order.totalPrice -
                order.shippingPrice -
                order.taxPrice +
                order.discountPrice),
            order.discountPrice);

        Timer(const Duration(seconds: 2), () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      OrderScreen(orderId: widget.orderId, user: widget.user)));
        });
      } else {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    OrderScreen(orderId: widget.orderId, user: widget.user)));
      }
    } else {
      throw Exception('Unable to cancel order from the REST API');
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
            onPressed: () => {
                  if (widget.user.role.name.toLowerCase() == "admin")
                    {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                OrdertListScreen(user: widget.user)),
                        (Route<dynamic> route) => false,
                      )
                    }
                  else
                    {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyOrders(user: widget.user)),
                        (Route<dynamic> route) => false,
                      )
                    }
                }),
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
                    OrderItems(
                      order: order,
                      user: widget.user,
                    ),
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    "Order ID :",
                                    style: TextStyle(
                                      fontSize:
                                          getProportionateScreenWidth(15.5),
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    right: getProportionateScreenWidth(35)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      order.id,
                                      style: TextStyle(
                                        fontSize:
                                            getProportionateScreenWidth(15.5),
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: getProportionateScreenHeight(6)),
                          PriceRow(
                              title: "Items price :",
                              price: order.totalPrice -
                                  order.shippingPrice -
                                  order.taxPrice +
                                  order.discountPrice),
                          SizedBox(height: getProportionateScreenHeight(6)),
                          PriceRow(title: "Tax price :", price: order.taxPrice),
                          SizedBox(height: getProportionateScreenHeight(6)),
                          PriceRow(
                              title: "Shipping price :",
                              price: order.shippingPrice.toDouble()),
                          (order.discountPrice != 0)
                              ? SizedBox(
                                  height: getProportionateScreenHeight(6))
                              : const SizedBox(),
                          (order.discountPrice != 0)
                              ? PriceRow(
                                  title: "Discount price :",
                                  price: -order.discountPrice.toDouble())
                              : const SizedBox(),
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
                          width: SizeConfig.screenWidth * 0.87,
                          child: (order.status.toLowerCase() == "pay" &&
                                  widget.user.role.name.toLowerCase() !=
                                      "admin")
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
                              : (order.status.toLowerCase() == "pay" &&
                                      widget.user.role.name.toLowerCase() ==
                                          "admin")
                                  ? null
                                  : (order.status.toLowerCase() == "wait" &&
                                          widget.user.role.name.toLowerCase() ==
                                              "admin")
                                      ? DefaultButton(
                                          text: "Mark as Delivery",
                                          press: () => showDialog(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  AlertDialog(
                                                    title:
                                                        const Text("Confirm"),
                                                    content: const Text(
                                                        "Are you sure to mark delivery this order?"),
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
                                                                markAsDelivery(),
                                                              }),
                                                    ],
                                                  )))
                                      : (order.status.toLowerCase() == "wait" &&
                                              order.paymentMethod
                                                      .toLowerCase() !=
                                                  "paypal" &&
                                              widget.user.role.name
                                                      .toLowerCase() !=
                                                  "admin")
                                          ? DefaultButton(
                                              text: "Cancel",
                                              press: () => showDialog(
                                                  context: context,
                                                  builder: (BuildContext context) =>
                                                      AlertDialog(
                                                        title: const Text(
                                                            "Confirm"),
                                                        content: const Text(
                                                            "Are you sure to cancel this order?"),
                                                        actions: <Widget>[
                                                          TextButton(
                                                            onPressed: () =>
                                                                Navigator.pop(
                                                                    context,
                                                                    'No'),
                                                            child: const Text(
                                                                'No'),
                                                          ),
                                                          TextButton(
                                                              child: const Text(
                                                                  'Yes'),
                                                              onPressed: () => {
                                                                    Navigator.pop(
                                                                        context,
                                                                        'Yes'),
                                                                    cancelOrder(),
                                                                  }),
                                                        ],
                                                      )))
                                          : (order.status.toLowerCase() ==
                                                      "delivered" &&
                                                  widget.user.role.name
                                                          .toLowerCase() !=
                                                      "admin")
                                              ? Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    SizedBox(
                                                      width:
                                                          getProportionateScreenHeight(
                                                              140),
                                                      height:
                                                          getProportionateScreenHeight(
                                                              50),
                                                      child: TextButton(
                                                        style: TextButton
                                                            .styleFrom(
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20)),
                                                          primary: Colors.white,
                                                          backgroundColor:
                                                              kPrimaryColor,
                                                        ),
                                                        onPressed: () {
                                                          showDialog(
                                                              context: context,
                                                              builder: (BuildContext
                                                                      context) =>
                                                                  AlertDialog(
                                                                    title: const Text(
                                                                        "Confirm"),
                                                                    content:
                                                                        const Text(
                                                                            "Are you sure to return this order?"),
                                                                    actions: <
                                                                        Widget>[
                                                                      TextButton(
                                                                        onPressed: () => Navigator.pop(
                                                                            context,
                                                                            'No'),
                                                                        child: const Text(
                                                                            'No'),
                                                                      ),
                                                                      TextButton(
                                                                          child: const Text(
                                                                              'Yes'),
                                                                          onPressed: () =>
                                                                              {
                                                                                Navigator.pop(context, 'Yes'),
                                                                                returnOrderByUser(),
                                                                              }),
                                                                    ],
                                                                  ));
                                                        },
                                                        child: Text(
                                                          "Return",
                                                          style: TextStyle(
                                                            fontSize:
                                                                getProportionateScreenWidth(
                                                                    18),
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 2,
                                                    ),
                                                    SizedBox(
                                                        width:
                                                            getProportionateScreenHeight(
                                                                190),
                                                        height:
                                                            getProportionateScreenHeight(
                                                                50),
                                                        child: TextButton(
                                                          style: TextButton
                                                              .styleFrom(
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20)),
                                                            primary:
                                                                Colors.white,
                                                            backgroundColor:
                                                                kPrimaryColor,
                                                          ),
                                                          onPressed: () {
                                                            showDialog(
                                                                context:
                                                                    context,
                                                                builder: (BuildContext
                                                                        context) =>
                                                                    AlertDialog(
                                                                      title: const Text(
                                                                          "Confirm"),
                                                                      content:
                                                                          const Text(
                                                                              "If you confirm received, this order will complete and can not return!"),
                                                                      actions: <
                                                                          Widget>[
                                                                        TextButton(
                                                                          onPressed: () => Navigator.pop(
                                                                              context,
                                                                              'No'),
                                                                          child:
                                                                              const Text('No'),
                                                                        ),
                                                                        TextButton(
                                                                            child:
                                                                                const Text('Yes'),
                                                                            onPressed: () => {
                                                                                  Navigator.pop(context, 'Yes'),
                                                                                  markAsReceived(),
                                                                                }),
                                                                      ],
                                                                    ));
                                                          },
                                                          child: Text(
                                                            "Mark as Received",
                                                            style: TextStyle(
                                                              fontSize:
                                                                  getProportionateScreenWidth(
                                                                      18),
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        )),
                                                  ],
                                                )
                                              : (order.status.toLowerCase() ==
                                                          "return" &&
                                                      widget.user.role.name
                                                              .toLowerCase() ==
                                                          "admin")
                                                  ? DefaultButton(
                                                      text: "Mark as Returned",
                                                      press: () => showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                                  context) =>
                                                              AlertDialog(
                                                                title: const Text(
                                                                    "Confirm"),
                                                                content: const Text(
                                                                    "Are you sure to mark returned this order?"),
                                                                actions: <
                                                                    Widget>[
                                                                  TextButton(
                                                                    onPressed: () =>
                                                                        Navigator.pop(
                                                                            context,
                                                                            'No'),
                                                                    child:
                                                                        const Text(
                                                                            'No'),
                                                                  ),
                                                                  TextButton(
                                                                      child: const Text(
                                                                          'Yes'),
                                                                      onPressed:
                                                                          () =>
                                                                              {
                                                                                Navigator.pop(context, 'Yes'),
                                                                                returnOrderByAdmin(),
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
          padding: EdgeInsets.only(right: getProportionateScreenWidth(35)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "${(price).toStringAsFixed(2)}\$",
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
