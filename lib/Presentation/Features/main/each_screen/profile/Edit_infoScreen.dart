import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class EditInfoscreen extends StatefulWidget {
  const EditInfoscreen({super.key});

  @override
  State<EditInfoscreen> createState() => _EditInfoscreenState();
}

class _EditInfoscreenState extends State<EditInfoscreen> {
  File? _image; // Lưu trữ ảnh đã chọn
  final picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery); // Chọn ảnh từ thư viện
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path); // Cập nhật ảnh đại diện
      });
    }
  }
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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15), // Đưa icon giỏ hàng gần vào
            child:GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
              child: Container(
                alignment: Alignment.center,
                child: Text("Done",
                  style: TextStyle(
                      color: Color(0xFF0D6EFD),
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      fontFamily: GoogleFonts.raleway().fontFamily
                  ),
                ),
              ),
            ),
          ),
        ],
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
              _buildeditfield()
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildeditfield(){
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
         _builditemfield("First Name", "Baodeptrai"),
          _builditemfield("Location", "VietNam"),
          _builditemfield("Mobile Number", "038423556")
        ],
      ),
    );
  }
  Widget _buildprofile(){
    return Container(
      margin: EdgeInsets.symmetric(vertical: 30),
      child:  Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipOval( // Đảm bảo cắt hình ảnh theo hình tròn
            child: Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                shape: BoxShape.circle, // Đặt hình dạng container thành hình tròn
              ),
              child:  _image != null
                  ? Image.file(_image!, fit: BoxFit.cover) // Hiển thị ảnh đã chọn
                  : Image.asset("assets/images/baodeptrai.png", fit: BoxFit.cover),
            ),
          ),
          SizedBox(height: 20,),
          GestureDetector(
            onTap: (){
            _pickImage();
            },
            child: Container(
              alignment: Alignment.center,
              child: Text("Change Profile Picture",
                style: TextStyle(
                    color: Color(0xFF0D6EFD),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    fontFamily: GoogleFonts.raleway().fontFamily
                ),
              ),
            ),
          ),
        ],
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
}
