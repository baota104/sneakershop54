import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CheckoutScreen extends StatelessWidget {
  final double totalCost;

  CheckoutScreen({required this.totalCost});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildContactInfo(),
            _buildAddress(),
            _buildPaymentMethod(),
            _buildTotalCost(),
            _buildCheckoutButton(),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text("My Cart", style: TextStyle(fontWeight: FontWeight.bold)),
      backgroundColor: Colors.white,
      elevation: 0,
    );
  }

  Widget _buildContactInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Contact Information", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        ListTile(
          leading: Icon(Icons.email),
          title: Text("Baodeptrai@gmail.com"),
          subtitle: Text("Email"),
        ),
        ListTile(
          leading: Icon(Icons.phone),
          title: Text("+084-113"),
          subtitle: Text("Phone"),
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
          leading: Icon(Icons.location_on),
          title: Text("Nhan chinh, Hanoi"),
          subtitle: Text("View Map"),
          trailing: Icon(Icons.arrow_forward_ios),
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
          leading: Icon(Icons.credit_card),
          title: Text("Mb bank"),
          subtitle: Text("**** 0543"),
        ),
      ],
    );
  }

  Widget _buildTotalCost() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Text(
        "Total Cost: \$${totalCost.toStringAsFixed(2)}",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
      ),
    );
  }

  Widget _buildCheckoutButton() {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, padding: EdgeInsets.symmetric(vertical: 12)),
      child: Text("Checkout", style: TextStyle(fontSize: 18, color: Colors.white)),
    );
  }
}
