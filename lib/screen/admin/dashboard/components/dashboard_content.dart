// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mystore/constants.dart';
import 'package:mystore/models/dashboard.dart';
import 'package:mystore/models/user.dart';
import 'package:mystore/size_config.dart';
import 'package:http/http.dart' as http;

class Body extends StatefulWidget {
  const Body({Key? key, required this.user}) : super(key: key);
  final User user;
  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  late List info;
  final List title = ["Products", "Users", "Orders", "Receipts"];
  final List svg = [
    "assets/icons/product.svg",
    "assets/icons/Subscribers.svg",
    "assets/icons/Pages.svg",
    "assets/icons/Pages.svg"
  ];
  final List color = [
    Colors.amber,
    Colors.blue,
    Colors.green,
    Colors.orange,
  ];

  var loading = false;
  final baseUrl = "https://mystore-backend.herokuapp.com";

  Future<void> getDashboardInfo() async {
    setState(() {
      loading = true;
    });
    final response = await http.get(Uri.parse("$baseUrl/api/dashboard"),
        headers: {"Accept": "application/json"});

    if (response.statusCode == 200) {
      setState(() {
        info = dashboardFromJson(response.body);
        loading = false;
      });
    } else {
      throw Exception('Unable to fetch products from the REST API');
    }
  }

  @override
  void initState() {
    getDashboardInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(getProportionateScreenWidth(16)),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: getProportionateScreenWidth(10)),
                child: Text.rich(
                  TextSpan(
                    text:
                        "Hi ${(widget.user.name).contains(" ") ? widget.user.name.split(" ").last : widget.user.name},",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 35),
                  ),
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: getProportionateScreenWidth(10)),
                child: Text.rich(
                  (DateTime.now().hour >= 5 && DateTime.now().hour <= 11)
                      ? TextSpan(
                          text: "Have a nice day! \n",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 32),
                        )
                      : (DateTime.now().hour >= 12 && DateTime.now().hour <= 17)
                          ? TextSpan(
                              text: "Good afternoon! \n",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 32),
                            )
                          : TextSpan(
                              text: "Good evening! \n",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 32),
                            ),
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 5,
                child: loading
                    ? Padding(
                        padding: EdgeInsets.only(
                            top: getProportionateScreenHeight(20)),
                        child: const Center(child: CircularProgressIndicator()))
                    : RefreshIndicator(
                        onRefresh: getDashboardInfo,
                        child: GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: 4,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: appPadding,
                            mainAxisSpacing: appPadding,
                            childAspectRatio: 2,
                          ),
                          itemBuilder: (context, index) => AnalyticInfoCard(
                            title: title[index],
                            color: color[index],
                            count: info[index],
                            svg: svg[index],
                          ),
                        ),
                      ),
              ),
            ],
          ),
          SizedBox(height: getProportionateScreenWidth(14)),
        ],
      ),
    );
  }
}

class AnalyticInfoCard extends StatelessWidget {
  const AnalyticInfoCard({
    Key? key,
    required this.title,
    required this.svg,
    required this.color,
    required this.count,
  }) : super(key: key);

  final String title;
  final String svg;
  final Color color;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: getProportionateScreenWidth(16),
        vertical: getProportionateScreenHeight(6),
      ),
      decoration: BoxDecoration(
          color: const Color.fromRGBO(237, 244, 254, 1),
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "$count",
                style: const TextStyle(
                  color: kTextColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                    color: color.withOpacity(0.1), shape: BoxShape.circle),
                child: SvgPicture.asset(
                  svg,
                  color: color,
                ),
              )
            ],
          ),
          SizedBox(
            height: getProportionateScreenHeight(8),
          ),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          )
        ],
      ),
    );
  }
}
