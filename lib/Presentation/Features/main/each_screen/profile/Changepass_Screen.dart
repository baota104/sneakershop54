import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChangepassScreen extends StatefulWidget {
  const ChangepassScreen({super.key});

  @override
  State<ChangepassScreen> createState() => _ChangepassScreenState();
}

class _ChangepassScreenState extends State<ChangepassScreen> {
  final _oldpass = TextEditingController();
  final _newpass1 = TextEditingController();
  final _newpass2 = TextEditingController();
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
                _buildoldpassfield("Old password",),
                _buildnewpassfield("New password"),
                _buildnewpass2field("Reenter New password"),
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
            child: Text("Change Password",
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
            child: Text("Enter your new and old password to proceed",
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

  Widget _buildoldpassfield(String title){
    return Container(
      margin: EdgeInsets.symmetric(vertical: 12,horizontal: 20),
      height: 80,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily:GoogleFonts.raleway().fontFamily,
            ),
          ),
          TextFormField(
            controller: _oldpass,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
              fillColor: Color(0xFFF7F7F9).withOpacity(0.5),
              filled: true,
              // hintText: content,
              // hintStyle: TextStyle(
              //     color: Colors.black,
              //     fontFamily: GoogleFonts.poppins().fontFamily
              // ),
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
        ],
      ),
    );
  }

  Widget _buildnewpassfield(String title){
    return Container(
      margin: EdgeInsets.symmetric(vertical: 12,horizontal: 20),
      height: 80,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily:GoogleFonts.raleway().fontFamily,
            ),
          ),
          TextFormField(
            controller: _newpass1,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
              fillColor: Color(0xFFF7F7F9).withOpacity(0.5),
              filled: true,
              // hintText: content,
              // hintStyle: TextStyle(
              //     color: Colors.black,
              //     fontFamily: GoogleFonts.poppins().fontFamily
              // ),
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
        ],
      ),
    );
  }

  Widget _buildnewpass2field(String title){
    return Container(
      margin: EdgeInsets.symmetric(vertical: 12,horizontal: 20),
      height: 80,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily:GoogleFonts.raleway().fontFamily,
            ),
          ),
          TextFormField(
            controller: _newpass2,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
              fillColor: Color(0xFFF7F7F9).withOpacity(0.5),
              filled: true,
              // hintText: content,
              // hintStyle: TextStyle(
              //     color: Colors.black,
              //     fontFamily: GoogleFonts.poppins().fontFamily
              // ),
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
        ],
      ),
    );
  }
  Widget _buildsignupbutton() {
    return Container(
      height: 48,
      margin: EdgeInsets.symmetric(horizontal: 20,vertical: 24),
      width: double.infinity,
      child: ElevatedButton(onPressed: () {
        _onhandlechangepassword();
      }, style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF0D6EFD),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14)
          )
      ), child: Text("Submit",
        style: TextStyle(color: Colors.white,
        ),
      )),
    );
  }
  void _onhandlechangepassword(){

  }
}
