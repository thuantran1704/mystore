import 'package:flutter/material.dart';
import 'package:mystore/constants.dart';
import 'package:mystore/models/user.dart';
import 'package:mystore/screen/admin/dashboard/components/drawer_menu.dart';
import 'package:mystore/screen/admin/order_list/components/body.dart';

class OrdertListScreen extends StatefulWidget {
  const OrdertListScreen({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  State<OrdertListScreen> createState() => _OrdertListScreenState();
}

class _OrdertListScreenState extends State<OrdertListScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 8,
      child: Scaffold(
        appBar: buildAppBar(),
        drawer: DrawerMenu(
          currentScreen: "order",
          user: widget.user,
        ),
        body: Body(user: widget.user),
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
        "Order Management",
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
          Text("Pay", style: TextStyle(fontSize: 16)),
          Text("Wait", style: TextStyle(fontSize: 16)),
          Text("Delivery", style: TextStyle(fontSize: 16)),
          Text("Completed", style: TextStyle(fontSize: 16)),
          Text("Return", style: TextStyle(fontSize: 16)),
          Text("Returned", style: TextStyle(fontSize: 16)),
          Text("Cancelled", style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
