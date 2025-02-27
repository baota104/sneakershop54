
import 'dart:async';

import 'package:sneaker_shop/Presentation/Features/utils.enum/authentication_status.dart';
import 'package:sneaker_shop/domains/authentication_repository/entities/user_entity.dart';
import 'package:sneaker_shop/domains/data_source/firebase_auth_service.dart';

abstract class AuthenticationRepository{
  //muon cac class khac truy cap
  Stream<AuthenticationStatus> get status;
  Stream<UserEntity> get user;
  // thi lam nhu sau

  Future<void> loginWithEmailAndPassword({
    required String email,
    required String password
});
  Future<void> registerWithEmailAndPassword({
    required String email,
    required String password
  });


}
class AuthenticationRepositoryImpl extends AuthenticationRepository{
  final FirebaseAuthService firebaseAuthService;

  final _statuscontroller = StreamController<AuthenticationStatus>();// de xac dinh da login hay chuaw
  final _usercontroller = StreamController<UserEntity>();
  AuthenticationRepositoryImpl({
  required this.firebaseAuthService
  }){
    firebaseAuthService.user.listen((firebaseuser){
      final isLoggeedIn = firebaseuser != null;
      // bien doi tu firebaseuser thanh UserEntity
      final user = isLoggeedIn ? firebaseuser.toUserEntity : UserEntity.empty;

      _usercontroller.sink.add(user);
      if(isLoggeedIn){
        _statuscontroller.sink.add(AuthenticationStatus.authenticated);
      }
      else {
        _statuscontroller.sink.add(AuthenticationStatus.unauthenticated);
      }
    });
  }

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

  @override
  Stream<AuthenticationStatus> get status async* { // Sửa kiểu trả về thành Stream<AuthenticationStatus>
    yield AuthenticationStatus.unauthenticated; //
    yield* _statuscontroller.stream;
  }

  @override
  Stream<UserEntity> get user async* { // Sửa kiểu trả về thành Stream<UserEntity>
    yield* _usercontroller.stream;
  }

  Future<void> registerWithEmailAndPassword({
    required String email,
    required String password
})async{
    try{
      await firebaseAuthService.registerWithEmailAndPassword(email: email, password: password);
    }
    catch(e){

    }

  }


}