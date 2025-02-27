import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Mainscreen extends StatefulWidget {
  const Mainscreen({super.key});

  @override
  State<Mainscreen> createState() => _MainscreenState();
}

class _MainscreenState extends State<Mainscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: Container(
        child: ElevatedButton(onPressed: (){
          FirebaseAuth.instance.signOut();
        }, child: Text("signout")),
      ),
    );
  }
}
