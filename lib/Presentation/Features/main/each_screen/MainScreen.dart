

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sneaker_shop/Presentation/Features/Product/ProductDetail.dart';
import 'package:sneaker_shop/Presentation/Features/main/each_screen/home/Home_Screen.dart';
import 'package:sneaker_shop/Presentation/Features/main/each_screen/Menu_Screen.dart';
import 'package:sneaker_shop/Presentation/Features/main/each_screen/favorite/FavoriteScreen.dart';
import 'package:sneaker_shop/Presentation/Features/main/each_screen/notification/NotificationScreen.dart';
import 'package:sneaker_shop/Presentation/Features/main/each_screen/profile/Profile_Screen.dart';
import 'package:sneaker_shop/Presentation/Features/main/each_screen/search/SearchScreen.dart';

import '../../../../domains/data_source/remote/firebase/product_firebase.dart';
import '../../../../domains/repository/product_repository.dart';
import 'home/Home_product_bloc.dart';
class MainScreen extends StatelessWidget {
  final int navigatorPage;

  const MainScreen({super.key, required this.navigatorPage});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (context) => Productfirebase()),
        ProxyProvider<Productfirebase, ProductRepository>(
          update: (context, productFirebase, _) => ProductRepository(productFirebase),
        ),
        ProxyProvider<ProductRepository, HomeProductBloc>(
          update: (context, repository, _) => HomeProductBloc(repository),
        ),
      ],
      child: MainScreenBody(navigatorpage: navigatorPage),
    );
  }
}

class MainScreenBody extends StatefulWidget {
  final navigatorpage;
  const MainScreenBody({super.key, required this.navigatorpage});

  @override
  State<MainScreenBody> createState() => _MainScreenBodyState();
}

class _MainScreenBodyState extends State<MainScreenBody> {
  List<Widget> _pages = [];
  int _currentPage = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _currentPage = widget.navigatorpage;
    _pages = [
      HomeScreen(),
      Searchscreen(),
      FavoriteScreen(),
      NotificationScreen(),
     ProfileScreen()
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   leading: IconButton(onPressed: (){},
      //       icon: icon
      //   ),
      // ),
      backgroundColor: Color(0xFF121212),
      body: _pages.elementAt(_currentPage),
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          unselectedItemColor: Colors.white,
          selectedItemColor: Color(0xFF0D6EFD),
          currentIndex: _currentPage,
          onTap: (index) {
            if (index == 2) return;
            setState(() {
              _currentPage = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_filled,
                color: Colors.grey,
              ),
              activeIcon:  Icon(Icons.home_filled,
                color: Colors.grey,
              ),
              backgroundColor: Colors.transparent,
              label: "Home",

            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search,
                color: Colors.grey,
              ),
              activeIcon: Icon(Icons.search,
                color: Colors.grey,
              ),
              backgroundColor: Colors.transparent,
              label: "Search",
            ),
            BottomNavigationBarItem(
              icon: Container(),
              label: "",
              backgroundColor: Colors.transparent,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications,
                color: Colors.grey,
              ),
              activeIcon: Icon(Icons.notifications,
                color: Colors.grey,
              ),
              backgroundColor: Colors.transparent,
              label: "Notification",
            ),
            BottomNavigationBarItem(
              icon:Icon(Icons.person,
                color: Colors.grey,
              ),
              activeIcon:
              Icon(Icons.person,
                color: Colors.grey,
              ),
              backgroundColor: Colors.transparent,
              label: "Profile",
            ),
          ]
      ),
      floatingActionButton: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
            color: Color(0xFF0D6EFD),
            borderRadius: BorderRadius.circular(32)
        ),
        child: IconButton(onPressed: () {
          setState(() {
            _currentPage = 2;
          });
        },
            icon: Icon(
              Icons.favorite,
              size: 30,
              color:_currentPage == 2 ? Colors.pink:Colors.white,

            )
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}