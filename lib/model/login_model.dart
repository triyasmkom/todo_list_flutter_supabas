class LoginModel {
  final String email;
  final String password;

  LoginModel({required this.email, required this.password});

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(password: json['password'], email: json['email']);
  }

  static List<LoginModel> fromJsonToList(List<dynamic> jsonList) {
    return jsonList.map((json) => LoginModel.fromJson(json)).toList();
  }
}
