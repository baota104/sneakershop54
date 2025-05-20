import 'package:sneaker_shop/domains/data_source/remote/firebase/favorite_firebase.dart';
import 'package:sneaker_shop/domains/model/FavoriteModel.dart';

class FavoriteRepository{
  final FavoriteFirebase _favoriteFirebase;

  FavoriteRepository(this._favoriteFirebase);
  Future<List<FavoriteModel>> fetchFavorites()async{
    return _favoriteFirebase.fetchFavorites();
  }
  Future<bool> removeFromFavorite(String productId) async{
    return _favoriteFirebase.removeFromFavorite(productId);
  }
}