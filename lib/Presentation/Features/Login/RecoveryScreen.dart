

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sneaker_shop/Presentation/Features/Login/LoginScreen.dart';

import 'bloc/login_cubit.dart';

class Recoveryscreen extends StatefulWidget {
  const Recoveryscreen({super.key});

  @override
  State<Recoveryscreen> createState() => _RecoveryscreenState();
}

class _RecoveryscreenState extends State<Recoveryscreen> {
  final _emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: SafeArea(
          child:Container(
            color: Colors.white,
            constraints: BoxConstraints.expand(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildtitleandcontent(),
                _buildmailfield(),
                _buildsignupbutton()
              ],
            ),
          )
      ),
    );
  }

  Widget _buildtitleandcontent(){
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            height: 45,
            child: Text("Forgot Password",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                fontFamily:GoogleFonts.raleway().fontFamily,
              ),
            ),
          ),
          SizedBox(height: 8,),
          Container(
            width: 315,
            height: 48,
            child: Text("Enter your Email account to reset your password",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF707B81),
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily:GoogleFonts.poppins().fontFamily,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildmailfield(){
    return Container(
      margin: EdgeInsets.symmetric(vertical: 30,horizontal: 20),
      height: 80,
      child: TextFormField(
            autofocus: false,
            maxLines: 1,
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
              fillColor: Color(0xFFF7F7F9).withOpacity(0.5),
              filled: true,
              hintText: "xxxxxxxxx",
              hintStyle: TextStyle(
                  color: Color(0xFF6A6A6A),
                  fontFamily: GoogleFonts.poppins().fontFamily
              ),
              labelStyle: TextStyle(color: Colors.blue),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(width: 1, color: Colors.white)
              ),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(width: 1, color: Colors.white)
              ),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(width: 1, color: Colors.white)
              ),
            ),
          ),
    );
  }

  Widget _buildsignupbutton() {
    return Container(
      height: 48,
      margin: EdgeInsets.symmetric(horizontal: 20,vertical: 24),
      width: double.infinity,
      child: ElevatedButton(onPressed: () {
        // Navigator.pop(context);
        _onhandlesendemail();
      }, style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF0D6EFD),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14)
          )
      ), child: Text("Send",
        style: TextStyle(color: Colors.white,
        ),
      )),
    );
  }
  Future<void> _onhandleloginsubmitgoogle () async {

    final logincubit = context.read<LoginCubit>();

    try{
      final success = await logincubit.loginWithGoogle();
      final message = success ? "Đăng nhập Google thành công!" : "Đăng nhập Google thất bại.";
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    }
    catch(e){
      print(e.toString());
    }
    return;
  }
  Future<void> _onhandlesendemail() async{
    String email = _emailController.text.trim();
    final logincubit = context.read<LoginCubit>();
    try {
      final success = await logincubit.resetPassword(email);
      if (success){
        Future.delayed(const Duration(seconds: 2), () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                title: Column(
                  children: [
                    Icon(Icons.email_outlined, size: 50, color: Colors.blue),
                    SizedBox(height: 10),
                    Text(
                      "Check Your Email",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: GoogleFonts
                            .raleway()
                            .fontFamily,
                      ),
                    ),
                  ],
                ),
                content: Text(
                  "We have sent a password recovery code to your email.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: GoogleFonts
                        .poppins()
                        .fontFamily,
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Đóng dialog
                    },
                    child: const Text(
                        "OK", style: TextStyle(color: Colors.blue)),
                  )
                ],
              );
            },
          );
        });
    }
      else{
        Future.delayed(const Duration(seconds: 2), () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                title: Column(
                  children: [
                    Icon(Icons.email_outlined, size: 50, color: Colors.blue),
                    SizedBox(height: 10),
                    Text(
                      "Send email failed",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: GoogleFonts
                            .raleway()
                            .fontFamily,
                      ),
                    ),
                  ],
                ),
                content: Text(
                  "Enter exactly your email",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: GoogleFonts
                        .poppins()
                        .fontFamily,
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Đóng dialog
                    },
                    child: const Text(
                        "OK", style: TextStyle(color: Colors.blue)),
                  )
                ],
              );
            },
          );
        });
      }
    }
    catch(e){
      print(e.toString());
    }
  }}
