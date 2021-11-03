// ignore_for_file: use_key_in_widget_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mystore/models/product.dart';

class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<Product> list = [];
  var loading = false;
  final baseUrl = "https://mystore-backend.herokuapp.com";

  // final baseUrl = "http://localhost:5000";

  Future<void> _fetchData() async {
    setState(() {
      loading = true;
    });
    final response = await http.get(Uri.parse("$baseUrl/api/products"),
        headers: {"Accept": "application/json"});

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        // for (Map<String, dynamic> i in data) {
        //   list.add(Product.fromJson(i));
        // }
        list = data;
        loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("List User Manager"),
        elevation: 0.0,
      ),
      body: Container(
        child: loading
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                // shrinkWrap: true,
                itemCount: list.length,
                itemBuilder: (context, i) {
                  final x = list[i];
                  return Container(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(x.name),
                        Text(x.brand.name),
                        Text(x.category.name),
                        Text(x.countInStock.toString()),
                        const SizedBox(
                          height: 5.0,
                        ),
                        const Text(
                          "Reviews : ",
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.bold),
                        ),
                        ListView.builder(
                            shrinkWrap: true,
                            itemCount: x.reviews.length,
                            itemBuilder: (context, q) {
                              final y = x.reviews[q];
                              return Container(
                                padding: const EdgeInsets.all(13.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text("name : ${y.name}"),
                                    Text("ratting : ${y.rating.toString()}"),
                                    Text("comment : ${y.comment}"),
                                    const SizedBox(
                                      height: 5.0,
                                    ),
                                  ],
                                ),
                              );
                            }),
                        const SizedBox(
                          height: 3.0,
                        ),
                        Text(
                          "description : ${x.description}",
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
