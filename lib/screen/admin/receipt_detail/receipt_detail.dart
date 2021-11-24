// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mystore/constants.dart';
import 'package:mystore/models/reciept.dart';
import 'package:mystore/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:mystore/screen/admin/receipt_detail/components/receipt_items.dart';

import 'package:mystore/screen/admin/receipt_detail/components/receipt_status_row.dart';
import 'package:mystore/screen/admin/receipt_list/receipt_list.dart';
import 'package:mystore/size_config.dart';

class ReceiptDetailScreen extends StatefulWidget {
  const ReceiptDetailScreen({
    Key? key,
    required this.receiptId,
    required this.user,
  }) : super(key: key);
  final String receiptId;
  final User user;

  @override
  State<ReceiptDetailScreen> createState() => _ReceiptDetailScreenState();
}

class _ReceiptDetailScreenState extends State<ReceiptDetailScreen> {
  late Receipt receipt;
  var loading = false;
  final baseUrl = "https://mystore-backend.herokuapp.com";

  Future<void> getReceiptDetails() async {
    setState(() {
      loading = true;
    });
    final response = await http
        .get(Uri.parse("$baseUrl/api/receipts/${widget.receiptId}"), headers: {
      'Authorization': 'Bearer ${widget.user.token}',
      "Accept": "application/json"
    });
    if (response.statusCode == 200) {
      setState(() {
        receipt = singleReceiptFromJson(response.body);
        loading = false;
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
        Uri.parse("$baseUrl/api/receipts/${widget.receiptId}/receive"),
        headers: {
          'Authorization': 'Bearer ${widget.user.token}',
          "Accept": "application/json"
        });

    if (response.statusCode == 200) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => ReceiptDetailScreen(
                  receiptId: widget.receiptId, user: widget.user)));
    } else {
      throw Exception('Unable to update Receipt from the REST API');
    }
  }

  Future<void> cancelReceipt() async {
    setState(() {
      loading = true;
    });
    final response = await http.put(
        Uri.parse("$baseUrl/api/receipts/${widget.receiptId}/cancel"),
        headers: {
          'Authorization': 'Bearer ${widget.user.token}',
          "Accept": "application/json"
        });

    if (response.statusCode == 200) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => ReceiptDetailScreen(
                  receiptId: widget.receiptId, user: widget.user)));
    } else {
      throw Exception('Unable to update Receipt from the REST API');
    }
  }

  @override
  void initState() {
    getReceiptDetails();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: backgroudColor,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Receipt Detail",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ReceiptListScreen(user: widget.user)),
                    (Route<dynamic> route) => false,
                  )
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
                )),
              )
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: getProportionateScreenHeight(3)),
                    ReceiptStatusRow(receipt: receipt),
                    SizedBox(height: getProportionateScreenHeight(6)),
                    CustomSuplier(suplier: receipt.supplier),
                    SizedBox(height: getProportionateScreenHeight(6)),
                    Divider(
                      color: Colors.black54,
                      height: getProportionateScreenHeight(20),
                    ),
                    SizedBox(height: getProportionateScreenHeight(6)),
                    ReceiptItems(receipt: receipt),
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
                            "Order ID :    ${receipt.id}",
                            style: TextStyle(
                              fontSize: getProportionateScreenWidth(15),
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: getProportionateScreenHeight(6)),
                          PriceRow(
                              title: "Items price :",
                              price: receipt.totalPrice),
                          SizedBox(height: getProportionateScreenHeight(6)),
                          PriceRow(
                              title: "Shipping price :",
                              price: receipt.shippingPrice.toDouble()),
                          SizedBox(height: getProportionateScreenHeight(6)),
                          PriceRow(
                              title: "Total price :",
                              price: receipt.totalPrice),
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
                    (receipt.status.toLowerCase() == "ordered")
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: getProportionateScreenWidth(330),
                                child: Row(
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
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  AlertDialog(
                                                    title:
                                                        const Text("Confirm"),
                                                    content: const Text(
                                                        "Are you sure to Cancel this Receipt?"),
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
                                                                cancelReceipt(),
                                                              }),
                                                    ],
                                                  ));
                                        },
                                        child: Text(
                                          "Cancel",
                                          style: TextStyle(
                                            fontSize:
                                                getProportionateScreenWidth(16),
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 2),
                                    SizedBox(
                                      width: getProportionateScreenHeight(175),
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
                                                        "Are you sure to mark as Received this Receipt?"),
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
                                                                markAsReceived(),
                                                              }),
                                                    ],
                                                  ));
                                        },
                                        child: Text(
                                          "Mark as Received",
                                          style: TextStyle(
                                            fontSize:
                                                getProportionateScreenWidth(16),
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        : const SizedBox(),
                  ],
                ),
        ),
      ),
    );
  }
}

class CustomSuplier extends StatelessWidget {
  const CustomSuplier({
    Key? key,
    required this.suplier,
  }) : super(key: key);

  final Supplier suplier;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12),
      child: Container(
        height: SizeConfig.screenHeight * 0.16,
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black54),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.shade100,
                // blurRadius: 10.0,
                spreadRadius: 2.0),
          ],
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: getProportionateScreenWidth(16),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                          1,
                          getProportionateScreenWidth(14),
                          getProportionateScreenWidth(10),
                          getProportionateScreenWidth(12),
                        ),
                        child: SvgPicture.asset(
                          "assets/icons/Location point.svg",
                          color: kPrimaryColor,
                          allowDrawingOutsideViewBox: true,
                          height: getProportionateScreenWidth(18),
                        ),
                      ),
                      const Text(
                        "Shipping Infomation",
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        suplier.name,
                        maxLines: 2,
                        style: const TextStyle(
                          fontSize: 14.0,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "Phone : ${suplier.phone}",
                        style: const TextStyle(
                          fontSize: 13.0,
                          color: Colors.black54,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 2),
                  SizedBox(
                    width: getProportionateScreenWidth(330),
                    height: getProportionateScreenWidth(36),
                    child: Text(
                      "${suplier.address}, ${suplier.country}.",
                      maxLines: 2,
                      softWrap: true,
                      style: const TextStyle(
                        fontSize: 13.0,
                        color: Colors.black54,
                        fontWeight: FontWeight.w600,
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
