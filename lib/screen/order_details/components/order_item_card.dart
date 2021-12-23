// ignore_for_file: prefer_const_constructors, import_of_legacy_library_into_null_safe

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mystore/constants.dart';
import 'package:mystore/models/order.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:mystore/models/user.dart';

import 'package:mystore/size_config.dart';

class OrderItemCard extends StatefulWidget {
  const OrderItemCard({
    Key? key,
    required this.item,
    required this.status,
    required this.user,
  }) : super(key: key);

  final OrderItem item;
  final String status;
  final User user;
  @override
  State<OrderItemCard> createState() => _OrderItemCardState();
}

class _OrderItemCardState extends State<OrderItemCard> {
  IconData? _selectedIcon;
  late double _rating;
  final TextEditingController commentController = TextEditingController();
  static const baseUrl = "https://mystore-backend.herokuapp.com";

  Future<void> createReview(
    int rating,
    String comment,
  ) async {
    var response = await http.post(
        Uri.parse("$baseUrl/api/products/${widget.item.product.id}/reviews"),
        headers: <String, String>{
          'Authorization': 'Bearer ${widget.user.token}',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          "rating": rating,
          "comment": comment,
        }));

    if (response.statusCode == 201) {
      _showToast("Review created successfully");
    } else if (response.statusCode == 400) {
      _showToast("This product was reviewed");
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
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: SizedBox(
            width: getProportionateScreenWidth(72),
            child: AspectRatio(
              aspectRatio: 1,
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey.shade400,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Image.network(//product image here
                    widget.item.product.images[0].url),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.item.product.name, // product name here
                style: const TextStyle(fontSize: 15, color: Colors.black),
                maxLines: 2,
              ),
              const SizedBox(height: 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text.rich(
                    TextSpan(
                      text: "\$${widget.item.price.toString()}",
                      style: const TextStyle(fontWeight: FontWeight.w600),
                      children: [
                        TextSpan(
                          text: " x ${widget.item.qty}", //qty here
                          style: TextStyle(color: kTextColor, fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                  ((widget.status.toLowerCase() == "delivered" ||
                              widget.status.toLowerCase() == "received") &&
                          widget.user.role.name.toLowerCase() != "admin")
                      ? Padding(
                          padding: EdgeInsets.only(
                            right: getProportionateScreenWidth(30),
                            // bottom: getProportionateScreenHeight(5),
                          ),
                          child: SafeArea(
                            child: SizedBox(
                              width: getProportionateScreenHeight(86),
                              height: getProportionateScreenHeight(38),
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                  primary: Colors.white,
                                  backgroundColor: kPrimaryColor,
                                ),
                                onPressed: () {
                                  showModalBottomSheet<void>(
                                    context: context,
                                    isScrollControlled: true,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(30.0),
                                          topRight: Radius.circular(30.0)),
                                    ),
                                    builder: (BuildContext context) {
                                      return Padding(
                                        padding:
                                            MediaQuery.of(context).viewInsets,
                                        child: Container(
                                          height: SizeConfig.screenHeight * 0.5,
                                          color: Colors.white,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              const SizedBox(
                                                height: 16,
                                              ),
                                              Container(
                                                height:
                                                    getProportionateScreenHeight(
                                                        100),
                                                width: SizeConfig.screenWidth *
                                                    0.96,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.black54),
                                                  color: Colors.grey.shade100,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          6.0),
                                                ),
                                                child: Row(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          20, 5, 5, 5),
                                                      child: Container(
                                                        width:
                                                            getProportionateScreenWidth(
                                                                82),
                                                        height:
                                                            getProportionateScreenHeight(
                                                                82),
                                                        padding:
                                                            const EdgeInsets
                                                                .all(5),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          border: Border.all(
                                                            color: Colors
                                                                .grey.shade500,
                                                            width: 1,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                        ),
                                                        child: Image.network(
                                                            //product image here
                                                            widget.item.product
                                                                .images[0].url),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                        width:
                                                            getProportionateScreenWidth(
                                                                5)),
                                                    SizedBox(
                                                      width:
                                                          getProportionateScreenWidth(
                                                              245),
                                                      height:
                                                          getProportionateScreenHeight(
                                                              50),
                                                      child: Text(
                                                        widget.item.product
                                                            .name, // product name here
                                                        style: const TextStyle(
                                                            fontSize: 15,
                                                            color:
                                                                Colors.black),
                                                        maxLines: 2,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                  height:
                                                      getProportionateScreenHeight(
                                                          16)),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left:
                                                        getProportionateScreenWidth(
                                                            30)),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    const Text(
                                                      'Rating Star ',
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    SizedBox(
                                                        width:
                                                            getProportionateScreenWidth(
                                                                5)),
                                                    RatingBar.builder(
                                                      initialRating: 0,
                                                      minRating: 1,
                                                      direction:
                                                          Axis.horizontal,
                                                      allowHalfRating: false,
                                                      unratedColor: Colors.amber
                                                          .withAlpha(50),
                                                      itemCount: 5,
                                                      itemSize: 34.0,
                                                      itemPadding:
                                                          const EdgeInsets
                                                                  .symmetric(
                                                              horizontal: 4.0),
                                                      itemBuilder:
                                                          (context, _) => Icon(
                                                        _selectedIcon ??
                                                            Icons.star,
                                                        color: Colors.amber,
                                                      ),
                                                      onRatingUpdate: (rating) {
                                                        setState(() {
                                                          _rating = rating;
                                                        });
                                                      },
                                                      updateOnDrag: true,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height:
                                                    getProportionateScreenHeight(
                                                        20),
                                              ),
                                              SizedBox(
                                                width: SizeConfig.screenWidth *
                                                    0.88,
                                                child: TextFormField(
                                                  controller: commentController,
                                                  minLines: 2,
                                                  maxLines: 4,
                                                  decoration:
                                                      const InputDecoration(
                                                    border:
                                                        OutlineInputBorder(),
                                                    hintText:
                                                        'Enter your comment ...',
                                                    labelText: 'Comment',
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height:
                                                    getProportionateScreenHeight(
                                                        25),
                                              ),
                                              SizedBox(
                                                width: SizeConfig.screenWidth *
                                                    0.65,
                                                height:
                                                    getProportionateScreenHeight(
                                                        48),
                                                child: ElevatedButton(
                                                    child: const Text(
                                                      'Submit',
                                                      style: TextStyle(
                                                          fontSize: 16),
                                                    ),
                                                    onPressed: () {
                                                      createReview(
                                                          int.parse(_rating
                                                              .toString()
                                                              .substring(0, 1)),
                                                          commentController
                                                              .text);
                                                      Navigator.pop(context);
                                                    }),
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: const Text(
                                  "review",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 13.5,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      : const SizedBox()
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
