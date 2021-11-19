import 'package:flutter/material.dart';
import 'package:mystore/constants.dart';
import 'package:mystore/models/user.dart';
import 'package:mystore/screen/admin/statistic/components/body.dart';
import 'package:mystore/screen/admin/dashboard/components/drawer_menu.dart';

class StatisticScreen extends StatefulWidget {
  const StatisticScreen({Key? key, required this.user}) : super(key: key);
  final User user;
  @override
  _StatisticScreenState createState() => _StatisticScreenState();
}

class _StatisticScreenState extends State<StatisticScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroudColor,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: const Text(
          "Statistic",
          style: TextStyle(color: Colors.white),
        ),
      ),
      drawer: DrawerMenu(
        currentScreen: "statistic",
        user: widget.user,
      ),
      body: Body(
        user: widget.user,
      ),
    );
  }
}
