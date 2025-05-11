import 'package:equatable/equatable.dart';

import '../../../domains/model/CartModel.dart';

enum CartStatus { initial, loading, success , updateSuccess , createSuccess ,addSuccess, deleteSuccess,orderSuccess,orderError, failure }

class CartState extends Equatable {
  CartStatus? status = null;
  CartModel? cartModel = null;
  String? message = null;

  CartState._({this.status, this.cartModel, this.message});

  CartState copyWith({CartStatus? status, CartModel? cartModel, String? message}) {
    return CartState._(
      status: status ?? this.status,
      cartModel: cartModel ?? this.cartModel,
      message: message ?? this.message,
    );
  }

  CartState.initial() : this._(status : CartStatus.initial);
  CartState.cartLoading() : this._(status : CartStatus.loading);
  CartState.fetchCartSuccess({required CartModel? cartModel}) : this._(cartModel: cartModel,status : CartStatus.success);
  CartState.fetchcartError({required String? message}) : this._(message: message ,status : CartStatus.failure);
  CartState.updateCartSuccess() : this._(status : CartStatus.updateSuccess);
  CartState.updateCartError({required String? message}) : this._(message: message ,status : CartStatus.failure);
  CartState.deleteItemSuccess(): this._(status : CartStatus.deleteSuccess);
  CartState.deleteItemError({required String? message}) : this._(message: message ,status : CartStatus.failure);
  CartState.addItemSuccess(): this._(status: CartStatus.addSuccess);
  CartState.addItemFailure({required String? message}): this._(message: message ,status : CartStatus.failure);
  CartState.createOrderSuccess() : this._(status : CartStatus.orderSuccess);
  CartState.createOrderError({required String? message}) : this._(message : message,status : CartStatus.orderError);
  CartState.productoutofstock({required String? message}) : this._(message : message,status : CartStatus.orderError);

  @override
  List<Object?> get props => [status,cartModel,message];
}