import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sneaker_shop/Presentation/Features/Cart/CheckoutScreen.dart';
import 'package:sneaker_shop/Presentation/Features/Cart/cart_bloc.dart';
import 'package:sneaker_shop/Presentation/Features/Cart/cart_event.dart';
import 'package:sneaker_shop/Presentation/Widgets/LoadingWidget.dart';

import '../../../domains/model/CartModel.dart';
import 'package:sneaker_shop/Presentation/Features/Cart/cart_state.dart';

class CartScreen extends StatefulWidget {

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {

   CartModel? _cartModel;
   double _subtotal = 0.0;
   double _deliveryFee = 0.0;
   double _totaldiscount = 0.0;
   late CartBloc cartBloc;

   double get _totalCost => _subtotal + _deliveryFee - _totaldiscount;



   void _recalculatePrices() {
     double newSubtotal = 0.0;
     double newdiscount = 0.0;
     print(_cartModel.toString()+"nul me r");
     if (_cartModel != null) {
       for (var item in _cartModel!.cart_items) {
         double price = item.price;
         newdiscount += item.discountprice;
         newSubtotal += price - newdiscount ;
       }
     }
     double newDeliveryFee = newSubtotal >= 200 ? 0.0 : 15.0;
     print(newSubtotal.toString());
     setState(() {
       _subtotal = newSubtotal;
       _totaldiscount = newdiscount;
       _deliveryFee = newDeliveryFee;
     });
   }

  @override
  void initState() {
    super.initState();
    cartBloc = context.read<CartBloc>();
    cartBloc.add(FetchCart());
    _recalculatePrices();
    // _initializeCart();
  }




  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: _buildAppBar(screenWidth),
      body:Container(
        color: Color(0xFFF7F7F9),
        constraints: BoxConstraints.expand(),
        child: BlocConsumer<CartBloc,CartState>(
          bloc: cartBloc,
          listener: (context ,state) {
            if (state.status == CartStatus.updateSuccess) {
              cartBloc.add(FetchCart());
            }
            if (state.status == CartStatus.success && state.cartModel != null) {
              setState(() {
                _cartModel = state.cartModel;
                _recalculatePrices();
              });
              // if(state.status == CartStatus.confirmSuccess){
              //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Dat hang thanh cong")));
              //   Navigator.pop(context);
              // }
            }
          },
          builder: (context, state) {
            print(state.status.toString());
            if(state.status == CartStatus.success){
              print("yess");
              if(state.cartModel != null ){
                _cartModel = state.cartModel;
                return _buildCartScreen(screenWidth,screenHeight);
              }else{
                return Center(child: Text("Ban chua co san pham nao"));
              }
            }else if (state.status == CartStatus.failure){
              return Center(child: Text(state.message!));
            }else if (state.status == CartStatus.loading){
              return Center(child: LoadingWidet());
            }
            return Container(

            );

          },
        ),
    )
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

   Widget _buildCartScreen(double screenWidth,double screenHeight){
     return  Column(
         children: [
           _buildCartItemList(screenWidth, screenHeight),
           _buildTotalCost(screenWidth,screenHeight),
           // _buildCheckoutButton(screenWidth, screenHeight),
         ],
     );
   }
  Widget _buildCartItemList(double screenWidth, double screenHeight) {
    if (_cartModel == null || _cartModel!.cart_items.isEmpty) {
      return
         Expanded(child: Center(child: Text("cart empty"),));

    }
     return Expanded(
      child: ListView.builder(
        itemCount: _cartModel!.cart_items.length,
        itemBuilder: (context, index) {
          return _buildCartItem(_cartModel!.cart_items[index], index, screenWidth, screenHeight);
        },
      ),
    );
  }

   Widget _buildCartItem(CartItem item, int index, double screenWidth, double screenHeight) {
     return Slidable(
       key: ValueKey(item.name),
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
               onPressed: () => cartBloc.add(DeleteItemCart(productId: item.pro_id)),
             ),
           ),
         ],
       ),
       child: Stack(
         children: [
           Card(
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
                       child: Image.network(item.imageUrl,
                           width: screenWidth * 0.22,
                           height: screenWidth * 0.22,
                           fit: BoxFit.contain),
                     ),
                   ),
                   SizedBox(width: screenWidth * 0.04),
                   Expanded(
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Text(
                           item.name,
                           maxLines: 2,
                           overflow: TextOverflow.ellipsis,
                           style: TextStyle(
                             fontSize: screenWidth * 0.045,
                             fontWeight: FontWeight.bold,
                             fontFamily: GoogleFonts.raleway().fontFamily,
                           ),
                         ),
                         SizedBox(height: screenHeight * 0.005),
                         Text("\$${item.price.toStringAsFixed(2)}",
                             style: TextStyle(
                               fontSize: screenWidth * 0.04,
                               color: Colors.grey,
                               fontFamily: GoogleFonts.poppins().fontFamily,
                             )),
                       ],
                     ),
                   ),
                 ],
               ),
             ),
           ),
           if (item.stock == 0)
             Positioned.fill(
               child: Container(
                 decoration: BoxDecoration(
                   color: Colors.white.withOpacity(0.75),
                   borderRadius: BorderRadius.circular(10),
                 ),
                 child: Center(
                   child: Text(
                     "Out of Stock",
                     style: TextStyle(
                       color: Colors.redAccent,
                       fontSize: screenWidth * 0.045,
                       fontWeight: FontWeight.bold,
                       fontFamily: GoogleFonts.poppins().fontFamily,
                     ),
                   ),
                 ),
               ),
             ),
         ],
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
            _buildPriceRow("Subtotal", _subtotal, screenWidth),
            _buildPriceRow("Totaldiscount", _totaldiscount, screenWidth),
            _buildPriceRow("Delivery", _deliveryFee, screenWidth),
            Divider(thickness: 1, color: Colors.grey[300]),
            _buildPriceRow("Total Cost", _totalCost, screenWidth, isTotal: true),
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
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider.value(
                value: cartBloc,
                child: CheckoutScreen(totalCost: _totalCost, Subtotal: _subtotal, Delivery: _deliveryFee, discount: _totaldiscount, cartItem: _cartModel!,),
              ),
            ),
          );
          //Navigator.push(context, MaterialPageRoute(builder: (context) => CheckoutScreen(totalCost: _totalCost, Subtotal: _subtotal, Delivery: _deliveryFee, discount: _totaldiscount, cartItem: _cartModel!,)));
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


