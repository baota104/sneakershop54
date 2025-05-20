import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../model/FavoriteModel.dart';

class FavoriteFirebase{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<FavoriteModel>> fetchFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString('uid');
    try {
      final snapshot = await _firestore
          .collection('Favorites')
          .doc(uid)
          .collection('items')
          .get();

      List<FavoriteModel> favoriteItems = snapshot.docs.map((doc) {
        final data = doc.data();
        return FavoriteModel.fromMap(data);
      }).toList();

      return favoriteItems;
    } catch (e) {
      print('Lỗi khi fetch favorites: $e');
      return [];
    }
  }
  Future<bool> removeFromFavorite(String productId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final uid = prefs.getString('uid');

      if (uid == null) throw Exception("UID không tồn tại trong SharedPreferences");

      // Tham chiếu tới document cần xóa
      final itemRef = _firestore
          .collection("Favorites")
          .doc(uid)
          .collection("items")
          .doc(productId);

      final snapshot = await itemRef.get();

      if (!snapshot.exists) {
        print("Sản phẩm không tồn tại trong favorites.");
        return false;
      }

      // Xóa document
      await itemRef.delete();
      print("Đã xóa sản phẩm khỏi favorites.");
      return true;
    } catch (e) {
      print("Lỗi khi xóa khỏi favorites: $e");
      return false;
    }
  }

}