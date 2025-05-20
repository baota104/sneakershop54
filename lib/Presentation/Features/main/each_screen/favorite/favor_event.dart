import 'package:equatable/equatable.dart';
import 'package:sneaker_shop/domains/model/FavoriteModel.dart';

abstract class FavorEventBase extends Equatable{}


class FetchListFavor extends FavorEventBase{

  FetchListFavor();

  @override
  List<Object?> get props => [];

}
class deleteFavor extends FavorEventBase{
  String proid;
  deleteFavor(this.proid);

  @override
  // TODO: implement props
  List<Object?> get props => [proid];

}