// ignore_for_file: curly_braces_in_flow_control_structures, import_of_legacy_library_into_null_safe, prefer_const_constructors

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mystore/components/default_button.dart';
import 'package:mystore/components/form_error.dart';
import 'package:mystore/constants.dart';
import 'package:mystore/helper/keyboard.dart';
import 'package:mystore/models/order.dart';
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
  bool useCoin = false;
  double coin = 0.0;
  int paymentMethod = 1;
  double itemsprice = 0;
  double taxPrice = 0;
  double shippingPrice = 0;
  double discountPrice = 0;
  String discountPercen = "0";
  double? totalPrice;

  static const baseUrl = "https://mystore-backend.herokuapp.com";

  Future<void> createOrder(
      List<Cart> orderItems,
      String? address,
      String? city,
      String? postalCode,
      String? country,
      int paymentMethod,
      double itemsprice,
      double taxPrice,
      double shippingPrice,
      double discountPrice,
      double? totalPrice) async {
    List jsonList = [];
    for (int i = 0; i < orderItems.length; i++) {
      CartItem item = CartItem(
          qty: orderItems[i].qty,
          price: orderItems[i].importPrice,
          product: orderItems[i].product.id);
      jsonList.add(item.toJson());
    }

    var response = await http.post(Uri.parse("$baseUrl/api/orders"),
        headers: <String, String>{
          'Authorization': 'Bearer ${widget.user.token}',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          "orderItems": jsonList.toList(),
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
          "discountPrice": discountPrice,
          "totalPrice": totalPrice,
          "status": (paymentMethod == 1) ? "Wait" : "Pay",
        }));

    if (response.statusCode == 201) {
      if (coin > 0) {
        widget.user.coin -= double.parse(coin.toStringAsFixed(2));
      }
      if (discountPercen != "0") {
        removeVoucher(widget.user.token, discountPercen);
        Timer(Duration(seconds: 3), () {
          _showToast("Order created successfully ");

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => OrderScreen(
                        orderId: response.body.toString().substring(1, 25),
                        user: widget.user,
                      )));
        });
      } else {
        _showToast("Order created successfully ");
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => OrderScreen(
                      orderId: response.body.toString().substring(1, 25),
                      user: widget.user,
                    )));
      }

      Timer(Duration(seconds: 3), () {
        removeAllCartItem(widget.user.token);
      });

      if (useCoin == true) {
        Timer(Duration(seconds: 3), () {
          updateUserCoin(coin);
        });
      }
      Timer(Duration(seconds: 3), () {
        sendEmail(
          email: widget.user.email,
          name: widget.user.name,
          orderId: response.body.toString().substring(1, 25),
          totalPrice: totalPrice.toString(),
        );
      });
    } else {
      _showToast("Order created failed");
    }
  }

  Future<void> updateUserCoin(double coin) async {
    var response =
        await http.put(Uri.parse("$baseUrl/api/users/coin/${widget.user.id}"),
            headers: <String, String>{
              'Authorization': 'Bearer ${widget.user.token}',
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode({
              "coin": coin,
            }));

    if (response.statusCode == 200) {
    } else {
      _showToast("update user coin failed");
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

  Future<void> removeVoucher(String token, String percen) async {
    var id = "";
    if (percen == "10") {
      id = "61a5b36e386b752278e13400";
    } else if (percen == "15") {
      id = "61a5b573dba9751ee8093113";
    } else if (percen == "20") {
      id = "61a5b3fa386b752278e13407";
    }

    final response = await http.delete(
        Uri.parse("$baseUrl/api/users/voucher/$id/remove"),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json; charset=UTF-8',
        });

    if (response.statusCode == 200) {
      setState(() {
        widget.user.voucher = parseVoucher(response.body);
      });
    } else {
      _showToast("Remove Failed");
      throw Exception('Unable to fetch products from the REST API');
    }
  }

  Future sendEmail(
      {required String name,
      required String email,
      required String orderId,
      required String totalPrice}) async {
    var serviceId = "service_szh30k9";
    var templateId = "template_43lfx7g";
    var userEmailId = "user_B4JHb8P6ynrwLb62unWdf";

    final url = Uri.parse("https://api.emailjs.com/api/v1.0/email/send");

    final response = await http.post(url,
        headers: {
          'origin': 'http://localhost',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode({
          'service_id': serviceId,
          'template_id': templateId,
          'user_id': userEmailId,
          'template_params': {
            'user_name': name, // tên ng nhận
            'user_email': "mystore@gmail.com", // email ng gửi
            'to_email': "thuantran1704@gmail.com", // email nhận
            'user_subject': "MyStore",
            'user_message':
                "Thank you for your order. \nYour order id is $orderId with total price: $totalPrice\$ \nWe will process your order within 36 hours from now"
          }
        }));
    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          msg: "Order Successfully. We sent a email to you",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Send Failed"),
      ));
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

    itemsprice = widget.total;
    taxPrice = double.parse((itemsprice * 0.1).toStringAsFixed(2));
    itemsprice >= 100 ? shippingPrice = 0 : shippingPrice = 2;
    totalPrice = double.parse(
        (itemsprice + taxPrice + shippingPrice).toStringAsFixed(2));
  }

  void calSum() {
    totalPrice = double.parse(
        (itemsprice + taxPrice + shippingPrice - discountPrice)
            .toStringAsFixed(2));
  }

  @override
  void initState() {
    super.initState();
    initScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
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
                horizontal: getProportionateScreenWidth(15)),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(height: SizeConfig.screenHeight * 0.01),
                    const CustomTitle(title: "Shipping Infomation"),
                    SizedBox(height: SizeConfig.screenHeight * 0.015),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(.2),
                              blurRadius: 1,
                              spreadRadius: 1,
                              offset: const Offset(3, 2),
                            ),
                          ]),
                      child: addressFormInput(),
                    ),
                    SizedBox(height: SizeConfig.screenHeight * 0.015),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(.2),
                              blurRadius: 1,
                              spreadRadius: 1,
                              offset: const Offset(3, 2),
                            ),
                          ]),
                      child: cityFormInput(),
                    ),
                    SizedBox(height: SizeConfig.screenHeight * 0.015),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(.2),
                              blurRadius: 1,
                              spreadRadius: 1,
                              offset: const Offset(3, 2),
                            ),
                          ]),
                      child: countryFormInput(),
                    ),
                    SizedBox(height: SizeConfig.screenHeight * 0.015),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(.2),
                              blurRadius: 1,
                              spreadRadius: 1,
                              offset: const Offset(3, 2),
                            ),
                          ]),
                      child: postalCodeFormInput(),
                    ),
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
                    const CustomTitle(title: "Your coin"),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Checkbox(
                          value: useCoin,
                          activeColor: kPrimaryColor,
                          onChanged: (value) {
                            setState(() {
                              useCoin = value!;
                              if (useCoin == true) {
                                if (widget.user.coin >= totalPrice!) {
                                  coin = totalPrice!;
                                  discountPrice += totalPrice!;
                                } else {
                                  discountPrice += widget.user.coin;
                                  coin = widget.user.coin;
                                }
                                calSum();
                              } else {
                                if (discountPercen != "0") {
                                  discountPrice = itemsprice *
                                      double.parse(discountPercen) /
                                      100;
                                  discountPrice = double.parse(
                                      discountPrice.toStringAsFixed(2));
                                  calSum();
                                } else {
                                  discountPrice = 0;
                                  calSum();
                                }
                                coin = 0;
                              }
                            });
                          },
                        ),
                        Text("Use Coins",
                            style: TextStyle(
                              fontSize: getProportionateScreenWidth(14),
                              color: Colors.black87,
                            )),
                        Spacer(),
                        Padding(
                          padding: EdgeInsets.only(
                              right: getProportionateScreenWidth(30)),
                          child: Text("Coin : ${widget.user.coin}",
                              style: TextStyle(
                                fontSize: getProportionateScreenWidth(14),
                                color: Colors.black87,
                              )),
                        ),
                      ],
                    ),
                    const CustomTitle(title: "Shipping Price "),
                    SizedBox(height: SizeConfig.screenHeight * 0.01),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Column(
                        children: [
                          PriceRow(
                            title: "Tax Price :",
                            price: taxPrice,
                          ),
                          const SizedBox(height: 8),
                          PriceRow(
                            title: "Shipping Price :",
                            price: shippingPrice,
                          ),
                          (discountPrice != 0)
                              ? SizedBox(height: 8)
                              : SizedBox(),
                          (discountPrice != 0)
                              ? PriceRow(
                                  title: "Discount Price :",
                                  price: -discountPrice,
                                )
                              : SizedBox(),
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
              InkWell(
                onTap: () {
                  showModalBottomSheet<String>(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.0),
                          topRight: Radius.circular(30.0)),
                    ),
                    builder: (BuildContext context) {
                      return Padding(
                        padding: MediaQuery.of(context).viewInsets,
                        child: Container(
                          height: SizeConfig.screenHeight * 0.5,
                          color: Colors.white,
                          child: widget.user.voucher.isEmpty
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Text("Your Voucher list is empty"),
                                  ],
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    ...List.generate(
                                        widget.user.voucher.length,
                                        (index) => VoucherItemCard(
                                            voucher:
                                                widget.user.voucher[index])),
                                  ],
                                ),
                        ),
                      );
                    },
                  ).then((value) {
                    if (value != null) {
                      setState(() {
                        discountPercen = value;
                        discountPrice = itemsprice * double.parse(value) / 100;
                        discountPrice =
                            double.parse(discountPrice.toStringAsFixed(2));
                        calSum();
                      });
                    }
                  });
                },
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      height: getProportionateScreenWidth(40),
                      width: getProportionateScreenWidth(40),
                      decoration: BoxDecoration(
                        color: Color(0xFFF5F6F9),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: SvgPicture.asset("assets/icons/receipt.svg"),
                    ),
                    Spacer(),
                    (discountPercen == "20")
                        ? Text(
                            "XMASVOUCHER",
                            style: const TextStyle(
                                fontSize: 16, color: Colors.black87),
                          )
                        : (discountPercen == "15")
                            ? Text(
                                "DISCOUNT15",
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.black87),
                              )
                            : (discountPercen == "10")
                                ? Text(
                                    "DISCOUNT10",
                                    style: const TextStyle(
                                        fontSize: 16, color: Colors.black87),
                                  )
                                : Text("Add voucher code"),
                    const SizedBox(width: 10),
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 12,
                      color: kTextColor,
                    )
                  ],
                ),
              ),
              SizedBox(height: 2),
              Divider(color: Colors.white),
              SizedBox(height: 2),
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
                              double.parse(discountPrice.toStringAsFixed(2)),
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
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
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
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
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
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
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
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        // suffixIcon:
        //     CustomSurfixIcon(svgIcon: "assets/icons/Location point.svg"),
      ),
    );
  }
}

class VoucherItemCard extends StatelessWidget {
  const VoucherItemCard({
    Key? key,
    required this.voucher,
  }) : super(key: key);

  final Voucher voucher;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.only(
            bottom: getProportionateScreenHeight(10),
            left: getProportionateScreenWidth(20),
          ),
          child: SizedBox(
            width: getProportionateScreenWidth(68),
            child: AspectRatio(
              aspectRatio: 1,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey.shade400,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: (voucher.discount == "10")
                    ? Image.asset("assets/images/discount10.jpg")
                    : (voucher.discount == "15")
                        ? Image.asset("assets/images/discount15.jpg")
                        : Image.asset("assets/images/discount20.jpg"),
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
                voucher.name, // product name here
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
                maxLines: 2,
              ),
              const SizedBox(height: 4),
              Text.rich(
                TextSpan(
                  text: "Discount ${voucher.discount}% \non total items price",
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Padding(
          padding: EdgeInsets.only(right: getProportionateScreenWidth(15)),
          child: SizedBox(
            width: getProportionateScreenWidth(80),
            height: getProportionateScreenHeight(40),
            child: ElevatedButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  primary: Colors.white,
                  backgroundColor: kPrimaryColor,
                ),
                child: const Text(
                  'Apply',
                  style:
                      TextStyle(fontSize: 16, backgroundColor: kPrimaryColor),
                ),
                onPressed: () {
                  Navigator.pop(context, voucher.discount);
                }),
          ),
        )
      ],
    );
  }
}
