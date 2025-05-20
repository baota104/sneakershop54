import 'package:equatable/equatable.dart';

abstract class UserEventBase extends Equatable{}


class GetUser extends UserEventBase{
  GetUser();
  @override
  List<Object?> get props => [];


}
class UpdateUserInformation extends UserEventBase{
  String name ;
  String location;
  String phone;
  String imageUrl;

  UpdateUserInformation(this.name, this.location, this.phone, this.imageUrl);

  @override
  // TODO: implement props
  List<Object?> get props => [name,location,phone,imageUrl];

}