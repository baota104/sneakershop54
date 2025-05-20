import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sneaker_shop/domains/model/CommentModel.dart';
import 'package:sneaker_shop/domains/model/ProductModel.dart';
import 'package:sneaker_shop/domains/repository/product_repository.dart';

import 'Home_event.dart';
import 'Home_state.dart';

class HomeProductBloc extends Bloc<HomeEventBase,HomeStateBase>{
  late ProductRepository _repository;

  HomeProductBloc(ProductRepository repository) : super(HomeStateInit()){
    _repository = repository;

    on<FetchListProduct>((event, emit) async{
      try {
        emit(HomeStateLoading());
        List<ProductModel> list = await _repository.fetchListProducts();
        if (list.isNotEmpty) {
          emit(FetchListProductSuccess(listProduct: list));
        } else {
          emit(FetchListProductError("Lỗi Firestore:)"));// Trạng thái không có dữ liệu
        }
      } catch (e) {
        if (e is FirebaseException) {
          emit(FetchListProductError("Lỗi Firestore: ${e.message}"));
        } else {
          emit(FetchListProductError("Lỗi không xác định: ${e.toString()}"));
        }
      }

    });
    on<FetchComments>((event, emit) async{
      try {
        emit(HomeStateLoading());
        List<CommentModel> list = await _repository.fetchAllComments();
        if (list.isNotEmpty) {
          emit(FetchCommentSuccess(list));
        } else {
          emit(FetchCommentError("dont have any comment:)"));// Trạng thái không có dữ liệu
        }
      } catch (e) {
        if (e is FirebaseException) {
          emit(FetchCommentError("Lỗi Firestore: ${e.message}"));
        } else {
          emit(FetchCommentError("Lỗi không xác định: ${e.toString()}"));
        }
      }

    });

  }

}