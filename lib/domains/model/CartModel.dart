import 'package:cloud_firestore/cloud_firestore.dart';

class CartModel {
  String cart_id;
  String user_id;
  List<CartItem> cart_items;

  CartModel({
    required this.cart_id,
    required this.user_id,
    required this.cart_items,
  });

  factory CartModel.fromMap(Map<String, dynamic> map) {
    return CartModel(
      cart_id: map['cart_id'],
      user_id: map['user_id'],
      cart_items: List<CartItem>.from(
        (map['cart_items'] as List).map((item) => CartItem.fromMap(item)),
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'cart_id': cart_id,
      'user_id': user_id,
      'cart_items': cart_items.map((item) => item.toMap()).toList(),
    };
  }
}

class CartItem {
  String pro_id;
  String imageUrl;
  String name;
  double price;
  int stock;
  double discountprice;
  DateTime addedAt;

  CartItem({
    required this.pro_id,
    required this.imageUrl,
    required this.name,
    required this.price,
    required this.stock,
    required this.discountprice,
    required this.addedAt,
  });

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      pro_id: map['pro_id'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      name: map['name'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      stock: map['stock'] ?? 0,
      discountprice: (map['discountprice'] ?? 0).toDouble(),
      addedAt: map['date'] != null
          ? (map['date'] as Timestamp).toDate()
          : DateTime.now(), // fallback nếu không có
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'pro_id':pro_id,
      'imageUrl': imageUrl,
      'name': name,
      'price': price,
      'stock':stock,
      'discountprice': discountprice,
      'addedAt': Timestamp.fromDate(addedAt),
    };
  }
}
