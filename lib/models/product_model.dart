import 'dart:convert';

/// Creates a product from a JSON String
Product productFromJson(String str) => Product.fromJson(json.decode(str));

/// Creates a JSON String from a product
String productToJson(Product data) => json.encode(data.toJson());

class Product {
  Product({
    this.id,
    this.title = '',
    this.price,
    this.available = true,
    this.pictureUrl,
  });

  String? id;
  String title;
  double? price;
  bool available;
  String? pictureUrl;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        title: json["title"],
        price: json["price"].toDouble(),
        available: json["available"],
        pictureUrl: json["pictureUrl"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "price": price,
        "available": available,
        "pictureUrl": pictureUrl,
      };
}
