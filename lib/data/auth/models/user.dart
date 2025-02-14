import 'package:tec_bloc/domain/auth/entity/user.dart';

class UserModel {
  final String userId;
  final String username;
  final String role;
  final String fullName;

  UserModel({
    required this.userId,
    required this.fullName,
    required this.role,
    required this.username,
  });

  factory UserModel.fromjson(Map<String, dynamic> json) {
    return UserModel(
      userId: json["uid"],
      fullName: json["full_name"], 
      role: json["role"],
      username: json["username"]
    );
  }
}


extension UserXModel on UserModel {
    UserEntity toEntity() {
      return UserEntity(
        userId: userId,
        role: role, 
        fullName: fullName,
        username: username,
    );
  }
}