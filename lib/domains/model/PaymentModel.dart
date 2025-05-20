class PaymentModel {
  String paymentId;
  String orderId;
  String userId;
  String paymentMethod;
  String paymentStatus;
  String? transactionId;
  double totalamount;
  DateTime createdAt;

  PaymentModel({
    required this.paymentId,
    required this.orderId,
    required this.userId,
    required this.paymentMethod,
    required this.paymentStatus,
    this.transactionId,
    required this.totalamount,
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
      "totalamount":totalamount,
      "created_at": createdAt.toIso8601String(),
    };
  }

  factory PaymentModel.fromMap(Map<String, dynamic> map) {
    return PaymentModel(
      paymentId: map["payment_id"],
      orderId: map["order_id"],
      userId: map["user_id"],
      paymentMethod: map["payment_method"],
      paymentStatus: map["payment_status"],
      transactionId: map["transaction_id"],
      totalamount: map["total_amount"],
      createdAt: DateTime.parse(map["created_at"]),
    );
  }
}
