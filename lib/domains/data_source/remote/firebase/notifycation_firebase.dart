
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sneaker_shop/domains/model/NotificationModel.dart';

class NotificationFirebase{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<NotificationModel>> fetchListNotification() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? uid = prefs.getString('uid');

      if (uid == null) {
        throw Exception("UID không tồn tại trong SharedPreferences");
      }

      // Lọc các thông báo có user_id bằng uid
      QuerySnapshot snapshot = await _firestore
          .collection("Notifications")
          .where("user_id", isEqualTo: uid)
          .get();

      // Chuyển đổi dữ liệu Firestore thành danh sách NotificationModel
      List<NotificationModel> notifys = snapshot.docs.map((doc) {
        return NotificationModel.fromMap({
          "notificationId": doc.id, // Lấy ID của document
          ...doc.data() as Map<String, dynamic>, // Lấy dữ liệu còn lại
        });
      }).toList();

      return notifys;
    } catch (e, stacktrace) {
      print("Lỗi khi lấy danh sách thông báo: $e");
      print("Stacktrace: $stacktrace");
      throw Exception("Không thể lấy danh sách thông báo");
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