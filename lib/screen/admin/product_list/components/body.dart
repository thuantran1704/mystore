// ignore_for_file: import_of_legacy_library_into_null_safe, unused_field

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mystore/models/product.dart';
import 'package:mystore/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:mystore/screen/admin/product_edit/product_edit.dart';
import 'package:mystore/size_config.dart';

class Body extends StatefulWidget {
  const Body({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  List<Product> list = [];
  var loading = false;
  final baseUrl = "https://mystore-backend.herokuapp.com";

  late final SlidableController slidableController;

  Future<void> getProductList() async {
    setState(() {
      loading = true;
    });
    final response = await http.get(Uri.parse("$baseUrl/api/products"),
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

  Future<void> addToCart(String id) async {
    var response = await http.post(Uri.parse("$baseUrl/api/users/cart/$id/add"),
        headers: <String, String>{
          'Authorization': 'Bearer ${widget.user.token}',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, int>{"qty": 1, "price": 0}));

    if (response.statusCode == 201) {
      _showToast("Add to Cart successful");
    } else {
      _showToast("Add to Cart failed");
    }
  }

  Future<void> deleteProduct(String id) async {
    var response = await http.delete(
      Uri.parse("$baseUrl/api/products/$id"),
      headers: <String, String>{
        'Authorization': 'Bearer ${widget.user.token}',
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    print("response.statusCode : " + response.statusCode.toString());
    if (response.statusCode == 200) {
      _showToast("Delete product successful");
    } else {
      _showToast("Delete product Failed");
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

  Animation<double>? _rotationAnimation;
  Color _fabColor = Colors.blue;

  @override
  void initState() {
    slidableController = SlidableController(
      onSlideAnimationChanged: handleSlideAnimationChanged,
      onSlideIsOpenChanged: handleSlideIsOpenChanged,
    );
    getProductList();
    super.initState();
  }

  void handleSlideAnimationChanged(Animation<double>? slideAnimation) {
    setState(() {
      _rotationAnimation = slideAnimation;
    });
  }

  void handleSlideIsOpenChanged(bool? isOpen) {
    setState(() {
      _fabColor = isOpen! ? Colors.green : Colors.blue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: loading
          ? Padding(
              padding: EdgeInsets.only(top: getProportionateScreenHeight(20)),
              child: const Center(child: CircularProgressIndicator()),
            )
          : list.isEmpty
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text("List product is empty"),
                  ],
                )
              : RefreshIndicator(
                  onRefresh: getProductList,
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(
                        horizontal: getProportionateScreenWidth(12)),
                    itemCount: list.length,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Slidable(
                        key: Key(list[index].id.toString()),
                        controller: slidableController,
                        direction: Axis.horizontal,
                        actionPane: const SlidableScrollActionPane(),
                        actionExtentRatio: 0.25,
                        child: VerticalListItem(
                          product: list[index],
                        ),
                        actions: [
                          IconSlideAction(
                            caption: 'Import',
                            color: Colors.greenAccent.shade200,
                            icon: Icons.add,
                            onTap: () {
                              addToCart(list[index].id);
                            },
                          ),
                        ],
                        secondaryActions: <Widget>[
                          IconSlideAction(
                            caption: 'Edit',
                            color: Colors.blue,
                            icon: Icons.edit,
                            onTap: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EditProductScreen(
                                            user: widget.user,
                                            product: list[index],
                                          )));
                            },
                          ),
                          IconSlideAction(
                            caption: 'Delete',
                            color: const Color(0xFFFFE6E6),
                            icon: Icons.delete,
                            onTap: () => {
                              deleteProduct(list[index].id),
                              list.removeAt(index),
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
    );
  }
}

class VerticalListItem extends StatelessWidget {
  const VerticalListItem({Key? key, required this.product}) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          Slidable.of(context)?.renderingMode == SlidableRenderingMode.none
              ? Slidable.of(context)?.open()
              : Slidable.of(context)?.close(),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Colors.grey.shade200,
                // blurRadius: 2.0,
                spreadRadius: 1.0),
          ],
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.0),
        ),
        // color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ProductItemCard(
            product: product,
          ),
        ),
      ),
    );
  }
}

class ProductItemCard extends StatefulWidget {
  const ProductItemCard({
    Key? key,
    required this.product,
  }) : super(key: key);

  final Product product;

  @override
  State<ProductItemCard> createState() => _ProductItemCardState();
}

class _ProductItemCardState extends State<ProductItemCard> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: getProportionateScreenWidth(70),
          child: AspectRatio(
            aspectRatio: 1,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey.shade400,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Image.network(//product image here
                  widget.product.images[0].url),
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.product.name, // product name here
                style: const TextStyle(fontSize: 16, color: Colors.black),
                maxLines: 2,
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text.rich(
                    TextSpan(
                      text: "\$${widget.product.price.toString()}",
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  (widget.product.countInStock != 0)
                      ? Padding(
                          padding: EdgeInsets.only(
                              right: getProportionateScreenWidth(18)),
                          child: Text.rich(
                            TextSpan(
                              text:
                                  "In stock : ${widget.product.countInStock.toString()}",
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        )
                      : Padding(
                          padding: EdgeInsets.only(
                              right: getProportionateScreenWidth(18)),
                          child: const Text.rich(
                            TextSpan(
                              text: "Out of stock",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.redAccent),
                            ),
                          ),
                        ),
                ],
              ),
              const SizedBox(height: 5),
            ],
          ),
        ),
      ],
    );
  }
}
