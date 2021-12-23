// ignore_for_file: prefer_const_constructors, import_of_legacy_library_into_null_safe

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mystore/constants.dart';
import 'package:mystore/models/dashboard.dart';
import 'package:mystore/models/user.dart';
import 'package:mystore/screen/admin/order_list/order_list.dart';
import 'package:mystore/screen/admin/product_list/product_list.dart';
import 'package:mystore/screen/admin/receipt_list/receipt_list.dart';
import 'package:mystore/screen/admin/user_list/user_list.dart';
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
    return loading
        ? Padding(
            padding: EdgeInsets.only(top: getProportionateScreenHeight(10)),
            child: const Center(
              child: CircularProgressIndicator(
                color: kPrimaryColor,
                // backgroundColor: Colors.black,
              ),
            ),
          )
        : SingleChildScrollView(
            padding: EdgeInsets.all(getProportionateScreenWidth(16)),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          left: getProportionateScreenWidth(10)),
                      child: Text.rich(
                        TextSpan(
                          text:
                              "Hi ${(widget.user.name).contains(" ") ? widget.user.name.split(" ").last : widget.user.name},",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 35,
                              color: Colors.blueGrey.shade600),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          left: getProportionateScreenWidth(10)),
                      child: Text.rich(
                        (DateTime.now().hour >= 5 && DateTime.now().hour <= 11)
                            ? TextSpan(
                                text: "Have a nice day! \n",
                                style: TextStyle(
                                    color: Colors.blueGrey.shade600,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 32),
                              )
                            : (DateTime.now().hour >= 12 &&
                                    DateTime.now().hour <= 17)
                                ? TextSpan(
                                    text: "Good afternoon! \n",
                                    style: TextStyle(
                                        color: Colors.blueGrey.shade600,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 32),
                                  )
                                : TextSpan(
                                    text: "Good evening! \n",
                                    style: TextStyle(
                                        color: Colors.blueGrey.shade600,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 32),
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
                              child: const Center(
                                  child: CircularProgressIndicator()))
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
                                itemBuilder: (context, index) =>
                                    AnalyticInfoCard(
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
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        "Today's tasks",
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: Container(
                          margin: const EdgeInsets.only(
                              left: 20.0, right: 10.0, top: 2),
                          child: const Divider(
                            color: Colors.black54,
                            thickness: 1,
                            height: 40,
                          )),
                    ),
                  ],
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                OrdertListScreen(user: widget.user)));
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: (info[4] <= 0)
                      ? Container(
                          height: SizeConfig.screenHeight * 0.12,
                          margin: const EdgeInsets.only(left: 8.0, top: 8),
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey.shade200,
                                  blurRadius: 12.0,
                                  spreadRadius: 4.0),
                            ],
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Center(
                            child: Text(
                              "You have completed all the tasks!",
                              style: const TextStyle(
                                fontSize: 16.0,
                                color: Colors.black54,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )
                      : Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              height: SizeConfig.screenHeight * 0.12,
                              margin: const EdgeInsets.only(left: 8.0, top: 8),
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.shade200,
                                      blurRadius: 12.0,
                                      spreadRadius: 4.0),
                                ],
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              child: Center(
                                child: Text(
                                  "There are ${info[4].toString()} tasks waiting for processing",
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            if (info[4] != 0)
                              Positioned(
                                top: 0,
                                right: -6,
                                child: Container(
                                  // padding:
                                  //     EdgeInsets.all(getProportionateScreenWidth(12)),
                                  height: getProportionateScreenHeight(24),
                                  width: getProportionateScreenWidth(24),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        width: 0.5, color: Colors.white),
                                  ),

                                  child: Center(
                                    child: Text(
                                      info[4].toString(),
                                      style: TextStyle(
                                        fontSize:
                                            getProportionateScreenWidth(12),
                                        height: 1,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                ),
                SizedBox(height: getProportionateScreenWidth(14)),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        "Management",
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: Container(
                          margin: const EdgeInsets.only(
                              left: 20.0, right: 10.0, top: 2),
                          child: const Divider(
                            color: Colors.black54,
                            thickness: 1,
                            height: 40,
                          )),
                    ),
                  ],
                ),
                ManagementCard(
                  text: title[0],
                  icon: svg[0],
                  color: color[0],
                  press: () => {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ProductListScreen(user: widget.user)))
                  },
                ),
                ManagementCard(
                  text: title[1],
                  icon: svg[1],
                  color: color[1],
                  press: () => {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                UserListScreen(user: widget.user)))
                  },
                ),
                ManagementCard(
                  text: title[2],
                  icon: svg[2],
                  color: color[2],
                  press: () => {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                OrdertListScreen(user: widget.user)))
                  },
                ),
                ManagementCard(
                  text: title[3],
                  icon: svg[3],
                  color: color[3],
                  press: () => {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ReceiptListScreen(user: widget.user)))
                  },
                ),
              ],
            ),
          );
  }
}

class ManagementCard extends StatelessWidget {
  const ManagementCard({
    Key? key,
    required this.text,
    required this.icon,
    this.press,
    required this.color,
  }) : super(key: key);
  final String text, icon;
  final Color color;
  final VoidCallback? press;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: getProportionateScreenHeight(12)),
      child: TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.all(20),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: Color(0xFFF5F6F9),
        ),
        onPressed: press,
        child: Row(
          children: [
            SvgPicture.asset(
              icon,
              color: color,
              width: 25,
            ),
            SizedBox(width: 20),
            Expanded(
                child: Text(
              text,
              style: TextStyle(color: Colors.black87, fontSize: 15.5),
            )),
            Icon(
              Icons.arrow_forward_ios,
              color: kPrimaryColor,
            ),
          ],
        ),
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
