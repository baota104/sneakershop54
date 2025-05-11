import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        print("Google sign-in cancelled by user");
        return null;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      final user = userCredential.user;

      if (user != null) {
        // Kiểm tra nếu user đã tồn tại trong Firestore chưa
        final docRef = FirebaseFirestore.instance.collection("Users").doc(user.uid);
        final snapshot = await docRef.get();

        if (!snapshot.exists) {
          // Nếu chưa có, thêm mới
          await docRef.set({
            "uid": user.uid,
            "email": user.email,
            "name":  "",
            "phone":  "",
            "address": "",
            "createdAt": FieldValue.serverTimestamp(),
          });

          // Tạo giỏ hàng rỗng tương ứng
          await FirebaseFirestore.instance.collection("Carts").doc(user.uid).set({
            "cart_id": user.uid,
            "user_id": user.uid,
          });

          print("Google user registered & Firestore data created");
        }

        return user;
      }

      return null;
    } catch (e) {
      print("Error during Google Sign-In: $e");
      return null;
    }
  }
  Future<User?> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String name
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
          "name": name,
          "phone": "",
          "address": "",
        });

        // Tạo giỏ hàng rỗng tương ứng
        await firestore.collection("Carts").doc(user.uid).set({
          "cart_id": user.uid,
          "user_id": user.uid,
          // "cart_items": [],
        });

        print(" Đăng ký + tạo giỏ hàng thành công cho user: ${user.email}");
        return user;
      }

      return null;
    } catch (e) {
      print(" Lỗi đăng ký hoặc tạo giỏ hàng: $e");
      return null;
    }
  }
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      print("Đã gửi email reset mật khẩu đến $email");
    } catch (e) {
      print("Lỗi khi gửi email reset mật khẩu: $e");
      rethrow;
    }
  }


}