class UserModel {
  String id;
  String fName;
  String email;
  String phone;

  UserModel({
    required this.id,
    required this.fName,
    required this.email,
    required this.phone,

  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'].toString(),
      fName: json['full_name'],
      email: json['email'],
      phone: json['phone_number'],
    );
  }
}
