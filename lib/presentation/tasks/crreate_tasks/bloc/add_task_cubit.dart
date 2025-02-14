

import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tec_bloc/data/tasks/models/add_new_task.dart';
import 'package:tec_bloc/domain/tasks/entity/task_entity.dart';
import 'package:tec_bloc/domain/tasks/usecases/create_task_usecase.dart';
import 'package:tec_bloc/locals/db/db_helper.dart';
// import 'package:tec_bloc/locals/db/db_helper.dart';

part 'add_task_state.dart';

class AddTaskCubit extends Cubit<AddTaskState> {
  final DbHelper dbHelper = DbHelper();
  final CreateTaskUsecase createTaskUsecase;
  AddTaskCubit(this.createTaskUsecase) : super(AddTaskInitial());


  Future<void> createTask(CreateTaskParams params) async {
    emit(AddTaskLoading());
    final result = await createTaskUsecase.call(params: params);
    result.fold(
      (failure) => emit(AddTaskFailure(failure.toString())), 
      (_) => emit(AddTaskSuccess())
    );
  }

  Future<void> createLocalTask(TaskEntity task) async {
    emit(AddTaskLoading());
    try {
      await dbHelper.insertTask(task);
      emit(AddTaskSuccess());
    } catch (e) {
      log("Error to create task localy: $e");
      emit(AddTaskFailure("Erreur to create task localy: $e"));
      throw("$e");
    }
  }

  Future<void> updateLocalTask(TaskEntity task) async {
    emit(AddTaskLoading());
    try {
      await dbHelper.updateTask(task);
      emit(AddTaskSuccess());
    } catch (e) {
      log("Error to update task localy: $e");
      emit(AddTaskFailure("Erreur to update task localy: $e"));
      throw("$e");
    }
  }


}
