import 'package:flutter/material.dart';
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
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildCartItemList(),
          _buildTotalCost(),
          _buildCheckoutButton(),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Center(
        child: Text(
          "My Cart",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: GoogleFonts.raleway().fontFamily),
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
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: Image.asset(item.imageUrl, width: 60, height: 60),
        title: Text(item.name, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("\$${item.price.toStringAsFixed(2)}"),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(icon: Icon(Icons.remove), onPressed: () => _decreaseQuantity(index)),
            Text("${item.quantity}"),
            IconButton(icon: Icon(Icons.add), onPressed: () => _increaseQuantity(index)),
            IconButton(icon: Icon(Icons.delete, color: Colors.red), onPressed: () => _removeItem(index)),
          ],
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
          Text("Subtotal: \$${subtotal.toStringAsFixed(2)}", style: TextStyle(fontSize: 16)),
          Text("Delivery: \$${deliveryFee.toStringAsFixed(2)}", style: TextStyle(fontSize: 16)),
          Text(
            "Total Cost: \$${totalCost.toStringAsFixed(2)}",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckoutButton() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => CheckoutScreen(totalCost: totalCost)));
        },
        style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, padding: EdgeInsets.symmetric(vertical: 12)),
        child: Text("Checkout", style: TextStyle(fontSize: 18, color: Colors.white)),
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
