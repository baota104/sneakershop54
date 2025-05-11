import 'package:equatable/equatable.dart';
import 'package:sneaker_shop/domains/model/OrderModel.dart';

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
class CreateOrder extends CartEventBase {
  final OrderModel orderModel;

  const CreateOrder({required this.orderModel});

  @override
  List<Object?> get props => [orderModel];
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
