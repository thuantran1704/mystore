// ignore_for_file: prefer_is_empty, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mystore/models/user.dart';
import 'package:mystore/screen/cart/components/cart_item_cart.dart';
import 'package:mystore/size_config.dart';
import 'package:http/http.dart' as http;

class Body extends StatefulWidget {
  const Body({
    Key? key,
    required this.token,
  }) : super(key: key);

  final String token;
  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  void _showToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        fontSize: 15,
        gravity: ToastGravity.BOTTOM,
        toastLength: Toast.LENGTH_LONG,
        timeInSecForIosWeb: 1);
  }

  List<Cart> list = [];
  var loading = false;
  final baseUrl = "https://mystore-backend.herokuapp.com";

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
      _showToast("Remove successful");
    } else {
      _showToast("Remove Failed");

      throw Exception('Unable to fetch products from the REST API');
    }
  }

  @override
  void initState() {
    super.initState();
    getCart(widget.token);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                          removeCartItem(
                              list[index].product.toString(), widget.token);
                          loading = false;
                          list.removeAt(index);
                        });
                      },
                      child: CartItemCard(cart: list[index]),
                    ),
                  ),
                ),
    );
  }
}
