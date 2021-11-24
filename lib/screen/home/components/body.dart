import 'package:mystore/models/user.dart';
import 'package:mystore/screen/home/components/brands.dart';
import 'package:mystore/screen/home/components/new_arrival_products.dart';
import 'package:mystore/screen/home/components/top_rated_product.dart';
import 'package:mystore/screen/home/components/special_offers.dart';
import 'package:mystore/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../components/home_header.dart';

class Body extends StatefulWidget {
  const Body({
    Key? key,
    required this.user,
  }) : super(key: key);

  final User user;

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: getProportionateScreenHeight(20)),
            HomeHeader(user: widget.user),
            SizedBox(height: getProportionateScreenHeight(20)),
            Brands(user: widget.user),
            SizedBox(height: getProportionateScreenHeight(20)),
            SpecialOffers(user: widget.user),
            SizedBox(height: getProportionateScreenHeight(20)),
            TopRated(user: widget.user),
            SizedBox(height: getProportionateScreenHeight(20)),
            NewArrival(user: widget.user),
            SizedBox(height: getProportionateScreenHeight(20)),
          ],
        ),
      ),
    );
  }
}
