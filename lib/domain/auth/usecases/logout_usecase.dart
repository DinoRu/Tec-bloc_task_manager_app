import 'package:tec_bloc/core/usecase/usecase.dart';
import 'package:tec_bloc/domain/auth/repository/auth.dart';

import '../../../service_locator.dart';

class LogoutUsecase implements UseCase {
  
  @override
  Future call({params}) async {
    return sl<AuthRepository>().logout();
  }
}