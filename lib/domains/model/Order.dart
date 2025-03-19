class Order {
  String orderId;
  String userId;
  double totalAmount;
  String status;
  DateTime createdAt;

  Order({
    required this.orderId,
    required this.userId,
    required this.totalAmount,
    required this.status,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      "order_id": orderId,
      "user_id": userId,
      "total_amount": totalAmount,
      "status": status,
      "created_at": createdAt.toIso8601String(),
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      orderId: map["order_id"],
      userId: map["user_id"],
      totalAmount: map["total_amount"],
      status: map["status"],
      createdAt: DateTime.parse(map["created_at"]),
    );
  }
}
