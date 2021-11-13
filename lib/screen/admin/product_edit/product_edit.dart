import 'package:flutter/material.dart';
import 'package:mystore/constants.dart';
import 'package:mystore/models/product.dart';
import 'package:mystore/models/user.dart';
import 'package:mystore/screen/admin/product_edit/components/body.dart';
import 'package:mystore/screen/admin/product_list/product_list.dart';

class EditProductScreen extends StatelessWidget {
  const EditProductScreen({Key? key, required this.user, required this.product})
      : super(key: key);
  final User user;
  final Product product;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroudColor,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: const Text(
          "Edit Product",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProductListScreen(user: user)),
                  (Route<dynamic> route) => false,
                )),
      ),
      body: Body(user: user, product: product),
    );
  }
}
