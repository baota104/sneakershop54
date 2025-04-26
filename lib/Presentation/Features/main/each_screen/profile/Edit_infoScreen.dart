import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class EditInfoscreen extends StatefulWidget {
  final Map<String, dynamic> userData;

  const EditInfoscreen({super.key, required this.userData});

  @override
  State<EditInfoscreen> createState() => _EditInfoscreenState();
}

class _EditInfoscreenState extends State<EditInfoscreen> {
  File? _image;
  final ImagePicker picker = ImagePicker();

  // Controllers cho các trường thông tin
  late TextEditingController _nameController;
  late TextEditingController _locationController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.userData["name"]);
    _locationController = TextEditingController(text: widget.userData["address"]);
    _phoneController = TextEditingController(text: widget.userData["phone"]);
  }

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _updateUserData() async {
    try {
      await FirebaseFirestore.instance.collection("Users").doc(widget.userData["uid"]).update({
        "name": _nameController.text,
        "address": _locationController.text,
        "phone": _phoneController.text,
      });

      // Hiển thị thông báo thành công
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Cập nhật thông tin thành công!")),
      );
      Navigator.pop(context);
    } catch (e) {
      print("Lỗi cập nhật dữ liệu: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(
          child: Text("Edit Profile",
            style: GoogleFonts.raleway(fontSize: 20),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: GestureDetector(
              onTap: _updateUserData,
              child: Container(
                alignment: Alignment.center,
                child: Text("Save",
                  style: TextStyle(
                    color: Color(0xFF0D6EFD),
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    fontFamily: GoogleFonts.raleway().fontFamily,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildProfile(),
            _buildEditField(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfile() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipOval(
            child: Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(shape: BoxShape.circle),
              child: Image.asset("assets/images/baodeptrai.png")
            ),
          ),
          SizedBox(height: 20),
          GestureDetector(
            onTap: _pickImage,
            child: Container(
              alignment: Alignment.center,
              child: Text("Change Profile Picture",
                style: TextStyle(
                  color: Color(0xFF0D6EFD),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  fontFamily: GoogleFonts.raleway().fontFamily,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditField() {
    return Container(
      child: Column(
        children: [
          _buildItemField("Name", _nameController),
          _buildItemField("Location", _locationController),
          _buildItemField("Mobile Number", _phoneController),
        ],
      ),
    );
  }

  Widget _buildItemField(String title, TextEditingController controller) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
            style: GoogleFonts.raleway(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          TextFormField(
            controller: controller,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
              fillColor: Color(0xFFF7F7F9).withOpacity(0.5),
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(width: 1, color: Colors.white),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(width: 1, color: Colors.blue),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(width: 1, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
