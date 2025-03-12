class CartItem {
  String cartId;
  String userId;
  String productId;
  int quantity;
  DateTime addedAt;

  CartItem({
    required this.cartId,
    required this.userId,
    required this.productId,
    required this.quantity,
    required this.addedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      "cart_id": cartId,
      "user_id": userId,
      "product_id": productId,
      "quantity": quantity,
      "added_at": addedAt.toIso8601String(),
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      cartId: map["cart_id"],
      userId: map["user_id"],
      productId: map["product_id"],
      quantity: map["quantity"],
      addedAt: DateTime.parse(map["added_at"]),
    );
  }
}
