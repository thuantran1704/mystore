// ignore_for_file: import_of_legacy_library_into_null_safe

import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:mystore/constants.dart';
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
  double sum = 0;
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
    });

    var response =
        await http.post(Uri.parse("$baseUrl/api/statistic/productbetween"),
            headers: <String, String>{
              'Authorization': 'Bearer ${widget.user.token}',
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode({"dateFrom": dateFrom, "dateTo": dateTo}));

    if (response.statusCode == 200) {
      setState(() {
        Statistic statistic = statisticFromJson(response.body);
        list = statistic.result;
        sum = statistic.sum;
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
  // @override
  // void initState() {
  //   super.initState();
  //   // getStatisticData(getText(DateTime.now()), getText(DateTime.now()));
  // }

  @override
  Widget build(BuildContext context) {
    List<charts.Series<Result, String>> series = [
      charts.Series(
          id: "name",
          data: list,
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
                  SizedBox(
                    height: getProportionateScreenHeight(16),
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
                  SizedBox(
                    height: 420,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
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
                                    height: 35,
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
                                    height: 35,
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
              height: getProportionateScreenHeight(60),
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
            height: 30,
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
