import 'package:equatable/equatable.dart';

abstract class HomeEventBase extends Equatable{}


class FetchListProduct extends HomeEventBase{

  FetchListProduct();

  @override
  List<Object?> get props => [];

}
class FetchComments extends HomeEventBase{
  FetchComments();
  @override
  List<Object?> get props => [];

}

// class FetchTotalCart extends HomeEventBase{
//
//   FetchTotalCart();
//
//   @override
//   List<Object?> get props => [];
//
// }
//
// class AddToCart extends HomeEventBase{
//   late String productId;
//
//   AddToCart({required this.productId});
//
//   @override
//   List<Object?> get props => [productId];
//
// }