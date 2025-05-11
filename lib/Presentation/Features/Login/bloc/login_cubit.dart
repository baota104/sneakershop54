import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:sneaker_shop/domains/data_source/remote/authentication_repository/authentication_repository.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthenticationRepository authenticationRepository;
  LoginCubit({
    required this.authenticationRepository
  }) : super(const LoginState(""));

      Future<void> login(String email,String password)async{
        try{
          print("yeeee sor");
          await authenticationRepository.loginWithEmailAndPassword(
              email: email,
              password: password
          );

        }
        catch(e){

          print(e.toString());
        }
      }
  Future<bool> loginWithGoogle() async {
    try {
      await authenticationRepository.loginWithGoogle();
      return true;
    } catch (e) {
      print("Google Sign-In failed: $e");
      return false;
    }
  }
  Future<bool> resetPassword(String email) async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection("Users")
          .where("email", isEqualTo: email)
          .get();

      if (userDoc.docs.isEmpty) {
        return false; // Không tìm thấy user với email đó
      }

      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return true; // Gửi email thành công
    } catch (e) {
      print("Lỗi reset mật khẩu: $e");
      return false;
    }
  }


}
