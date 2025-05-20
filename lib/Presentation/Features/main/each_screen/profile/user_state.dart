import 'package:equatable/equatable.dart';
import 'package:sneaker_shop/domains/model/OrderModel.dart';
import 'package:sneaker_shop/domains/model/UserModel.dart';

abstract class UserStateBase extends Equatable{}


class UserStateInit extends UserStateBase{

  @override
  List<Object?> get props => [];

}
class UserStateLoading extends UserStateBase{

  @override
  List<Object?> get props => [];

}

class GetUserSuccess extends UserStateBase{

  late UserModel userModel;

  GetUserSuccess(this.userModel);

  @override
  List<Object?> get props => [userModel];

}

class GetUserError extends UserStateBase{

  late String message;

  GetUserError(String message){
    this.message = message;
  }

  @override
  List<Object?> get props => [message];
}
class UpdateUserSuccess extends UserStateBase{
  UpdateUserSuccess();

  @override
  // TODO: implement props
  List<Object?> get props => [];

}
class UpdateUserError extends UserStateBase{

  late String message;

  UpdateUserError(String message){
    this.message = message;
  }

  @override
  List<Object?> get props => [message];
}
