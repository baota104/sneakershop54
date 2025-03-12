
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sneaker_shop/Presentation/Features/Cart/CartScreen.dart';
import 'package:sneaker_shop/Presentation/Features/Product/ProductCard.dart';
import 'package:sneaker_shop/Presentation/Features/Product/ProductDetail.dart';
import 'package:sneaker_shop/Presentation/Features/main/each_screen/Menu_Screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        appBar:AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: Builder(
            builder: (context) => Padding(
              padding: const EdgeInsets.only(left: 10),
              child: GestureDetector(
                onTap: () {
                  Scaffold.of(context).openDrawer(); // Mở Drawer đúng cách
                },
                child: Image.asset("assets/images/menu.png", width: 24, height: 24),
              ),
            ),
          ),
          title: Center(
            child: Text(
              'Explore',
              style: TextStyle(
                color: Colors.black,
                fontSize: 32, // Giảm kích thước chữ để phù hợp hơn
                fontWeight: FontWeight.bold,
                fontFamily: GoogleFonts.raleway().fontFamily,
              ),
            ),
          ),
          centerTitle: false,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 15), // Đưa icon giỏ hàng gần vào
              child: Stack(
                clipBehavior: Clip.none, // Cho phép hiển thị phần tử Positioned ra ngoài Stack
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>CartScreen()));
                    },
                    child: Image.asset("assets/images/bag-2.png", width: 26, height: 26),
                  ),
                  Positioned(
                    right: -2, // Điều chỉnh vị trí chấm đỏ
                    top: -2,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        drawer: Drawer(
          child: MenuScreen(),
        ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildnewarrive(),
            SizedBox(height: 20,),
            _buildProductList("Popular Shoes"),
            SizedBox(height: 20,),
            _buildProductList("Recommened for you")
          ],
        ),
      ),
        );
  }
  Widget _buildnewarrive(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tiêu đề + Nút "See all"
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "New Arrivals",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,
                    fontFamily: GoogleFonts.raleway().fontFamily
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Text(
                  "See all",
                  style: TextStyle(color: Colors.blue, fontSize: 14,
                      fontFamily: GoogleFonts.poppins().fontFamily
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          // Banner quảng cáo
          Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  spreadRadius: 1,
                )
              ],
            ),
            child: Stack(
              children: [
                // Nội dung bên trái
                Positioned(
                  left: 16,
                  top: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Summer Sale",
                        style: TextStyle(fontSize: 14, color: Colors.grey[700],
                            fontFamily: GoogleFonts.raleway().fontFamily
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "15% OFF",
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple,
                          fontFamily: GoogleFonts.raleway().fontFamily
                        ),
                      ),
                    ],
                  ),
                ),
                // Ảnh giày
                Positioned(
                  right: 10,
                  bottom: 15,
                  child: Image.asset(
                    "assets/images/onboard2.png", // Thay ảnh của bạn ở đây
                    height: 100,
                  ),
                ),
                Positioned(
                  right: 5,
                  bottom: 10,
                  child: Image.asset(
                  "assets/images/shadow.png", // Thay ảnh của bạn ở đây
                    fit: BoxFit.cover,
                    width: 100,
                ),),
                // Nhãn "NEW!"
                Positioned(
                  right: 90,
                  top: 20,
                  child: Transform.rotate(
                    angle: -0.2,
                    child: Text(
                      "NEW!",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildProductList(String title){
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      height: 230,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,
                    fontFamily: GoogleFonts.raleway().fontFamily
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Text(
                  "See all",
                  style: TextStyle(color: Colors.blue, fontSize: 14,
                      fontFamily: GoogleFonts.raleway().fontFamily
                  ),
                ),
              ),
            ],
          ),
          _buildProductListItem(),
        ],
      ),
    );
  }
  Widget _buildProductListItem() {
    return Container(
      height: 200, // Chiều cao danh sách sản phẩm
      child: LayoutBuilder(
        builder: (context, constraints) {
          double cardWidth = constraints.maxWidth * 0.4; // Chiều rộng card tối đa 40% màn hình
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemCount: 5,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder:(context)=>ProductDetailScreen()));
                  },
                  child: SizedBox(
                    width: cardWidth,
                    child: ProductCard(islove: false,),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

}
