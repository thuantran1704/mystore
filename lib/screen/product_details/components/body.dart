import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mystore/components/default_button.dart';
import 'package:mystore/components/rounded_icon_btn.dart';
import 'package:mystore/models/product.dart';
import 'package:mystore/models/user.dart';
import 'package:mystore/screen/home/components/product_card.dart';
import 'package:mystore/screen/home/components/section_title.dart';
import 'package:mystore/screen/product_details/components/product_description.dart';
import 'package:mystore/screen/product_details/components/product_images.dart';
import 'package:mystore/screen/product_details/components/top_rounded_container.dart';
import 'package:mystore/screen/product_details/details_screen.dart';
import 'package:mystore/size_config.dart';
import 'package:http/http.dart' as http;

class Body extends StatefulWidget {
  final Product product;
  final User user;

  const Body({
    Key? key,
    required this.product,
    required this.user,
  }) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  int qty = 1;

  void _showToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        fontSize: 15,
        gravity: ToastGravity.BOTTOM,
        toastLength: Toast.LENGTH_LONG,
        timeInSecForIosWeb: 1);
  }

  List<Product> list = [];
  var loading = false;
  final baseUrl = "https://mystore-backend.herokuapp.com";

  Future<void> addToCard(String id, int qty) async {
    var response = await http.post(Uri.parse("$baseUrl/api/users/cart/$id/add"),
        headers: <String, String>{
          'Authorization': 'Bearer ${widget.user.token}',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, int>{"qty": qty}));

    if (response.statusCode == 201) {
      _showToast("Add to Cart successful");
    } else {
      _showToast("Add to Cart failed");
    }
  }

  Future<void> getSameProducts(String brandName) async {
    var response = await http.get(
        Uri.parse("$baseUrl/api/products/same/$brandName"),
        headers: {"Accept": "application/json"});

    if (response.statusCode == 200) {
      setState(() {
        list = parseProducts(response.body);
        loading = false;
      });
    } else {
      throw Exception('Unable to fetch products from the REST API');
    }
  }

  @override
  void initState() {
    getSameProducts(widget.product.brand.name);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ProductImages(product: widget.product),
          TopRoudedContainer(
            color: Colors.grey.shade200,
            child: Column(
              children: [
                ProductDescription(
                  product: widget.product,
                ),
                TopRoudedContainer(
                  color: Colors.white,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                              padding: EdgeInsets.only(
                                  left: getProportionateScreenHeight(30)),
                              child: Text(
                                "\$${widget.product.price}",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              )),
                          Row(
                            children: [
                              const Text(
                                "Qty :",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal:
                                        getProportionateScreenWidth(20)),
                                child: Row(
                                  children: [
                                    RoundedIconBtn(
                                      iconData: Icons.remove,
                                      press: () {
                                        if (widget.product.countInStock != 0 &&
                                            qty != 1) {
                                          setState(() {
                                            qty--;
                                          });
                                        }
                                      },
                                    ),
                                    SizedBox(
                                        width: getProportionateScreenWidth(15)),
                                    Text(
                                      qty.toString(),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(
                                        width: getProportionateScreenWidth(15)),
                                    RoundedIconBtn(
                                      iconData: Icons.add,
                                      press: () {
                                        if (widget.product.countInStock != 0 &&
                                            qty !=
                                                widget.product.countInStock) {
                                          setState(() {
                                            qty++;
                                          });
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      TopRoudedContainer(
                        color: Colors.grey.shade200,
                        child: Padding(
                          padding: EdgeInsets.only(
                              // left: getProportionateScreenHeight(10),
                              // right: getProportionateScreenHeight(10),
                              // bottom: getProportionateScreenWidth(10),
                              ),
                          child: Column(
                            children: [
                              DefaultButton(
                                text: "Add to Cart",
                                press: () {
                                  if (widget.product.countInStock == 0) {
                                    _showToast("This product is out of stock");
                                  } else {
                                    addToCard(widget.product.id, qty);
                                  }
                                },
                              ),
                              TopRoudedContainer(
                                  color: Colors.white,
                                  child: Column(
                                    children: [
                                      Container(
                                        child: loading
                                            ? Padding(
                                                padding: EdgeInsets.only(
                                                    top:
                                                        getProportionateScreenHeight(
                                                            20)),
                                                child: const Center(
                                                    child:
                                                        CircularProgressIndicator()),
                                              )
                                            : Column(
                                                children: [
                                                  SectionTitle(
                                                    text: "You may also love",
                                                    press: () {},
                                                  ),
                                                  SizedBox(
                                                      height:
                                                          getProportionateScreenHeight(
                                                              5)),
                                                  SingleChildScrollView(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    child: Row(
                                                      children: [
                                                        ...List.generate(
                                                          list.length,
                                                          (index) =>
                                                              ProductCard(
                                                            product:
                                                                list[index],
                                                            press: () => Navigator.pushNamed(
                                                                context,
                                                                DetailsScreen
                                                                    .routeName,
                                                                arguments: ProductDetailsArguments(
                                                                    product: list[
                                                                        index],
                                                                    user: widget
                                                                        .user)),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                            width:
                                                                getProportionateScreenWidth(
                                                                    20))
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                      ),
                                      SizedBox(height: 20)
                                    ],
                                  ))
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
