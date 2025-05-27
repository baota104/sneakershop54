
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sneaker_shop/Presentation/Features/Cart/CartScreen.dart';
import 'package:sneaker_shop/Presentation/Features/Cart/map/Googmapicker.dart';
import 'package:sneaker_shop/Presentation/Features/main/each_screen/MainScreen.dart';
import 'package:sneaker_shop/Presentation/Features/main/each_screen/order/orderscreen.dart';
import 'package:sneaker_shop/Presentation/Features/main/each_screen/profile/user_bloc.dart';
import 'package:sneaker_shop/Presentation/Features/main/each_screen/profile/user_event.dart';
import 'package:sneaker_shop/Presentation/Features/main/each_screen/profile/user_state.dart';
import 'package:sneaker_shop/Presentation/Widgets/LoadingWidget.dart';
import 'package:sneaker_shop/domains/model/UserModel.dart';

import '../../Cart/cart_bloc.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  late CartBloc cartBloc;
  UserModel? userModel; // Sửa thành nullable
  late UserBloc userBloc;

  @override
  void initState() {
    super.initState();
    cartBloc = context.read<CartBloc>();
    userBloc = context.read<UserBloc>();
    userBloc.add(GetUser());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<UserBloc, UserStateBase>(
        bloc: userBloc,
        listener: (context, state) {
          if (state is GetUserSuccess) {
            setState(() {
              userModel = state.userModel;
            });
          }
        },
        builder: (context, state) {
          if (state is UserStateLoading || userModel == null) {
            return Center(child: LoadingWidet());
          } else if (state is GetUserSuccess || userModel != null) {
            return SafeArea(
              child: Container(
                color: Color(0xFF1483C2),
                constraints: BoxConstraints.expand(),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildprofile(),
                      _buildMenuItem(Icons.person, "Profile"),
                      _buildMenuItem(Icons.shopping_cart_outlined, "My Cart"),
                      _buildMenuItem(Icons.favorite, "Favorite"),
                      _buildMenuItem(Icons.fire_truck, "Orders"),
                      _buildMenuItem(Icons.notifications, "Notifications"),
                      _buildMenuItem(Icons.settings, "Settings"),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 40),
                        child: Divider(color: Colors.white54),
                      ),
                      _buildMenuItem(Icons.logout, "Sign Out"),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  Widget _buildprofile() {
    if (userModel == null) return SizedBox(); // Tránh lỗi nếu null

    return Container(
      alignment: Alignment.topLeft,
      margin: EdgeInsets.only(top: 30, left: 25),
      child: Column(
        children: [
          ClipOval(
            child: Container(
              width: 96,
              height: 96,
              child: Image.network(
                userModel!.imageurl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Text(
            userModel!.name,
            style: TextStyle(
              fontSize: 20,
              fontFamily: GoogleFonts.raleway().fontFamily,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
      child: InkWell(
        onTap: () => _navigateToPage(title),
        splashColor: Colors.white,
        highlightColor: Colors.white,
        child: ListTile(
          leading: Icon(icon, color: Colors.white),
          title: Text(title, style: TextStyle(color: Colors.white, fontSize: 16)),
          trailing: Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
        ),
      ),
    );
  }

  Future<void> _navigateToPage(String title) async {
    Navigator.pop(context);
    if (title == "Profile") {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainScreen(navigatorPage: 4)));
    } else if (title == "My Cart") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: cartBloc,
            child: CartScreen(),
          ),
        ),
      );
    } else if (title == "Favorite") {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainScreen(navigatorPage: 2)));
    } else if (title == "Orders") {
      Navigator.push(context, MaterialPageRoute(builder: (context) => OrderscreenContainer()));
    } else if (title == "Notifications") {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainScreen(navigatorPage: 3)));
    } else if (title == "Settings") {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final result = prefs.setBool("kOnboardingCompleted",false);
    } else if (title == "Sign Out") {
      await logout();
    }
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('uid');
    print("Đã đăng xuất và xóa UID");
  }
}
