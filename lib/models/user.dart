import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  final String id;
  final String name;
  final String email;
  final String password;
  final String phone;
  final List<Cart> cart;
  final bool isDisable;
  final Role role;
  final UserAddress userAddress;
  final String token;

  User({
    required this.id,
    required this.userAddress,
    required this.role,
    required this.isDisable,
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
    required this.cart,
    required this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["_id"],
      name: json["name"],
      email: json["email"],
      password: json["password"],
      phone: json["phone"],
      cart: List<Cart>.from(json["cart"].map((x) => Cart.fromJson(x))),
      isDisable: json["isDisable"],
      role: Role.fromJson(json["role"]),
      userAddress: UserAddress.fromJson(json["userAddress"]),
      token: json["token"],
    );
  }

  Map<String, dynamic> toJson() => {
        "userAddress": userAddress.toJson(),
        "role": role.toJson(),
        "isDisable": isDisable,
        "_id": id,
        "name": name,
        "email": email,
        "password": password,
        "phone": phone,
        "cart": List<dynamic>.from(cart.map((x) => x.toJson())),
      };
}

List<Cart> parseCart(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Cart>((json) => Cart.fromJson(json)).toList();
}

class Cart {
  Cart({
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

  factory Cart.fromJson(Map<String, dynamic> json) => Cart(
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

class Role {
  Role({
    required this.name,
    required this.role,
  });

  final String name;
  final String role;

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      name: json["name"],
      role: json["role"],
    );
  }
  Map<String, dynamic> toJson() => {
        "name": name,
        "role": role,
      };
}

class UserAddress {
  UserAddress({
    required this.address,
    required this.city,
    required this.postalCode,
    required this.country,
  });

  final String address;
  final String city;
  final String postalCode;
  final String country;

  factory UserAddress.fromJson(Map<String, dynamic> json) {
    return UserAddress(
      address: json["address"],
      city: json["city"],
      postalCode: json["postalCode"],
      country: json["country"],
    );
  }

  Map<String, dynamic> toJson() => {
        "address": address,
        "city": city,
        "postalCode": postalCode,
        "country": country,
      };
}
