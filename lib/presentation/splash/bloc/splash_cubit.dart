import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tec_bloc/domain/auth/usecases/is_logged_in.dart';
import 'package:tec_bloc/service_locator.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(DisplaySplash());

  void appStarted() async {
    await Future.delayed(const Duration(seconds: 5));
    var isLoggedIn = await sl <IsLoggedInUseCase> ().call();
    if (isLoggedIn) {
      emit(
        Authenticated()
      );
    } else {
      emit(UnAuthenticated());
    }
  }
}
