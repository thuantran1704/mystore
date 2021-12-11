import 'dart:convert';

class ListProduct {
  ListProduct({
    required this.products,
    this.page,
    this.pages,
    this.count,
  });

  List<Product> products;
  int? page;
  int? pages;
  int? count;

  factory ListProduct.fromJson(Map<String, dynamic> json) => ListProduct(
        products: List<Product>.from(
            json["products"].map((x) => Product.fromJson(x))),
        page: json["page"],
        pages: json["pages"],
        count: json["count"],
      );

// Map<String, dynamic> toJson() => {
//   "products": List<dynamic>.from(products.map((x) => x.toJson())),
//   "page": page,
//   "pages": pages,
//   "count": count,
// };
}

List<Product> parseProducts(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Product>((json) => Product.fromJson(json)).toList();
}

class Product {
  Product({
    required this.rating,
    required this.numReviews,
    required this.price,
    required this.countInStock,
    required this.sold,
    required this.id,
    required this.name,
    required this.description,
    required this.images,
    required this.category,
    required this.brand,
    required this.reviews,
    required this.createdAt,
  });

  int rating;
  int numReviews;
  double price;
  int countInStock;
  int sold;
  String id;
  String name;
  String description;
  List<ProductImage> images;
  Brand category;
  Brand brand;
  List<Review> reviews;
  DateTime createdAt;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        rating: json["rating"],
        numReviews: json["numReviews"],
        price: json["price"].toDouble(),
        countInStock: json["countInStock"],
        sold: json["sold"],
        id: json["_id"],
        name: json["name"],
        description: json["description"],
        images: List<ProductImage>.from(
            json["images"].map((x) => ProductImage.fromJson(x))),
        category: Brand.fromJson(json["category"]),
        brand: Brand.fromJson(json["brand"]),
        reviews:
            List<Review>.from(json["reviews"].map((x) => Review.fromJson(x))),
        createdAt: DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toJson() => {
        "rating": rating,
        "numReviews": numReviews,
        "price": price,
        "countInStock": countInStock,
        "sold": sold,
        "_id": id,
        "name": name,
        "description": description,
        "images": List<dynamic>.from(images.map((x) => x.toJson())),
        "category": category.toJson(),
        "brand": brand.toJson(),
        "reviews": List<dynamic>.from(reviews.map((x) => x.toJson())),
        "createdAt": createdAt.toIso8601String(),
      };
}

class Brand {
  Brand({
    required this.id,
    required this.name,
  });

  String id;
  String name;

  factory Brand.fromJson(Map<String, dynamic> json) => Brand(
        id: json["_id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
      };
}

class ProductImage {
  ProductImage({
    required this.id,
    required this.publicId,
    required this.url,
  });

  String id;
  String publicId;
  String url;

  factory ProductImage.fromJson(Map<String, dynamic> json) => ProductImage(
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

class Review {
  Review({
    required this.id,
    required this.rating,
    required this.comment,
    required this.user,
    required this.createdAt,
  });

  String id;
  int rating;
  String comment;
  Brand user;
  DateTime createdAt;

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        id: json["_id"],
        rating: json["rating"],
        comment: json["comment"],
        user: Brand.fromJson(json["user"]),
        createdAt: DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "rating": rating,
        "comment": comment,
        "user": user.toJson(),
        "createdAt": createdAt.toIso8601String(),
      };
}
