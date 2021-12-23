// ignore_for_file: import_of_legacy_library_into_null_safe

import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:mystore/constants.dart';
import 'package:mystore/models/order.dart';
import 'package:mystore/models/statistic.dart';
import 'package:mystore/models/user.dart';
import 'package:mystore/size_config.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intl/intl.dart';

class Body extends StatefulWidget {
  const Body({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  List<Result> list = [];
  List<Result> listChartData = [];
  List<Order> listOrder = [];

  late Profit listProfitFromJson;
  List<OrderProfit> listOrderProfit = [];
  List<ReceiptProfit> listReceiptProfit = [];

  OrderProfit orderItem = OrderProfit(qty: 0, price: [], productId: "");
  ReceiptProfit receiptItem = ReceiptProfit(price: [], productId: "");

  Result rs = Result(name: "name", sold: 0);
  int index = -1;
  double sum = 0;
  double profit = 0;

  var loading = false;
  final baseUrl = "https://mystore-backend.herokuapp.com";

  late DateTime dateFrom = DateTime.now();
  late DateTime dateTo = DateTime.now();

  String getText(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
    // return '${date.month}/${date.day}/${date.year}';
  }

  Future pickDateFrom(BuildContext context) async {
    final newDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
    );

    if (newDate == null) return;

    setState(() => dateFrom = newDate);
  }

  Future pickDateTo(BuildContext context) async {
    final newDate2 = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
    );

    if (newDate2 == null) return;

    setState(() => dateTo = newDate2);
  }

  Future<void> getStatisticData(String dateFrom, String dateTo) async {
    setState(() {
      loading = true;
      listOrder = [];
      list = [];
      listChartData = [];
    });

    var response =
        await http.post(Uri.parse("$baseUrl/api/statistic/orderbetween"),
            headers: <String, String>{
              'Authorization': 'Bearer ${widget.user.token}',
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode({"dateFrom": dateFrom, "dateTo": dateTo}));

    if (response.statusCode == 200) {
      setState(() {
        sum = 0;
        listOrder = parseOrders(response.body);
        for (int i = 0; i < listOrder.length; i++) {
          sum += listOrder[i].totalPrice;
          for (int j = 0; j < listOrder[i].orderItems.length; j++) {
            index = -1;
            rs = Result(
                name: listOrder[i].orderItems[j].product.name,
                sold: listOrder[i].orderItems[j].qty);
            index = list.indexWhere((element) => element.name == rs.name);
            if (index != -1) {
              list[index].sold += listOrder[i].orderItems[j].qty;
            } else {
              list.add(rs);
            }
          }
        }
        list.sort((a, b) => b.sold.compareTo(a.sold));

        if (list.length > 5) {
          for (int i = 0; i < 5; i++) {
            listChartData.add(list[i]);
          }
        } else {
          for (int i = 0; i < list.length; i++) {
            listChartData.add(list[i]);
          }
        }

        loading = false;
      });
    } else {
      throw Exception('Unable to fetch orders from the REST API');
    }
  }

  Future<void> getProfitData(String dateFrom, String dateTo) async {
    setState(() {
      loading = true;
    });

    var response =
        await http.post(Uri.parse("$baseUrl/api/statistic/profitbetween"),
            headers: <String, String>{
              'Authorization': 'Bearer ${widget.user.token}',
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode({"dateFrom": dateFrom, "dateTo": dateTo}));

    if (response.statusCode == 200) {
      setState(() {
        listProfitFromJson = profitFromJson(response.body);
        listOrderProfit = [];
        listReceiptProfit = [];
        profit = 0;
        List<OrderS> orders = listProfitFromJson.orders;
        List<ReceiptS> receipts = listProfitFromJson.receipts;

        for (int i = 0; i < orders.length; i++) {
          for (int j = 0; j < orders[i].orderItems.length; j++) {
            orderItem = OrderProfit(
                productId: orders[i].orderItems[j].product,
                qty: orders[i].orderItems[j].qty,
                price: [orders[i].orderItems[j].price]);
            index = listOrderProfit.indexWhere(
                (element) => element.productId == orderItem.productId);
            if (index == -1) {
              listOrderProfit.add(orderItem);
            } else {
              listOrderProfit[index].qty += orders[i].orderItems[j].qty;
              listOrderProfit[index].price.add(orders[i].orderItems[j].price);
            }
          }
        }

        for (int i = 0; i < receipts.length; i++) {
          for (int j = 0; j < receipts[i].receiptItems.length; j++) {
            receiptItem = ReceiptProfit(
                productId: receipts[i].receiptItems[j].product,
                price: [receipts[i].receiptItems[j].price]);
            index = listReceiptProfit.indexWhere(
                (element) => element.productId == receiptItem.productId);
            if (index == -1) {
              listReceiptProfit.add(receiptItem);
            } else {
              listReceiptProfit[index]
                  .price
                  .add(receipts[i].receiptItems[j].price);
            }
          }
        }

        for (int i = 0; i < listOrderProfit.length; i++) {
          index = listReceiptProfit.indexWhere(
              (element) => element.productId == listOrderProfit[i].productId);
          if (index != -1) {
            double importAverage = 0;
            listReceiptProfit[index].price.forEach((e) => importAverage += e);
            importAverage = importAverage /
                listReceiptProfit[index].price.length; // giá nhập trung bình.
            double sellAverage = 0;
            listOrderProfit[i].price.forEach((e) => sellAverage += e);
            sellAverage = sellAverage /
                listOrderProfit[i].price.length; // giá bán trung bình.
            profit += (sellAverage - importAverage) * listOrderProfit[i].qty;
          }
        }
        loading = false;
      });
    } else {
      throw Exception('Unable to fetch orders from the REST API');
    }
  }

  void _showToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        fontSize: 15,
        gravity: ToastGravity.BOTTOM,
        toastLength: Toast.LENGTH_LONG,
        timeInSecForIosWeb: 1);
  }

  @override
  Widget build(BuildContext context) {
    List<charts.Series<Result, String>> series = [
      charts.Series(
          id: "name",
          data: listChartData,
          domainFn: (Result ds, _) => ds.name.split(" ").first,
          measureFn: (Result ds, _) => ds.sold)
    ];
    return SafeArea(
      child: loading
          ? Padding(
              padding: EdgeInsets.only(top: getProportionateScreenHeight(20)),
              child: const Center(child: CircularProgressIndicator()),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: getProportionateScreenHeight(20)),
                  Padding(
                    padding: EdgeInsets.only(
                        left: getProportionateScreenWidth(20),
                        right: getProportionateScreenWidth(20)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "From Date : ",
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                        SizedBox(
                          width: SizeConfig.screenWidth * 0.6,
                          height: getProportionateScreenHeight(40),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(40),
                              primary: Colors.grey.shade200,
                            ),
                            child: FittedBox(
                              child: Text(
                                getText(dateFrom).substring(8, 10) +
                                    getText(dateFrom).substring(4, 8) +
                                    getText(dateFrom).substring(0, 4),
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.black),
                              ),
                            ),
                            onPressed: () => pickDateFrom(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: getProportionateScreenHeight(12)),
                  Padding(
                    padding: EdgeInsets.only(
                        left: getProportionateScreenWidth(20),
                        right: getProportionateScreenWidth(20)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "To Date : ",
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                        SizedBox(
                          width: SizeConfig.screenWidth * 0.6,
                          height: getProportionateScreenHeight(40),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(40),
                              primary: Colors.grey.shade200,
                            ),
                            child: FittedBox(
                              child: Text(
                                getText(dateTo).substring(8, 10) +
                                    getText(dateTo).substring(4, 8) +
                                    getText(dateTo).substring(0, 4),
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.black),
                              ),
                            ),
                            onPressed: () => pickDateTo(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: getProportionateScreenHeight(20)),
                  Padding(
                    padding: EdgeInsets.only(
                        left: getProportionateScreenWidth(20),
                        right: getProportionateScreenWidth(20)),
                    child: SizedBox(
                      width: double.infinity,
                      height: getProportionateScreenHeight(56),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          primary: Colors.white,
                          backgroundColor: backgroudColor,
                        ),
                        onPressed: () {
                          if (dateFrom.isAfter(dateTo)) {
                            _showToast(
                                "Date To must be equal or greater than Date From !");
                          } else {
                            getStatisticData(
                                getText(dateFrom), getText(dateTo));
                          }
                        },
                        child: Text(
                          "Statistic",
                          style: TextStyle(
                            fontSize: getProportionateScreenWidth(18),
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: getProportionateScreenHeight(20)),
                  Padding(
                    padding: EdgeInsets.only(
                        left: getProportionateScreenWidth(20),
                        right: getProportionateScreenWidth(20)),
                    child: SizedBox(
                      width: double.infinity,
                      height: getProportionateScreenHeight(56),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          primary: Colors.white,
                          backgroundColor: backgroudColor,
                        ),
                        onPressed: () {
                          if (dateFrom.isAfter(dateTo)) {
                            _showToast(
                                "Date To must be equal or greater than Date From !");
                          } else {
                            getProfitData(getText(dateFrom), getText(dateTo));
                          }
                        },
                        child: Text(
                          "Profit",
                          style: TextStyle(
                            fontSize: getProportionateScreenWidth(18),
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: getProportionateScreenHeight(16),
                  ),
                  (list.isNotEmpty)
                      ? Padding(
                          padding: EdgeInsets.only(
                              bottom: getProportionateScreenHeight(10)),
                          child: Text.rich(
                            TextSpan(
                              children: [
                                const TextSpan(
                                  text: 'Total value of all orders : ',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.black87),
                                ),
                                TextSpan(
                                  text: sum.toStringAsFixed(2) + "\$",
                                  style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ))
                      : SizedBox(
                          height: getProportionateScreenHeight(0),
                        ),
                  (profit != 0)
                      ? Center(
                          child: Column(
                            children: [
                              SizedBox(
                                height: getProportionateScreenHeight(16),
                              ),
                              RichText(
                                text: TextSpan(
                                  style: DefaultTextStyle.of(context).style,
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: "Profit form ",
                                        style: TextStyle(
                                            fontSize:
                                                getProportionateScreenHeight(
                                                    16),
                                            color: Colors.black87)),
                                    TextSpan(
                                        text: dateFrom.day.toString() +
                                            "-" +
                                            dateFrom.month.toString() +
                                            "-" +
                                            dateFrom.year.toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize:
                                                getProportionateScreenHeight(
                                                    17),
                                            color: Colors.black87)),
                                    TextSpan(
                                      text: ' to ',
                                      style: TextStyle(
                                          fontSize:
                                              getProportionateScreenHeight(16),
                                          color: Colors.black87),
                                    ),
                                    TextSpan(
                                        text: dateTo.day.toString() +
                                            "-" +
                                            dateTo.month.toString() +
                                            "-" +
                                            dateTo.year.toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize:
                                                getProportionateScreenHeight(
                                                    17),
                                            color: Colors.black87)),
                                  ],
                                ),
                              ),
                              Text(
                                "${profit.toStringAsFixed(2)}\$",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: getProportionateScreenHeight(19),
                                    color: Colors.black87),
                              ),
                              SizedBox(
                                height: getProportionateScreenHeight(16),
                              ),
                            ],
                          ),
                        )
                      : SizedBox(
                          height: getProportionateScreenHeight(0),
                        ),
                  (list.isNotEmpty)
                      ? (list.length < 5)
                          ? Text(
                              "Top ${list.length} selling products",
                              style: TextStyle(
                                fontSize: getProportionateScreenWidth(20),
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          : Text(
                              "Top 5 selling products",
                              style: TextStyle(
                                fontSize: getProportionateScreenWidth(20),
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            )
                      : SizedBox(
                          height: getProportionateScreenHeight(0),
                        ),
                  (list.isNotEmpty)
                      ? SizedBox(
                          height: 420,
                          child: Card(
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: getProportionateScreenWidth(5),
                                  right: getProportionateScreenWidth(5)),
                              child: Column(
                                children: [
                                  Expanded(
                                      child: charts.BarChart(
                                    series,
                                    animate: true,
                                  ))
                                ],
                              ),
                            ),
                          ),
                        )
                      : SizedBox(
                          height: getProportionateScreenHeight(0),
                        ),
                  SizedBox(height: getProportionateScreenHeight(20)),
                  (list.isNotEmpty)
                      ? Padding(
                          padding: EdgeInsets.only(
                              left: getProportionateScreenWidth(8),
                              right: getProportionateScreenWidth(8)),
                          child: Table(
                            border: TableBorder.all(),
                            columnWidths: const <int, TableColumnWidth>{
                              0: FixedColumnWidth(295),
                              1: FixedColumnWidth(80),
                              // 2: FlexColumnWidth(20),
                            },
                            defaultVerticalAlignment:
                                TableCellVerticalAlignment.middle,
                            children: [
                              TableRow(
                                children: [
                                  Container(
                                    height: SizeConfig.screenHeight * 0.045,
                                    color: Colors.grey.shade800,
                                    child: Center(
                                      child: Text("Product Name",
                                          style: TextStyle(
                                            fontSize:
                                                getProportionateScreenWidth(16),
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                          )),
                                    ),
                                  ),
                                  Container(
                                    height: SizeConfig.screenHeight * 0.045,
                                    color: Colors.grey.shade800,
                                    child: Center(
                                      child: Text("Sold",
                                          style: TextStyle(
                                            fontSize:
                                                getProportionateScreenWidth(16),
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                          )),
                                    ),
                                  ),
                                ],
                              ),
                              ...List.generate(
                                list.length,
                                (index) => customRow(
                                    list[index].name, list[index].sold),
                              ),
                            ],
                          ),
                        )
                      : SizedBox(
                          height: getProportionateScreenHeight(0),
                        ),
                  SizedBox(height: getProportionateScreenHeight(20)),
                ],
              ),
            ),
    );
  }

  TableRow customRow(String name, int sold) {
    return TableRow(
      decoration: const BoxDecoration(
        color: Colors.white10,
      ),
      children: [
        Center(
          child: SizedBox(
              height: SizeConfig.screenHeight * 0.075,
              child: Padding(
                padding: EdgeInsets.only(
                    left: getProportionateScreenWidth(5),
                    right: getProportionateScreenWidth(5),
                    top: getProportionateScreenHeight(4)),
                child: Text(name,
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: getProportionateScreenWidth(15),
                      color: Colors.black87,
                      fontWeight: FontWeight.w400,
                    )),
              )),
        ),
        Center(
          child: SizedBox(
            height: 26,
            child: Text(sold.toString(),
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(16),
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                )),
          ),
        ),
      ],
    );
  }
}
