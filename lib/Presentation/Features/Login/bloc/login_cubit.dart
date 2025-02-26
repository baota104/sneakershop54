import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:sneaker_shop/domains/authentication_repository/authentication_repository.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthenticationRepository authenticationRepository;
  LoginCubit({
    required this.authenticationRepository
  }) : super(const LoginState(""));

      Future<void> login(String email,String password)async{
        try{
          await authenticationRepository.loginWithEmailAndPassword(
              email: email,
              password: password
          );
        }
        catch(e){
          print(e.toString());
        }
      }
}
