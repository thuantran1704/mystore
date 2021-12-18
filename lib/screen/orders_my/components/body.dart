// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:flutter/material.dart';
import 'package:mystore/constants.dart';
import 'package:mystore/models/order.dart';
import 'package:mystore/models/user.dart';
import 'package:mystore/screen/order_details/order_details_screen.dart';
import 'package:mystore/size_config.dart';
import 'package:http/http.dart' as http;

class Body extends StatefulWidget {
  const Body({
    Key? key,
    required this.user,
  }) : super(key: key);

  final User user;

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  List<Order> list = [];
  var loading = false;
  final baseUrl = "https://mystore-backend.herokuapp.com";
  Future<void> getMyOrders() async {
    setState(() {
      loading = true;
    });
    final response = await http.get(Uri.parse("$baseUrl/api/orders/myorders"),
        headers: {
          'Authorization': 'Bearer ${widget.user.token}',
          "Accept": "application/json"
        });

    if (response.statusCode == 200) {
      setState(() {
        list = parseOrders(response.body);
        loading = false;
      });
    } else {
      throw Exception('Unable to fetch products from the REST API');
    }
  }

  @override
  void initState() {
    super.initState();
    getMyOrders();
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
              child: (list.isEmpty)
                  ? const Center(
                      child: Text("Your list Order is empty"),
                    )
                  : Column(
                      children: [
                        ...List.generate(
                          list.length,
                          (index) => Column(
                            children: [
                              SizedBox(
                                  height: getProportionateScreenHeight(10)),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => OrderScreen(
                                                orderId: list[index].id,
                                                user: widget.user,
                                              )));
                                },
                                child: Container(
                                  height: SizeConfig.screenHeight * 0.12,
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey.shade200,
                                          blurRadius: 12.0,
                                          spreadRadius: 4.0),
                                    ],
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          margin:
                                              const EdgeInsets.only(left: 15.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                list[index].id,
                                                style: const TextStyle(
                                                  fontSize: 16.0,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                "Total : " +
                                                    list[index]
                                                        .totalPrice
                                                        .toString(),
                                                style: const TextStyle(
                                                  fontSize: 14.0,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              (list[index]
                                                          .status
                                                          .toLowerCase() ==
                                                      "pay")
                                                  ? const StatusMyOrdersCard(
                                                      status:
                                                          "Waitting for Payment",
                                                      color: Colors.blueAccent)
                                                  : (list[index]
                                                              .status
                                                              .toLowerCase() ==
                                                          "wait")
                                                      ? const StatusMyOrdersCard(
                                                          status:
                                                              "Waitting for Confirm",
                                                          color:
                                                              Colors.blueAccent,
                                                        )
                                                      : (list[index]
                                                                  .status
                                                                  .toLowerCase() ==
                                                              "delivered")
                                                          ? const StatusMyOrdersCard(
                                                              status:
                                                                  "On delivery",
                                                              color:
                                                                  kPrimaryColor,
                                                            )
                                                          : (list[index]
                                                                      .status
                                                                      .toLowerCase() ==
                                                                  "received")
                                                              ? const StatusMyOrdersCard(
                                                                  status:
                                                                      "Completed",
                                                                  color: Colors
                                                                      .green,
                                                                )
                                                              : (list[index]
                                                                          .status
                                                                          .toLowerCase() ==
                                                                      "return")
                                                                  ? const StatusMyOrdersCard(
                                                                      status:
                                                                          "Requesting Return",
                                                                      color: Colors
                                                                          .deepOrange,
                                                                    )
                                                                  : (list[index]
                                                                              .status
                                                                              .toLowerCase() ==
                                                                          "returned")
                                                                      ? const StatusMyOrdersCard(
                                                                          status:
                                                                              "Returned",
                                                                          color:
                                                                              Colors.deepOrange,
                                                                        )
                                                                      : StatusMyOrdersCard(
                                                                          status:
                                                                              "Cancelled",
                                                                          color: Colors
                                                                              .red
                                                                              .shade900,
                                                                        )
                                            ],
                                          ),
                                        ),
                                        const Icon(
                                          Icons.chevron_right,
                                          color: kPrimaryColor,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
            ),
    );
  }
}

class StatusMyOrdersCard extends StatelessWidget {
  const StatusMyOrdersCard({
    Key? key,
    required this.status,
    required this.color,
  }) : super(key: key);
  final String status;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Text(
      status,
      style: TextStyle(
        fontSize: 14.0,
        color: color,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
