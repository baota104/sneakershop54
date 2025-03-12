import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Product/ProductCard.dart';

class Searchscreen extends StatefulWidget {
  const Searchscreen({super.key});

  @override
  State<Searchscreen> createState() => _SearchscreenState();
}

class _SearchscreenState extends State<Searchscreen> {
  final List<String> _categories = ["All Shoes", "Daily", "Running", "Basketball", "Football"];
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text("Search",
            style: TextStyle(
              fontSize: 20,
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontFamily: GoogleFonts.raleway().fontFamily
            ),
          ),
        ),
      ),
      body: SafeArea(
          child: Container(
            constraints: BoxConstraints.expand(),
            color: Color(0xFFF7F7F9),
            child: Column(
              children: [
              _builsearchfield(),
                _buildcategoryfield(),
                Expanded(child:
                _buildlistproduct()
                )
              ],
            ),
          )
      ),
    );
  }
  Widget _builsearchfield(){
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20,horizontal: 20),
      child: TextFormField(
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search),
          suffixIcon: IconButton(onPressed: (){

          }, icon:  Icon(Icons.mic)
          ),
          fillColor: Colors.white,
          filled: true,
          hintText: "Search Your Shoes",
          hintStyle: TextStyle(
              color: Color(0xFF6A6A6A),
              fontFamily: GoogleFonts.poppins().fontFamily
          ),
          labelStyle: TextStyle(color: Colors.blue),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(width: 1, color: Colors.white)
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(width: 1, color: Colors.white)
          ),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(width: 1, color: Colors.white)
          ),
        ),
      ),
    );
  }
  Widget _buildcategoryfield(){
    return Container(
      margin: EdgeInsets.only(left: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text("Select Category", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,
              fontFamily: GoogleFonts.poppins().fontFamily
            )),
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
                        fontFamily: GoogleFonts.poppins().fontFamily
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
  Widget _buildlistproduct() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.75,
        ),
        itemCount: 8,
        itemBuilder: (context, index) {
          return ProductCard(islove: false,);
        },
      ),
    );
  }

}
