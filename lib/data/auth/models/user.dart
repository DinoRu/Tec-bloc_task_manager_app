import 'package:tec_bloc/domain/auth/entity/user.dart';

class UserModel {
  final String userId;
  final String username;
  final String? location;
  final String fullName;
  final String password;

  UserModel({
    required this.userId,
    required this.fullName,
    required this.location,
    required this.username,
    required this.password
  });

  factory UserModel.fromjson(Map<String, dynamic> json) {
    return UserModel(
      userId: json["user_id"],
      fullName: json["full_name"], 
      location: json["location"] ?? "", 
      password: json["password"], 
      username: json["username"]
    );
  }
}


extension UserXModel on UserModel {
    UserEntity toEntity() {
      return UserEntity(
        userId: userId,
        location: location ?? "", 
        fullName: fullName,
        username: username,
        password: password
    );
  }
}