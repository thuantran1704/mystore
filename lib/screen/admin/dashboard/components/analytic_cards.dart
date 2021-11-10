import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mystore/constants.dart';
import 'package:mystore/models/dashboard.dart';
import 'package:http/http.dart' as http;
import 'package:mystore/size_config.dart';

class AnalyticCards extends StatefulWidget {
  const AnalyticCards({Key? key}) : super(key: key);

  @override
  State<AnalyticCards> createState() => _AnalyticCardsState();
}

class _AnalyticCardsState extends State<AnalyticCards> {
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
    super.initState();
    getDashboardInfo();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Padding(
        padding: EdgeInsets.only(top: getProportionateScreenHeight(20)),
        child: const Center(child: CircularProgressIndicator()),
      );
    } else {
      return GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: 4,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
      );
    }
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
          color: Color.fromRGBO(237, 244, 254, 1),
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
            height: getProportionateScreenHeight(12),
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