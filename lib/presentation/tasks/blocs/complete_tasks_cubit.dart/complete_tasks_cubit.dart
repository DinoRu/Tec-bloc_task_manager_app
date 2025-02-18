import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tec_bloc/domain/tasks/entity/task_entity.dart';
import 'package:tec_bloc/domain/tasks/usecases/get_completed_tasks_usecase.dart';

import '../../../../service_locator.dart';

part 'complete_tasks_state.dart';

class CompleteTasksCubit extends Cubit<CompleteTasksState> {
  CompleteTasksCubit() : super(CompleteTasksInitial());

  Future<void> getCompletedTasks() async {
    emit(CompleteTasksLoading());
    try {
      final result = await sl<GetCompletedTasksUsecase>().call();
      result.fold(
        (error) => emit(CompleteTasksFailure("Error: $error")), 
        (tasks) => emit(CompleteTaskLoaded(tasks: tasks))
      );
    } catch (e) {
      emit(CompleteTasksFailure("$e"));
    }
  }
}
