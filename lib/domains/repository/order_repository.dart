
import 'package:sneaker_shop/domains/data_source/remote/firebase/order_firebase.dart';
import 'package:sneaker_shop/domains/model/OrderModel.dart';

class OrderRepository{
  final Orderfirebase _orderfirebase;
  OrderRepository(this._orderfirebase);
  Future<List<OrderModel>> fetchListOrders() async {
    return _orderfirebase.fetchListOrders();
  }
  Future<bool> updateorderstatus(String orderId,String newStatus) async{
    return _orderfirebase.updateOrderStatus(orderId, newStatus);
  }
  Future<void> updateStockWhenCancelled(String orderId){
    return _orderfirebase.updateStockWhenCancelled(orderId);
  }

}