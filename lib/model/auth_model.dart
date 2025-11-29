class AuthModel {
  final int? id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final bool? isActive;

  AuthModel({
    required this.id,
    this.firstName,
    this.isActive,
    this.lastName,
    this.email,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      id: json['id'],
      lastName: json['last_name'],
      firstName: json['first_name'],
      email: json['email'],
      isActive: json['is_active'],
    );
  }

  static List<AuthModel> fromJsonToList(List<dynamic> jsonList) {
    return jsonList.map((json) => AuthModel.fromJson(json)).toList();
  }

  @override
  String toString() {
    return 'AuthModel(id: $id, last_name: $lastName, first_name: $firstName, email: $email)';
  }
}
