// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:mystore/models/product.dart';
import 'package:mystore/models/user.dart';
import 'package:mystore/screen/product_details/components/custom_app_bar.dart';
import 'package:mystore/screen/product_details/components/body.dart';

class DetailsScreen extends StatelessWidget {
  static String routeName = "/details";

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)!.settings.arguments as ProductDetailsArguments;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(arguments.product.rating),
      body: Body(
        product: arguments.product,
        user: arguments.user,
      ),
    );
  }
}

class ProductDetailsArguments {
  final Product product;
  final User user;
  ProductDetailsArguments({required this.user, required this.product});
}
