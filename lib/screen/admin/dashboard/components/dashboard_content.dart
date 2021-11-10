import 'package:flutter/material.dart';
import 'package:mystore/constants.dart';
import 'package:mystore/screen/admin/dashboard/components/analytic_cards.dart';
import 'package:mystore/screen/admin/dashboard/components/custom_app_bar.dart';
import 'package:mystore/size_config.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 5,
            child: SafeArea(
              child: SingleChildScrollView(
                padding:  EdgeInsets.all(getProportionateScreenWidth(14)),
                child: Column(
                  children: [
                    Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 5,
                              child:  Column(
                                children:  [
                                  AnalyticCards(),
                                  SizedBox(
                                    height: getProportionateScreenWidth(14),
                                  ),
                                  // Users(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
