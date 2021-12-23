import 'dart:convert';

class Result {
  Result({
    required this.name,
    required this.sold,
  });

  String name;
  int sold;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        name: json["name"],
        sold: json["sold"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "sold": sold,
      };
}

Profit profitFromJson(String str) => Profit.fromJson(json.decode(str));

String profitToJson(Profit data) => json.encode(data.toJson());

class Profit {
  Profit({
    required this.orders,
    required this.receipts,
  });

  List<OrderS> orders;
  List<ReceiptS> receipts;

  factory Profit.fromJson(Map<String, dynamic> json) => Profit(
        orders:
            List<OrderS>.from(json["orders"].map((x) => OrderS.fromJson(x))),
        receipts: List<ReceiptS>.from(
            json["receipts"].map((x) => ReceiptS.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "orders": List<dynamic>.from(orders.map((x) => x.toJson())),
        "receipts": List<dynamic>.from(receipts.map((x) => x.toJson())),
      };
}

class OrderS {
  OrderS({
    required this.orderItems,
  });

  List<Item> orderItems;

  factory OrderS.fromJson(Map<String, dynamic> json) => OrderS(
        orderItems:
            List<Item>.from(json["orderItems"].map((x) => Item.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "orderItems": List<dynamic>.from(orderItems.map((x) => x.toJson())),
      };
}

class Item {
  Item({
    required this.qty,
    required this.price,
    required this.product,
  });

  int qty;
  double price;
  String product;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        qty: json["qty"],
        price: json["price"].toDouble(),
        product: json["product"],
      );

  Map<String, dynamic> toJson() => {
        "qty": qty,
        "price": price,
        "product": product,
      };
}

class ReceiptS {
  ReceiptS({
    required this.receiptItems,
  });

  List<Item> receiptItems;

  factory ReceiptS.fromJson(Map<String, dynamic> json) => ReceiptS(
        receiptItems:
            List<Item>.from(json["receiptItems"].map((x) => Item.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "receiptItems": List<dynamic>.from(receiptItems.map((x) => x.toJson())),
      };
}

class OrderProfit {
  OrderProfit({
    required this.qty,
    required this.price,
    required this.productId,
  });

  int qty;
  List<double> price;
  String productId;
}

class ReceiptProfit {
  ReceiptProfit({
    required this.price,
    required this.productId,
  });

  List<double> price;
  String productId;
}
