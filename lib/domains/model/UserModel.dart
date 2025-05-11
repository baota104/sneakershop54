class UserModel {
  String userId;
  String name;
  String email;
  String password;
  String phone;
  String address;
  List<String> fav;
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
      "favorite":fav,
      "created_at": createdAt.toIso8601String(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userId: map["user_id"] ?? '',
      name: map["name"] ?? '',
      email: map["email"] ?? '',
      password: map["password"] ?? '',
      phone: map["phone"] ?? '',
      address: map["address"] ?? '',
      fav: List<String>.from(map["favorite"] ?? []),
      createdAt: map["created_at"] != null
          ? DateTime.parse(map["created_at"])
          : DateTime.now(),
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
