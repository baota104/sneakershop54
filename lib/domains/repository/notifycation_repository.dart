import 'package:sneaker_shop/domains/data_source/remote/firebase/notifycation_firebase.dart';
import 'package:sneaker_shop/domains/model/NotificationModel.dart';

class NotificationRepository{
  final NotificationFirebase _notificationfirebase;

  NotificationRepository(this._notificationfirebase);

  Future <List<NotificationModel>> fetchListNotification () async{
    return _notificationfirebase.fetchListNotification();
  }
  Future<bool> deleteNotification (String notificationId)async{
    return _notificationfirebase.deleteNotification(notificationId);
  }

}