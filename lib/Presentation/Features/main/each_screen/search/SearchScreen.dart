import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sneaker_shop/Presentation/Features/Cart/cart_bloc.dart';
import 'package:sneaker_shop/domains/model/ProductModel.dart';

import '../../../../Widgets/LoadingWidget.dart';
import '../../../Cart/cart_state.dart';
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
  List<ProductModel> _allproducts = [];
  List<ProductModel> _filteredProducts = [];
  final TextEditingController _searchcontroller = TextEditingController();

  @override
  void initState() {
    super.initState();
    cartBloc = context.read<CartBloc>();
    bloc = context.read<HomeProductBloc>();
    _searchcontroller.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchcontroller.removeListener(_onSearchChanged);
    _searchcontroller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    bloc.add(FetchListProduct());
    super.didChangeDependencies();
  }

  void _onSearchChanged() {
    _applyFilters();
    setState(() {});
    // if (_searchcontroller.text.isNotEmpty) {
    //   _showSearchBottomSheet(context);
    // } else {
    //   Navigator.of(context).maybePop(); // Close BottomSheet if open
    // }
  }

  void _applyFilters() {
    List<ProductModel> filtered = _allproducts;

    // Lọc theo category
    if (_selectedIndex != 0) {
      String selectedCategory = _categories[_selectedIndex];
      filtered = filtered
          .where((product) => product.activity.toLowerCase() == selectedCategory.toLowerCase())
          .toList();
    }

    // Lọc theo từ khóa tìm kiếm
    if (_searchcontroller.text.isNotEmpty) {
      filtered = filtered
          .where((product) =>
          product.name.toLowerCase().contains(_searchcontroller.text.toLowerCase()))
          .toList();
    }

    setState(() {
      _filteredProducts = filtered;
    });
  }

  void _showSearchBottomSheet(BuildContext contextchinh) {
    showModalBottomSheet(
      context: contextchinh,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      builder: (context) {
        return BlocProvider.value(
          value: cartBloc, // Truyền bloc đúng
          child: SafeArea(
            child: Container(
              padding: EdgeInsets.all(16),
              height: MediaQuery.of(context).size.height * 0.75,
              child: _filteredProducts.isEmpty
                  ? Center(child: Text("Không tìm thấy sản phẩm"))
                  : GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.75,
                ),
                itemCount: _filteredProducts.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        contextchinh,
                        MaterialPageRoute(
                          builder: (context) => BlocProvider.value(
                            value: cartBloc,
                            child: ProductDetailScreen(product: _filteredProducts[index]),
                          ),
                        ),
                      );
                    },
                    child: ProductCard(product: _filteredProducts[index]),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
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
            _allproducts = state.listProduct;
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
    bool isSearching = _searchcontroller.text.isNotEmpty;
    return SafeArea(
      child: Container(
        constraints: BoxConstraints.expand(),
        color: Color(0xFFF7F7F9),
        child: Column(
          children: [
            _buildSearchField(),
            if (!isSearching) ...[
              _buildCategoryField(),
              Expanded(child: _buildListProduct()),
            ] else ...[
              Expanded(child: _buildSearchResultsContainer()),
              // TextButton(
              //   onPressed: () {
              //     _searchcontroller.clear();
              //     FocusScope.of(context).unfocus(); // đóng bàn phím
              //     setState(() {}); // cập nhật lại trạng thái
              //   },
              //   child: Text(
              //     "Cancel",
              //     style: TextStyle(color: Colors.blue),
              //   ),
              // ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: TextField(
        onChanged: (value) {
          _onSearchChanged();// Cập nhật kết quả
        },
        onSubmitted: (value) {
         _buildSearchResultsContainer();
        },
        controller: _searchcontroller,
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search),
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                _searchcontroller.clear();
              });
            },
            icon: Icon(Icons.cancel),
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
    return BlocListener<CartBloc, CartState>(
        listener: (context, state) {
          print(state.status);
          if (state.status == CartStatus.addSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Đã thêm vào giỏ hàng"),
              backgroundColor: Colors.green,
            ));
          }
          else if (state.status == CartStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Đã thêm vào giỏ hàng"),
              backgroundColor: Colors.green,
            ));
          }
        },
    child: Padding(
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
    ),
    );
  }
  Widget _buildSearchResultsContainer() {
    return _filteredProducts.isEmpty
        ? Center(child: Text("Không tìm thấy sản phẩm"))
        : GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.75,
      ),
      itemCount: _filteredProducts.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider.value(
                  value: cartBloc,
                  child: ProductDetailScreen(product: _filteredProducts[index]),
                ),
              ),
            );
          },
          child: ProductCard(product: _filteredProducts[index]),
        );
      },
    );
  }

}
