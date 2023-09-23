class User {
  late String userName;
  late String password;
  late String email;

  User({required this.userName, required this.email, required this.password});

  Map<String, dynamic> toJson() {
    return {'userName': userName, 'email': email, 'password': password};
  }
}
