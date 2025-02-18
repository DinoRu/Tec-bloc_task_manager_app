import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tec_bloc/domain/tasks/usecases/get_tasks_usecase.dart';

import '../../../../domain/tasks/entity/task_entity.dart';
import '../../../../service_locator.dart';

part 'task_state.dart';

class TaskFromFileCubit extends Cubit<TaskFromFileState> {
  TaskFromFileCubit() : super(TaskFromFileInitial());

  Future<void> getFileTasks() async {
    emit(TaskFromFileLoading());
    try {
      final result = await sl<GetTasksUsecase>().call();
      result.fold(
        (error) => emit(TaskFromFileFailure(error: "$error")), 
        (tasks) => emit(TaskFromFileLoaded(tasks: tasks))
      );
    } catch (e) {
      log("Error: $e");
      emit(TaskFromFileFailure(error: 'Error occur: $e'));
    }
  }
}
