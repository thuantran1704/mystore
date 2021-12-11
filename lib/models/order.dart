import 'dart:convert';

List<Order> listOrderFromJson(String str) =>
    List<Order>.from(json.decode(str).map((x) => Order.fromJson(x)));

String listOrderToJson(List<Order> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

List<Order> parseOrders(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Order>((json) => Order.fromJson(json)).toList();
}

Order parseOrder(String str) => Order.fromJson(json.decode(str));

String orderToJson(Order data) => json.encode(data.toJson());

class Order {
  Order({
    required this.shippingAddress,
    required this.taxPrice,
    required this.shippingPrice,
    required this.discountPrice,
    required this.totalPrice,
    required this.status,
    required this.id,
    required this.orderItems,
    required this.user,
    required this.paymentMethod,
    required this.createdAt,
    this.paidAt,
    this.deliveredAt,
  });

  ShippingAddress shippingAddress;
  double taxPrice;
  int shippingPrice;
  double discountPrice;
  double totalPrice;
  String status;
  String id;
  List<OrderItem> orderItems;
  UserOrder user;
  String paymentMethod;
  DateTime createdAt;
  DateTime? paidAt;
  DateTime? deliveredAt;

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        shippingAddress: ShippingAddress.fromJson(json["shippingAddress"]),
        taxPrice: json["taxPrice"].toDouble(),
        shippingPrice: json["shippingPrice"],
        discountPrice: json["discountPrice"].toDouble(),
        totalPrice: json["totalPrice"].toDouble(),
        status: json["status"],
        id: json["_id"],
        orderItems: List<OrderItem>.from(
            json["orderItems"].map((x) => OrderItem.fromJson(x))),
        user: UserOrder.fromJson(json["user"]),
        paymentMethod: json["paymentMethod"],
        createdAt: DateTime.parse(json["createdAt"]),
        paidAt: json["paidAt"] == null ? null : DateTime.parse(json["paidAt"]),
        deliveredAt: json["deliveredAt"] == null
            ? null
            : DateTime.parse(json["deliveredAt"]),
      );

  Map<String, dynamic> toJson() => {
        "shippingAddress": shippingAddress.toJson(),
        "taxPrice": taxPrice,
        "shippingPrice": shippingPrice,
        "discountPrice": discountPrice,
        "totalPrice": totalPrice,
        "status": status,
        "_id": id,
        "orderItems": List<dynamic>.from(orderItems.map((x) => x.toJson())),
        "user": user.toJson(),
        "paymentMethod": paymentMethod,
        "createdAt": createdAt.toIso8601String(),
        "paidAt": paidAt == null ? null : paidAt!.toIso8601String(),
        "deliveredAt":
            deliveredAt == null ? null : deliveredAt!.toIso8601String(),
      };
}

class OrderItem {
  OrderItem({
    required this.id,
    required this.qty,
    required this.price,
    required this.product,
  });

  String id;
  int qty;
  double price;
  ProductItem product;

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
        id: json["_id"],
        qty: json["qty"],
        price: json["price"].toDouble(),
        product: ProductItem.fromJson(json["product"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "qty": qty,
        "price": price,
        "product": product.toJson(),
      };
}

class ProductItem {
  ProductItem({
    required this.id,
    required this.name,
    required this.images,
  });

  String id;
  String name;
  List<ImageItem> images;

  factory ProductItem.fromJson(Map<String, dynamic> json) => ProductItem(
        id: json["_id"],
        name: json["name"],
        images: List<ImageItem>.from(
            json["images"].map((x) => ImageItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "images": List<dynamic>.from(images.map((x) => x.toJson())),
      };
}

class ImageItem {
  ImageItem({
    required this.id,
    required this.publicId,
    required this.url,
  });

  String id;
  String publicId;
  String url;

  factory ImageItem.fromJson(Map<String, dynamic> json) => ImageItem(
        id: json["_id"],
        publicId: json["public_id"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "public_id": publicId,
        "url": url,
      };
}

class ShippingAddress {
  ShippingAddress({
    required this.address,
    required this.city,
    required this.postalCode,
    required this.country,
  });

  String address;
  String city;
  String postalCode;
  String country;

  factory ShippingAddress.fromJson(Map<String, dynamic> json) =>
      ShippingAddress(
        address: json["address"],
        city: json["city"],
        postalCode: json["postalCode"],
        country: json["country"],
      );

  Map<String, dynamic> toJson() => {
        "address": address,
        "city": city,
        "postalCode": postalCode,
        "country": country,
      };
}

class UserOrder {
  UserOrder({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
  });

  String id;
  String name;
  String email;
  String phone;

  factory UserOrder.fromJson(Map<String, dynamic> json) => UserOrder(
        id: json["_id"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "email": email,
        "phone": phone,
      };
}

String orderItemToJson(OrderItem data) => json.encode(data.toJson());

class CartItem {
  CartItem({
    required this.qty,
    required this.price,
    required this.product,
  });

  int qty;
  double price;
  String product;

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
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
