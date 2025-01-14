class UserEntity {
  final String userId;
  final String fullName;
  final String username;
  final String? location;
  final String? password;

  const UserEntity({
    required this.userId,
    required this.fullName,
    this.location,
    required this.username,
    required this.password
  });

}