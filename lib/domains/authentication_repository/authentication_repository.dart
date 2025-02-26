
import 'package:sneaker_shop/domains/data_source/firebase_auth_service.dart';

abstract class AuthenticationRepository{
  Future<void> loginWithEmailAndPassword({
    required String email,
    required String password
});

}
class AuthenticationRepositoryImpl extends AuthenticationRepository{
  final FirebaseAuthService firebaseAuthService;

  AuthenticationRepositoryImpl({
  required this.firebaseAuthService
  });

  @override
  Future<void> loginWithEmailAndPassword({
    required String email,
    required String password,

  }) async{
    try{
     await firebaseAuthService.loginWithEmailAndPassword(email: email, password: password);
     // login thanh cong thi thuc hien tiep theo o day
    }
    catch(e){
      print(e.toString());
    }
  }
}