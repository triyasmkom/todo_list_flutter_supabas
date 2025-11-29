class RegisterModel {
  final String firstName;
  final String lastName;
  final String email;
  final String password;

  RegisterModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
  });

  factory RegisterModel.fromJson(Map<String, dynamic> json) {
    return RegisterModel(
      password: json['password'],
      lastName: json['last_name'],
      firstName: json['first_name'],
      email: json['email'],
    );
  }

  static List<RegisterModel> fromJsonToList(List<dynamic> jsonList) {
    return jsonList.map((json) => RegisterModel.fromJson(json)).toList();
  }
}
