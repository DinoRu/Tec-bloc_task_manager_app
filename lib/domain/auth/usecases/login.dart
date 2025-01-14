
import 'package:dartz/dartz.dart';
import 'package:tec_bloc/core/usecase/usecase.dart';
import 'package:tec_bloc/data/auth/models/user_login_req.dart';
import 'package:tec_bloc/domain/auth/repository/auth.dart';

import '../../../service_locator.dart';

class LoginUseCase implements UseCase<Either, UserLoginReq> {

  @override
  Future<Either> call({UserLoginReq? params}) async {
    return sl<AuthRepository>().login(params!);
  }
  
}