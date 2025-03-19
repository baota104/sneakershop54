import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sneaker_shop/domains/model/ProductModel.dart';

class Productfirebase {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<ProductModel>> fetchListProducts() async {
    try {
      // Lấy dữ liệu từ Firestore
      QuerySnapshot snapshot = await _firestore.collection("Products").get();

      // Chuyển đổi dữ liệu Firestore thành danh sách ProductModel
      List<ProductModel> products = snapshot.docs.map((doc) {
        return ProductModel.fromMap({
          "product_id": doc.id, // Lấy ID của document
          ...doc.data() as Map<String, dynamic>, // Lấy dữ liệu còn lại
        });
      }).toList();

      return products;
    } catch (e, stacktrace) {
      print("❌ Lỗi khi lấy danh sách sản phẩm: $e");
      print("📌 Stacktrace: $stacktrace");
      throw Exception("Không thể lấy danh sách sản phẩm");
    }
  }
}
