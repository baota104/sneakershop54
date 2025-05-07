import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sneaker_shop/Presentation/Features/Cart/cart_bloc.dart';
import 'package:sneaker_shop/Presentation/Features/Cart/cart_event.dart';
import 'package:sneaker_shop/domains/model/ProductModel.dart';

import '../../../domains/model/CartModel.dart';
import '../Cart/cart_state.dart';

class ProductCard extends StatefulWidget {
  final ProductModel product; // Nhận ProductModel làm tham số
  const ProductCard({super.key, required this.product});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  late bool isLoved; // Trạng thái yêu thích
  late CartBloc cartBloc;

  @override
  void initState() {
    super.initState();
    isLoved = widget.product.isloved; // Gán trạng thái từ productd
    cartBloc = context.read<CartBloc>();
  }

  void toggleLove() {
    setState(() {
      isLoved = !isLoved;
    });
  }


  @override
  Widget build(BuildContext context) {
    return   LayoutBuilder(
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
                  Text(
                    widget.product.name,
                    style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                      fontFamily: GoogleFonts.raleway().fontFamily,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Spacer(),
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
                      GestureDetector(
                        onTap: () {
                          context.read<CartBloc>().add(
                            AddItemtoCart(productId: widget.product.productId),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.all(fontSize * 0.4),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                          child:Icon(
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


}
