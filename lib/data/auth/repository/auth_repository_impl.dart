

import 'package:dartz/dartz.dart';
import 'package:tec_bloc/data/auth/models/user_login_req.dart';
import 'package:tec_bloc/data/auth/source/auth_remote_service_impl.dart';
import 'package:tec_bloc/domain/auth/repository/auth.dart';
import 'package:tec_bloc/service_locator.dart';

class AuthRepositoryImpl implements AuthRepository {

  @override
  Future<bool> isLoggedIn() async {
    return await sl<AuthRemoteService>().isLoggedIn();
  }

  @override
  Future<Either> login(UserLoginReq user) async{
    return await sl<AuthRemoteService>().signin(user);
  }
  
  @override
  Future<Either> getUser() {
    return sl<AuthRemoteService>().getUser();
  }

  @override
  Future<void> logout() {
    return sl<AuthRemoteService>().logout();
  }

}