import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sneaker_shop/domains/authentication_repository/authentication_repository.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final AuthenticationRepository authenticationRepository;
  RegisterCubit({required this.authenticationRepository}) : super(const RegisterState());

  Future<void> register(String email,String password) async{
    try{
        await authenticationRepository.registerWithEmailAndPassword(email: email, password: password);
    }
    catch(e){
      print("loi o dang ki" + e.toString());
    }
  }

}
