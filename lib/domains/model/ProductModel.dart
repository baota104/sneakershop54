class ProductModel {
  String productId;
  String name;
  String brand;
  double price;
  double? discountPrice;
  int stock;
  String activity;
  String description;
  String imageUrl;
  bool isloved;
  List<int> size;

  ProductModel({
    required this.productId,
    required this.name,
    required this.brand,
    required this.price,
    this.discountPrice,
    required this.stock,
    required this.activity,
    required this.description,
    required this.imageUrl,
    required this.isloved,
    required this.size,
  });

  Map<String, dynamic> toMap() {
    return {
      "product_id": productId,
      "name": name,
      "brand": brand,
      "price": price,
      "discountPrice": discountPrice,
      "stock": stock,
      "activity":activity,
      "description": description,
      "imageUrl": imageUrl,
      "isloved": isloved,
      "size": size,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      productId: map["product_id"] ?? "", // Đảm bảo không bị null
      name: map["name"] ?? "Không có tên",
      brand: map["brand"] ?? "Không rõ thương hiệu",
      price: (map["price"] as num).toDouble(), // Ép kiểu an toàn
      discountPrice: map["discountPrice"] != null ? (map["discountPrice"] as num).toDouble() : null,
      stock: map["stock"] ?? 0,
      activity: map["activity"] ?? "",
      description: map["description"] ?? "",
      imageUrl: map["imageUrl"] ?? "",
      isloved: map["isloved"] ?? false,
      size: (map["size"] as List<dynamic>).map((e) => e as int).toList(),
    );
  }

}
