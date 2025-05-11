import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sneaker_shop/Presentation/Features/Cart/cart_state.dart';
import 'package:sneaker_shop/Presentation/Features/main/each_screen/notification/Notification_event.dart';
import 'package:sneaker_shop/Presentation/Features/main/each_screen/notification/Notification_state.dart';
import 'package:sneaker_shop/domains/model/NotificationModel.dart';
import 'package:sneaker_shop/domains/model/ProductModel.dart';
import 'package:sneaker_shop/domains/repository/notifycation_repository.dart';
import 'package:sneaker_shop/domains/repository/product_repository.dart';



class NotificationBloc extends Bloc<NotiEventBase,NotiStateBase>{
  late NotificationRepository _repository;

  NotificationBloc(NotificationRepository repository) : super(NotiStateInit()){
    _repository = repository;

    on<FetchListNotification>((event, emit) async{
      try {
        emit(NotiStateLoading());
        List<NotificationModel> list = await _repository.fetchListNotification();
        if (list.isNotEmpty) {
          emit(FetchListNotiSuccess(listNotification: list));
        } else {
          emit(FetchListNotiError("cant fetch notifications"));// Trạng thái không có dữ liệu
        }
      } catch (e) {
        if (e is FirebaseException) {
          emit(FetchListNotiError("Lỗi Firestore: ${e.message}"));
        } else {
          emit(FetchListNotiError("Lỗi không xác định: ${e.toString()}"));
        }
      }

    });
    on<DeleteNotification>((event,emit)async {
      try{
        var check = await _repository.deleteNotification(event.notifiId);
        if(check){
          emit(DeletenotificationSuccess());
        }
        else{
          emit(DeletenotificationError("error when delete notification"));
        }
      }
      catch(e){
        if (e is FirebaseException) {
          emit(DeletenotificationError("Lỗi Firestore: ${e.message}"));
        } else {
          emit(DeletenotificationError("Lỗi không xác định: ${e.toString()}"));
        }
      }


    });

  }

}