import 'package:flutter/material.dart';
import 'package:mystore/models/user.dart';
import 'package:mystore/screen/my_account/components/body.dart';

class MyAccountScreen extends StatelessWidget {
  const MyAccountScreen({
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
          "My Account",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Body(user: user),
    );
  }
}
