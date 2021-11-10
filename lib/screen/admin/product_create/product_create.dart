import 'package:flutter/material.dart';
import 'package:mystore/constants.dart';
import 'package:mystore/models/user.dart';
import 'package:mystore/screen/admin/product_create/components/body.dart';
import 'package:mystore/screen/admin/product_list/product_list.dart';

class CreateProductScreen extends StatelessWidget {
  const CreateProductScreen({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroudColor,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: const Text(
          "Create Product",
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

      body: Body(user : user),
    );
  }
}
