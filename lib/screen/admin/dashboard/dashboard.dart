import 'package:flutter/material.dart';

import 'package:mystore/models/user.dart';
import 'package:mystore/screen/admin/dashboard/components/drawer_menu.dart';
import 'package:mystore/constants.dart';

import 'package:mystore/screen/admin/dashboard/components/dashboard_content.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroudColor,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: const Text(
          "Dash Board",
          style: TextStyle(color: Colors.white),
        ),
      ),
      // key: context.read<Controller>().scaffoldKey,
      // backgroundColor: bgColor,
      drawer: DrawerMenu(
        currentScreen: "dashboard",
        user: widget.user,
      ),
      body: const Body(),
    );
  }
}
