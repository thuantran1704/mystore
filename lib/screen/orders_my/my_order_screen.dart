import 'package:flutter/material.dart';
import 'package:mystore/models/user.dart';
import 'package:mystore/screen/orders_my/components/body.dart';
import 'package:mystore/screen/profile/profile_screen.dart';

class MyOrders extends StatelessWidget {
  const MyOrders({
    Key? key,
    required this.user,
  }) : super(key: key);
  final User user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "My Orders",
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProfileScreen(user: user)),
                  (Route<dynamic> route) => false,
                )),
      ),
      // ============================ body ===========================//
      body: Body(user: user),
    );
  }
}
