import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tec_bloc/domain/auth/usecases/get_user_usecase.dart';
import 'package:tec_bloc/service_locator.dart';

import '../../../domain/auth/entity/user.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  
  UserCubit() : super(UserInitial());

  Future<void> fetchUser() async {
    emit(UserLoading());
    try {
      final result = await sl<GetUserUseCase>().call();
      result.fold(
        (error) => emit(UserFailure()),
        (user) => emit(UserLoaded(user: user))
      );
    } catch (e) {
      log("error: $e");
    }
  }
}
