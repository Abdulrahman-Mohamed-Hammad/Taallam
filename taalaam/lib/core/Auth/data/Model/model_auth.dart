class AuthRequestModel {
  final String? fullName;
  final String email;
  final String password;

  AuthRequestModel({
    this.fullName,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toMap() => {
    'fullName': fullName,
    'email': email,
    'password': password,
  };
}
