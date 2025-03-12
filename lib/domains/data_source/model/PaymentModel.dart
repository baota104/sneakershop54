class Payment {
  String paymentId;
  String orderId;
  String userId;
  String paymentMethod;
  String paymentStatus;
  String? transactionId;
  DateTime createdAt;

  Payment({
    required this.paymentId,
    required this.orderId,
    required this.userId,
    required this.paymentMethod,
    required this.paymentStatus,
    this.transactionId,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      "payment_id": paymentId,
      "order_id": orderId,
      "user_id": userId,
      "payment_method": paymentMethod,
      "payment_status": paymentStatus,
      "transaction_id": transactionId,
      "created_at": createdAt.toIso8601String(),
    };
  }

  factory Payment.fromMap(Map<String, dynamic> map) {
    return Payment(
      paymentId: map["payment_id"],
      orderId: map["order_id"],
      userId: map["user_id"],
      paymentMethod: map["payment_method"],
      paymentStatus: map["payment_status"],
      transactionId: map["transaction_id"],
      createdAt: DateTime.parse(map["created_at"]),
    );
  }
}
