import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:tec_bloc/data/tasks/local/usecases/get_local_usecase.dart';
import 'package:tec_bloc/data/tasks/local/usecases/get_pending_tasks.dart';
import 'package:tec_bloc/domain/tasks/entity/task_entity.dart';

import '../../../../service_locator.dart';

part 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
 
  List<TaskEntity> allTasks = [];
  TaskCubit() : super(TaskInitialState());

  void displayTask({dynamic params}) async {
    emit(TaskLoading());
    final result = await sl<GetLocalTaskUsecase>().call();
    result.fold(
      (error) {
        log("$error");
        emit(LoadTasksFailure());
        throw(error);
      },
      (tasks) {
        allTasks = tasks;
        debugPrint("ALL TASKS : $allTasks");
        emit(TaskLoaded(tasks: tasks));
      }
    );
  }

  void displayPendingTasks() async {
    emit(PendingTasksLoading());
    try {
      final result = await sl<GetPendingTasksUsecase>().call();
      result.fold(
        (error) => emit(PendingTasksFailure("Error: $error")),
        (tasks) => emit(PendingTasksLoaded(tasks))
      );
    } catch (e) {
      emit(PendingTasksFailure("Error $e"));
    }
  }

  void displayInitial() {
    emit(
      TaskInitialState()
    );
  }
}
