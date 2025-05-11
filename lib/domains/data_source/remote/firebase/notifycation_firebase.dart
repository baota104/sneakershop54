
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sneaker_shop/domains/model/NotificationModel.dart';

class NotificationFirebase{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<NotificationModel>> fetchListNotification() async {
    try {
      // Lấy dữ liệu từ Firestore
      QuerySnapshot snapshot = await _firestore.collection("Notifications").get();

      // Chuyển đổi dữ liệu Firestore thành danh sách ProductModel
      List<NotificationModel> notifys = snapshot.docs.map((doc) {
        return NotificationModel.fromMap({
          "notificationId": doc.id, // Lấy ID của document
          ...doc.data() as Map<String, dynamic>, // Lấy dữ liệu còn lại
        });
      }).toList();
      return notifys;
    } catch (e, stacktrace) {
      print(" Lỗi khi lấy danh sách sản phẩm: $e");
      print(" Stacktrace: $stacktrace");
      throw Exception("Không thể lấy danh sách sản phẩm");
    }
  }
  Future<bool> deleteNotification(String notificationId) async {
    try {
      await FirebaseFirestore.instance
          .collection("Notifications")
          .doc(notificationId)
          .delete();
      print("Thông báo đã được xóa thành công.");
      return true;
    } catch (e) {
      print("Lỗi khi xóa thông báo: $e");
      return false;
    }
  }

}