import 'dart:convert';

List<Receipt> receiptFromJson(String str) =>
    List<Receipt>.from(json.decode(str).map((x) => Receipt.fromJson(x)));

Receipt singleReceiptFromJson(String str) => Receipt.fromJson(json.decode(str));

String receiptToJson(List<Receipt> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

List<Receipt> parseReceipts(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Receipt>((json) => Receipt.fromJson(json)).toList();
}

class Receipt {
  Receipt({
    required this.shippingPrice,
    required this.totalPrice,
    required this.status,
    required this.id,
    required this.receiptItems,
    required this.user,
    required this.supplier,
    required this.orderAt,
    required this.receiveAt,
  });

  int shippingPrice;
  double totalPrice;
  String status;
  String id;
  List<ReceiptItem> receiptItems;
  UserReceipt user;
  SupplierReceipt supplier;
  DateTime orderAt;
  DateTime? receiveAt;

  factory Receipt.fromJson(Map<String, dynamic> json) => Receipt(
        shippingPrice: json["shippingPrice"],
        totalPrice: json["totalPrice"].toDouble(),
        status: json["status"],
        id: json["_id"],
        receiptItems: List<ReceiptItem>.from(
            json["receiptItems"].map((x) => ReceiptItem.fromJson(x))),
        user: UserReceipt.fromJson(json["user"]),
        supplier: SupplierReceipt.fromJson(json["supplier"]),
        orderAt: DateTime.parse(json["orderAt"]),
        receiveAt: json["receiveAt"] == null
            ? null
            : DateTime.parse(json["receiveAt"]),
      );

  Map<String, dynamic> toJson() => {
        "shippingPrice": shippingPrice,
        "totalPrice": totalPrice,
        "status": status,
        "_id": id,
        "receiptItems": List<dynamic>.from(receiptItems.map((x) => x.toJson())),
        "user": user.toJson(),
        "supplier": supplier.toJson(),
        "orderAt": orderAt.toIso8601String(),
        "receiveAt": receiveAt == null ? null : receiveAt!.toIso8601String(),
      };
}

class ReceiptItem {
  ReceiptItem({
    required this.id,
    required this.qty,
    required this.price,
    required this.product,
  });

  String id;
  int qty;
  double price;
  Product product;

  factory ReceiptItem.fromJson(Map<String, dynamic> json) => ReceiptItem(
        id: json["_id"],
        qty: json["qty"],
        price: json["price"].toDouble(),
        product: Product.fromJson(json["product"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "qty": qty,
        "price": price,
        "product": product.toJson(),
      };
}

class Product {
  Product({
    required this.id,
    required this.name,
    required this.images,
  });

  String id;
  String name;
  List<ImageReceipt> images;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["_id"],
        name: json["name"],
        images: List<ImageReceipt>.from(
            json["images"].map((x) => ImageReceipt.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "images": List<dynamic>.from(images.map((x) => x.toJson())),
      };
}

class ImageReceipt {
  ImageReceipt({
    required this.id,
    required this.publicId,
    required this.url,
  });

  String id;
  String publicId;
  String url;

  factory ImageReceipt.fromJson(Map<String, dynamic> json) => ImageReceipt(
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

List<SupplierReceipt> parseSupplierReceipts(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed
      .map<SupplierReceipt>((json) => SupplierReceipt.fromJson(json))
      .toList();
}

class SupplierReceipt {
  SupplierReceipt({
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

  factory SupplierReceipt.fromJson(Map<String, dynamic> json) =>
      SupplierReceipt(
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

class UserReceipt {
  UserReceipt({
    required this.id,
    required this.name,
    required this.email,
  });

  String id;
  String name;
  String email;

  factory UserReceipt.fromJson(Map<String, dynamic> json) => UserReceipt(
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
