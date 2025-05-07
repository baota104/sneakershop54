import 'package:equatable/equatable.dart';

abstract class CartEventBase extends Equatable {
  const CartEventBase();

  @override
  List<Object?> get props => [];
}

// Fetch giỏ hàng từ Firebase
class FetchCart extends CartEventBase {
  const FetchCart();
}

// Xóa một item khỏi giỏ hàng
class DeleteItemCart extends CartEventBase {
  final String productId;

  const DeleteItemCart({required this.productId});

  @override
  List<Object?> get props => [productId];
}

// Xác nhận thanh toán giỏ hàng
class Confirm extends CartEventBase {
  final String orderId;

  const Confirm({required this.orderId});

  @override
  List<Object?> get props => [orderId];
}

// Thêm sản phẩm vào giỏ hàng
class AddItemtoCart extends CartEventBase {
  final String productId;

  const AddItemtoCart({required this.productId});

  @override
  List<Object?> get props => [productId];
}
class ResetCartStatus extends CartEventBase{
  @override
  List<Object?> get props => [];
}
