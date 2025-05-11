class OrderDetail {
   String productId;
   String name;
   String imageUrl;
   double price;
   double discountprice;



  OrderDetail({
    required this.productId,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.discountprice
  });

  factory OrderDetail.fromMap(Map<String, dynamic> map) {
    return OrderDetail(
      productId: map['productId'] ?? '',
      name: map['name'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      discountprice: (map['price'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'name': name,
      'imageUrl': imageUrl,
      'price': price,
      'discountprice':discountprice,
    };
  }
}
