import 'package:flutter/material.dart';
import 'package:mystore/models/user.dart';

class ReceiptDetailScreen extends StatelessWidget {
  const ReceiptDetailScreen({
    Key? key,
    required this.receiptId,
    required this.user,
  }) : super(key: key);
  final String receiptId;
  final User user;
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
