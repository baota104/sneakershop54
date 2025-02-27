import 'package:firebase_auth/firebase_auth.dart';
class FirebaseAuthService {
  Stream<User?> get user{
    return FirebaseAuth.instance.authStateChanges().map((firebaseUser)=> firebaseUser);
  }
  Future<void> loginWithEmailAndPassword({
    required String email,
    required String password,

  }) async{
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
    }
    catch(e){
      print(e.toString());
    }
  }
  Future<void> registerWithEmailAndPassword({
    required String email,
    required String password,

  }) async{
    try{
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
    }
    catch(e){
      print(e.toString());
    }
  }
}