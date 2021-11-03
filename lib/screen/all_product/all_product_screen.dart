// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:mystore/models/product.dart';
import 'package:mystore/models/user.dart';
import 'package:mystore/screen/home/components/product_card.dart';
import 'package:mystore/screen/product_details/details_screen.dart';
import 'package:mystore/size_config.dart';

class AllProductScreen extends StatefulWidget {
  const AllProductScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  final User user;

  @override
  _AllProductScreenState createState() => _AllProductScreenState();
}

class _AllProductScreenState extends State<AllProductScreen> {
  List<Product> list = [];
  List<Product> showList = [];
  var loading = false;
  final baseUrl = "https://mystore-backend.herokuapp.com";

  static const double _endReachedThreshold = 200;
  static const int _itemsPerPage = 6;
  final ScrollController _controller = ScrollController();

  int _nextPage = 1;
  bool _loading = true;
  bool _canLoadMore = true;

  Future<void> getProductListFromAPI() async {
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

  Future<List<Product>> getProductFromListToShow(
      {required int page,
      required int limit,
      required List<Product> list}) async {
    if (limit <= 0) return [];

    await Future.delayed(Duration(seconds: 1));

    return list.skip((page - 1) * limit).take(limit).toList();
  }

  Future<void> _getShowList() async {
    if (list.isEmpty) {
      await getProductListFromAPI();
    }
    _loading = true;

    final newProducts = await getProductFromListToShow(
        page: _nextPage, limit: _itemsPerPage, list: list);

    setState(() {
      showList.addAll(newProducts);

      _nextPage++;

      if (newProducts.length < _itemsPerPage) {
        _canLoadMore = false;
        _loading = false;
      }

      _loading = false;
    });
  }

  void _onScroll() {
    if (!_controller.hasClients || _loading) return;
    if (_controller.position.extentAfter < _endReachedThreshold) {
      _getShowList();
    }
  }

  Future<void> _refresh() async {
    _canLoadMore = true;
    showList.clear();
    _nextPage = 1;
    await _getShowList();
  }

  Widget _buildProductItem(BuildContext context, int index) {
    return ProductCard(
        product: showList[index],
        press: () => Navigator.pushNamed(context, DetailsScreen.routeName,
            arguments: ProductDetailsArguments(
                product: showList[index], user: widget.user)));
  }

  @override
  void initState() {
    _controller.addListener(_onScroll);
    _getShowList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "All Products",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: CustomScrollView(
        controller: _controller,
        slivers: [
          CupertinoSliverRefreshControl(
            onRefresh: _refresh,
          ),
          SliverPadding(
            padding: EdgeInsets.only(
              right: getProportionateScreenWidth(20),
            ),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 0.78,
                crossAxisCount: 2,
              ),
              delegate: SliverChildBuilderDelegate(
                _buildProductItem,
                childCount: showList.length,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: _canLoadMore
                ? Column(
                    children: [
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.only(bottom: 20),
                        alignment: Alignment.center,
                        child: const CircularProgressIndicator(),
                      ),
                    ],
                  )
                : const SizedBox(height: 20),
          ),
        ],
      ),
    );
  }
}
