import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../model/CartModel.dart';

class CartFirebase {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<CartModel?> fetchCart() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('uid');

      QuerySnapshot snapshot = await _firestore
          .collection("Carts")
          .where("user_id", isEqualTo: userId)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final doc = snapshot.docs.first;
        final cartId = doc.id;
        final data = doc.data() as Map<String, dynamic>;

        QuerySnapshot cartItemsSnapshot = await _firestore
            .collection("Carts")
            .doc(cartId)
            .collection("cart_items")
            .get();

        List<CartItem> cartItems = cartItemsSnapshot.docs.map((itemDoc) {
          return CartItem.fromMap(itemDoc.data() as Map<String, dynamic>);
        }).toList();

        return CartModel(
          cart_id: cartId,
          user_id: data['user_id'],
          cart_items: cartItems,
        );
      }
      return null;
    } catch (e) {
      print(" Lỗi fetchCart: $e");
      return null;
    }
  }

  Future<bool> AddItemToCart(String proId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userId = prefs.getString('uid');
    if (userId == null) false;

    // 1. Lấy thông tin sản phẩm từ "Products"
    final productSnapshot = await _firestore.collection("Products").doc(proId).get();

    if (!productSnapshot.exists) {
      print("Sản phẩm không tồn tại");
      return false;
    }

    final productData = productSnapshot.data()!;
    final cartItem = CartItem(
      pro_id: proId,
      imageUrl: productData['imageUrl'] ?? '',
      name: productData['name'] ?? '',
      price: (productData['price'] ?? 0).toDouble(),
      discountprice: (productData['discountprice'] ?? 0).toDouble(),
      addedAt: DateTime.now(),
    );

    // 2. Kiểm tra người dùng đã có giỏ hàng chưa
    QuerySnapshot snapshot = await _firestore
        .collection("Carts")
        .where("user_id", isEqualTo: userId)
        .limit(1)
        .get();

    String cartId;

    if (snapshot.docs.isEmpty) {
      // Tạo mới giỏ hàng nếu chưa có
      DocumentReference newCart = await _firestore.collection("Carts").add({
        'user_id': userId,
        'created_at': DateTime.now(),
      });
      cartId = newCart.id;
    } else {
      cartId = snapshot.docs.first.id;
    }

    // 3. Thêm item vào subcollection "cart_items"
    await _firestore
        .collection("Carts")
        .doc(cartId)
        .collection("cart_items")
        .add(cartItem.toMap());

    return true;
  }


  Future<bool> deleteItemCart(String proId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? uid = prefs.getString('uid');
    if (uid == null) return false;
    QuerySnapshot cartSnapshot = await _firestore
        .collection("Carts")
        .where("user_id", isEqualTo: uid)
        .limit(1)
        .get();

    if (cartSnapshot.docs.isNotEmpty) {
      String cartId = cartSnapshot.docs.first.id;

      QuerySnapshot itemSnapshot = await _firestore
          .collection("Carts")
          .doc(cartId)
          .collection("cart_items")
          .where("pro_id", isEqualTo: proId)
          .limit(1)
          .get();

      if (itemSnapshot.docs.isNotEmpty) {
        await itemSnapshot.docs.first.reference.delete();
      }return true;
    }return false;

  }

  Future<void> confirm(String orderId) async {
    // Xử lý tạo đơn hàng, xoá giỏ
    print("Xác nhận thanh toán cho orderId: $orderId");
  }
}
