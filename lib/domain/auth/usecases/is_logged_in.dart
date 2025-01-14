import 'package:tec_bloc/domain/auth/repository/auth.dart';

import '../../../core/usecase/usecase.dart';
import '../../../service_locator.dart';

class IsLoggedInUseCase implements UseCase<bool,dynamic> {

  @override
  Future<bool> call({params}) async {
    return await sl<AuthRepository>().isLoggedIn();
  }

}
