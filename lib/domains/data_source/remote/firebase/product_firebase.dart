import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sneaker_shop/domains/model/ProductModel.dart';

import '../../../model/CommentModel.dart';

class Productfirebase {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<ProductModel>> fetchListProducts() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection("Products").get();
      List<ProductModel> products = snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return ProductModel.fromMap({
          "product_id": doc.id,
          ...data,
        });
      }).toList();
      return products;
    } catch (e, stacktrace) {
      print("Lỗi khi lấy danh sách sản phẩm: $e");
      print("Stacktrace: $stacktrace");
      throw Exception("Không thể lấy danh sách sản phẩm");
    }
  }




  Future<List<CommentModel>> fetchAllComments() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('shop_comments')
          .orderBy('timestamp', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => CommentModel.fromMap(doc.data()))
          .toList();
    } catch (e) {
      print('Error fetching comments: $e');
      return [];
    }
  }


}
