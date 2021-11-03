import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:mystore/models/product.dart';
import 'package:mystore/models/user.dart';
import 'package:mystore/screen/product_details/details_screen.dart';
import 'package:mystore/screen/home/components/product_card.dart';
import 'package:mystore/screen/home/components/section_title.dart';
import 'package:mystore/size_config.dart';

class TopRated extends StatefulWidget {
  const TopRated({
    Key? key,
    required this.user,
  }) : super(key: key);
  final User user;

  @override
  _TopRatedState createState() => _TopRatedState();
}

class _TopRatedState extends State<TopRated> {
  List<Product> list = [];
  var loading = false;
  final baseUrl = "https://mystore-backend.herokuapp.com";

  Future<void> getProductList() async {
    setState(() {
      loading = true;
    });
    final response = await http.get(Uri.parse("$baseUrl/api/products/top"),
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
    super.initState();
    getProductList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionTitle(
          text: "Most Rated",
          press: () {},
        ),
        SizedBox(height: getProportionateScreenHeight(5)),
        Container(
          child: loading
              ? Padding(
                  padding:
                      EdgeInsets.only(top: getProportionateScreenHeight(20)),
                  child: const Center(child: CircularProgressIndicator()),
                )
              : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ...List.generate(
                        list.length,
                        (index) => ProductCard(
                          product: list[index],
                          press: () => Navigator.pushNamed(
                              context, DetailsScreen.routeName,
                              arguments: ProductDetailsArguments(
                                  product: list[index], user: widget.user)),
                        ),
                      ),
                      SizedBox(width: getProportionateScreenWidth(20))
                    ],
                  ),
                ),
        ),
      ],
    );
  }
}
