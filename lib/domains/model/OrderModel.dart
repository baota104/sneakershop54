

import 'package:cloud_firestore/cloud_firestore.dart';

import 'OrderDetail.dart';

class OrderModel{
  String orderId;
  String userId;
  String status;
  double totalAmount;
  List<OrderDetail> orderDetails;
  DateTime time;
  String address;

  OrderModel({
    required this.orderId,
    required this.userId,
    required this.status,
    required this.totalAmount,
    required this.orderDetails,
    required this.time,
    required this.address
  });

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      orderId: map['orderId'] ?? '',
      userId: map['user_id'] ?? '',
      status: map['status'] ?? '',
      time: (map['time'] as Timestamp).toDate(),
      totalAmount: map['total_amout'] ?? 0,
      orderDetails: List<OrderDetail>.from(
      (map['order_details'] ?? []).map((item) => OrderDetail.fromMap(item)),
      ),
      address: map['address']??''
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'user_id': userId,
      'status': status,
      'time': Timestamp.fromDate(time),
      'total_amout': totalAmount,
      'order_details': orderDetails.map((item) => item.toMap()).toList(),
      'address':address
    };
  }
}