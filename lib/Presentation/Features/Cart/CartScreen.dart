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
    CartItem(name: "Nike Club Max", price: 584.95, quantity: 1, imageUrl: "assets/images/onboard1.png"),
    CartItem(name: "Nike Air Max 200", price: 94.05, quantity: 1, imageUrl: "assets/images/onboard2.png"),
    CartItem(name: "Nike Air Max 270 Essential", price: 74.95, quantity: 1, imageUrl: "assets/images/onboard3.png"),
    CartItem(name: "Nike Air Max 270 Essential", price: 74.95, quantity: 1, imageUrl: "assets/images/onboard3.png"),
    CartItem(name: "Nike Air Max 270 Essential", price: 74.95, quantity: 1, imageUrl: "assets/images/onboard3.png"),
  ];

  double get subtotal => cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));
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
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: _buildAppBar(screenWidth),
      body: Container(
        color: Color(0xFFF7F7F9),
        child: Column(
          children: [
            _buildCartItemList(screenWidth, screenHeight),
            _buildTotalCost(screenWidth,screenHeight),
            // _buildCheckoutButton(screenWidth, screenHeight),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar(double screenWidth) {
    return AppBar(
      centerTitle: true,
        title: Text(
          "My Cart",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black,
            fontFamily: GoogleFonts.raleway().fontFamily,
          ),
        ),

      backgroundColor: Colors.white,
      elevation: 10,
    );
  }

  Widget _buildCartItemList(double screenWidth, double screenHeight) {
    return Expanded(
      child: ListView.builder(
        itemCount: cartItems.length,
        itemBuilder: (context, index) {
          return _buildCartItem(cartItems[index], index, screenWidth, screenHeight);
        },
      ),
    );
  }

  Widget _buildCartItem(CartItem item, int index, double screenWidth, double screenHeight) {
    return Slidable(
      key: ValueKey(item.name),
      startActionPane: ActionPane(
        motion: const BehindMotion(),
        extentRatio: 0.20,
        children: [
          Container(
            width: screenWidth * 0.15,
            height: screenHeight * 0.17,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.add, color: Colors.white, size: screenWidth * 0.06),
                  onPressed: () => _increaseQuantity(index),
                ),
                Text("${item.quantity}",
                    style: TextStyle(color: Colors.white, fontSize: screenWidth * 0.045)),
                IconButton(
                  icon: Icon(Icons.remove, color: Colors.white, size: screenWidth * 0.06),
                  onPressed: () => _decreaseQuantity(index),
                ),
              ],
            ),
          ),
        ],
      ),
      endActionPane: ActionPane(
        motion: const BehindMotion(),
        extentRatio: 0.20,
        children: [
          Container(
            width: screenWidth * 0.15,
            height: screenHeight * 0.12,
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(10),
            ),
            child: IconButton(
              icon: Icon(Icons.delete, color: Colors.white, size: screenWidth * 0.07),
              onPressed: () => _removeItem(index),
            ),
          ),
        ],
      ),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.03, vertical: screenHeight * 0.015),
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.04),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  color: Color(0xFFF7F7F9),
                  child: Image.asset(item.imageUrl,
                      width: screenWidth * 0.22,
                      height: screenWidth * 0.22,
                      fit: BoxFit.cover),
                ),
              ),
              SizedBox(width: screenWidth * 0.04),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name,
                      style: TextStyle(fontSize: screenWidth * 0.045, fontWeight: FontWeight.bold,
                      fontFamily: GoogleFonts.raleway().fontFamily,
                      )),
                  SizedBox(height: screenHeight * 0.005),
                  Text("\$${item.price.toStringAsFixed(2)}",
                      style: TextStyle(fontSize: screenWidth * 0.04, color: Colors.grey,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                      )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTotalCost(double screenWidth,double screenHeight) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: 10),
        child: Column(
          children: [
            _buildPriceRow("Subtotal", subtotal, screenWidth),
            _buildPriceRow("Delivery", deliveryFee, screenWidth),
            Divider(thickness: 1, color: Colors.grey[300]),
            _buildPriceRow("Total Cost", totalCost, screenWidth, isTotal: true),
            _buildCheckoutButton(screenWidth, screenHeight)
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRow(String label, double amount, double screenWidth, {bool isTotal = false}) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(fontSize: screenWidth * 0.045, fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                fontFamily: GoogleFonts.raleway().fontFamily,
              )),
          Text("\$${amount.toStringAsFixed(2)}",
              style: TextStyle(fontSize: screenWidth * 0.045, fontWeight: FontWeight.bold, color: isTotal ? Colors.blue : Colors.black,
                fontFamily: GoogleFonts.poppins().fontFamily,
              )),
        ],
      ),
    );
  }

  Widget _buildCheckoutButton(double screenWidth, double screenHeight) {
    return Container(
      height: screenHeight * 0.06,
      margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: screenHeight * 0.02),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => CheckoutScreen(totalCost: totalCost, Subtotal: subtotal, Delivery: deliveryFee,)));
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF0D6EFD),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        child: Text("Checkout", style: TextStyle( color: Colors.white)),
      ),
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
