import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main/each_screen/MainScreen.dart';

class CheckoutScreen extends StatefulWidget {
  final double totalCost;
  final double Subtotal;
  final double Delivery;
  final double discount;

  CheckoutScreen({
    required this.totalCost,
    required this.Subtotal,
    required this.Delivery,
    required this.discount
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  bool isEditingEmail = false;
  bool isEditingPhone = false;
  String? userId;
  Map<String, dynamic>? userData;
  TextEditingController emailController = TextEditingController(text: "bao@gmail.com");
  TextEditingController phoneController = TextEditingController(text: "+084-113");

  @override
  void initState() {
    super.initState();
    _loadUserData();

  }
  /// Lấy UID từ SharedPreferences và truy vấn Firestore
  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? uid = prefs.getString('uid');

    print("UID lấy từ SharedPreferences: $uid"); // Kiểm tra UID

    if (uid != null) {
      setState(() {
        userId = uid;
      });
      try {
        DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection("Users").doc(uid).get();

        print("Dữ liệu lấy từ Firestore: ${userDoc.data()}"); // Kiểm tra dữ liệu lấy về

        if (userDoc.exists) {
          setState(() {
            userData = userDoc.data() as Map<String, dynamic>;
            emailController.text = userData?["email"] ?? "bao@gmail.com";
            phoneController.text = userData?["phone"] ?? "+084-113";
          });
        } else {
          print("Không tìm thấy user trong Firestore.");
        }
      } catch (e) {
        print("Lỗi khi lấy dữ liệu từ Firestore: $e");
      }
    } else {
      print("UID chưa được lưu hoặc bị null.");
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double padding = screenWidth * 0.05;

    return Scaffold(
      appBar: _buildAppBar(context),
      body: Container(
        color: Color(0xFFF7F7F9),
        // constraints: BoxConstraints.expand(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _buildInfo(screenWidth, screenHeight)),
                _buildTotalCost(screenWidth, screenHeight)
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
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black,
          fontFamily: GoogleFonts.raleway().fontFamily,
        ),
      ),
      centerTitle: true,
    );
  }
  Widget _buildInfo(double screenWidth,double screenHeight  ){
    return Container(
      margin: EdgeInsets.symmetric(horizontal:screenWidth * 0.05 ),
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildContactInfo(screenWidth),
            SizedBox(height: screenHeight * 0.02),
            _buildAddress(screenWidth),
            SizedBox(height: screenHeight * 0.02),
            _buildPaymentMethod(screenWidth),
          ],
        ),
      ),
    );
  }
  Widget _buildContactInfo(double screenWidth) {
    double fontSize = screenWidth * 0.04;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Contact Information", style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize,
        fontFamily: GoogleFonts.raleway().fontFamily,
        )),
        _editableField(Icons.email_outlined, "Email", emailController, isEditingEmail, () {
          setState(() {
            isEditingEmail = !isEditingEmail;
            isEditingPhone = false; // Đóng phone khi mở email
          });
        }, fontSize),
        _editableField(Icons.phone, "Phone", phoneController, isEditingPhone, () {
          setState(() {
            isEditingPhone = !isEditingPhone;
            isEditingEmail = false; // Đóng email khi mở phone
          });
        }, fontSize),
      ],
    );
  }

  Widget _editableField(
      IconData icon, String label, TextEditingController controller, bool isEditing, VoidCallback onEdit, double fontSize) {
    return ListTile(
      leading: Icon(icon, color: Colors.black, size: fontSize * 1.2),
      title: isEditing
          ? TextFormField(
        controller: controller,
        style: TextStyle(fontSize: fontSize,
          fontFamily: GoogleFonts.poppins().fontFamily,
        ),
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        ),
      )
          : Text(controller.text, style: TextStyle(fontSize: fontSize,
        fontFamily: GoogleFonts.poppins().fontFamily,
      )),
      subtitle: Text(label, style: TextStyle(color: Colors.grey, fontSize: fontSize * 0.9)),
      trailing: IconButton(
        icon: Icon(Icons.edit, color: Colors.grey, size: fontSize),
        onPressed: onEdit,
      ),
    );
  }
  Widget _buildAddress(double screenWidth) {
    double fontSize = screenWidth * 0.04;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Address", style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize,
          fontFamily: GoogleFonts.raleway().fontFamily,
        )),
        ListTile(
          leading: Icon(Icons.location_on_rounded, color: Colors.black, size: fontSize * 1.2),
          title: Text(userData!= null?userData!["address"]:"Nhan Chinh, Hanoi", style: TextStyle(fontSize: fontSize,
            fontFamily: GoogleFonts.poppins().fontFamily,
          )),
          subtitle: Text("View Map", style: TextStyle(color: Colors.grey, fontSize: fontSize * 0.9,
            fontFamily: GoogleFonts.raleway().fontFamily,
          )),
          trailing: Icon(Icons.arrow_drop_down, color: Colors.grey, size: fontSize),
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.asset("assets/images/map1.png",
              width: double.infinity, height: screenWidth * 0.4, fit: BoxFit.cover),
        ),
      ],
    );
  }

  Widget _buildPaymentMethod(double screenWidth) {
    double fontSize = screenWidth * 0.04;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Payment Method", style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize,
          fontFamily: GoogleFonts.raleway().fontFamily,
        )),
        ListTile(
          leading: Icon(Icons.credit_card, color: Colors.black, size: fontSize * 1.2),
          title: Text("MB Bank", style: TextStyle(fontSize: fontSize)),
          subtitle: Text("**** 0543", style: TextStyle(color: Colors.grey, fontSize: fontSize * 0.9)),
          trailing: Icon(Icons.arrow_drop_down, color: Colors.grey, size: fontSize),
        ),
      ],
    );
  }

  Widget _buildTotalCost(double screenWidth, double screenHeight) {
    return Container(
      width: double.infinity, // Đảm bảo chiếm toàn bộ chiều rộng
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: 15), // Thêm padding để nhìn thoáng hơn
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)), // Bo góc trên cho đẹp
        boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 10, spreadRadius: 2)], // Đổ bóng nhẹ
      ),
      child: Column(
        children: [
          _buildPriceRow("Subtotal", widget.Subtotal, screenWidth),
          _buildPriceRow("Delivery", widget.Delivery, screenWidth),
          _buildPriceRow("Totaldiscount", widget.discount, screenWidth),
          Divider(thickness: 1, color: Colors.grey[300]),
          _buildPriceRow("Total Cost", widget.totalCost, screenWidth, isTotal: true),
          _buildCheckoutButton(screenWidth, screenHeight),
        ],
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
         _showPaymentSuccessDialog();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF0D6EFD),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        child: Text("Checkout", style: TextStyle( color: Colors.white)),
      ),
    );
  }

  void _showPaymentSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset("assets/images/success.png", height: 100),
                SizedBox(height: 20),
                Text(
                  "Your Payment Is Successful",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,
                  fontFamily: GoogleFonts.raleway().fontFamily
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>MainScreen(navigatorPage: 0)),
                      ModalRoute.withName('/'),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text("Back To Shopping", style: TextStyle(color: Colors.white,
                      fontFamily: GoogleFonts.raleway().fontFamily
                  )),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
