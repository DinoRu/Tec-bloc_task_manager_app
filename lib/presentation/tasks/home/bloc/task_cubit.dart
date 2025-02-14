import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:tec_bloc/core/usecase/usecase.dart';
import 'package:tec_bloc/domain/tasks/entity/task_entity.dart';

part 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  final UseCase useCase;
  List<TaskEntity> allTasks = [];
  TaskCubit({required this.useCase}) : super(TaskInitialState());

  void displayTask({dynamic params}) async {
    emit(TaskLoading());
    final result = await useCase.call(params: params);
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

  void displayInitial() {
    emit(
      TaskInitialState()
    );
  }
}
