class UserModel {
  String userId;
  String name;
  String email;
  String password;
  String phone;
  String address;
  DateTime createdAt;

  UserModel({
    required this.userId,
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
    required this.address,
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
      createdAt: DateTime.parse(map["created_at"]),
    );
  }
}
