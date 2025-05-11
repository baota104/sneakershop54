import 'package:equatable/equatable.dart';

abstract class NotiEventBase extends Equatable{}


class FetchListNotification extends NotiEventBase{

  FetchListNotification();

  @override
  List<Object?> get props => [];

}
class DeleteNotification extends NotiEventBase{
  late String notifiId;
  DeleteNotification(this.notifiId);

  @override
  // TODO: implement props
  List<Object?> get props => [notifiId];

}
