import 'package:equatable/equatable.dart';
import 'package:sneaker_shop/domains/model/ProductModel.dart';

abstract class HomeStateBase extends Equatable{}


class HomeStateInit extends HomeStateBase{

  @override
  List<Object?> get props => [];

}
class HomeStateLoading extends HomeStateBase{

  @override
  List<Object?> get props => [];

}

class FetchListProductSuccess extends HomeStateBase{

  late List<ProductModel> listProduct;

  FetchListProductSuccess({required this.listProduct});

  @override
  List<Object?> get props => [listProduct];

}

class FetchListProductError extends HomeStateBase{

  late String message;

  FetchListProductError(String message){
    this.message = message;
  }

  @override
  List<Object?> get props => [message];

}

