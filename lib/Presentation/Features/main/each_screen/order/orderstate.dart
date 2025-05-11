import 'package:equatable/equatable.dart';
import 'package:sneaker_shop/domains/model/OrderModel.dart';

abstract class OrderStateBase extends Equatable{}


class OrderStateInit extends OrderStateBase{

  @override
  List<Object?> get props => [];

}
class OrderStateLoading extends OrderStateBase{

  @override
  List<Object?> get props => [];

}

class FetchListOrderSuccess extends OrderStateBase{

  late List<OrderModel> listOrder;

  FetchListOrderSuccess ({required this.listOrder});

  @override
  List<Object?> get props => [listOrder];

}

class FetchListOrderError extends OrderStateBase{

  late String message;

  FetchListOrderError(String message){
    this.message = message;
  }

  @override
  List<Object?> get props => [message];
}
class UpdateorderSuccess extends OrderStateBase{
  UpdateorderSuccess();

  @override
  // TODO: implement props
  List<Object?> get props => [];

}
class UpdateorderError extends OrderStateBase{

  late String message;

  UpdateorderError(String message){
    this.message = message;
  }

  @override
  List<Object?> get props => [message];
}
