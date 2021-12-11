import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
    required this.cart,
    required this.voucher,
    required this.isDisable,
    required this.role,
    required this.userAddress,
    required this.token,
  });

  String id;
  String name;
  String email;
  String password;
  String phone;
  List<Cart> cart;
  List<Voucher> voucher;
  bool isDisable;
  Role role;
  UserAddress userAddress;
  String token;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["_id"],
        name: json["name"],
        email: json["email"],
        password: json["password"],
        phone: json["phone"],
        cart: List<Cart>.from(json["cart"].map((x) => Cart.fromJson(x))),
        voucher:
            List<Voucher>.from(json["voucher"].map((x) => Voucher.fromJson(x))),
        isDisable: json["isDisable"],
        role: Role.fromJson(json["role"]),
        userAddress: UserAddress.fromJson(json["userAddress"]),
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "email": email,
        "password": password,
        "phone": phone,
        "cart": List<dynamic>.from(cart.map((x) => x.toJson())),
        "voucher": List<dynamic>.from(voucher.map((x) => x.toJson())),
        "isDisable": isDisable,
        "role": role.toJson(),
        "userAddress": userAddress.toJson(),
        "token": token,
      };
}

List<Cart> parseCart(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Cart>((json) => Cart.fromJson(json)).toList();
}

class Cart {
  Cart({
    required this.id,
    required this.qty,
    required this.importPrice,
    required this.product,
  });

  String id;
  int qty;
  double importPrice;
  ProductObj product;

  factory Cart.fromJson(Map<String, dynamic> json) => Cart(
        id: json["_id"],
        qty: json["qty"],
        importPrice: json["importPrice"].toDouble(),
        product: ProductObj.fromJson(json["product"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "qty": qty,
        "importPrice": importPrice,
        "product": product.toJson(),
      };
}

class ProductObj {
  ProductObj({
    required this.price,
    required this.id,
    required this.name,
    required this.images,
  });

  double price;
  String id;
  String name;
  List<ImageObj> images;

  factory ProductObj.fromJson(Map<String, dynamic> json) => ProductObj(
        price: json["price"].toDouble(),
        id: json["_id"],
        name: json["name"],
        images: List<ImageObj>.from(
            json["images"].map((x) => ImageObj.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "price": price,
        "_id": id,
        "name": name,
        "images": List<dynamic>.from(images.map((x) => x.toJson())),
      };
}

class ImageObj {
  ImageObj({
    required this.id,
    required this.publicId,
    required this.url,
  });

  String id;
  String publicId;
  String url;

  factory ImageObj.fromJson(Map<String, dynamic> json) => ImageObj(
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

class Role {
  Role({
    required this.id,
    required this.name,
  });

  String id;
  String name;

  factory Role.fromJson(Map<String, dynamic> json) => Role(
        id: json["_id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
      };
}

class UserAddress {
  UserAddress({
    required this.address,
    required this.city,
    required this.postalCode,
    required this.country,
  });

  String address;
  String city;
  String postalCode;
  String country;

  factory UserAddress.fromJson(Map<String, dynamic> json) => UserAddress(
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

List<Voucher> parseVoucher(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Voucher>((json) => Voucher.fromJson(json)).toList();
}

class Voucher {
  Voucher({
    required this.id,
    required this.name,
    required this.discount,
  });

  String id;
  String name;
  String discount;

  factory Voucher.fromJson(Map<String, dynamic> json) => Voucher(
        id: json["_id"],
        name: json["name"],
        discount: json["discount"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "discount": discount,
      };
}

List<ManagerUser> managerUserFromJson(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<ManagerUser>((json) => ManagerUser.fromJson(json)).toList();
}

class ManagerUser {
  ManagerUser({
    required this.id,
    required this.userAddress,
    required this.isDisable,
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
    required this.role,
  });

  UserAddress userAddress;
  bool isDisable;
  String id;
  String name;
  String email;
  String password;
  String phone;
  Role role;

  factory ManagerUser.fromJson(Map<String, dynamic> json) => ManagerUser(
        userAddress: UserAddress.fromJson(json["userAddress"]),
        isDisable: json["isDisable"],
        id: json["_id"],
        name: json["name"],
        email: json["email"],
        password: json["password"],
        phone: json["phone"],
        role: Role.fromJson(json["role"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "email": email,
        "password": password,
        "phone": phone,
        "userAddress": userAddress.toJson(),
        "isDisable": isDisable,
        "role": role.toJson(),
      };
}
