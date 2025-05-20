import 'package:sneaker_shop/domains/data_source/remote/firebase/cart_firebase.dart';
import 'package:sneaker_shop/domains/model/CartModel.dart';
import 'package:sneaker_shop/domains/model/OrderModel.dart';
import 'package:sneaker_shop/domains/model/PaymentModel.dart';
import 'package:sneaker_shop/domains/model/ProductModel.dart';

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
  Future<int> createOrder(OrderModel order) async {
    // return _cartFirebase.confirm(orderId);
    return _cartFirebase.createOrder(order);
  }
  Future<bool> createpayment(PaymentModel payment){
    return _cartFirebase.createPayment(payment);
  }
  Future<bool> addtofavorite(ProductModel product){
    return _cartFirebase.addToFavorite(product);

  }
}
