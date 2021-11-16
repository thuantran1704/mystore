import 'package:flutter/material.dart';
import 'package:mystore/constants.dart';
import 'package:mystore/models/user.dart';
import 'package:mystore/screen/admin/receipt_cart/receipt_cart.dart';
import 'package:mystore/screen/admin/receipt_list/components/body.dart';
import 'package:mystore/screen/admin/dashboard/components/drawer_menu.dart';

class ReceiptListScreen extends StatefulWidget {
  const ReceiptListScreen({
    Key? key,
    required this.user,
  }) : super(key: key);
  final User user;

  @override
  _ReceiptListScreenState createState() => _ReceiptListScreenState();
}

class _ReceiptListScreenState extends State<ReceiptListScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: buildAppBar(),
        drawer: DrawerMenu(
          currentScreen: "receipt",
          user: widget.user,
        ),
        body: Body(user: widget.user),
        //===========================//
        floatingActionButton: FloatingActionButton(
          backgroundColor: kPrimaryColor,
          onPressed: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ReceiptCartScreen(user: widget.user)));
          },
          tooltip: 'Receipt Cart',
          child: const Icon(Icons.shopping_cart),
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: backgroudColor,
      iconTheme: const IconThemeData(color: Colors.white),
      centerTitle: true,
      title: const Text(
        "Receipt Management",
        style: TextStyle(color: Colors.white),
      ),
      bottom: TabBar(
        labelPadding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          color: kPrimaryColor,
        ),
        isScrollable: true,
        indicatorSize: TabBarIndicatorSize.tab,
        labelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelColor: Colors.white,
        labelColor: Colors.white,
        tabs: const [
          Text("All", style: TextStyle(fontSize: 16)),
          Text("Ordered", style: TextStyle(fontSize: 16)),
          Text("Received", style: TextStyle(fontSize: 16)),
          Text("Cancelled", style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
