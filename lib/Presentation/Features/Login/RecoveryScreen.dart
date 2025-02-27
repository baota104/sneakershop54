

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Recoveryscreen extends StatefulWidget {
  const Recoveryscreen({super.key});

  @override
  State<Recoveryscreen> createState() => _RecoveryscreenState();
}

class _RecoveryscreenState extends State<Recoveryscreen> {
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
            // controller: _usermailController,
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
        Navigator.pop(context);
        _onhandlesendemail();
      }, style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF0D6EFD),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14)
          )
      ), child: Text("Sign Up",
        style: TextStyle(color: Colors.white,
        ),
      )),
    );
  }
  void _onhandlesendemail(){

  }
}
