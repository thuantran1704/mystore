import 'package:flutter/material.dart';
import 'package:mystore/models/reciept.dart';
import 'package:mystore/size_config.dart';

class ReceiptStatusRow extends StatelessWidget {
  const ReceiptStatusRow({
    Key? key,
    required this.receipt,
  }) : super(key: key);

  final Receipt receipt;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: SizeConfig.screenHeight * 0.14,
        child: (receipt.status.toLowerCase() == "ordered")
            ? firtsRowOrderDetais(
                status: "Waiting for delivery",
                createdAt: receipt.orderAt.toString(),
                creator: receipt.user.name,
                image: "assets/images/waiting.jpg",
                color: Colors.blueAccent,
              )
            : (receipt.status.toLowerCase() == "received")
                ? firtsRowOrderDetais(
                    status: "Completed",
                    createdAt: receipt.orderAt.toString(),
                    creator: receipt.user.name,
                    image: "assets/images/complete.jpg",
                    color: Colors.green,
                  )
                : firtsRowOrderDetais(
                    status: "Canceled",
                    createdAt: receipt.orderAt.toString(),
                    creator: receipt.user.name,
                    image: "assets/images/cancle.png",
                    color: Colors.red,
                  ));
  }
}

// ignore: camel_case_types
class firtsRowOrderDetais extends StatelessWidget {
  const firtsRowOrderDetais({
    Key? key,
    required this.status,
    required this.createdAt,
    required this.creator,
    required this.image,
    required this.color,
  }) : super(key: key);

  final String status;
  final String createdAt;
  final String creator;
  final String image;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          margin: EdgeInsets.only(
            left: getProportionateScreenWidth(30),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                status,
                style: TextStyle(
                  fontSize: 18.0,
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 6,
              ),
              Text(
                "Created at : ${createdAt.toString().substring(8, 10)}-${createdAt.toString().substring(5, 7)}-${createdAt.toString().substring(0, 4)}",
                style: const TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 2,
              ),
              Text(
                "Creator : $creator",
                style: const TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w700,
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Image.asset(
            image,
            height: 120,
            width: 120,
          ),
        ),
        const SizedBox(width: 1),
      ],
    );
  }
}
