// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:flutter/material.dart';
import 'package:mystore/constants.dart';
import 'package:mystore/models/order.dart';
import 'package:mystore/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:mystore/screen/order_details/order_details_screen.dart';
import 'package:mystore/screen/orders_my/components/body.dart';
import 'package:mystore/size_config.dart';

class Body extends StatefulWidget {
  const Body({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  List<Order> list = [];
  var loading = false;
  final baseUrl = "https://mystore-backend.herokuapp.com";

  Future<void> getAllOrders() async {
    setState(() {
      loading = true;
    });
    final response = await http.get(Uri.parse("$baseUrl/api/orders"), headers: {
      'Authorization': 'Bearer ${widget.user.token}',
      "Accept": "application/json"
    });

    if (response.statusCode == 200) {
      setState(() {
        list = parseOrders(response.body);
        loading = false;
      });
    } else {
      throw Exception('Unable to fetch orders from the REST API');
    }
  }

  @override
  void initState() {
    getAllOrders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TabBarView(children: [
      Container(
        child: loading
            ? Padding(
                padding: EdgeInsets.only(top: getProportionateScreenHeight(10)),
                child: const Center(
                  child: CircularProgressIndicator(
                    color: kPrimaryColor,
                    // backgroundColor: Colors.black,
                  ),
                ),
              )
            : list.isEmpty
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text("List Order is empty"),
                    ],
                  )
                : RefreshIndicator(
                    onRefresh: getAllOrders,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            height: getProportionateScreenHeight(12),
                          ),
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
                                            margin: const EdgeInsets.only(
                                                left: 15.0),
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
                                                (list[
                                                                index]
                                                            .status
                                                            .toLowerCase() ==
                                                        "pay")
                                                    ? const StatusMyOrdersCard(
                                                        status:
                                                            "Waitting for Payment",
                                                        color:
                                                            Colors.blueAccent)
                                                    : (list[index]
                                                                .status
                                                                .toLowerCase() ==
                                                            "wait")
                                                        ? const StatusMyOrdersCard(
                                                            status:
                                                                "Waitting for Confirm",
                                                            color: Colors
                                                                .blueAccent,
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
                                                                    : (list[index].status.toLowerCase() ==
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
                                                                            color:
                                                                                Colors.red.shade900,
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
                          SizedBox(height: getProportionateScreenHeight(20)),
                        ],
                      ),
                    ),
                  ),
      ),
      OrderTabViewByStatus(
        status: "Pay",
        title: "Waitting for Payment",
        color: Colors.blueAccent,
        user: widget.user,
      ),
      OrderTabViewByStatus(
        status: "Wait",
        title: "Waitting for Confirm",
        color: Colors.blueAccent,
        user: widget.user,
      ),
      OrderTabViewByStatus(
        status: "Delivered",
        title: "On delivery",
        color: kPrimaryColor,
        user: widget.user,
      ),
      OrderTabViewByStatus(
        status: "Received",
        title: "Completed",
        color: Colors.green,
        user: widget.user,
      ),
      OrderTabViewByStatus(
        status: "Return",
        title: "Requesting Return",
        color: Colors.deepOrange,
        user: widget.user,
      ),
      OrderTabViewByStatus(
        status: "Returned",
        title: "Returned",
        color: Colors.deepOrange,
        user: widget.user,
      ),
      OrderTabViewByStatus(
        status: "Cancelled",
        title: "Cancelled",
        color: Colors.red.shade900,
        user: widget.user,
      ),
    ]);
  }
}

class OrderTabViewByStatus extends StatefulWidget {
  const OrderTabViewByStatus(
      {Key? key,
      required this.status,
      required this.title,
      required this.color,
      required this.user})
      : super(key: key);
  final String status;
  final String title;
  final Color color;
  final User user;

  @override
  _OrderTabViewByStatusState createState() => _OrderTabViewByStatusState();
}

class _OrderTabViewByStatusState extends State<OrderTabViewByStatus> {
  List<Order> list = [];
  var loading = false;
  final baseUrl = "https://mystore-backend.herokuapp.com";

  Future<void> getOrdersByStatus() async {
    setState(() {
      loading = true;
    });
    final response = await http.get(
        Uri.parse("$baseUrl/api/orders/status/${widget.status}"),
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
      throw Exception('Unable to fetch orders from the REST API');
    }
  }

  @override
  void initState() {
    getOrdersByStatus();
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
              )),
            )
          : list.isEmpty
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text("List Order is empty"),
                  ],
                )
              : RefreshIndicator(
                  onRefresh: getOrdersByStatus,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: getProportionateScreenHeight(12),
                        ),
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
                                              StatusMyOrdersCard(
                                                  status: widget.title,
                                                  color: widget.color)
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
                        SizedBox(height: getProportionateScreenHeight(20)),
                      ],
                    ),
                  ),
                ),
    );
  }
}
