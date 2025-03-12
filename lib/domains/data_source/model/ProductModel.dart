class Product {
  String productId;
  String name;
  String brand;
  double price;
  double? discountPrice;
  int stock;
  String description;
  String imageUrl;
  bool isLoved;
  List<String> sizes;
  DateTime createdAt;

  Product({
    required this.productId,
    required this.name,
    required this.brand,
    required this.price,
    this.discountPrice,
    required this.stock,
    required this.description,
    required this.imageUrl,
    required this.isLoved,
    required this.sizes,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      "product_id": productId,
      "name": name,
      "brand": brand,
      "price": price,
      "discount_price": discountPrice,
      "stock": stock,
      "description": description,
      "image_url": imageUrl,
      "is_loved": isLoved,
      "sizes": sizes,
      "created_at": createdAt.toIso8601String(),
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      productId: map["product_id"],
      name: map["name"],
      brand: map["brand"],
      price: map["price"],
      discountPrice: map["discount_price"],
      stock: map["stock"],
      description: map["description"],
      imageUrl: map["image_url"],
      isLoved: map["is_loved"],
      sizes: List<String>.from(map["sizes"]),
      createdAt: DateTime.parse(map["created_at"]),
    );
  }
}
