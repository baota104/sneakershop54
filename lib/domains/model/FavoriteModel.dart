class FavoriteModel {
  String pro_id;
  String activity;
  String name;
  double price;
  String imageUrl;

  FavoriteModel({
    required this.pro_id,
    required this.activity,
    required this.name,
    required this.price,
    required this.imageUrl,
  });

  factory FavoriteModel.fromMap(Map<String, dynamic> map) {
    return FavoriteModel(
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
