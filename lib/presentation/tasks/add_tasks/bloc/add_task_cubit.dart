

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tec_bloc/data/tasks/models/add_new_task.dart';
import 'package:tec_bloc/domain/tasks/usecases/add_new_task_usecase.dart';

part 'add_task_state.dart';

class AddTaskCubit extends Cubit<AddTaskState> {
  final AddNewTaskUsecase addNewTaskUsecase;
  AddTaskCubit(this.addNewTaskUsecase) : super(AddTaskInitial());


  Future<void> addTask(AddNewTaskParams params) async {
    emit(AddTaskLoading());
    final result = await addNewTaskUsecase.call(params: params);
    result.fold(
      (failure) => emit(AddTaskFailure(failure.toString())), 
      (_) => emit(AddTaskSuccess())
    );
  }


}
