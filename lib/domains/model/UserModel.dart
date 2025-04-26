class UserModel {
  String userId;
  String name;
  String email;
  String password;
  String phone;
  String address;
  List<Favoritesitems> fav;
  DateTime createdAt;

  UserModel({
    required this.userId,
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
    required this.address,
    required this.fav,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      "user_id": userId,
      "name": name,
      "email": email,
      "password": password,
      "phone": phone,
      "address": address,
      "fav": fav.map((e) => e.toMap()).toList(),
      "created_at": createdAt.toIso8601String(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userId: map["user_id"],
      name: map["name"],
      email: map["email"],
      password: map["password"],
      phone: map["phone"],
      address: map["address"],
      fav: List<Favoritesitems>.from(
        (map['cart_items'] as List).map((item) => Favoritesitems.fromMap(item)),
      ),
      createdAt: DateTime.parse(map["created_at"]),
    );
  }
}

class Favoritesitems {
  String pro_id;
  String activity;
  String name;
  double price;
  String imageUrl;

  Favoritesitems({
    required this.pro_id,
    required this.activity,
    required this.name,
    required this.price,
    required this.imageUrl,
  });

  factory Favoritesitems.fromMap(Map<String, dynamic> map) {
    return Favoritesitems(
      pro_id: map['pro_id'],
      activity: map['activity'],
      name: map['name'],
      price: (map['price'] as num).toDouble(),
      imageUrl: map['imageUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'pro_id': pro_id,
      'activity': activity,
      'name': name,
      'price': price,
      'imageUrl': imageUrl,
    };
  }
}
