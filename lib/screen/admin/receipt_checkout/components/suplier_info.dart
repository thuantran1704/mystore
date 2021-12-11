import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mystore/constants.dart';

import 'package:mystore/models/reciept.dart';
import 'package:mystore/size_config.dart';

class CustomSuplierInfo extends StatelessWidget {
  const CustomSuplierInfo({
    Key? key,
    required this.suplier,
  }) : super(key: key);

  final SupplierReceipt suplier;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12),
      child: Container(
        height: SizeConfig.screenHeight * 0.16,
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black54),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.shade100,
                // blurRadius: 10.0,
                spreadRadius: 2.0),
          ],
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: getProportionateScreenWidth(16),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                          1,
                          getProportionateScreenWidth(14),
                          getProportionateScreenWidth(10),
                          getProportionateScreenWidth(12),
                        ),
                        child: SvgPicture.asset(
                          "assets/icons/Location point.svg",
                          color: kPrimaryColor,
                          allowDrawingOutsideViewBox: true,
                          height: getProportionateScreenWidth(18),
                        ),
                      ),
                      const Text(
                        "Shipping Infomation",
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        suplier.name,
                        maxLines: 2,
                        style: const TextStyle(
                          fontSize: 14.0,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "Phone : ${suplier.phone}",
                        style: const TextStyle(
                          fontSize: 13.0,
                          color: Colors.black54,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 2),
                  SizedBox(
                    width: getProportionateScreenWidth(330),
                    height: getProportionateScreenWidth(36),
                    child: Text(
                      "${suplier.address}, ${suplier.country}.",
                      maxLines: 2,
                      softWrap: true,
                      style: const TextStyle(
                        fontSize: 13.0,
                        color: Colors.black54,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
