import 'package:equatable/equatable.dart';

abstract class OrderEventBase extends Equatable{}


class FetchListOrders extends OrderEventBase{

  FetchListOrders();

  @override
  List<Object?> get props => [];

}
class UpdateOrderstatus extends OrderEventBase{
  String ordid;
  String status;
  UpdateOrderstatus(this.ordid,this.status);

  @override
  // TODO: implement props
  List<Object?> get props => [ordid,status];

}