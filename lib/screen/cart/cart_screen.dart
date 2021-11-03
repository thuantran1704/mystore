// ignore_for_file: prefer_is_empty

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mystore/components/coustom_bottom_nav_bar.dart';
import 'package:mystore/components/default_button.dart';
import 'package:mystore/enums.dart';
import 'package:mystore/models/user.dart';

import 'package:mystore/screen/check_out/check_out_screen.dart';
import 'package:mystore/size_config.dart';
import 'package:http/http.dart' as http;

class CartScreen extends StatefulWidget {
  static String routeName = "/cart";

  const CartScreen({
    Key? key,
    required this.user,
  }) : super(key: key);
  final User user;
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  double total = 0;
  List<Cart> list = [];
  var loading = false;
  final baseUrl = "https://mystore-backend.herokuapp.com";

  void calSum(List<Cart> list) {
    total = 0;
    for (int i = 0; i < list.length; i++) {
      total = total + (list[i].price * list[i].qty);
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

  Future<void> getCart(String token) async {
    setState(() {
      loading = true;
    });
    final response = await http.get(Uri.parse("$baseUrl/api/users/cart/mycart"),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json; charset=UTF-8',
        });

    if (response.statusCode == 200) {
      setState(() {
        list = parseCart(response.body);
        calSum(list);
        loading = false;
      });
    } else {
      throw Exception('Unable to fetch products from the REST API');
    }
  }

  Future<void> removeCartItem(String productId, String token) async {
    setState(() {
      loading = true;
    });
    final response = await http.delete(
        Uri.parse("$baseUrl/api/users/cart/$productId/remove"),
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

  @override
  void initState() {
    super.initState();
    getCart(widget.user.token);
    // calSum(list);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      // ======================= body =======================//
      body: Container(
        child: loading
            ? Padding(
                padding: EdgeInsets.only(top: getProportionateScreenHeight(20)),
                child: const Center(child: CircularProgressIndicator()),
              )
            : list.length == 0
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text("Your Cart is empty"),
                    ],
                  )
                : ListView.builder(
                    padding: EdgeInsets.symmetric(
                        horizontal: getProportionateScreenWidth(20)),
                    itemCount: list.length,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Dismissible(
                        key: Key(list[index].product.toString()),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFE6E6),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            children: [
                              const Spacer(),
                              SvgPicture.asset("assets/icons/Trash.svg"),
                            ],
                          ),
                        ),
                        onDismissed: (direction) {
                          setState(() {
                            removeCartItem(list[index].product.toString(),
                                widget.user.token);
                            loading = false;

                            list.removeAt(index);
                            calSum(list);
                          });
                        },
                        child: Row(
                          children: [
                            SizedBox(
                              width: getProportionateScreenWidth(88),
                              child: AspectRatio(
                                aspectRatio: 1,
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey.shade400,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Image.network(//product image here
                                      list[index].image),
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    list[index].name, // product name here
                                    style: const TextStyle(
                                        fontSize: 16, color: Colors.black),
                                    maxLines: 2,
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text.rich(
                                        TextSpan(
                                          text:
                                              "\$${list[index].price.toString()}",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      Column(
                                        children: [
                                          Row(
                                            children: [
                                              IconButton(
                                                iconSize: 18.0,
                                                padding:
                                                    const EdgeInsets.all(2.0),
                                                icon: const Icon(Icons.remove),
                                                onPressed: () {
                                                  setState(() {
                                                    if (list[index].qty > 1) {
                                                      list[index].qty -= 1;
                                                      calSum(list);
                                                    }
                                                  });
                                                },
                                              ),
                                              Text(
                                                "${list[index].qty}",
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              IconButton(
                                                iconSize: 18.0,
                                                padding:
                                                    const EdgeInsets.all(2.0),
                                                icon: const Icon(Icons.add),
                                                onPressed: () {
                                                  setState(() {
                                                    list[index].qty += 1;
                                                    calSum(list);
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
      ),
      // ======================= bottomNavigationBar =======================//
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              vertical: getProportionateScreenWidth(15),
              horizontal: getProportionateScreenWidth(30),
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
                          text: "Total Items:\n",
                          children: [
                            TextSpan(
                              text: "\$${total.toStringAsFixed(2)}",
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: getProportionateScreenWidth(190),
                        child: DefaultButton(
                          text: "Check Out",
                          press: () => {
                            if (list.length > 0)
                              {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CheckOutScreen(
                                              list: list,
                                              user: widget.user,
                                              total: total,
                                            )))
                              }
                            else
                              _showToast("Please add product first")
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          CustomBottomNavBar(
            selectedMenu: MenuState.cart,
            currentPage: 3,
            user: widget.user,
          ),
        ],
      ),
    );
  }
}

AppBar buildAppBar(BuildContext context) {
  return AppBar(
    centerTitle: true,
    title: const Text(
      "Your Cart",
      style: TextStyle(color: Colors.black),
    ),
  );
}
