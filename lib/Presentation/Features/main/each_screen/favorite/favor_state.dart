import 'package:equatable/equatable.dart';
import 'package:sneaker_shop/domains/model/FavoriteModel.dart';
import 'package:sneaker_shop/domains/model/OrderModel.dart';

abstract class FavorStateBase extends Equatable{}


class FavorStateInit extends FavorStateBase{

  @override
  List<Object?> get props => [];

}
class FavorStateLoading extends FavorStateBase{

  @override
  List<Object?> get props => [];

}

class FetchListFavorrSuccess extends FavorStateBase{

  late List<FavoriteModel> listFavor;

  FetchListFavorrSuccess ({required this.listFavor});

  @override
  List<Object?> get props => [listFavor];

}

class FetchListlistFavorError extends FavorStateBase{

  late String message;

  FetchListlistFavorError(String message){
    this.message = message;
  }

  @override
  List<Object?> get props => [message];
}
class deleteFavorrSuccess extends FavorStateBase{
  deleteFavorrSuccess ();

  @override
  // TODO: implement props
  List<Object?> get props => [];

}
class deleteFavorError extends FavorStateBase{

  late String message;
  deleteFavorError(String message){
    this.message = message;
  }

  @override
  List<Object?> get props => [message];
}
