
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domains/model/CartModel.dart';
import '../../../domains/repository/cart_repository.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEventBase,CartState>{

  late CartRepository _cartRepository;

  CartBloc(CartRepository repository) : super(CartState.initial()){
    _cartRepository = repository;

    // Sự kiện lấy giỏ hàng
    on<FetchCart>((event, emit) async {
      try {
        emit(CartState.cartLoading());
        final cart = await _cartRepository.fetchCart();
        emit(CartState.fetchCartSuccess(cartModel: cart));
      } catch (e) {
        emit(CartState.fetchcartError(message: e.toString()));
      }
    });

    // Sự kiện xóa item khỏi giỏ
    on<DeleteItemCart>((event, emit) async {
      try {
        emit(CartState.cartLoading());
        await _cartRepository.deleteItemFromCart(event.productId);
        emit(CartState.deleteItemSuccess());
        // Cập nhật lại giỏ hàng sau khi xóa
        final updatedCart = await _cartRepository.fetchCart();
        emit(CartState.fetchCartSuccess(cartModel: updatedCart!));
      } catch (e) {
        emit(CartState.deleteItemError(message: e.toString()));
      }
    });

    // Sự kiện xác nhận giỏ hàng


    // Sự kiện thêm item vào giỏ hàng
    on<AddItemtoCart>((event, emit) async {
      try {
        emit(CartState.cartLoading());
        bool check = await _cartRepository.AddItemToCart(event.productId);
        if (check) {
          emit(CartState.addItemSuccess());
        } else {
          emit(CartState.addItemFailure(message: 'Thêm không thành công'));
        }
      } catch (e) {
        emit(CartState.addItemFailure(message: e.toString()));
      }
    });


    on<CreateOrder>((event, emit) async {
      try {
        emit(CartState.cartLoading());
        int check = await  _cartRepository.createOrder(event.orderModel);
        if(check == 0){
          emit(CartState.productoutofstock(message: "the order contains a product is out of stock"));
        }
        else if(check == 1)
           emit(CartState.createOrderSuccess());
        else{
          emit(CartState.createOrderError(message: "system error"));
        }
      } catch (e) {
        emit(CartState.createOrderError(message: e.toString()));
      }
    });
    // cart_bloc.dart
    on<ResetCartStatus>((event, emit) {
      emit(state.copyWith(status: CartStatus.initial));
    });


  }

}

