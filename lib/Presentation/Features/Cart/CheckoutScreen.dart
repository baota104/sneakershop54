import 'package:flutter/material.dart';

class CheckoutScreen extends StatefulWidget {
  final double totalCost;

  CheckoutScreen({required this.totalCost});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildContactInfo(),
            SizedBox(height: 10),
            _buildAddress(),
            SizedBox(height: 10),
            _buildPaymentMethod(),
            SizedBox(height: 20),
            Divider(thickness: 1, color: Colors.grey[300]), // Đường kẻ
            SizedBox(height: 10),
            _buildTotalCost(),
            _buildCheckoutButton(),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        "My Cart",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
      ),
      centerTitle: true,
    );
  }

  Widget _buildContactInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Contact Information", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        ListTile(
          leading: Icon(Icons.email, color: Colors.blue),
          title: Text("Baodeptrai@gmail.com", style: TextStyle(fontSize: 16)),
          subtitle: Text("Email", style: TextStyle(color: Colors.grey)),
          trailing: Icon(Icons.edit, color: Colors.grey),
        ),
        ListTile(
          leading: Icon(Icons.phone, color: Colors.blue),
          title: Text("+084-113", style: TextStyle(fontSize: 16)),
          subtitle: Text("Phone", style: TextStyle(color: Colors.grey)),
          trailing: Icon(Icons.edit, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildAddress() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Address", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        ListTile(
          leading: Icon(Icons.location_on, color: Colors.blue),
          title: Text("Nhan Chinh, Hanoi", style: TextStyle(fontSize: 16)),
          subtitle: Text("View Map", style: TextStyle(color: Colors.grey)),
          trailing: Icon(Icons.arrow_drop_down, color: Colors.grey),
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.asset("assets/images/map1.png", width: double.infinity, height: 150, fit: BoxFit.cover),
        ),
      ],
    );
  }

  Widget _buildPaymentMethod() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Payment Method", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        ListTile(
          leading: Icon(Icons.credit_card, color: Colors.blue),
          title: Text("MB Bank", style: TextStyle(fontSize: 16)),
          subtitle: Text("**** 0543", style: TextStyle(color: Colors.grey)),
          trailing: Icon(Icons.arrow_drop_down, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildTotalCost() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Subtotal", style: TextStyle(fontSize: 16, color: Colors.black)),
              Text("\$753.95", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Delivery", style: TextStyle(fontSize: 16, color: Colors.black)),
              Text("\$60.20", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
          SizedBox(height: 10),
          Divider(thickness: 1, color: Colors.grey[300]), // Đường kẻ
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Total Cost", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
              Text("\$${widget.totalCost.toStringAsFixed(2)}",
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
        _showPaymentSuccessDialog();
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
  void _showPaymentSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // Người dùng không thể bấm ra ngoài để đóng
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset("assets/images/success.png", height: 100), // Hình ảnh biểu tượng 🎉
                SizedBox(height: 20),
                Text(
                  "Your Payment Is Successful",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Đóng Dialog
                    Navigator.pop(context); // Quay lại trang trước
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text("Back To Shopping", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

}

