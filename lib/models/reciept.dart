import 'dart:convert';

List<Receipt> receiptFromJson(String str) =>
    List<Receipt>.from(json.decode(str).map((x) => Receipt.fromJson(x)));

String receiptToJson(List<Receipt> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

Receipt singleReceiptFromJson(String str) => Receipt.fromJson(jsonDecode(str));

class Receipt {
  Receipt({
    required this.supplier,
    required this.shippingPrice,
    required this.totalPrice,
    required this.status,
    required this.id,
    required this.receiptItems,
    required this.user,
    required this.orderAt,
    required this.receiveAt,
  });

  Supplier supplier;
  int shippingPrice;
  double totalPrice;
  String status;
  String id;
  List<ReceiptItem> receiptItems;
  UserR user;
  DateTime orderAt;
  DateTime receiveAt;

  factory Receipt.fromJson(Map<String, dynamic> json) => Receipt(
        supplier: Supplier.fromJson(json["supplier"]),
        shippingPrice: json["shippingPrice"],
        totalPrice: json["totalPrice"].toDouble(),
        status: json["status"],
        id: json["_id"],
        receiptItems: List<ReceiptItem>.from(
            json["receiptItems"].map((x) => ReceiptItem.fromJson(x))),
        user: UserR.fromJson(json["user"]),
        orderAt: DateTime.parse(json["orderAt"]),
        receiveAt: DateTime.parse(json["receiveAt"]),
      );

  Map<String, dynamic> toJson() => {
        "supplier": supplier.toJson(),
        "shippingPrice": shippingPrice,
        "totalPrice": totalPrice,
        "status": status,
        "_id": id,
        "receiptItems": List<dynamic>.from(receiptItems.map((x) => x.toJson())),
        "user": user.toJson(),
        "orderAt": orderAt.toIso8601String(),
        "receiveAt": receiveAt.toIso8601String(),
      };
}

class ReceiptItem {
  ReceiptItem({
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

  factory ReceiptItem.fromJson(Map<String, dynamic> json) => ReceiptItem(
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

class Supplier {
  Supplier({
    required this.name,
    required this.address,
    required this.country,
    required this.phone,
  });

  String name;
  String address;
  String country;
  String phone;

  factory Supplier.fromJson(Map<String, dynamic> json) => Supplier(
        name: json["name"],
        address: json["address"],
        country: json["country"],
        phone: json["phone"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "address": address,
        "country": country,
        "phone": phone,
      };
}

class UserR {
  UserR({
    required this.id,
    required this.name,
    required this.email,
  });

  String id;
  String name;
  String email;

  factory UserR.fromJson(Map<String, dynamic> json) => UserR(
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

List<SuplierInfo> suplierInfoFromJson(String str) => List<SuplierInfo>.from(
    json.decode(str).map((x) => SuplierInfo.fromJson(x)));

String suplierInfoToJson(List<SuplierInfo> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SuplierInfo {
  SuplierInfo({
    required this.id,
    required this.name,
    required this.address,
    required this.country,
    required this.phone,
  });

  String id;
  String name;
  String address;
  String country;
  String phone;

  factory SuplierInfo.fromJson(Map<String, dynamic> json) => SuplierInfo(
        id: json["_id"],
        name: json["name"],
        address: json["address"],
        country: json["country"],
        phone: json["phone"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "address": address,
        "country": country,
        "phone": phone,
      };
}
