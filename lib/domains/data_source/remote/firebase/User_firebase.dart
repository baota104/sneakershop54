import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sneaker_shop/domains/model/UserModel.dart';

class UserFirebase{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<UserModel?> fetchUser(String uid)async{
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? uid = prefs.getString('uid');
      if (uid != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('Users')
            .doc(uid)
            .get();

        if (userDoc.exists) {
          Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
          return UserModel.fromMap(data);
        }
        return null;

      }
    }
    catch(e){
      print(e.toString());
      return null;
    }
  }

}