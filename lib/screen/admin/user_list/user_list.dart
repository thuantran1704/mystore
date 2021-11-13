import 'package:flutter/material.dart';
import 'package:mystore/constants.dart';
import 'package:mystore/models/user.dart';
import 'package:mystore/screen/admin/dashboard/components/drawer_menu.dart';
import 'package:mystore/screen/admin/product_create/product_create.dart';
import 'package:mystore/screen/admin/user_list/components/body.dart';

class UserListScreen extends StatelessWidget {
  const UserListScreen({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: buildAppBar(),
        drawer: DrawerMenu(
          currentScreen: "user",
          user: user,
        ),
        //============================================================//
        body: Body(user: user),
        //============================================================//
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
        "User Management",
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
          Text("In used", style: TextStyle(fontSize: 16)),
          Text("Disable", style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
