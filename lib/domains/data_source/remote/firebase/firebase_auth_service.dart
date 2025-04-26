import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class FirebaseAuthService {
  Stream<User?> get user{
    return FirebaseAuth.instance.authStateChanges().map((firebaseUser)=> firebaseUser);
  }
  Future<UserCredential> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
      return await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
  }
  Future<User?> registerWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      User? user = userCredential.user;

      if (user != null) {
        final FirebaseFirestore firestore = FirebaseFirestore.instance;
        // Tạo tài khoản người dùng trong Firestore
        await firestore.collection("Users").doc(user.uid).set({
          "uid": user.uid,
          "email": user.email,
          "name": "",
          "phone": "",
          "address": "",
        });

        // Tạo giỏ hàng rỗng tương ứng
        await firestore.collection("Carts").doc(user.uid).set({
          "cart_id": user.uid,
          "userid": user.uid,
          // "cart_items": [],
        });

        print("✅ Đăng ký + tạo giỏ hàng thành công cho user: ${user.email}");
        return user;
      }

      return null;
    } catch (e) {
      print("❌ Lỗi đăng ký hoặc tạo giỏ hàng: $e");
      return null;
    }
  }

}