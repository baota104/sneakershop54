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
  Future<bool> updateUserData(String name,String address,String phone) async {
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
      });
      return true;
    } catch (e) {
      print("Lỗi cập nhật dữ liệu: $e");
      return false;
    }
  }

}