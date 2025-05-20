import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sneaker_shop/Presentation/Features/main/each_screen/profile/user_event.dart';
import 'package:sneaker_shop/Presentation/Features/main/each_screen/profile/user_state.dart';
import 'package:sneaker_shop/domains/model/OrderModel.dart';
import 'package:sneaker_shop/domains/model/UserModel.dart';
import 'package:sneaker_shop/domains/repository/order_repository.dart';
import 'package:sneaker_shop/domains/repository/user_repository.dart';



class UserBloc extends Bloc<UserEventBase,UserStateBase>{
  late UserRepository _repository;

  UserBloc(UserRepository repository) : super(UserStateInit()){
    _repository = repository;

    on<GetUser>((event, emit) async{
      try {
        emit(UserStateLoading());
        UserModel? user = await _repository.GetUser();
        if (user != null ) {
          emit(GetUserSuccess(user));
        } else {
          emit(GetUserError("Lỗi khong lấy được user)"));// Trạng thái không có dữ liệu
        }
      } catch (e) {
        if (e is FirebaseException) {
          emit(GetUserError("Lỗi Firestore: ${e.message}"));
        } else {
          emit(GetUserError("Lỗi không xác định: ${e.toString()}"));
        }
      }

    });
    on<UpdateUserInformation>((event, emit) async {
      try{
        emit(UserStateLoading());
        var check = await  _repository.updateUserData(event.name,event.location,event.phone,event.imageUrl);
        if(check){
          emit(UpdateUserSuccess());
        }
        else{
          emit(UpdateUserError("error when update user information "));
        }
      }
      catch(e){
        emit(UpdateUserError("system error )"));
      }

    });

  }

}