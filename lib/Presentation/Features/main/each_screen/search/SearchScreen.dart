import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sneaker_shop/Presentation/Features/Cart/cart_bloc.dart';
import 'package:sneaker_shop/domains/model/ProductModel.dart';

import '../../../../Widgets/LoadingWidget.dart';
import '../../../Product/ProductCard.dart';
import '../../../Product/ProductDetail.dart';
import '../home/Home_event.dart';
import '../home/Home_product_bloc.dart';
import '../home/Home_state.dart';

class Searchscreen extends StatefulWidget {
  const Searchscreen({super.key});

  @override
  State<Searchscreen> createState() => _SearchscreenState();
}

class _SearchscreenState extends State<Searchscreen> {
  final List<String> _categories = ["All Shoes", "Daily", "Running", "Basketball", "Football"];
  int _selectedIndex = 0;
  late HomeProductBloc bloc;
  late CartBloc cartBloc;
  List<ProductModel> _filteredProducts = [];

  @override
  void initState() {
    super.initState();
    cartBloc = context.read<CartBloc>();
    bloc = context.read<HomeProductBloc>();
    bloc.add(FetchListProduct());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(
          child: Text(
            "Search",
            style: TextStyle(
              fontSize: 20,
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontFamily: GoogleFonts.raleway().fontFamily,
            ),
          ),
        ),
      ),
      body: BlocConsumer<HomeProductBloc, HomeStateBase>(
        bloc: bloc,
        listener: (context, state) {
          if (state is FetchListProductSuccess) {
            _filterProducts(state.listProduct);
          }
        },
        builder: (context, state) {
          if (state is FetchListProductSuccess) {
            return _buildSearchScreen();
          } else if (state is HomeStateLoading) {
            return Center(child: LoadingWidet());
          } else if (state is FetchListProductError) {
            return Center(child: Text(state.message + " tại sao nhỉ"));
          } else {
            return SizedBox();
          }
        },
      ),
    );
  }

  void _filterProducts(List<ProductModel> productmodel) {
    setState(() {
      if (_selectedIndex == 0) {
        // Hiển thị tất cả sản phẩm nếu chọn "All Shoes"
        _filteredProducts = productmodel;
      } else {
        // Lọc sản phẩm theo category
        String selectedCategory = _categories[_selectedIndex];
        _filteredProducts = productmodel.where((product) {
          return product.activity.toLowerCase() == selectedCategory.toLowerCase();
        }).toList();
      }
    });
  }

  Widget _buildSearchScreen() {
    return SafeArea(
      child: Container(
        constraints: BoxConstraints.expand(),
        color: Color(0xFFF7F7F9),
        child: Column(
          children: [
            _buildSearchField(),
            _buildCategoryField(),
            Expanded(child: _buildListProduct()),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: TextFormField(
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search),
          suffixIcon: IconButton(
            onPressed: () {},
            icon: Icon(Icons.mic),
          ),
          fillColor: Colors.white,
          filled: true,
          hintText: "Search Your Shoes",
          hintStyle: TextStyle(
            color: Color(0xFF6A6A6A),
            fontFamily: GoogleFonts.poppins().fontFamily,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(width: 1, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryField() {
    return Container(
      margin: EdgeInsets.only(left: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "Select Category",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: GoogleFonts.poppins().fontFamily,
              ),
            ),
          ),
          SizedBox(height: 10),
          Container(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                bool isSelected = index == _selectedIndex;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedIndex = index;
                      _filterProducts(bloc.state is FetchListProductSuccess
                          ? (bloc.state as FetchListProductSuccess).listProduct
                          : []);
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 8),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? Color(0xFF0D6EFD) : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      _categories[index],
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListProduct() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.75,
        ),
        itemCount: _filteredProducts.length,
        itemBuilder: (context, index) {
          return GestureDetector(
              onTap: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlocProvider.value(
                        value: cartBloc,
                        child: ProductDetailScreen(product:_filteredProducts[index],
                        ),
                      ),
                    ));
              },
              child: Container(
                  child: ProductCard(product: _filteredProducts[index])));
        },
      ),
    );
  }
}
