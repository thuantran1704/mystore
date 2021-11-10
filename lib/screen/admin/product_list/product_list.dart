import 'package:flutter/material.dart';
import 'package:mystore/constants.dart';
import 'package:mystore/models/user.dart';
import 'package:mystore/screen/admin/dashboard/components/drawer_menu.dart';
import 'package:mystore/screen/admin/product_create/product_create.dart';
import 'package:mystore/screen/admin/product_list/components/body.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroudColor,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: const Text(
          "Product Management",
          style: TextStyle(color: Colors.white),
        ),
      ),
      // key: context.read<Controller>().scaffoldKey,
      // backgroundColor: bgColor,
      drawer: DrawerMenu(
        currentScreen: "product",
        user: user,
      ),
      body: Body(user : user),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kPrimaryColor,
        onPressed: (){
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>  CreateProductScreen(user: user)));
        },
        tooltip: 'Create new Product',
        child: const Icon(Icons.add),
      ),
      // body: const Body(),
    );
  }
}
