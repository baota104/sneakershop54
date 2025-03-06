
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Color(0xFF1483C2),
          constraints: BoxConstraints.expand(),
          child: SingleChildScrollView(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildprofile(),
                _buildMenuItem(Icons.person, "Profile"),
                _buildMenuItem(Icons.shopping_cart_outlined, "My Cart"),
                _buildMenuItem(Icons.heart_broken_rounded, "Favorite"),
                _buildMenuItem(Icons.fire_truck, "Orders"),
                _buildMenuItem(Icons.notifications, "Notifications"),
                _buildMenuItem(Icons.settings, "Settings"),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 40),
                  child: Divider(color: Colors.white54),
                ),
                _buildMenuItem(Icons.logout, "Sign Out"),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildprofile(){
    return Container(
      alignment: Alignment.topLeft,
      margin: EdgeInsets.only(top:30,left: 25),
      child: Column(
        children: [
          ClipOval( // Đảm bảo cắt hình ảnh theo hình tròn
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
          Text("Baodeptrai",
          style: TextStyle(
            fontSize: 20,
            fontFamily: GoogleFonts.raleway().fontFamily,
            color: Colors.white
          ),
          )
        ],
      ),
    );
  }
  Widget _buildMenuItem(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7,horizontal: 15),
      child: InkWell( // Thêm hiệu ứng InkWell khi nhấn
        onTap: () {
          // Thêm hành động khi nhấn
          print('$title tapped');
        },
        splashColor: Colors.white, // Màu sóng khi nhấn
        highlightColor: Colors.white, // Màu khi giữ
        child: ListTile(
          leading: Icon(icon, color: Colors.white),
          title: Text(title, style: TextStyle(color: Colors.white, fontSize: 16)),
          trailing: Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
        ),
      ),
    );
  }
}
