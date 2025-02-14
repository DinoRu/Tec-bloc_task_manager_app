
import 'package:dartz/dartz.dart';
import 'package:tec_bloc/data/tasks/models/add_new_task.dart';
import 'package:tec_bloc/data/tasks/models/update_task_params.dart';
import 'package:tec_bloc/data/tasks/source/task_remote_service.dart';
import 'package:tec_bloc/domain/tasks/repository/task_repository.dart';

import '../../../service_locator.dart';

class TaskRepositoryimpl implements TaskRepository {
 

  @override
  Future<Either> getTasks() async {
    return await sl<TaskRemoteService>().getTasks();
  }

  @override
  Future<Either> updateTask(UpdateTaskParams params, int taskId) async {
    return await sl<TaskRemoteService>().updateTask(params, taskId);
  }

  @override
  Future<Either> createTask(CreateTaskParams params) async {
    return await sl<TaskRemoteService>().createTask(params);
  }

}