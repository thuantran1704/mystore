import 'package:mystore/models/user.dart';
import 'package:mystore/screen/all_product/all_product_screen.dart';
import 'package:mystore/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Brands extends StatelessWidget {
  const Brands({Key? key, required this.user}) : super(key: key);
  final User user;
  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> brands = [
      {"icon": "assets/icons/Asus.svg", "text": "ASUS"},
      {"icon": "assets/icons/Iogear.svg", "text": "Iogear"},
      {"icon": "assets/icons/Acer.svg", "text": "Acer"},
      {"icon": "assets/icons/Cougar.svg", "text": "Cougar"},
      {"icon": "assets/icons/Msi.svg", "text": "MSI"},
    ];
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...List.generate(
              brands.length,
              (index) => BrandCard(
                    icon: brands[index]["icon"],
                    text: brands[index]["text"],
                    press: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AllProductScreen(
                                    user: user,
                                    brand: brands[index]["text"],
                                  )));
                    },
                  ))
        ],
      ),
    );
  }
}

class BrandCard extends StatelessWidget {
  const BrandCard({
    Key? key,
    required this.icon,
    required this.text,
    required this.press,
  }) : super(key: key);

  final String icon, text;
  final GestureTapCallback? press;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: SizedBox(
        width: getProportionateScreenWidth(55),
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 2), // changes position of shadow
                    ),
                  ],
                  color: Colors.grey.shade200,
                  border: Border.all(color: Colors.black38),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: SvgPicture.asset(icon),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              text,
              style: const TextStyle(color: Colors.black87),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
