import 'package:flutter/material.dart';
import 'package:sneaker_shop/Presentation/Features/Product/ProductCard.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Favourite",
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.favorite,
              color: Colors.pink,),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        // child: Padding(
        //   padding: const EdgeInsets.all(16.0),
        //     child: GridView.builder(
        //       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        //         crossAxisCount: 2, // Hiển thị 2 cột
        //         crossAxisSpacing: 12,
        //         mainAxisSpacing: 12,
        //         childAspectRatio: 0.75, // Tỷ lệ chiều cao / chiều rộng
        //       ),
        //       itemCount: 8, // Số lượng sản phẩm yêu thích
        //       itemBuilder: (context, index) {
        //         return ProductCard( islove: true,);
        //       },
        //     ),
        // ),
      ),
    );
  }
}
