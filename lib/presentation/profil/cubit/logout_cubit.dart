
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tec_bloc/domain/auth/usecases/logout_usecase.dart';

part 'logout_state.dart';

class LogoutCubit extends Cubit<LogoutState> {
  final LogoutUsecase logoutUsecase;
  LogoutCubit(this.logoutUsecase) : super(LogoutInitial());

  Future<void> logout() async {
    emit(LogoutLoading());
    try {
      final result = await logoutUsecase.call();
      result.fold(
        (error) {
          log("Logout failed: ${error.message}");
          emit(LogoutError(message: error.message));
        },
        (_) => emit(LogoutSuccess())
      );
    } catch (e) {
      log("Unexpected error during logout: $e");
      emit(LogoutError(message: "An unexpected error occurred."));
    }
  }
}
