import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sneaker_shop/Presentation/Features/Product/ProductCard.dart';
import 'package:sneaker_shop/Presentation/Features/main/each_screen/favorite/favor_bloc.dart';
import 'package:sneaker_shop/Presentation/Features/main/each_screen/favorite/favor_event.dart';
import 'package:sneaker_shop/Presentation/Features/main/each_screen/home/Home_product_bloc.dart';
import 'package:sneaker_shop/Presentation/Widgets/LoadingWidget.dart';
import 'package:sneaker_shop/domains/model/UserModel.dart';

import '../../../../../domains/model/FavoriteModel.dart';
import '../home/Home_state.dart';
import 'favor_state.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  UserModel? userModel;
  late FavorBloc bloc;
  late List<FavoriteModel> favoritemodel;

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc = context.read<FavorBloc>();
    bloc.add(FetchListFavor());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Favourite",
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.favorite,
              color: Colors.pink,),
            onPressed: () {},
          ),
        ],
      ),
      body: BlocConsumer<FavorBloc, FavorStateBase>(
    bloc: bloc,
    listener: (context, state) {
      if(state is deleteFavorrSuccess){
        print("delete thanh cong");
        bloc.add(FetchListFavor());
      }
      else if(state is deleteFavorError){
        print(state.message);
      }

    },
  builder: (context, state) {
    if(state is FetchListFavorrSuccess){
      return _buildfavorscreen(state.listFavor);
    }
    else if(state is FetchListlistFavorError){
      return Center(child: Text(state.message),);
    }
    else if(state is FavorStateLoading){
      return Center(child: LoadingWidet(),);
    }
    return Container();
  },
),
    );
  }

  Widget _buildfavorscreen(List<FavoriteModel> list){
  return Container(
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Hiển thị 2 cột
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.75, // Tỷ lệ chiều cao / chiều rộng
        ),
        itemCount: list.length, // Số lượng sản phẩm yêu thích
        itemBuilder: (context, index) {
          return _productcard(list.elementAt(index));
        },
      ),
    ),
  );
  }
  Widget _productcard(FavoriteModel item){
    return LayoutBuilder(
      builder: (context, constraints) {
        double width = constraints.maxWidth * 0.9;
        double imageSize = width * 0.8;
        double fontSize = width * 0.08;

        return  Container(
          width: width,
          padding: EdgeInsets.all(width * 0.07),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text("Confirm"),
                        content: Text("Do you really want to delete thís item from favorite list?"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: Text("No"),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: Text("Yes", style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                    );
                    if (confirm == true) {
                      bloc.add(deleteFavor(item.pro_id));
                    }
                  },
                  icon: Icon(
                    Icons.favorite,
                    color: Colors.pink,
                    size: fontSize * 1.2,
                  ),
                ),
              ),
              SizedBox(height: 4),
              Center(
                child: Image.network(
                  item.imageUrl,
                  width: imageSize,
                  height: imageSize * 0.6,
                  fit: BoxFit.fitWidth,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.image_not_supported,
                    size: imageSize * 0.5,
                    color: Colors.grey,
                  ),
                ),
              ),
              SizedBox(height: 8),
              if (item.activity.isNotEmpty)
                Text(
                  item.activity.toUpperCase(),
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: fontSize * 0.8,
                    fontWeight: FontWeight.bold,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                  ),
                ),
              SizedBox(height: 4),
              Text(
                item.name,
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                  fontFamily: GoogleFonts.raleway().fontFamily,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "\$${item.price.toStringAsFixed(2)}",
                    style: TextStyle(
                      fontSize: fontSize * 1.1,
                      fontWeight: FontWeight.bold,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

