import 'package:equatable/equatable.dart';
import 'package:sneaker_shop/domains/model/NotificationModel.dart';
import 'package:sneaker_shop/domains/model/ProductModel.dart';

abstract class NotiStateBase extends Equatable{}


class NotiStateInit extends NotiStateBase{

  @override
  List<Object?> get props => [];

}
class NotiStateLoading extends NotiStateBase{

  @override
  List<Object?> get props => [];

}

class FetchListNotiSuccess extends NotiStateBase{

  late List<NotificationModel> listNotification;

  FetchListNotiSuccess({required this.listNotification});

  @override
  List<Object?> get props => [listNotification];

}


class FetchListNotiError extends NotiStateBase{

  late String message;

  FetchListNotiError(String message){
    this.message = message;
  }

  @override
  List<Object?> get props => [message];

}

class DeletenotificationSuccess extends NotiStateBase{
  DeletenotificationSuccess();

  @override
  // TODO: implement props
  List<Object?> get props => [];

}
class DeletenotificationError extends NotiStateBase{
  late String message;
  DeletenotificationError(this.message);

  @override
  // TODO: implement props
  List<Object?> get props => [message];

}

