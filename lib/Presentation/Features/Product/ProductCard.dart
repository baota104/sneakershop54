import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductCard extends StatefulWidget {
  final bool islove; // Không dùng dấu _ vì không cần private ở đây
  const ProductCard({super.key, required this.islove});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  late bool islove; // Tạo một biến nội bộ để thay đổi trạng thái

  @override
  void initState() {
    super.initState();
    islove = widget.islove; // Gán giá trị ban đầu từ widget cha
  }

  void toggleLove() {
    setState(() {
      islove = !islove; // Cập nhật trạng thái trái tim
    });
  }
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double width = constraints.maxWidth * 0.9; // Giới hạn chiều rộng theo tỷ lệ
        double imageSize = width * 0.8; // Kích thước ảnh giảm theo card
        double fontSize = width * 0.1; // Kích thước chữ co giãn theo card

        return Container(
          width: width,
          padding: EdgeInsets.all(width * 0.07),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: (){
                    toggleLove();
                  },
                  child: Container(
                    child: islove ? Icon(
                      Icons.favorite,
                      color:Colors.pink,
                      size: fontSize * 1.2,
                    )
                    :Icon(
                      Icons.favorite_border,
                      color:Colors.black,
                      size: fontSize * 1.2,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 4),
              Center(
                child: Image.asset(
                  "assets/images/onboard2.png",
                  width: imageSize,
                  height: imageSize * 0.6,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "BEST SELLER",
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: fontSize * 0.8,
                  fontWeight: FontWeight.bold,
                  fontFamily: GoogleFonts.poppins().fontFamily
                ),
              ),
              SizedBox(height: 4),
              Text(
                "Nike Jordan",
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                    fontFamily: GoogleFonts.raleway().fontFamily
                ),
              ),
              SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "\$302.00",
                    style: TextStyle(
                      fontSize: fontSize * 1.1,
                      fontWeight: FontWeight.bold,
                        fontFamily: GoogleFonts.poppins().fontFamily
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(fontSize * 0.4),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                      size: fontSize,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
