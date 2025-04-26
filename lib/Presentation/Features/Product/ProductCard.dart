import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sneaker_shop/domains/model/ProductModel.dart';

import '../../../domains/model/CartModel.dart';

class ProductCard extends StatefulWidget {
  final ProductModel product; // Nhận ProductModel làm tham số
  const ProductCard({super.key, required this.product});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  late bool isLoved; // Trạng thái yêu thích

  @override
  void initState() {
    super.initState();
    isLoved = widget.product.isloved; // Gán trạng thái từ product
  }

  void toggleLove() {
    setState(() {
      isLoved = !isLoved;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double width = constraints.maxWidth * 0.9;
        double imageSize = width * 0.8;
        double fontSize = width * 0.1;

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
              // Nút yêu thích (heart icon)
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: toggleLove,
                  child: Icon(
                    isLoved ? Icons.favorite : Icons.favorite_border,
                    color: isLoved ? Colors.pink : Colors.black,
                    size: fontSize * 1.2,
                  ),
                ),
              ),
              SizedBox(height: 4),
              // Ảnh sản phẩm
              Center(
                child: Image.network(
                  widget.product.imageUrl,
                  width: imageSize,
                  height: imageSize * 0.6,
                  fit: BoxFit.fitWidth,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.image_not_supported,
                    size: imageSize * 0.5,
                    color: Colors.grey,
                  ),
                ),
              ),
              SizedBox(height: 8),
              // Nhãn sản phẩm (nếu có)
              if (widget.product.activity.isNotEmpty)
                Text(
                  widget.product.activity.toUpperCase(),
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: fontSize * 0.8,
                    fontWeight: FontWeight.bold,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                  ),
                ),
              SizedBox(height: 4),
              // Tên sản phẩm
              Text(
                widget.product.name,
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                  fontFamily: GoogleFonts.raleway().fontFamily,
                ),
                maxLines: 2, // Giới hạn số dòng hiển thị
                overflow: TextOverflow.ellipsis, // Hiển thị "..." nếu bị tràn
              ),
              Spacer(),
              // Giá sản phẩm (hiển thị giá giảm nếu có)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                    Text(
                      "\$${widget.product.price.toStringAsFixed(2)}",
                      style: TextStyle(
                        fontSize: fontSize * 1.1,
                        fontWeight: FontWeight.bold,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                      ),
                    ),
                  // Nút thêm vào giỏ hàng
                  GestureDetector(
                    onTap: (){
                      CartItem cart = CartItem(pro_id: widget.product.productId, imageUrl: widget.product.imageUrl, name: widget.product.name, price: widget.product.price, discountprice: widget.product.discountPrice!.toDouble(), addedAt: DateTime.now());
                      _addtocart(cart);
                    },
                    child: Container(
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
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
  void _addtocart(CartItem newItem) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? uid = prefs.getString('uid');
    if (uid == null) return;

    final cartRef = FirebaseFirestore.instance
        .collection("Carts")
        .doc(uid)
        .collection("cart_items");

    try {
      // Check nếu sản phẩm đã có thì tăng số lượng (nếu bạn có field quantity)
      QuerySnapshot existing = await cartRef
          .where("pro_id", isEqualTo: newItem.pro_id)
          .limit(1)
          .get();

      if (existing.docs.isNotEmpty) {
        print("da co sanr pham roi");
      } else {
        await cartRef.add(newItem.toMap());
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("add to cart successfully"),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      print("❌ Lỗi khi thêm vào giỏ: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("fail to add to cart"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
