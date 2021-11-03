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
    required this.brand,
    required this.category,
    required this.rating,
    required this.numReviews,
    required this.price,
    required this.countInStock,
    required this.sold,
    required this.id,
    required this.name,
    required this.description,
    required this.images,
    required this.reviews,
  });

  Brand brand;
  Category category;
  double rating;
  int numReviews;
  double price;
  int countInStock;
  int sold;
  String id;
  String name;
  String description;
  List<ProductImage> images;
  List<Review> reviews;

  factory Product.fromJson(Map<String, dynamic> json) {
    final reviewsData = json['reviews'] as List<dynamic>?;
    final reviews = reviewsData != null
        ? reviewsData.map((reviewData) => Review.fromJson(reviewData)).toList()
        : <Review>[];

    final imagesData = json['images'] as List<dynamic>?;
    final images = imagesData != null
        ? imagesData
            .map((imageData) => ProductImage.fromJson(imageData))
            .toList()
        : <ProductImage>[];

    return Product(
      brand: Brand.fromJson(json["brand"]),
      category: Category.fromJson(json["category"]),
      rating: json["rating"].toDouble(),
      numReviews: json["numReviews"],
      price: json["price"].toDouble(),
      countInStock: json["countInStock"],
      sold: json["sold"],
      id: json["_id"],
      name: json["name"],
      description: json["description"],
      images: images,
      reviews: reviews,
    );
  }
}

class Brand {
  Brand({
    required this.name,
    required this.brand,
  });

  String name;
  String brand;

  factory Brand.fromJson(Map<String, dynamic> json) => Brand(
        name: json["name"],
        brand: json["brand"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "brand": brand,
      };
}

class Category {
  Category({
    required this.name,
    required this.category,
  });

  String name;
  String category;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        name: json["name"],
        category: json["category"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "category": category,
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
    required this.name,
    required this.rating,
    required this.comment,
    required this.user,
    required this.createdAt,
  });

  String id;
  String name;
  int rating;
  String comment;
  String user;
  DateTime createdAt;

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        id: json["_id"],
        name: json["name"],
        rating: json["rating"],
        comment: json["comment"],
        user: json["user"],
        createdAt: DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "rating": rating,
        "comment": comment,
        "user": user,
        "createdAt": createdAt.toIso8601String(),
      };
}
