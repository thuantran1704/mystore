import 'package:flutter/material.dart';
import 'package:mystore/components/default_button.dart';
import 'package:mystore/constants.dart';
import 'package:mystore/models/reciept.dart';
import 'package:mystore/models/user.dart';
import 'package:mystore/screen/admin/receipt_checkout/components/receipt_items.dart';
import 'package:mystore/screen/admin/receipt_checkout/components/suplier_info.dart';
import 'package:mystore/screen/check_out/components/custom_title.dart';
import 'package:mystore/size_config.dart';
import 'package:http/http.dart' as http;

class RecieptCheckOutScreen extends StatefulWidget {
  const RecieptCheckOutScreen({
    Key? key,
    required this.user,
    required this.total,
    required this.suplier,
    required this.list,
  }) : super(key: key);
  final User user;
  final double total;
  final SuplierInfo suplier;
  final List<Cart> list;
  @override
  _RecieptCheckOutScreenState createState() => _RecieptCheckOutScreenState();
}

class _RecieptCheckOutScreenState extends State<RecieptCheckOutScreen> {
  final shippingPrice = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroudColor,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: const Text(
          "Check Out Receipt",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(0)),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  SizedBox(height: SizeConfig.screenHeight * 0.01),
                  CustomSuplierInfo(suplier: widget.suplier),
                  SizedBox(height: SizeConfig.screenHeight * 0.01),
                  Padding(
                    padding: EdgeInsets.only(
                        left: getProportionateScreenWidth(10),
                        right: getProportionateScreenWidth(10)),
                    child: Divider(
                        color: Colors.black54,
                        height: getProportionateScreenHeight(20)),
                  ),
                  ReceiptItems(list: widget.list),
                  Padding(
                    padding: EdgeInsets.only(
                        left: getProportionateScreenWidth(10),
                        right: getProportionateScreenWidth(10)),
                    child: const CustomTitle(title: "Receipt Price "),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(left: getProportionateScreenWidth(20)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: getProportionateScreenHeight(6)),
                        PriceRow(title: "Items price :", price: widget.total),
                        SizedBox(height: getProportionateScreenHeight(6)),
                        const PriceRow(title: "Shipping price :", price: 0),
                        SizedBox(height: getProportionateScreenHeight(6)),
                        PriceRow(title: "Total price :", price: widget.total),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      // ============================ bottomNavigationBar ===========================//
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(
          vertical: getProportionateScreenWidth(15),
          horizontal: getProportionateScreenWidth(30),
        ),
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, -15),
              blurRadius: 20,
              color: const Color(0xFFDADADA).withOpacity(0.15),
            )
          ],
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text.rich(
                    TextSpan(
                      text: "Total Order:\n",
                      children: [
                        TextSpan(
                          text: "\$${widget.total.toStringAsFixed(2)}",
                          style: const TextStyle(
                              fontSize: 16, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: getProportionateScreenWidth(190),
                    child: DefaultButton(
                      text: "Place Order",
                      press: () {
                        // createReceipt(widget.list, shippingPrice, totalPrice);
                      },
                    ),
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
