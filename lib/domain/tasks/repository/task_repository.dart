import 'package:dartz/dartz.dart';
import 'package:tec_bloc/data/tasks/models/add_new_task.dart';

import '../../../data/tasks/models/update_task_params.dart';

abstract class TaskRepository {

  Future<Either> getTasks();
  Future<Either> getCompletedTasks();
  Future<Either> createTask(CreateTaskParams params);
  Future<Either> updateTask(UpdateTaskData params, int taskId);
}