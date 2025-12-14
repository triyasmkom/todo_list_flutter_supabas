class LoginModel {
  final String email;
  final String password;
  final bool rememberMe;

  LoginModel({
    required this.email,
    required this.password,
    this.rememberMe = false,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      password: json['password'],
      email: json['email'],
      rememberMe: json["remember_me"],
    );
  }

  static List<LoginModel> fromJsonToList(List<dynamic> jsonList) {
    return jsonList.map((json) => LoginModel.fromJson(json)).toList();
  }
}
