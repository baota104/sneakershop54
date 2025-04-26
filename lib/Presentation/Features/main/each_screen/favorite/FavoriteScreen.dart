import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sneaker_shop/Presentation/Features/Product/ProductCard.dart';
import 'package:sneaker_shop/domains/model/UserModel.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  UserModel? userModel;
  Future<UserModel?> fetchUser(String uid)async{
    try{
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('Users')
            .doc(uid)
            .get();

        if (userDoc.exists) {
          Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
          return UserModel.fromMap(data);
        }
        return null;
    }
    catch(e){
      print(e.toString());
      return null;
    }
  }
  Future<void> _iniuser()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? uid = prefs.getString('uid');
    if (uid != null) {
      final user = await fetchUser(uid);
      print(user);
      setState(() {
        userModel = user;
      });

    }
  }
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    _iniuser();
  }
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Hiển thị 2 cột
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.75, // Tỷ lệ chiều cao / chiều rộng
              ),
              itemCount: 8, // Số lượng sản phẩm yêu thích
              itemBuilder: (context, index) {
                return null;
              },
            ),
        ),
      ),
    );
  }

  Widget _productcard(Favoritesitems item){
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
                  child: Icon(
                    Icons.favorite,
                    color: Colors.pink,
                    size: fontSize * 1.2,
                  ),
              ),
              SizedBox(height: 4),
              // Ảnh sản phẩm
              Center(
                child: Image.network(
                  item.imageUrl,
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
              if (item.activity.isNotEmpty)
                Text(
                  item.activity.toUpperCase(),
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
                item.name,
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
                    "\$${item.price.toStringAsFixed(2)}",
                    style: TextStyle(
                      fontSize: fontSize * 1.1,
                      fontWeight: FontWeight.bold,
                      fontFamily: GoogleFonts.poppins().fontFamily,
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

