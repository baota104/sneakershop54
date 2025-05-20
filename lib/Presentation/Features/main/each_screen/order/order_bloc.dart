import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sneaker_shop/domains/model/OrderModel.dart';
import 'package:sneaker_shop/domains/repository/order_repository.dart';

import 'order_event.dart';
import 'orderstate.dart';

class OrderBloc extends Bloc<OrderEventBase,OrderStateBase>{
  late OrderRepository _repository;

  OrderBloc(OrderRepository repository) : super(OrderStateInit()){
    _repository = repository;

    on<FetchListOrders>((event, emit) async{
      try {
        emit(OrderStateLoading());
        List<OrderModel> list = await _repository.fetchListOrders();
        if (list.isNotEmpty ) {
          emit(FetchListOrderSuccess(listOrder: list));
        } else {
          emit(FetchListOrderError("Lỗi Firestore:)"));// Trạng thái không có dữ liệu
        }
      } catch (e) {
        if (e is FirebaseException) {
          emit(FetchListOrderError("Lỗi Firestore: ${e.message}"));
        } else {
          emit(FetchListOrderError("Lỗi không xác định: ${e.toString()}"));
        }
      }

    });
    on<UpdateOrderstatus>((event, emit) async {
        try{
          emit(OrderStateLoading());
          var check = await  _repository.updateorderstatus(event.ordid, event.status);
          String ss = event.status;
          if(check){
            emit(UpdateorderSuccess());
            if(event.status == "cancelled") {
            _repository.updateStockWhenCancelled(event.ordid);
          }
        }
          else{
            emit(UpdateorderError("error when $ss the order )"));
          }
        }
        catch(e){
          emit(UpdateorderError("system error )"));
        }

    });

  }

}