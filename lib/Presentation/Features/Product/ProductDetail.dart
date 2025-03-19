import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sneaker_shop/domains/model/ProductModel.dart';

class ProductDetailScreen extends StatefulWidget {
  final ProductModel product; // Nhận ProductModel làm tham số

  const ProductDetailScreen({super.key, required this.product});

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool isExpanded = false;
  late bool isLoved;

  @override
  void initState() {
    super.initState();
    isLoved = widget.product.isloved; // Gán trạng thái ban đầu từ sản phẩm
  }

  void toggleLove() {
    setState(() {
      isLoved = !isLoved;
    });
  }

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
              SizedBox(height: screenHeight * 0.05),
              _buildTitle(screenWidth),
              _buildCategory(screenWidth),
              _buildPrice(screenWidth),
              _buildImage(screenWidth, screenHeight),
              _buildDescription(screenWidth),
              _buildReadMoreButton(screenWidth),
              SizedBox(height: screenHeight * 0.02),
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
              Image.asset("assets/images/bag-2.png"),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: screenWidth * 0.02,
                  height: screenWidth * 0.02,
                  decoration:
                  BoxDecoration(color: Colors.red, shape: BoxShape.circle),
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
      width: screenWidth * 0.8,
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        widget.product.name,
        style: TextStyle(
          fontSize: screenWidth * 0.06,
          fontWeight: FontWeight.bold,
          fontFamily: GoogleFonts.raleway().fontFamily,
        ),
      ),
    );
  }

  // 🔹 Danh mục sản phẩm
  Widget _buildCategory(double screenWidth) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        widget.product.activity,
        style: TextStyle(
          color: Colors.grey,
          fontSize: screenWidth * 0.04,
          fontFamily: GoogleFonts.raleway().fontFamily,
        ),
      ),
    );
  }

  // 🔹 Giá sản phẩm
  Widget _buildPrice(double screenWidth) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
           child:  Text(
              "\$${widget.product.price.toStringAsFixed(2)}",
              style: TextStyle(
                fontSize: screenWidth * 0.05,
                fontWeight: FontWeight.bold,
                fontFamily: GoogleFonts.poppins().fontFamily,
              ),
            ),
    );
  }

  // 🔹 Hình ảnh sản phẩm
  Widget _buildImage(double screenWidth, double screenHeight) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Center(
        child: Image.network(
          widget.product.imageUrl,
          width: screenWidth * 0.7,
          height: screenHeight * 0.25,
          fit: BoxFit.fitWidth,
          errorBuilder: (context, error, stackTrace) => Icon(
            Icons.image_not_supported,
            size: screenWidth * 0.5,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  // 🔹 Mô tả sản phẩm
  Widget _buildDescription(double screenWidth) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        isExpanded ? widget.product.description : widget.product.description.substring(0, 100) + "...",
        style: TextStyle(
          fontSize: screenWidth * 0.035,
          color: Colors.black87,
          fontFamily: GoogleFonts.poppins().fontFamily,
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
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
            fontSize: screenWidth * 0.035,
          ),
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
            onTap: toggleLove,
            child: Container(
              padding: EdgeInsets.all(screenWidth * 0.03),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Color(0xFFD9D9D9)),
                color: isLoved ? Colors.pink[100] : Color(0xFFD9D9D9),
              ),
              child: Icon(
                Icons.favorite,
                color: isLoved ? Colors.pink : Colors.white,
                size: screenWidth * 0.07,
              ),
            ),
          ),

          // Nút "Add to Cart"
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text("Add To Cart", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
