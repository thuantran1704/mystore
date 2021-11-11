// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mystore/components/default_button.dart';
import 'package:mystore/components/form_error.dart';
import 'package:mystore/constants.dart';
import 'package:mystore/helper/keyboard.dart';
import 'package:mystore/models/user.dart';
import 'package:mystore/screen/check_out/components/custom_title.dart';
import 'package:mystore/screen/check_out/components/order_item_card.dart';
import 'package:mystore/screen/order_details/order_details_screen.dart';
import 'package:mystore/size_config.dart';
import 'package:http/http.dart' as http;

class CheckOutScreen extends StatefulWidget {
  const CheckOutScreen({
    Key? key,
    required this.list,
    required this.user,
    required this.total,
  }) : super(key: key);

  final List<Cart> list;
  final User user;
  final double total;

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  // final _formKey = GlobalKey<FormState>();
  final _formKey = GlobalKey<FormState>();
  final List<String> errors = [];
  String? address;
  TextEditingController addressController = TextEditingController();

  String? city;
  TextEditingController cityController = TextEditingController();

  String? postalCode;
  TextEditingController postalCodeController = TextEditingController();

  String? country;
  TextEditingController countryController = TextEditingController();
  // String? fullAddress;

  int paymentMethod = 1;
  double itemsprice = 0;
  double taxPrice = 0;
  double shippingPrice = 0;
  double? totalPrice;

  static const baseUrl = "https://mystore-backend.herokuapp.com";

  Future<void> createOrder(
      List orderItems,
      String? address,
      String? city,
      String? postalCode,
      String? country,
      int paymentMethod,
      double itemsprice,
      double taxPrice,
      double shippingPrice,
      double? totalPrice) async {
    List jsonList = [];
    orderItems.map((item) => jsonList.add(item.toJson())).toList();

    var response = await http.post(Uri.parse("$baseUrl/api/orders"),
        headers: <String, String>{
          'Authorization': 'Bearer ${widget.user.token}',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          "orderItems": jsonList,
          "shippingAddress": ({
            "address": address,
            "city": city,
            "country": country,
            "postalCode": postalCode,
          }),
          "paymentMethod": (paymentMethod == 1) ? "ShipCOD" : "PayPal",
          "itemsPrice": itemsprice,
          "taxPrice": taxPrice,
          "shippingPrice": shippingPrice,
          "totalPrice": totalPrice,
        }));

    if (response.statusCode == 201) {
      _showToast("Order created successfully ");
      removeAllCartItem(widget.user.token);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => OrderScreen(
                    orderId: response.body.toString().substring(1, 25),
                    user: widget.user,
                  )));
    } else {
      _showToast("Order created failed");
    }
  }

  Future<void> removeAllCartItem(String token) async {
    final response = await http.delete(
        Uri.parse("$baseUrl/api/users/cart/remove"),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json; charset=UTF-8',
        });

    if (response.statusCode == 200) {
    } else {
      _showToast("Remove Failed");

      throw Exception('Unable to fetch products from the REST API');
    }
  }

  void addError({required String error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({required String error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  void _showToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        fontSize: 15,
        gravity: ToastGravity.BOTTOM,
        toastLength: Toast.LENGTH_LONG,
        timeInSecForIosWeb: 1);
  }

  void initScreen() {
    addressController =
        TextEditingController(text: widget.user.userAddress.address);
    cityController = TextEditingController(text: widget.user.userAddress.city);
    countryController =
        TextEditingController(text: widget.user.userAddress.country);
    postalCodeController =
        TextEditingController(text: widget.user.userAddress.postalCode);
    // fullAddress =
    //     "${addressController.text}, ${cityController.text}, ${countryController.text}, ${postalCodeController.text}";
    itemsprice = widget.total;
    taxPrice = double.parse((widget.total * 0.1).toStringAsFixed(2));
    itemsprice >= 100 ? shippingPrice = 0 : shippingPrice = 2;
    totalPrice = double.parse(
        (itemsprice + taxPrice + shippingPrice).toStringAsFixed(2));
  }

  @override
  void initState() {
    super.initState();
    initScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Your Order",
          style: TextStyle(color: Colors.black),
        ),
      ),
      // ============================ body ===========================//
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(18)),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(height: SizeConfig.screenHeight * 0.01),
                    const CustomTitle(title: "Shipping Infomation"),
                    SizedBox(height: SizeConfig.screenHeight * 0.02),
                    // Container(
                    //   height: SizeConfig.screenHeight * 0.12,
                    //   decoration: BoxDecoration(
                    //     border: Border.all(color: Colors.black54),
                    //     boxShadow: [
                    //       BoxShadow(
                    //           color: Colors.grey.shade200,
                    //           blurRadius: 2.0,
                    //           spreadRadius: 1.0),
                    //     ],
                    //     color: Colors.white,
                    //     borderRadius: BorderRadius.circular(20.0),
                    //   ),
                    //   child: Padding(
                    //     padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    //     child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //       crossAxisAlignment: CrossAxisAlignment.center,
                    //       children: [
                    //         Column(
                    //           mainAxisAlignment: MainAxisAlignment.center,
                    //           crossAxisAlignment: CrossAxisAlignment.start,
                    //           children: [
                    //             SizedBox(
                    //               width: SizeConfig.screenWidth * 0.75,
                    //               child: Text("$fullAddress"),
                    //             )
                    //           ],
                    //         ),
                    //         GestureDetector(
                    //           onTap: () {
                    //             showModalBottomSheet<void>(
                    //               context: context,
                    //               builder: (BuildContext context) {
                    //                 return Container(
                    //                   height: 700,
                    //                   color: Colors.white,
                    //                   child: Center(
                    //                     child: Padding(
                    //                       padding: EdgeInsets.only(
                    //                         left:
                    //                             getProportionateScreenWidth(18),
                    //                         right:
                    //                             getProportionateScreenWidth(18),
                    //                       ),
                    //                       child: Form(
                    //                         key: _formKey,
                    //                         child: Column(
                    //                           mainAxisSize: MainAxisSize.min,
                    //                           children: <Widget>[
                    //                             addressFormInput(),
                    //                             SizedBox(
                    //                                 height: SizeConfig
                    //                                         .screenHeight *
                    //                                     0.03),
                    //                             cityFormInput(),
                    //                             SizedBox(
                    //                                 height: SizeConfig
                    //                                         .screenHeight *
                    //                                     0.03),
                    //                             countryFormInput(),
                    //                             SizedBox(
                    //                                 height: SizeConfig
                    //                                         .screenHeight *
                    //                                     0.03),
                    //                             postalCodeFormInput(),
                    //                             SizedBox(
                    //                                 height: SizeConfig
                    //                                         .screenHeight *
                    //                                     0.02),
                    //                             FormError(errors: errors),
                    //                             SizedBox(
                    //                               width:
                    //                                   SizeConfig.screenWidth *
                    //                                       0.89,
                    //                               height:
                    //                                   getProportionateScreenHeight(
                    //                                       45),
                    //                               child: ElevatedButton(
                    //                                   child:
                    //                                       const Text('Submit'),
                    //                                   onPressed: () {
                    //                                     if (_formKey
                    //                                         .currentState!
                    //                                         .validate()) {
                    //                                       _formKey.currentState!
                    //                                           .save();
                    //                                       KeyboardUtil
                    //                                           .hideKeyboard(
                    //                                               context);
                    //                                       setState(() {
                    //                                         fullAddress =
                    //                                             "${addressController.text}, ${cityController.text}, ${countryController.text}, ${postalCodeController.text}";
                    //                                       });
                    //                                       Navigator.pop(
                    //                                           context);
                    //                                     }
                    //                                   }),
                    //                             )
                    //                           ],
                    //                         ),
                    //                       ),
                    //                     ),
                    //                   ),
                    //                 );
                    //               },
                    //             );
                    //           },
                    //           child: const Icon(
                    //             Icons.chevron_right,
                    //             color: kPrimaryColor,
                    //           ),
                    //         )
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    addressFormInput(),
                    SizedBox(height: SizeConfig.screenHeight * 0.03),
                    cityFormInput(),
                    SizedBox(height: SizeConfig.screenHeight * 0.03),
                    countryFormInput(),
                    SizedBox(height: SizeConfig.screenHeight * 0.03),
                    postalCodeFormInput(),
                    SizedBox(height: SizeConfig.screenHeight * 0.02),
                    FormError(errors: errors),

                    SizedBox(height: SizeConfig.screenHeight * 0.01),
                    const CustomTitle(title: "Payment Method "),
                    paymentMethodRadioButton(),
                    const CustomTitle(title: "Order Items "),
                    SizedBox(height: SizeConfig.screenHeight * 0.02),
                    Column(
                      children: [
                        ...List.generate(widget.list.length,
                            (index) => OrderItemCard(cart: widget.list[index])),
                      ],
                    ),
                    const CustomTitle(title: "Shipping Price "),
                    SizedBox(height: SizeConfig.screenHeight * 0.01),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Tax Price : \t\t\t\t\t\t\t\t \$ $taxPrice",
                                style: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Shipping Price :  \$ $shippingPrice",
                                textAlign: TextAlign.justify,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ],
                ),
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
                          text: "\$$totalPrice",
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
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          KeyboardUtil.hideKeyboard(context);
                          createOrder(
                              widget.list,
                              addressController.text,
                              cityController.text,
                              postalCodeController.text,
                              countryController.text,
                              paymentMethod,
                              itemsprice,
                              taxPrice,
                              shippingPrice,
                              totalPrice);
                        }
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

  Column paymentMethodRadioButton() {
    return Column(
      children: [
        ListTile(
          title: const Text('Cash On Delivery'),
          leading: Radio(
            activeColor: kPrimaryColor,
            value: 1,
            groupValue: paymentMethod,
            onChanged: (value) {
              setState(() {
                paymentMethod = value as int;
              });
            },
          ),
        ),
        ListTile(
          title: const Text('PayPal'),
          leading: Radio(
            value: 2,
            activeColor: kPrimaryColor,
            groupValue: paymentMethod,
            onChanged: (value) {
              setState(() {
                paymentMethod = value as int;
              });
            },
          ),
        ),
      ],
    );
  }

  TextFormField addressFormInput() {
    return TextFormField(
      controller: addressController,
      onSaved: (newValue) => address = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kAddressNullError);
        }
        return;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kAddressNullError);
          return "required";
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "Address",
        hintText: "Enter your Address",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        // suffixIcon:
        //     CustomSurfixIcon(svgIcon: "assets/icons/Location point.svg"),
      ),
    );
  }

  TextFormField cityFormInput() {
    return TextFormField(
      controller: cityController,
      onSaved: (newValue) => city = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kCityNullError);
        }
        return;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kCityNullError);
          return "required";
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "City",
        hintText: "Enter your City",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        // suffixIcon:
        //     CustomSurfixIcon(svgIcon: "assets/icons/Location point.svg"),
      ),
    );
  }

  TextFormField countryFormInput() {
    return TextFormField(
      controller: countryController,
      onSaved: (newValue) => country = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kCountryNullError);
        }
        return;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kCountryNullError);
          return "required";
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "Country",
        hintText: "Enter your Country",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        // suffixIcon:
        //     CustomSurfixIcon(svgIcon: "assets/icons/Location point.svg"),
      ),
    );
  }

  TextFormField postalCodeFormInput() {
    return TextFormField(
      controller: postalCodeController,
      onSaved: (newValue) => postalCode = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPostalCodeNullError);
        }
        return;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kPostalCodeNullError);
          return "required";
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "PostalCode",
        hintText: "Enter your PostalCode",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        // suffixIcon:
        //     CustomSurfixIcon(svgIcon: "assets/icons/Location point.svg"),
      ),
    );
  }
}
