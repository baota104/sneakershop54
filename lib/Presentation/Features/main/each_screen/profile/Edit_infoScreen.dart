import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:sneaker_shop/Presentation/Features/main/each_screen/profile/user_bloc.dart';
import 'package:sneaker_shop/Presentation/Features/main/each_screen/profile/user_event.dart';
import 'package:sneaker_shop/Presentation/Features/main/each_screen/profile/user_state.dart';
import 'package:sneaker_shop/Presentation/Widgets/LoadingWidget.dart';
import 'package:sneaker_shop/domains/model/UserModel.dart';

class EditInfoscreen extends StatefulWidget {
  final UserModel userData;

  const EditInfoscreen({super.key, required this.userData});

  @override
  State<EditInfoscreen> createState() => _EditInfoscreenState();
}

class _EditInfoscreenState extends State<EditInfoscreen> {
  File? _image;
  final ImagePicker picker = ImagePicker();

  late TextEditingController _nameController;
  late TextEditingController _locationController;
  late TextEditingController _phoneController;

  late UserBloc useBloc;

  @override
  void initState() {
    super.initState();
    useBloc = context.read<UserBloc>();
    _nameController = TextEditingController(text: widget.userData.name);
    _locationController = TextEditingController(text: widget.userData.address);
    _phoneController = TextEditingController(text: widget.userData.phone);
  }

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _handleUpdate() async {
    String imageUrl = widget.userData.imageurl;

    if (_image != null) {
      try {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('profile_images/${FirebaseAuth.instance.currentUser!.uid}_${DateTime.now().millisecondsSinceEpoch}.jpg');
        await storageRef.putFile(_image!);
        imageUrl = await storageRef.getDownloadURL();
      } catch (e) {
        print("Lỗi upload ảnh: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Tải ảnh lên thất bại")),
        );
        return;
      }
    }
    FocusScope.of(context).unfocus();
    useBloc.add(UpdateUserInformation(
      _nameController.text.trim(),
      _locationController.text.trim(),
      _phoneController.text.trim(),
      imageUrl,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(
          child: Text(
            "Edit Profile",
            style: GoogleFonts.raleway(fontSize: 20),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: GestureDetector(
              onTap: _handleUpdate,
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  "Save",
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
      body: BlocConsumer<UserBloc, UserStateBase>(
        listener: (context, state) {
          if (state is UpdateUserSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Cập nhật thông tin thành công!")),
            );
            Navigator.pop(context,true);
          } else if (state is UpdateUserError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is UserStateLoading) {
            return Center(child: LoadingWidet());
          }

          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildProfile(),
                _buildEditField(),
              ],
            ),
          );
        },
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
              child: _image != null
                  ? Image.file(_image!, fit: BoxFit.cover)
                  : Image.network(widget.userData.imageurl, fit: BoxFit.cover),
            ),
          ),
          SizedBox(height: 20),
          GestureDetector(
            onTap: _pickImage,
            child: Container(
              alignment: Alignment.center,
              child: Text(
                "Change Profile Picture",
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
    return Column(
      children: [
        _buildItemField("Name", _nameController),
        _buildItemField("Location", _locationController),
        _buildItemField("Mobile Number", _phoneController),
      ],
    );
  }

  Widget _buildItemField(String title, TextEditingController controller) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
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
