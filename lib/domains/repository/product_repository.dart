import 'package:sneaker_shop/domains/data_source/remote/firebase/product_firebase.dart';
import 'package:sneaker_shop/domains/model/ProductModel.dart';

import '../model/CommentModel.dart';

class ProductRepository {
  final Productfirebase _productFirebase;
  ProductRepository(this._productFirebase);

  Future<List<ProductModel>> fetchListProducts() {
    return _productFirebase.fetchListProducts();
  }
  Future<List<CommentModel>> fetchAllComments(){
    return _productFirebase.fetchAllComments();
  }
}
