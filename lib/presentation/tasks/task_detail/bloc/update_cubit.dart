

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tec_bloc/data/tasks/models/update_task_params.dart';
import 'package:tec_bloc/domain/tasks/usecases/update_task_usecase.dart';

part 'update_state.dart';

class UpdateCubit extends Cubit<UpdateState> {
  final UpdateTaskUsecase updateTaskUsecase;
  UpdateCubit(this.updateTaskUsecase) : super(UpdateInitial());

  Future<void> updateTask(int taskId, UpdateTaskData params) async {
    emit(UpdateTaskLoading());
    final result = await updateTaskUsecase.call(params: params, taskId: taskId);
    result.fold(
      (failure) => emit(const UpdateTaskFailure("Error to update task")), 
      (_) => emit(UpdateTaskLoaded())
    );
  }

   
}
