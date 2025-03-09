import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sneaker_shop/Presentation/Features/Cart/CheckoutScreen.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<CartItem> cartItems = [
    CartItem(name: "Nike Club Max",
        price: 584.95,
        quantity: 1,
        imageUrl: "assets/images/onboard1.png"),
    CartItem(name: "Nike Air Max 200",
        price: 94.05,
        quantity: 1,
        imageUrl: "assets/images/onboard2.png"),
    CartItem(name: "Nike Air Max 270 Essential",
        price: 74.95,
        quantity: 1,
        imageUrl: "assets/images/onboard3.png"),
  ];

  double get subtotal =>
      cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));
  double deliveryFee = 60.20;

  double get totalCost => subtotal + deliveryFee;

  void _increaseQuantity(int index) {
    setState(() {
      cartItems[index].quantity++;
    });
  }

  void _decreaseQuantity(int index) {
    if (cartItems[index].quantity > 1) {
      setState(() {
        cartItems[index].quantity--;
      });
    }
  }

  void _removeItem(int index) {
    setState(() {
      cartItems.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Container(
        constraints: BoxConstraints.expand(),
        color: Color(0xFFF7F7F9),
        child: Column(
          children: [
            _buildCartItemList(),
            _buildTotalCost(),
            _buildCheckoutButton(),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Center(
        child: Text(
          "My Cart",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, fontFamily: GoogleFonts
              .raleway()
              .fontFamily),
        ),
      ),

      backgroundColor: Colors.white,
      elevation: 0,
    );
  }

  Widget _buildCartItemList() {
    return Expanded(
      child: ListView.builder(
        itemCount: cartItems.length,
        itemBuilder: (context, index) {
          return _buildCartItem(cartItems[index], index);
        },
      ),
    );
  }

  Widget _buildCartItem(CartItem item, int index) {
    double screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    double screenHeight = MediaQuery
        .of(context)
        .size
        .height;

    return Slidable(
      key: ValueKey(item.name),
      startActionPane: ActionPane(
        motion: const BehindMotion(),
        children: [
          Container(
            width: screenWidth * 0.15, // 15% chiều rộng màn hình
            height: screenHeight * 0.17, // 12% chiều cao màn hình
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(
                      Icons.add, color: Colors.white, size: screenWidth * 0.05),
                  onPressed: () => _increaseQuantity(index),
                ),
                Text("${item.quantity}",
                    style: TextStyle(
                        color: Colors.white, fontSize: screenWidth * 0.04)),
                IconButton(
                  icon: Icon(Icons.remove, color: Colors.white,
                      size: screenWidth * 0.05),
                  onPressed: () => _decreaseQuantity(index),
                ),
              ],
            ),
          ),
        ],
      ),

      // Vuốt sang trái (Hiện container xóa)
      endActionPane: ActionPane(
        motion: const BehindMotion(),
        children: [
          Container(
            width: screenWidth * 0.15,
            height: screenHeight * 0.12,
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(10),
            ),
            child: IconButton(
              icon: Icon(
                  Icons.delete, color: Colors.white, size: screenWidth * 0.06),
              onPressed: () => _removeItem(index),
            ),
          ),
        ],
      ),

      // Nội dung chính
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.03, vertical: screenHeight * 0.01),
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.03),
          child: Row(
            children: [
              // Ảnh sản phẩm
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(item.imageUrl,
                    width: screenWidth * 0.2, // 20% chiều rộng màn hình
                    height: screenWidth * 0.2,
                    fit: BoxFit.cover
                ),
              ),
              SizedBox(width: screenWidth * 0.04),

              // Thông tin sản phẩm
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name,
                      style: TextStyle(fontSize: screenWidth * 0.045,
                          fontWeight: FontWeight.bold)),
                  SizedBox(height: screenHeight * 0.005),
                  Text("\$${item.price.toStringAsFixed(2)}",
                      style: TextStyle(
                          fontSize: screenWidth * 0.04, color: Colors.grey)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildTotalCost() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Subtotal", style: TextStyle(fontSize: 16, color: Colors.black)),
              Text("\$${subtotal.toStringAsFixed(2)}",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Delivery", style: TextStyle(fontSize: 16, color: Colors.black)),
              Text("\$${deliveryFee.toStringAsFixed(2)}",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
          SizedBox(height: 10),
          Divider(thickness: 1, color: Colors.grey[300]), // Đường kẻ ngăn cách
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Total Cost",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
              Text("\$${totalCost.toStringAsFixed(2)}",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue)),
            ],
          ),
        ],
      ),
    );
  }


  Widget _buildCheckoutButton() {
    return Container(
      height: 48,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      width: double.infinity,
      child: ElevatedButton(onPressed: () {
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => CheckoutScreen(totalCost: totalCost)));
      }, style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF0D6EFD),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14)
          )
      ), child: Text("Checkout",
        style: TextStyle(color: Colors.white,
        ),
      )),
    );
  }
}

class CartItem {
  String name;
  double price;
  int quantity;
  String imageUrl;

  CartItem({required this.name, required this.price, required this.quantity, required this.imageUrl});
}
