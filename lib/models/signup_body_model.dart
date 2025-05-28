class SignUpBody {
  String fullName;
  String email;
  String password;
  String phoneNumber;
  String confirmPassword;

  SignUpBody({
    required this.fullName,
    required this.email,
    required this.password,
    required this.phoneNumber,
    required this.confirmPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      "full_name": fullName,
      "email": email,
      "password": password,
      "phone_number": phoneNumber,
      "confirm_password": confirmPassword,
    };
  }
}
