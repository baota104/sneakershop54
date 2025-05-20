import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sneaker_shop/domains/model/FavoriteModel.dart';

import '../../../../../domains/repository/favorite_repository.dart';
import 'favor_event.dart';
import 'favor_state.dart';

class FavorBloc extends Bloc<FavorEventBase,FavorStateBase>{
  late FavoriteRepository _repository;

  FavorBloc(FavoriteRepository repository) : super(FavorStateInit()){
    _repository = repository;

    on<FetchListFavor>((event, emit) async{
      try {
        emit(FavorStateLoading());
        List<FavoriteModel> list = await _repository.fetchFavorites();
        if (list.isNotEmpty ) {
          emit(FetchListFavorrSuccess(listFavor: list));
        } else {
          emit(FetchListlistFavorError("you dont have any favorite item"));// Trạng thái không có dữ liệu
        }
      } catch (e) {
        if (e is FirebaseException) {
          emit(FetchListlistFavorError("Lỗi Firestore: ${e.message}"));
        } else {
          emit(FetchListlistFavorError("Lỗi không xác định: ${e.toString()}"));
        }
      }

    });
    on<deleteFavor>((event, emit) async{
      try {
        emit(FavorStateLoading());
       var check = await _repository.removeFromFavorite(event.proid);
        if (check ) {
          emit(deleteFavorrSuccess());
        } else {
          emit(deleteFavorError("delete fail"));// Trạng thái không có dữ liệu
        }
      } catch (e) {
        if (e is FirebaseException) {
          emit(deleteFavorError("Lỗi Firestore: ${e.message}"));
        } else {
          emit(deleteFavorError("Lỗi không xác định: ${e.toString()}"));
        }
      }

    });
    // on<UpdateOrderstatus>((event, emit) async {
    //   try{
    //     emit(OrderStateLoading());
    //     var check = await  _repository.updateorderstatus(event.ordid, event.status);
    //     String ss = event.status;
    //     if(check){
    //       emit(UpdateorderSuccess());
    //       _repository.updateStockWhenCancelled(event.ordid);
    //     }
    //     else{
    //       emit(UpdateorderError("error when $ss the order )"));
    //     }
    //   }
    //   catch(e){
    //     emit(UpdateorderError("system error )"));
    //   }
    //
    // });

  }

}