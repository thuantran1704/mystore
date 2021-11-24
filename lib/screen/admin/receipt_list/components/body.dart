// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:flutter/material.dart';
import 'package:mystore/constants.dart';
import 'package:mystore/models/reciept.dart';
import 'package:mystore/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:mystore/screen/admin/receipt_detail/receipt_detail.dart';
import 'package:mystore/screen/orders_my/components/body.dart';
import 'package:mystore/size_config.dart';

class Body extends StatefulWidget {
  const Body({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  List<Receipt> list = [];
  var loading = false;
  final baseUrl = "https://mystore-backend.herokuapp.com";

  Future<void> getAllReceipts() async {
    setState(() {
      loading = true;
    });
    final response = await http.get(Uri.parse("$baseUrl/api/receipts"),
        headers: {
          'Authorization': 'Bearer ${widget.user.token}',
          "Accept": "application/json"
        });

    if (response.statusCode == 200) {
      setState(() {
        list = receiptFromJson(response.body);
        loading = false;
      });
    } else {
      throw Exception('Unable to fetch Receipts from the REST API');
    }
  }

  @override
  void initState() {
    getAllReceipts();
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
                )),
              )
            : list.isEmpty
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text("List Receipt is empty"),
                    ],
                  )
                : RefreshIndicator(
                    onRefresh: getAllReceipts,
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
                                            builder: (context) =>
                                                ReceiptDetailScreen(
                                                  receiptId: list[index].id,
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
                                                (list[index]
                                                            .status
                                                            .toLowerCase() ==
                                                        "ordered")
                                                    ? StatusMyOrdersCard(
                                                        status:
                                                            list[index].status,
                                                        color:
                                                            Colors.blueAccent)
                                                    : (list[index]
                                                                .status
                                                                .toLowerCase() ==
                                                            "received")
                                                        ? StatusMyOrdersCard(
                                                            status: list[index]
                                                                .status,
                                                            color: Colors.green,
                                                          )
                                                        : StatusMyOrdersCard(
                                                            status: "Cancelled",
                                                            color: Colors
                                                                .red.shade900,
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
        status: "Ordered",
        color: Colors.blueAccent,
        user: widget.user,
      ),
      OrderTabViewByStatus(
        status: "Received",
        color: Colors.green,
        user: widget.user,
      ),
      OrderTabViewByStatus(
        status: "Cancelled",
        color: Colors.red.shade900,
        user: widget.user,
      ),
    ]);
  }
}

class OrderTabViewByStatus extends StatefulWidget {
  const OrderTabViewByStatus(
      {Key? key, required this.status, required this.color, required this.user})
      : super(key: key);
  final String status;
  final Color color;
  final User user;

  @override
  _OrderTabViewByStatusState createState() => _OrderTabViewByStatusState();
}

class _OrderTabViewByStatusState extends State<OrderTabViewByStatus> {
  List<Receipt> list = [];
  var loading = false;
  final baseUrl = "https://mystore-backend.herokuapp.com";

  Future<void> getReceiptsByStatus() async {
    setState(() {
      loading = true;
    });
    final response = await http.get(
        Uri.parse("$baseUrl/api/receipts/status/${widget.status}"),
        headers: {
          'Authorization': 'Bearer ${widget.user.token}',
          "Accept": "application/json"
        });

    if (response.statusCode == 200) {
      setState(() {
        list = receiptFromJson(response.body);
        loading = false;
      });
    } else {
      throw Exception('Unable to fetch orders from the REST API');
    }
  }

  @override
  void initState() {
    getReceiptsByStatus();
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
                    Text("List Receipt is empty"),
                  ],
                )
              : RefreshIndicator(
                  onRefresh: getReceiptsByStatus,
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
                                          builder: (context) =>
                                              ReceiptDetailScreen(
                                                receiptId: list[index].id,
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
                                                  status: widget.status,
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
