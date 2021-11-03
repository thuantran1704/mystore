// ignore_for_file: avoid_print

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:mystore/models/product.dart';
import 'package:mystore/models/user.dart';
import 'package:mystore/screen/all_product/all_product_screen.dart';
import 'package:mystore/screen/home/components/product_card.dart';
import 'package:mystore/screen/home/components/section_title.dart';
import 'package:mystore/screen/product_details/details_screen.dart';
import 'package:mystore/size_config.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';

class NewArrival extends StatefulWidget {
  const NewArrival({
    Key? key,
    required this.user,
  }) : super(key: key);
  final User user;

  @override
  _NewArrivalState createState() => _NewArrivalState();
}

class _NewArrivalState extends State<NewArrival> {
  List<Product> list = [];

  var loading = false;
  final baseUrl = "https://mystore-backend.herokuapp.com";

  Future<void> getProductListFromAPI() async {
    setState(() {
      loading = true;
    });
    final response = await http.get(Uri.parse("$baseUrl/api/products"),
        headers: {"Accept": "application/json"});

    if (response.statusCode == 200) {
      setState(() {
        list = parseProducts(response.body).take(6).toList();

        loading = false;
      });
    } else {
      throw Exception('Unable to fetch products from the REST API');
    }
  }

  Widget _buildProductItem(BuildContext context, int index) {
    return ProductCard(
        product: list[index],
        press: () => Navigator.pushNamed(context, DetailsScreen.routeName,
            arguments: ProductDetailsArguments(
                product: list[index], user: widget.user)));
  }

  @override
  void initState() {
    getProductListFromAPI();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SectionTitle(
          text: "New Arrival",
          press: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AllProductScreen(user: widget.user)));
          },
        ),
        SizedBox(height: getProportionateScreenHeight(5)),
        loading
            ? Padding(
                padding: EdgeInsets.only(top: getProportionateScreenHeight(20)),
                child: const Center(child: CircularProgressIndicator()),
              )
            : CustomScrollView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                slivers: [
                  SliverPadding(
                    padding: EdgeInsets.only(
                      right: getProportionateScreenWidth(20),
                    ),
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 0.78,
                        crossAxisCount: 2,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        _buildProductItem,
                        childCount: list.length,
                      ),
                    ),
                  ),
                ],
              ),
      ],
    );
  }
}
