import 'package:flutter/material.dart';
import 'package:mystore/constants.dart';
import 'package:mystore/models/user.dart';
import 'package:mystore/screen/admin/dashboard/components/drawer_list_tile.dart';
import 'package:mystore/screen/admin/dashboard/dashboard.dart';
import 'package:mystore/screen/admin/order_list/order_list.dart';
import 'package:mystore/screen/admin/product_list/product_list.dart';
import 'package:mystore/screen/admin/receipt_list/receipt_list.dart';
import 'package:mystore/screen/admin/user_list/user_list.dart';
import 'package:mystore/screen/sign_in/sign_in_screen.dart';

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({Key? key, required this.currentScreen, required this.user})
      : super(key: key);

  final String currentScreen;
  final User user;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(appPadding),
            child: Image.asset("assets/images/logowithtext.png"),
          ),
          DrawerListTile(
              title: 'Dash Board',
              svgSrc: 'assets/icons/Dashboard.svg',
              style: (currentScreen == "dashboard")
                  ? const TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)
                  : const TextStyle(color: grey),
              tap: () {
                if (currentScreen != "dashboard") {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DashBoardScreen(user: user)));
                }
              }),
          DrawerListTile(
              title: 'Products',
              style: (currentScreen == "product")
                  ? const TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)
                  : const TextStyle(color: grey),
              svgSrc: 'assets/icons/product.svg',
              tap: () {
                if (currentScreen != "product") {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProductListScreen(user: user)));
                }
              }),
          DrawerListTile(
              title: 'Users',
              style: (currentScreen == "user")
                  ? const TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)
                  : const TextStyle(color: grey),
              svgSrc: 'assets/icons/Subscribers.svg',
              tap: () {
                if (currentScreen != "user") {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UserListScreen(user: user)));
                }
              }),
          DrawerListTile(
              title: 'Orders',
              style: (currentScreen == "order")
                  ? const TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)
                  : const TextStyle(color: grey),
              svgSrc: 'assets/icons/Pages.svg',
              tap: () {
                if (currentScreen != "order") {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => OrdertListScreen(user: user)));
                }
              }),
          DrawerListTile(
              style: (currentScreen == "receipt")
                  ? const TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)
                  : const TextStyle(color: grey),
              title: 'Receipts',
              svgSrc: 'assets/icons/Pages.svg',
              tap: () {
                if (currentScreen != "receipt") {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ReceiptListScreen(user: user)));
                }
              }),
          DrawerListTile(
              title: 'Statistics',
              style: (currentScreen == "statistic")
                  ? const TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)
                  : const TextStyle(color: grey),
              svgSrc: 'assets/icons/Statistics.svg',
              tap: () {}),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: appPadding * 2),
            child: Divider(
              color: grey,
              thickness: 0.2,
            ),
          ),
          DrawerListTile(
              style: (currentScreen == "setting")
                  ? const TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)
                  : const TextStyle(color: grey),
              title: 'Settings',
              svgSrc: 'assets/icons/Setting.svg',
              tap: () {}),
          DrawerListTile(
              style: const TextStyle(color: grey),
              title: 'Logout',
              svgSrc: 'assets/icons/Logout.svg',
              tap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                          title: const Text("Confirm"),
                          content: const Text(
                              "Do you really want to log out? \t\t\t"),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'No'),
                              child: const Text('No'),
                            ),
                            TextButton(
                                child: const Text('Yes'),
                                onPressed: () => {
                                      Navigator.pop(context, 'Yes'),
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SignInScreen()),
                                        (Route<dynamic> route) => false,
                                      ),
                                    }),
                          ],
                        ));
                //
              }),
        ],
      ),
    );
  }
}
