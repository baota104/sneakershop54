
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sneaker_shop/domains/model/OrderDetail.dart';

import '../../../model/OrderModel.dart';



class Orderfirebase{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<OrderModel>> fetchListOrders() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userId = prefs.getString('uid').toString();

      QuerySnapshot snapshot = await _firestore
          .collection("Orders")
          .where("user_id", isEqualTo: userId)
          .get();

      List<OrderModel> orders = [];

      for (var doc in snapshot.docs) {
        final orderId = doc.id;
        final data = doc.data() as Map<String, dynamic>;

        // Lấy dữ liệu từ subcollection order_details
        QuerySnapshot orderDetailsSnapshot = await _firestore
            .collection("Orders")
            .doc(orderId)
            .collection("order_details")
            .get();

        List<OrderDetail> orderDetails = orderDetailsSnapshot.docs.map((itemDoc) {
          return OrderDetail.fromMap(itemDoc.data() as Map<String, dynamic>);
        }).toList();

        // Kết hợp dữ liệu để tạo Order
        final order = OrderModel(
          orderId: orderId,
          userId: data['user_id'] ?? '',
          status: data['status'] ?? '',
          paymentmethod: data['paymentmethod'] ?? '',
          totalAmount: (data['total_amout'] ?? 0).toDouble(),
          orderDetails: orderDetails,
          time: (data['time'] as Timestamp).toDate(),
          address: data['address'] ?? '',
        );

        orders.add(order);
      }

      return orders;
    } catch (e, stacktrace) {
      print("Lỗi fetchListOrders: $e");
      print("Stacktrace: $stacktrace");
      throw Exception("Không thể lấy danh sách sản phẩm");
    }
  }
  Future<void> updateStockWhenCancelled(String orderId) async {
    try {
      final orderDetailsSnapshot = await  _firestore
          .collection("Orders")
          .doc(orderId)
          .collection('order_details')
          .get();

      for (var itemDoc in orderDetailsSnapshot.docs) {
        final itemData = itemDoc.data() as Map<String, dynamic>;
        final String productId = itemData['productId'] ?? '';
        await  _firestore
            .collection("Products").doc(productId).update({'stock': 1});
      }
    } catch (error) {
      print("Lỗi cập nhật stock khi hủy đơn hàng: $error");
    }
  }

  Future<bool> updateOrderStatus(String orderId, String newStatus) async {
    try {
      await  _firestore
          .collection("Orders").doc(orderId).update({
        'status': newStatus,
        'updated_at': FieldValue.serverTimestamp(),
      });

      return true;
    } catch (error) {
      return false;
      print("Lỗi cập nhật trạng thái: $error");
      throw Exception("Lỗi cập nhật đơn hàng: $error");
    }
  }


}