import 'package:flutter/material.dart';
import 'package:mystore/constants.dart';
import 'package:mystore/models/order.dart';
import 'package:mystore/size_config.dart';

class OrderStatusRow extends StatelessWidget {
  const OrderStatusRow({
    Key? key,
    required this.order,
  }) : super(key: key);

  final Order order;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: SizeConfig.screenHeight * 0.14,
      child: (order.status.toLowerCase() == "wait")
          ? firtsRowOrderDetais(
              status: "Waitting for Confirm",
              createdAt: order.createdAt.toString(),
              paymentMethod: order.paymentMethod,
              image: "assets/images/waiting.jpg",
              color: Colors.blueAccent,
            )
          : (order.status.toLowerCase() == "pay")
              ? firtsRowOrderDetais(
                  status: "Waitting for Payment",
                  createdAt: order.createdAt.toString(),
                  paymentMethod: order.paymentMethod,
                  image: "assets/images/waiting.jpg",
                  color: Colors.blueAccent,
                )
              : (order.status.toLowerCase() == "delivered")
                  ? firtsRowOrderDetais(
                      status: "On delivery",
                      createdAt: order.createdAt.toString(),
                      paymentMethod: order.paymentMethod,
                      image: "assets/images/delivery.jpg",
                      color: kPrimaryColor,
                    )
                  : (order.status.toLowerCase() == "received")
                      ? firtsRowOrderDetais(
                          status: "Completed",
                          createdAt: order.createdAt.toString(),
                          paymentMethod: order.paymentMethod,
                          image: "assets/images/complete.jpg",
                          color: Colors.green,
                        )
                      : (order.status.toLowerCase() == "return")
                          ? firtsRowOrderDetais(
                              status: "Requesting Return",
                              createdAt: order.createdAt.toString(),
                              paymentMethod: order.paymentMethod,
                              image: "assets/images/return.jpg",
                              color: Colors.deepOrange,
                            )
                          : (order.status.toLowerCase() == "returned")
                              ? firtsRowOrderDetais(
                                  status: "Returned",
                                  createdAt: order.createdAt.toString(),
                                  paymentMethod: order.paymentMethod,
                                  image: "assets/images/return.jpg",
                                  color: Colors.deepOrange,
                                )
                              : firtsRowOrderDetais(
                                  status: "Cancelled",
                                  createdAt: order.createdAt.toString(),
                                  paymentMethod: order.paymentMethod,
                                  image: "assets/images/cancle.png",
                                  color: Colors.red.shade900,
                                ),
    );
  }
}

// ignore: camel_case_types
class firtsRowOrderDetais extends StatelessWidget {
  const firtsRowOrderDetais({
    Key? key,
    required this.status,
    required this.createdAt,
    required this.paymentMethod,
    required this.image,
    required this.color,
  }) : super(key: key);

  final String status;
  final String createdAt;
  final String paymentMethod;
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
                "Payment method : $paymentMethod",
                style: const TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w600,
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
