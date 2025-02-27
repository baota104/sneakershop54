import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sneaker_shop/Presentation/Features/Register/bloc/register_cubit.dart';
import 'package:sneaker_shop/main.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Registerscreen extends StatefulWidget {
  const Registerscreen({super.key});

  @override
  State<Registerscreen> createState() => _RegisterscreenState();
}

class _RegisterscreenState extends State<Registerscreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _usermailController = TextEditingController();
  final TextEditingController _userpassController = TextEditingController();
  bool isvisibleicon = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Form(
        child: Container(
          constraints: BoxConstraints.expand(),
          color: Colors.white,
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  minHeight:double.minPositive
              ),
              child: IntrinsicHeight(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildtitleandcontent(),
                    _buildnamefield(),
                    _buildemailfield(),
                    SizedBox(height: 25,),
                    _buildpasswordfield(),
                    _buildsignupbutton(),
                    _buildgoogle(),
                    _buildtextlogin()
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildtitleandcontent(){
    return Column(
      children: [
        Container(
          width: 262,
          height: 45,
          child: Text("Register Account",
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
          child: Text("Fill your details or continue with social media",
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
    );
  }
  Widget _buildnamefield(){
    return Container(
      margin: EdgeInsets.symmetric(vertical: 12,horizontal: 20),
      height: 80,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Your Name",
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily:GoogleFonts.raleway().fontFamily,
            ),
          ),
          TextFormField(
            autofocus: false,
            maxLines: 1,
            controller: _usernameController,
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
        ],
      ),
    );
  }
  Widget _buildemailfield(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      height: 80,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Email Address",
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily:GoogleFonts.raleway().fontFamily,
            ),
          ),
          TextFormField(
            autofocus: false,
            maxLines: 1,
            controller: _usermailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            style: TextStyle(color: Colors.black),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return "Email is required";
              }
              final bool emailValid =
              RegExp(
                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                  .hasMatch(value);
              if (emailValid) {
                return null; // email hop le
              }
              else {
                return "email is not invalidate";
              }
              return null;
            },
            decoration: InputDecoration(
              fillColor: Color(0xFFF7F7F9).withOpacity(0.5),
              filled: true,
              hintText: "xyz@gmail.com",
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
        ],
      ),
    );
  }
  Widget _buildpasswordfield(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Password",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily:GoogleFonts.raleway().fontFamily,
            ),
          ),
          TextFormField(
            maxLines: 1,
            controller: _userpassController,
            obscureText: isvisibleicon,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
            style: TextStyle(color: Color(0xFF6A6A6A)),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return "Password is required";
              }
              if (value.length < 6) {
                return "required more than 6 words";
              }
              return null;
            },
            decoration: InputDecoration(
              suffixIcon: IconButton(onPressed: (){
                setState(() {
                  isvisibleicon = !isvisibleicon;
                });
              }, icon: isvisibleicon ? Icon(CupertinoIcons.eye,color: Color(0xFF6A6A6A),):Icon(CupertinoIcons.eye_slash,color: Color(0xFF6A6A6A))
              ),
              fillColor: Color(0xFFF7F7F9).withOpacity(0.5),
              filled: true,
              hintStyle: TextStyle(
                  color: Color(0xFF6A6A6A),
                  fontFamily: GoogleFonts.poppins().fontFamily
              ),
              labelStyle: TextStyle(color: Colors.black),
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
        _onsubmitregister();
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
  Widget _buildgoogle(){
    return Container(
      height: 48,
      margin: EdgeInsets.symmetric(horizontal: 20,vertical: 24),
      width: double.infinity,
      child: ElevatedButton(onPressed: () {

      }, style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xF7F7F9).withOpacity(0.9),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14)
        ),

      ), child: Row(
        //   crossAxisAlignment: CrossAxisAlignment.center,\
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Image.asset("assets/images/google.png",
            width: 22,
            height: 22,
          ),
          SizedBox(width: 12,),
          Text("Sign Up With Google ",
            style: TextStyle(color: Colors.black,
                fontFamily: GoogleFonts.raleway().fontFamily,
                fontSize: 14
            ),
          ),
        ],
      )),
    );
  }
  Widget _buildtextlogin(){
    return Container(
      margin: EdgeInsets.only(top: 70),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Already Have Account?",
            style: TextStyle(
              color: Color(0xFF6A6A6A),
              fontFamily: GoogleFonts.raleway().fontFamily,
              fontSize: 16,
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.pop(context);
              print("hello uc");
            },
            child: Text("Log In",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontFamily: GoogleFonts.raleway().fontFamily,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }
  void _onsubmitregister(){
    final registercubit = context.read<RegisterCubit>();
    var email = _usermailController.text;
    var password = _userpassController.text;
    try{
      registercubit.register(email, password);
    }
    catch(e){
      print(e.toString()+"loi o register");
    }

  }

}
