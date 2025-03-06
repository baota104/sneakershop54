
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sneaker_shop/Presentation/Features/main/each_screen/profile/Changepass_Screen.dart';
import 'package:sneaker_shop/Presentation/Features/main/each_screen/profile/Edit_infoScreen.dart';

import '../../../Login/RecoveryScreen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text("Profile",
          style: TextStyle(
            fontSize: 20,
            fontFamily: GoogleFonts.raleway().fontFamily,
          ),
          ),
        ),
      ),
      body: Container(
        constraints: BoxConstraints.expand(),
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildprofile(),
              _builditemfield("Your Name", "Baodeptrai54"),
              SizedBox(height: 5,),
              _builditemfield("Email Address", "Baodeptrai@gmail.com"),
              SizedBox(height: 25,),
              _buildpassfield(),
              _buildeditbutton(),
          
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildprofile(){
    return Container(
      margin: EdgeInsets.symmetric(vertical: 30),
         child:  ClipOval( // Đảm bảo cắt hình ảnh theo hình tròn
            child: Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                shape: BoxShape.circle, // Đặt hình dạng container thành hình tròn
              ),
              child: Image.asset(
                "assets/images/baodeptrai.png",
                fit: BoxFit.cover, // Đảm bảo hình ảnh hiển thị đúng tỷ lệ
              ),
            ),
          ),

    );
  }
  Widget _builditemfield(String title,String content){
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
            readOnly: true,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
              fillColor: Color(0xFFF7F7F9).withOpacity(0.5),
              filled: true,
              hintText: content,
              hintStyle: TextStyle(
                  color: Colors.black,
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
        ],
      ),
    );
  }
  Widget _buildpassfield(){
    return Container(
      margin: EdgeInsets.symmetric(vertical: 12,horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Password",
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily:GoogleFonts.raleway().fontFamily,
            ),
          ),
          TextFormField(
            readOnly: true,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
              fillColor: Color(0xFFF7F7F9).withOpacity(0.5),
              filled: true,
              hintText: "******",
              hintStyle: TextStyle(
                  color: Colors.black,
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
          GestureDetector(
            onTap: (){
              Navigator.push(context,
                  MaterialPageRoute(
                      builder: (context) => ChangepassScreen())
              );
            },
            child: Container(
              alignment: Alignment.centerRight,
              child: Text("Change Password",
                style: TextStyle(
                    color: Color(0xFF707B81),
                    fontSize: 12,
                    fontFamily: GoogleFonts.poppins().fontFamily
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildeditbutton() {
    return Container(
      height: 48,
      margin: EdgeInsets.symmetric(horizontal: 20,vertical: 24),
      width: double.infinity,
      child: ElevatedButton(onPressed: () {
        Navigator.push(context,
            MaterialPageRoute(
                builder: (context) => EditInfoscreen())
        );
      }, style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF0D6EFD),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14)
          )
      ), child: Text("Edit Information",
        style: TextStyle(color: Colors.white,
        ),
      )),
    );
  }

}
