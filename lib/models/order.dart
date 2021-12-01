import 'dart:convert';

List<Order> orderFromJson(String str) =>
    List<Order>.from(json.decode(str).map((x) => Order.fromJson(x)));

String orderToJson(List<Order> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

List<Order> parseOrders(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Order>((json) => Order.fromJson(json)).toList();
}

Order parseOrder(String str) => Order.fromJson(json.decode(str));

class Order {
  Order({
    required this.shippingAddress,
    required this.taxPrice,
    required this.shippingPrice,
    required this.discountPrice,
    required this.totalPrice,
    required this.isPaid,
    required this.isDelivered,
    required this.status,
    required this.isCancelled,
    required this.id,
    required this.orderItems,
    required this.user,
    required this.paymentMethod,
    required this.createdAt,
  });

  ShippingAddress shippingAddress;
  double taxPrice;
  int shippingPrice;
  double discountPrice;
  double totalPrice;
  bool isPaid;
  bool isDelivered;
  int status;
  bool isCancelled;
  String id;
  List<OrderItem> orderItems;
  UserO user;
  String paymentMethod;
  DateTime createdAt;

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        shippingAddress: ShippingAddress.fromJson(json["shippingAddress"]),
        taxPrice: json["taxPrice"].toDouble(),
        shippingPrice: json["shippingPrice"],
        discountPrice: json["discountPrice"].toDouble(),
        totalPrice: json["totalPrice"].toDouble(),
        isPaid: json["isPaid"],
        isDelivered: json["isDelivered"],
        status: json["status"],
        isCancelled: json["isCancelled"],
        id: json["_id"],
        orderItems: List<OrderItem>.from(
            json["orderItems"].map((x) => OrderItem.fromJson(x))),
        user: UserO.fromJson(json["user"]),
        paymentMethod: json["paymentMethod"],
        createdAt: DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toJson() => {
        "shippingAddress": shippingAddress.toJson(),
        "taxPrice": taxPrice,
        "shippingPrice": shippingPrice,
        "discountPrice": discountPrice,
        "totalPrice": totalPrice,
        "isPaid": isPaid,
        "isDelivered": isDelivered,
        "status": status,
        "isCancelled": isCancelled,
        "_id": id,
        "orderItems": List<dynamic>.from(orderItems.map((x) => x.toJson())),
        "user": user.toJson(),
        "paymentMethod": paymentMethod,
        "createdAt": createdAt.toIso8601String(),
      };
}

class OrderItem {
  OrderItem({
    required this.id,
    required this.name,
    required this.qty,
    required this.image,
    required this.price,
    required this.product,
  });

  String id;
  String name;
  int qty;
  String image;
  double price;
  String product;

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
        id: json["_id"],
        name: json["name"],
        qty: json["qty"],
        image: json["image"],
        price: json["price"].toDouble(),
        product: json["product"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "qty": qty,
        "image": image,
        "price": price,
        "product": product,
      };
}

class ShippingAddress {
  ShippingAddress({
    required this.address,
    required this.city,
    required this.country,
    required this.postalCode,
  });

  String address;
  String city;
  String country;
  String postalCode;

  factory ShippingAddress.fromJson(Map<String, dynamic> json) =>
      ShippingAddress(
        address: json["address"],
        city: json["city"],
        country: json["country"],
        postalCode: json["postalCode"],
      );

  Map<String, dynamic> toJson() => {
        "address": address,
        "city": city,
        "country": country,
        "postalCode": postalCode,
      };
}

class UserO {
  UserO({
    required this.id,
    required this.name,
    required this.email,
  });

  String id;
  String name;
  String email;

  factory UserO.fromJson(Map<String, dynamic> json) => UserO(
        id: json["_id"],
        name: json["name"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "email": email,
      };
}
