import 'package:sneaker_shop/domains/data_source/remote/firebase/cart_firebase.dart';
import 'package:sneaker_shop/domains/model/CartModel.dart';

class CartRepository {
  final CartFirebase _cartFirebase;

  CartRepository(this._cartFirebase);

  // Lấy giỏ hàng theo userId
  Future<CartModel?> fetchCart() async {
    return _cartFirebase.fetchCart();
  }

  // Thêm sản phẩm vào giỏ hàng
  Future<bool> AddItemToCart(String proid) async {
    return _cartFirebase.AddItemToCart(proid);
  }

  // Xóa một item trong giỏ hàng
  Future<bool> deleteItemFromCart(String productId) async {
    return _cartFirebase.deleteItemCart(productId);
  }

  // Xác nhận thanh toán
  Future<bool> confirmOrder(String orderId) async {
    // return _cartFirebase.confirm(orderId);
    return false;
  }
}
