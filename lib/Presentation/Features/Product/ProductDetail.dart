import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductDetailScreen extends StatefulWidget {
  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool isExpanded = false;
  bool _isloved = false;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: _buildAppBar(screenWidth),
      body: Container(
        constraints: BoxConstraints.expand(),
        color: Color(0xFFF7F7F9),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight*0.05,),
              _buildTitle(screenWidth),
              _buildCategory(screenWidth),
              _buildPrice(screenWidth),
              _buildImage(screenWidth, screenHeight),
              _buildDescription(screenWidth),
              _buildReadMoreButton(screenWidth),
              SizedBox(height: screenHeight * 0.02), // Thay Spacer() bằng SizedBox
              _buildActionButtons(screenWidth, screenHeight),
            ],
          ),
        ),
      ),
    );
  }

  // 🔹 AppBar Widget
  AppBar _buildAppBar(double screenWidth) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Text(
        "Sneaker Shop",
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      actions: [
        Padding(
          padding: EdgeInsets.only(right: screenWidth * 0.04),
          child: Stack(
            children: [
              Image.asset("assets/images/bag-2.png",
              ),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: screenWidth * 0.02,
                  height: screenWidth * 0.02,
                  decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // 🔹 Tiêu đề sản phẩm
  Widget _buildTitle(double screenWidth) {
    return Container(
      width: screenWidth*0.5,
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        "Nike Air Max 270 Essential",
        style: TextStyle(fontSize: screenWidth * 0.06, fontWeight: FontWeight.bold,
            fontFamily: GoogleFonts.raleway().fontFamily
        ),
      ),
    );
  }

  // 🔹 Danh mục sản phẩm
  Widget _buildCategory(double screenWidth) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        "Men's Shoes",
        style: TextStyle(color: Colors.grey, fontSize: screenWidth * 0.04,
            fontFamily: GoogleFonts.raleway().fontFamily
        ),
      ),
    );
  }

  // 🔹 Giá sản phẩm
  Widget _buildPrice(double screenWidth) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        "\$179.39",
        style: TextStyle(fontSize: screenWidth * 0.05, fontWeight: FontWeight.bold,
            fontFamily: GoogleFonts.poppins().fontFamily
        ),
      ),
    );
  }

  // 🔹 Hình ảnh sản phẩm
  Widget _buildImage(double screenWidth, double screenHeight) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Center(
        child: Image.asset(
          "assets/images/onboard3.png",
          width: screenWidth * 0.7,
          height: screenHeight * 0.25,
        ),
      ),
    );
  }
  // 🔹 Mô tả sản phẩm
  Widget _buildDescription(double screenWidth) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        isExpanded
            ? "The Max Air 270 Unit delivers unrivaled, all-day comfort. The sleek, running-inspired design roots you to everything Nike. "
            "With its breathable mesh upper and responsive cushioning, it provides the perfect balance between performance and street style. "
            "This sneaker is a must-have for athletes and sneaker enthusiasts alike. Whether you're hitting the gym or the streets, "
            "the Nike Air Max 270 offers unbeatable comfort and a bold look."
            : "The Max Air 270 Unit delivers unrivaled, all-day comfort. The sleek, running-inspired design roots you to everything Nike...",
        style: TextStyle(
            fontSize: screenWidth * 0.035, color: Colors.black87,
          fontFamily: GoogleFonts.poppins().fontFamily

        ),
      ),
    );
  }

  // 🔹 Nút "Read More"
  Widget _buildReadMoreButton(double screenWidth) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: () {
          setState(() {
            isExpanded = !isExpanded;
          });
        },
        child: Text(
          isExpanded ? "Read Less" : "Read More",
          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: screenWidth * 0.035),
        ),
      ),
    );
  }

  // 🔹 Nút yêu thích và "Add to Cart"
  Widget _buildActionButtons(double screenWidth, double screenHeight) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Nút yêu thích
          GestureDetector(
            onTap: (){
              setState(() {
                _isloved = !_isloved;
              });
            },
            child: Container(
              padding: EdgeInsets.all(screenWidth * 0.03),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Color(0xFFD9D9D9)),
                color: Color(0xFFD9D9D9),
              ),
              child: Icon( Icons.favorite,
                  color:_isloved ? Colors.pink:Colors.white,
                  size: screenWidth * 0.07),
            ),
          ),

          // Nút "Add to Cart"
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.1,
                vertical: screenHeight * 0.02,
              ),
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(screenWidth * 0.03),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min, // Để hàng gọn trong nút
              children: [
                Image.asset("assets/images/bag-2.png", width: screenWidth * 0.06,
                color: Colors.white,
                ), // Icon hình ảnh
                SizedBox(width: screenWidth * 0.02), // Khoảng cách giữa ảnh và chữ
                Text(
                  "Add To Cart",
                  style: TextStyle(
                    fontSize: screenWidth * 0.045,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: GoogleFonts.raleway().fontFamily, // Sử dụng Google Fonts
                  ),
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }
}
