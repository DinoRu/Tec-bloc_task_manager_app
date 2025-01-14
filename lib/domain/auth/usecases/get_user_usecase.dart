import 'package:tec_bloc/core/usecase/usecase.dart';
import 'package:tec_bloc/domain/auth/repository/auth.dart';

import '../../../service_locator.dart';

class GetUserUseCase implements UseCase {
  @override
  Future call({params}) async {
    return await sl<AuthRepository>().getUser();
  }
  
}