import 'package:sneaker_shop/domains/data_source/remote/firebase/user_firebase.dart';
import 'package:sneaker_shop/domains/model/UserModel.dart';

class UserRepository{
  final UserFirebase _userFirebase;

  UserRepository(this._userFirebase);
  Future<UserModel?> GetUser() async{
    return _userFirebase.getUser();
  }
  Future <bool> updateUserData(String name,String address,String phone,String imageUrl) async{
    return _userFirebase.updateUserData(name, address, phone,imageUrl);
  }


}