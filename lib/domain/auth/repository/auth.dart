import 'package:dartz/dartz.dart';
import 'package:tec_bloc/data/auth/models/user_login_req.dart';

abstract class AuthRepository {

  Future<Either> login(UserLoginReq user);
  Future<void> logout();
  Future<bool> isLoggedIn();
  Future<Either> getUser();
}