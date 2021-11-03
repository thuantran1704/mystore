// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:mystore/screen/spash/components/body.dart';
import 'package:mystore/size_config.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);
  static String routeName = "/splash";
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      body: Body(),
    );
  }
}
