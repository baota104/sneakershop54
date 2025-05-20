import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../model/UserModel.dart';

class UserFirebase{
  Future<UserModel?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final String? uid = prefs.getString('uid');

    if (uid == null) {
      print("UID not found in SharedPreferences.");
      return null;
    }

    try {
      final doc = await FirebaseFirestore.instance.collection('Users').doc(uid).get();

      if (doc.exists && doc.data() != null) {
        return UserModel.fromMap(doc.data()!);
      } else {
        print("User document does not exist.");
        return null;
      }
    } catch (e) {
      print("Error fetching user: $e");
      return null;
    }
  }
  Future<bool> updateUserData(String name,String address,String phone,String imageUrl) async {
    final prefs = await SharedPreferences.getInstance();
    final String? uid = prefs.getString('uid');

    if (uid == null) {
      print("UID not found in SharedPreferences.");
      return false;
    }
    try {
      await FirebaseFirestore.instance.collection("Users").doc(uid).update({
        "name": name,
        "address": address,
        "phone": phone,
        "imageUrl":imageUrl
      });
      return true;
    } catch (e) {
      print("Lỗi cập nhật dữ liệu: $e");
      return false;
    }
  }
  Future<int> addProductToFavorites(String productId) async {
    final prefs = await SharedPreferences.getInstance();
    final String? uid = prefs.getString('uid');

    if (uid == null) {
      print("UID không tìm thấy trong SharedPreferences.");
      return -1;
    }

    try {
      final docRef = FirebaseFirestore.instance.collection('Users').doc(uid);
      final doc = await docRef.get();

      if (!doc.exists) {
        print("Không tìm thấy người dùng.");
        return -1;
      }

      List<dynamic> currentFav = doc.data()?['favorite'] ?? [];

      if (!currentFav.contains(productId)) {
        currentFav.add(productId);
        await docRef.update({'favorite': currentFav});
        return 1;
        print("Đã thêm sản phẩm vào danh sách yêu thích.");
      } else {
        return 0;
        print("Sản phẩm đã tồn tại trong danh sách yêu thích.");
      }
    } catch (e) {
      return 0;
      print("Lỗi khi thêm sản phẩm vào yêu thích: $e");
    }
  }


}