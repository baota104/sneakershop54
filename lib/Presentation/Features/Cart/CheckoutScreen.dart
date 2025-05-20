import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sneaker_shop/Presentation/Features/Cart/cart_bloc.dart';
import 'package:sneaker_shop/Presentation/Features/Cart/cart_event.dart';
import 'package:sneaker_shop/Presentation/Widgets/LoadingWidget.dart';
import 'package:sneaker_shop/domains/data_source/remote/firebase/user_firebase.dart';
import 'package:sneaker_shop/domains/model/CartModel.dart';
import 'package:sneaker_shop/domains/model/OrderDetail.dart';
import 'package:sneaker_shop/domains/model/OrderModel.dart';
import 'package:sneaker_shop/domains/model/PaymentModel.dart';
import 'package:sneaker_shop/domains/model/UserModel.dart';
import 'package:uuid/uuid.dart';

import '../main/each_screen/MainScreen.dart';
import 'cart_state.dart';

class CheckoutScreen extends StatefulWidget {
  final double totalCost;
  final double Subtotal;
  final double Delivery;
  final double discount;
  final CartModel cartItem;

  CheckoutScreen({
    required this.totalCost,
    required this.Subtotal,
    required this.Delivery,
    required this.discount,
    required this.cartItem
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  bool isEditingEmail = false;
  bool isEditingPhone = false;
  String? userId;
  Map<String, dynamic>? userData;
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  late CartBloc cartBloc;
  String selectedPaymentMethod = "Cash on delivery";
  bool isExpanded = false;
  final UserFirebase _userFirebase = UserFirebase();
  late UserModel _userModel;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    cartBloc = context.read<CartBloc>();
    _loadUserData();

  }
  /// Lấy UID từ SharedPreferences và truy vấn Firestore
  Future<void> _loadUserData() async {
    _userModel = (await _userFirebase.getUser())!;
    print(_userModel.toString());
    emailController.text = _userModel.email ?? '';
    phoneController.text = _userModel.phone ?? '';
    addressController.text = _userModel.address ?? '';
    setState(() {}); // trigger rebuild
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double padding = screenWidth * 0.05;

    return Scaffold(
      appBar: _buildAppBar(context),
      body: BlocConsumer<CartBloc,CartState>(
  listener: (context, state) {
    // if(state.status == CartStatus.paymentSuccess){
    //   print("tao payment thanh cong");
    // }
    // else{
    //   print("tao payment that bai")
    // }
  },
  builder: (context, state) {
    if(state.status == CartStatus.orderSuccess){
      // _showPaymentSuccessDialog();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showPaymentSuccessDialog();
      });
    }
    else if(state.status == CartStatus.orderError){
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(state.message.toString()),
          backgroundColor: Colors.green,
        ));
      });
    }
    // else{
    //   return Center(child: LoadingWidet(),);
    // }
    return Container(
        color: Color(0xFFF7F7F9),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _buildInfo(screenWidth, screenHeight)),
                _buildTotalCost(screenWidth, screenHeight)
              ],
            ),
          );
  },
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
        child: Form(
          key: _formKey,
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
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '$label is required';
            }
            if (label == "Email" && !RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
              return 'Enter a valid email';
            }
            if (label == "Phone" && !RegExp(r'^\d{9,11}$').hasMatch(value)) {
              return 'Enter a valid phone number';
            }
            return null;
          },
          style: TextStyle(
            fontSize: fontSize,
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
        Text(
          "Address",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: fontSize,
            fontFamily: GoogleFonts.raleway().fontFamily,
          ),
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(Icons.location_on_rounded, color: Colors.black, size: fontSize * 1.2),
          title: TextFormField(
            controller: addressController,
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return "Address is required";
              }
            },
            decoration: InputDecoration(
              hintText: "Enter your address",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
            style: TextStyle(fontSize: fontSize, fontFamily: GoogleFonts.poppins().fontFamily),
          ),
          trailing: IconButton(
            icon: Icon(Icons.check, color: Colors.green, size: fontSize * 1.2),
            onPressed: () {
              // setState(() {
              //   // Gán lại dữ liệu nếu muốn lưu
              //   userData ??= {};
              //   userData!["address"] = _addressController.text;
              // });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethod(double screenWidth) {
    double fontSize = screenWidth * 0.04;

    final List<Map<String, String>> methods = [
      {"name": "e-banking", "details": "**** 0543"},
      {"name": "Momo", "details": "0988***123"},
      {"name": "ZaloPay", "details": "zalo_user_abc"},
      {"name": "Cash on delivery", "details": "COD"},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Payment Method",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: fontSize,
            fontFamily: GoogleFonts.raleway().fontFamily,
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.credit_card, color: Colors.black, size: fontSize * 1.2),
            title: Text(selectedPaymentMethod, style: TextStyle(fontSize: fontSize)),
            subtitle: Text("Chạm để chọn phương thức khác", style: TextStyle(color: Colors.grey, fontSize: fontSize * 0.9)),
            trailing: Icon(
              isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              color: Colors.grey,
              size: fontSize * 1.2,
            ),
          ),
        ),
        if (isExpanded)
          Column(
            children: methods
                .where((method) => method["name"] != selectedPaymentMethod)
                .map((method) => ListTile(
              contentPadding: EdgeInsets.only(left: screenWidth * 0.12),
              title: Text(method["name"]!, style: TextStyle(fontSize: fontSize)),
              subtitle: Text(method["details"]!, style: TextStyle(color: Colors.grey, fontSize: fontSize * 0.9)),
              onTap: () {
                setState(() {
                  selectedPaymentMethod = method["name"]!;
                  isExpanded = false;
                });
              },
            ))
                .toList(),
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
          if (_formKey.currentState!.validate()) {
            var uuid = Uuid();
            String orderId = uuid.v4();
            String userId = widget.cartItem.user_id;
            DateTime time = DateTime.now();
            String address = addressController.text;

            List<OrderDetail> orderdetail = widget.cartItem.cart_items.map((i) {
              return OrderDetail(
                productId: i.pro_id,
                name: i.name,
                imageUrl: i.imageUrl,
                price: i.price,
                discountprice: i.discountprice,
              );
            }).toList();

            var orderModel = OrderModel(
              orderId: orderId,
              userId: userId,
              status: "pending",
              paymentmethod: selectedPaymentMethod,
              totalAmount: widget.totalCost,
              orderDetails: orderdetail,
              time: time,
              address: address,
            );

            cartBloc.add(CreateOrder(orderModel: orderModel));
            if(selectedPaymentMethod != "Cash on delivery"){
              var uuid = Uuid();
              String paymentId = uuid.v4();
              PaymentModel paymentModel = PaymentModel(paymentId: paymentId, orderId: orderId, userId: userId, paymentMethod: selectedPaymentMethod, paymentStatus: "completed", totalamount: widget.totalCost, createdAt: time);
              cartBloc.add(CreatePayment(paymentModel: paymentModel));
            }
          }
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
