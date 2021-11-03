import 'package:flutter/material.dart';
import 'package:mystore/screen/sign_in/components/body.dart';

// ignore: use_key_in_widget_constructors
class SignInScreen extends StatelessWidget {
  static String routeName = "/sign_in";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Sign In",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Body(),
    );
  }
}
