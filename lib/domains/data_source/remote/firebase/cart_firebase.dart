import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sneaker_shop/domains/model/OrderModel.dart';

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

        List<CartItem> cartItems = [];

        for (var itemDoc in cartItemsSnapshot.docs) {
          Map<String, dynamic> itemData = itemDoc.data() as Map<String,
              dynamic>;
          String productId = itemData['pro_id'];

          // Lấy thông tin sản phẩm mới nhất từ "Products"
          DocumentSnapshot productSnap =
          await _firestore.collection("Products").doc(productId).get();

          if (productSnap.exists) {
            Map<String, dynamic> productData =
            productSnap.data() as Map<String, dynamic>;

            cartItems.add(CartItem(
              pro_id: productId,
              imageUrl: productData['imageUrl'],
              name: productData['name'],
              price: productData['price']?.toDouble() ?? 0,
              stock: productData['stock'] ?? 0,
              discountprice: productData['discountprice']?.toDouble() ?? 0,
              addedAt: productData['date'] != null
                  ? (productData['date'] as Timestamp).toDate()
                  : DateTime.now(),
            ));
          }
        }
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
    if (userId == null) return false;

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
      stock: productData['stock']??0,
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

    // 3. Kiểm tra xem sản phẩm đã có trong giỏ hàng chưa
    final existingItemSnapshot = await _firestore
        .collection("Carts")
        .doc(cartId)
        .collection("cart_items")
        .where("pro_id", isEqualTo: proId)
        .limit(1)
        .get();

    if (existingItemSnapshot.docs.isNotEmpty) {
      print("Sản phẩm đã có trong giỏ hàng");
      return false;
    }

    // 4. Thêm item vào subcollection "cart_items"
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
        return true;
      }
    }
    return false;

  }
  Future<int> createOrder(OrderModel order) async {
    WriteBatch batch = _firestore.batch();

    try {
      // 1. Kiểm tra tồn kho tất cả sản phẩm
      for (var detail in order.orderDetails) {
        DocumentReference productRef = _firestore.collection("Products").doc(detail.productId);
        DocumentSnapshot productSnap = await productRef.get();

        if (!productSnap.exists) {
          throw Exception("Sản phẩm không tồn tại: ${detail.productId}");
        }

        final stock = productSnap['stock'];
        if (stock != 1) {
          print("Sản phẩm ${detail.productId} đã hết hàng");
          return 0; // Trả về 0 để báo sản phẩm hết hàng
        }

        // Đánh dấu cập nhật stock = 0
        batch.update(productRef, {'stock': 0});
      }

      // 2. Tạo đơn hàng
      DocumentReference orderRef = _firestore.collection("Orders").doc();
      batch.set(orderRef, {
        'user_id': order.userId,
        'status': order.status,
        'total_amout': order.totalAmount,
        'time': Timestamp.fromDate(order.time),
        'address': order.address,
      });

      // 3. Tạo chi tiết đơn hàng (subcollection "order_details")
      for (var detail in order.orderDetails) {
        DocumentReference detailRef = orderRef.collection("order_details").doc();
        batch.set(detailRef, detail.toMap());
      }

      // 4. Commit batch
      await batch.commit();

      print("Đơn hàng đã được tạo thành công!");
      return 1; // Thành công
    } catch (e, stacktrace) {
      print("Lỗi khi tạo đơn hàng: $e");
      print("Stacktrace: $stacktrace");
      return 2; // Lỗi khác
    }
  }



  Future<void> confirm(String orderId) async {
    // Xử lý tạo đơn hàng, xoá giỏ
    print("Xác nhận thanh toán cho orderId: $orderId");
  }
}
